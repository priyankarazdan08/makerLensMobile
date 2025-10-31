import Firebase
import FirebaseFirestore
import FirebaseAuth
import Combine

class FirebaseService: ObservableObject {
    static let shared = FirebaseService()
    let db = Firestore.firestore()
    
    // Published properties for real-time updates
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var creations: [Creation] = []
    
    private init() {
        // Configure Firebase if not already done
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        setupAuthListener()
    }
    
    // MARK: - Authentication
    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                Task {
                    await self?.loadCurrentUser(uid: user.uid)
                }
            } else {
                self?.currentUser = nil
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await loadCurrentUser(uid: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func signUp(email: String, password: String, name: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Create user document with points fields
            let userData: [String: Any] = [
                "id": result.user.uid,
                "name": name,
                "email": email,
                "accountType": "individual",
                "createdAt": FieldValue.serverTimestamp(),
                
                // NEW: Points system fields
                "totalPoints": 0,
                "totalScans": 0,
                "lastScanDate": NSNull(),
                
                // Additional fields
                "completedCreations": [],
                "currentModule": "part-1-preparation"
            ]
            
            try await db.collection("users").document(result.user.uid).setData(userData)
            await loadCurrentUser(uid: result.user.uid)
            
            print("✅ User created with points fields")
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
    }
    
    // MARK: - User Operations
    
    func loadUser(userId: String) async {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            
            print("🔍 Document exists: \(document.exists)")
            print("🔍 Document data: \(document.data() ?? [:])")
            
            if document.exists {
                if let user = try? document.data(as: User.self) {
                    await MainActor.run {
                        self.currentUser = user
                    }
                    print("✅ User decoded successfully: \(user.name)")
                } else {
                    print("❌ Failed to decode user document")
                }
            } else {
                print("❌ User document does not exist at path: users/\(userId)")
            }
        } catch {
            print("❌ Error loading user: \(error.localizedDescription)")
        }
    }
    
    private func loadCurrentUser(uid: String) async {
        do {
            let document = try await db.collection("users").document(uid).getDocument()
            if let user = try? document.data(as: User.self) {
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            }
        } catch {
            print("Error loading user: \(error)")
        }
    }
    
    private func createUser(_ user: User) async throws {
        guard let userId = user.id else { throw FirebaseError.invalidUserId }
        try db.collection("users").document(userId).setData(from: user)
    }
    
    // MARK: - Points System
    
    /// Award points for component detection
    func awardPointsForScan(componentCount: Int, pointsPerComponent: Int = 35) async throws {
        guard let userId = currentUser?.id else { throw FirebaseError.userNotLoggedIn }
        
        let pointsEarned = componentCount * pointsPerComponent
        let userRef = db.collection("users").document(userId)
        
        // Check if user has points fields
        let doc = try await userRef.getDocument()
        
        if let currentPoints = doc.data()?["totalPoints"] as? Int {
            // Update existing points
            try await userRef.updateData([
                "totalPoints": currentPoints + pointsEarned,
                "lastScanDate": FieldValue.serverTimestamp(),
                "totalScans": FieldValue.increment(Int64(1))
            ])
        } else {
            // Create points fields (for existing users without these fields)
            try await userRef.setData([
                "totalPoints": pointsEarned,
                "lastScanDate": FieldValue.serverTimestamp(),
                "totalScans": 1
            ], merge: true)
        }
        
        // Reload current user to update local state
        await loadCurrentUser(uid: userId)
        
        print("✅ Awarded \(pointsEarned) points (\(componentCount) components × \(pointsPerComponent) points)")
    }
    
    /// Get user's total points
    func getUserPoints() async throws -> Int {
        guard let userId = currentUser?.id else { throw FirebaseError.userNotLoggedIn }
        
        let doc = try await db.collection("users").document(userId).getDocument()
        return doc.data()?["totalPoints"] as? Int ?? 0
    }
    
    /// Get leaderboard (top users by points)
    func getLeaderboard(limit: Int = 10) async throws -> [(userId: String, name: String, points: Int, scans: Int)] {
        let snapshot = try await db.collection("users")
            .order(by: "totalPoints", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            guard let name = doc.data()["name"] as? String,
                  let points = doc.data()["totalPoints"] as? Int else {
                return nil
            }
            let scans = doc.data()["totalScans"] as? Int ?? 0
            return (userId: doc.documentID, name: name, points: points, scans: scans)
        }
    }
    
    /// Get user's rank on leaderboard
    func getUserRank() async throws -> Int? {
        guard let userId = currentUser?.id,
              let userPoints = try await getUserPoints() as Int? else {
            return nil
        }
        
        // Count how many users have more points
        let snapshot = try await db.collection("users")
            .whereField("totalPoints", isGreaterThan: userPoints)
            .getDocuments()
        
        return snapshot.documents.count + 1 // +1 because rank starts at 1
    }
    
    // MARK: - Creation Operations
    
    func addCompletedCreation(_ creationId: String) async throws {
        guard let userId = currentUser?.id else { throw FirebaseError.userNotLoggedIn }
        
        try await db.collection("users").document(userId).updateData([
            "completedCreations": FieldValue.arrayUnion([creationId])
        ])
        
        // Update local user object
        DispatchQueue.main.async {
            if !self.currentUser!.completedCreations.contains(creationId) {
                self.currentUser?.completedCreations.append(creationId)
            }
        }
    }
    
    func completeCreation(userId: String, creationId: String, pointsEarned: Int) async throws {
        // Update user's completed creations AND add lesson points
        try await db.collection("users").document(userId).updateData([
            "completedCreations": FieldValue.arrayUnion([creationId]),
            "totalPoints": FieldValue.increment(Int64(pointsEarned))
        ])
        
        // Add user to creation's completedBy array
        try await db.collection("creations").document(creationId).updateData([
            "completedBy": FieldValue.arrayUnion([userId])
        ])
        
        // Reload user to update points
        await loadCurrentUser(uid: userId)
        
        print("✅ Completed creation: \(creationId), earned \(pointsEarned) points")
    }
    
    func loadCreations() async throws {
        let snapshot = try await db.collection("creations").getDocuments()
        
        await MainActor.run {
            self.creations = snapshot.documents.compactMap { doc in
                try? doc.data(as: Creation.self)
            }
        }
    }
    
    func loadCreation(id: String) async throws -> Creation? {
        let document = try await db.collection("creations").document(id).getDocument()
        return try? document.data(as: Creation.self)
    }
    
    // MARK: - Progress Operations
    func loadUserProgress(creationId: String) async throws -> UserProgress? {
        guard let userId = currentUser?.id else { throw FirebaseError.userNotLoggedIn }
        
        let document = try await db.collection("userProgress")
            .document("\(userId)_\(creationId)")
            .getDocument()
        
        return try? document.data(as: UserProgress.self)
    }
    
    func updateUserProgress(_ progress: UserProgress) async throws {
        guard let progressId = progress.id else { return }
        
        try db.collection("userProgress")
            .document(progressId)
            .setData(from: progress)
    }
    
    func createUserProgress(userId: String, creationId: String) async throws -> UserProgress {
        let progress = UserProgress(
            id: "\(userId)_\(creationId)",
            userId: userId,
            creationId: creationId
        )
        
        try db.collection("userProgress")
            .document(progress.id!)
            .setData(from: progress)
        
        return progress
    }
    
    // MARK: - Component Operations
    
    func loadComponents(for category: ComponentCategory) async throws -> [Component] {
        let snapshot = try await db.collection("components")
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Component.self)
        }
    }
    
    // MARK: - One-Time Migration (run once to update existing users)
    
    /// Call this ONCE to add points fields to all existing users
    func migrateExistingUsersToPointsSystem() async throws {
        print("🔄 Starting user migration...")
        
        let snapshot = try await db.collection("users").getDocuments()
        let batch = db.batch()
        
        for doc in snapshot.documents {
            let data = doc.data()
            
            // Only update if they don't have points fields yet
            if data["totalPoints"] == nil {
                batch.updateData([
                    "totalPoints": 0,
                    "totalScans": 0,
                    "lastScanDate": NSNull()
                ], forDocument: doc.reference)
            }
        }
        
        try await batch.commit()
        print("✅ Migrated \(snapshot.documents.count) users to points system")
    }
}

// MARK: - Firebase Errors
enum FirebaseError: LocalizedError {
    case userNotLoggedIn
    case invalidUserId
    case documentNotFound
    
    var errorDescription: String? {
        switch self {
        case .userNotLoggedIn:
            return "User is not logged in"
        case .invalidUserId:
            return "Invalid user ID"
        case .documentNotFound:
            return "Document not found"
        }
    }
}

extension FirebaseService {
    
    /// Fetches leaderboard data based on scope
    func fetchLeaderboard(scope: String) async throws -> [LeaderboardEntry] {
        var query: Query = db.collection("users")
            .order(by: "totalPoints", descending: true)
            .limit(to: 100)
        
        // Apply scope filters
        switch scope.lowercased() {
        case "school":
            // Filter by user's school if available
            if let school = currentUser?.school, !school.isEmpty {
                query = query.whereField("school", isEqualTo: school)
            }
        case "friends":
            // Filter by user's friends list if available
            if let userId = currentUser?.id {
                let friendsDoc = try await db.collection("users")
                    .document(userId)
                    .getDocument()
                
                if let friendIds = friendsDoc.data()?["friends"] as? [String], !friendIds.isEmpty {
                    // User has friends, filter by them
                    query = query.whereField(FieldPath.documentID(), in: friendIds)
                } else {
                    // No friends yet, return empty array instead of error
                    return []
                }
            }
        default:
            // Global - no additional filter needed
            break
        }
        
        let snapshot = try await query.getDocuments()
        
        var entries: [LeaderboardEntry] = []
        for (index, document) in snapshot.documents.enumerated() {
            let data = document.data()
            
            let entry = LeaderboardEntry(
                userId: document.documentID,
                username: data["name"] as? String ?? "Unknown User",
                avatar: data["avatar"] as? String,
                xp: data["totalPoints"] as? Int ?? 0,
                rank: index + 1,
                streak: data["streak"] as? Int ?? 0,
                movement: data["rankMovement"] as? Int ?? 0
            )
            entries.append(entry)
        }
        
        return entries
    }
    
    /// Updates user's XP with streak multiplier
    /// This is similar to awardPointsForScan but includes streak multiplier
    func updateUserXP(additionalXP: Int) async throws {
        guard let userId = currentUser?.id else {
            throw FirebaseError.userNotLoggedIn
        }
        
        let userRef = db.collection("users").document(userId)
        
        try await db.runTransaction { transaction, errorPointer in
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let currentXP = userDocument.data()?["totalPoints"] as? Int else {
                let error = NSError(
                    domain: "FirebaseService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Could not fetch current points"]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            let streak = userDocument.data()?["streak"] as? Int ?? 0
            let multiplier = self.calculateStreakMultiplier(streak: streak)
            let finalXP = Int(Double(additionalXP) * multiplier)
            let newTotalXP = currentXP + finalXP
            
            transaction.updateData([
                "totalPoints": newTotalXP,
                "lastActivityDate": Timestamp(date: Date())
            ], forDocument: userRef)
            
            return nil
        }
        
        // Update streak automatically when earning points
        try? await updateStreak()
        
        // Refresh current user data
        if let userId = currentUser?.id {
            await loadCurrentUser(uid: userId)
        }
    }
    
    /// Updates user profile information
    func updateUserProfile(name: String, email: String) async throws {
        guard let userId = currentUser?.id else {
            throw FirebaseError.userNotLoggedIn
        }
        
        try await db.collection("users").document(userId).updateData([
            "name": name,
            "email": email
        ])
        
        // Update email in Firebase Auth if changed
        if let currentAuthUser = Auth.auth().currentUser, currentAuthUser.email != email {
            try await currentAuthUser.updateEmail(to: email)
        }
        
        // Refresh current user data
        await loadCurrentUser(uid: userId)
    }
    
    /// Calculates streak multiplier based on days
    private func calculateStreakMultiplier(streak: Int) -> Double {
        switch streak {
        case 30...:
            return 3.0
        case 14...:
            return 2.5
        case 7...:
            return 2.0
        case 3...:
            return 1.5
        default:
            return 1.0
        }
    }
    
    /// Updates user streak (call this daily when user completes an activity)
    func updateStreak() async throws {
        guard let userId = currentUser?.id else {
            throw FirebaseError.userNotLoggedIn
        }
        
        let userRef = db.collection("users").document(userId)
        let userDoc = try await userRef.getDocument()
        guard let data = userDoc.data() else { return }
        
        let lastActivityTimestamp = data["lastActivityDate"] as? Timestamp
        let lastActivityDate = lastActivityTimestamp?.dateValue() ?? Date.distantPast
        let calendar = Calendar.current
        
        let isToday = calendar.isDateInToday(lastActivityDate)
        let wasYesterday = calendar.isDateInYesterday(lastActivityDate)
        
        var newStreak = data["streak"] as? Int ?? 0
        
        if isToday {
            // Already active today, no change needed
            return
        } else if wasYesterday {
            // Continuing streak
            newStreak += 1
        } else {
            // Streak broken, reset to 1
            newStreak = 1
        }
        
        try await userRef.updateData([
            "streak": newStreak,
            "lastActivityDate": Timestamp(date: Date())
        ])
        
        // Refresh current user data
        await loadCurrentUser(uid: userId)
    }
    
    /// Updates user's rank in the leaderboard (call periodically or after point changes)
    func updateUserRank() async throws {
        guard let userId = currentUser?.id else {
            throw FirebaseError.userNotLoggedIn
        }
        
        let userDoc = try await db.collection("users").document(userId).getDocument()
        guard let userPoints = userDoc.data()?["totalPoints"] as? Int else { return }
        
        // Count how many users have more points
        let snapshot = try await db.collection("users")
            .whereField("totalPoints", isGreaterThan: userPoints)
            .getDocuments()
        
        let rank = snapshot.documents.count + 1
        
        try await db.collection("users").document(userId).updateData([
            "rank": rank
        ])
        
        // Refresh current user data
        await loadCurrentUser(uid: userId)
    }
    
    /// One-time migration to add streak and rank fields to all users
    func migrateUsersToStreakSystem() async throws {
        print("🔄 Starting streak system migration...")
        
        let snapshot = try await db.collection("users").getDocuments()
        let batch = db.batch()
        
        for doc in snapshot.documents {
            let data = doc.data()
            
            // Only update if they don't have streak fields yet
            if data["streak"] == nil {
                batch.updateData([
                    "streak": 0,
                    "rank": 999,
                    "rankMovement": 0,
                    "lastActivityDate": NSNull()
                ], forDocument: doc.reference)
            }
        }
        
        try await batch.commit()
        print("✅ Migrated \(snapshot.documents.count) users to streak system")
    }
}
