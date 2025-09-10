//
//  FirebaseService.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import Firebase
import FirebaseFirestore
import FirebaseAuth
import Combine

class FirebaseService: ObservableObject {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    // Published properties for real-time updates
    @Published var currentUser: User?
    @Published var modules: [Module] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
            
            // Create user document
            let newUser = User(
                id: result.user.uid,
                name: name,
                email: email,
                accountType: .individual
            )
            
            try await createUser(newUser)
            await loadCurrentUser(uid: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
        modules = []
    }
    
    // MARK: - User Operations
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
    
    func updateUserProgress(moduleId: String, progress: Double) async throws {
        guard let userId = currentUser?.id else { throw FirebaseError.userNotLoggedIn }
        
        try await db.collection("users").document(userId).updateData([
            "moduleProgress.\(moduleId)": progress
        ])
        
        // Update local user object
        DispatchQueue.main.async {
            self.currentUser?.moduleProgress[moduleId] = progress
        }
    }
    
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
    
    // MARK: - Module Operations
    func loadModules() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await db.collection("modules")
                .order(by: "order")
                .getDocuments()
            
            let fetchedModules = snapshot.documents.compactMap { doc -> Module? in
                try? doc.data(as: Module.self)
            }
            
            DispatchQueue.main.async {
                self.modules = fetchedModules
                self.updateModuleUnlockStatus()
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load modules: \(error.localizedDescription)"
            }
        }
    }
    
    private func updateModuleUnlockStatus() {
        guard let user = currentUser else { return }
        
        for i in 0..<modules.count {
            if modules[i].order == 1 {
                // First module is always unlocked
                modules[i].isUnlocked = true
            } else if let unlockCriteria = modules[i].unlockCriteria {
                // Check if unlock criteria is met
                if unlockCriteria.starts(with: "complete module") {
                    let moduleNumber = modules[i].order - 1
                    if moduleNumber > 0 && moduleNumber <= modules.count {
                        let previousModuleId = modules[moduleNumber - 1].id
                        let progress = user.moduleProgress[previousModuleId ?? ""] ?? 0
                        modules[i].isUnlocked = progress >= 100
                    }
                }
            }
            
            // Update completion percentage from user progress
            if let moduleId = modules[i].id {
                modules[i].completionPercentage = user.moduleProgress[moduleId] ?? 0
            }
        }
    }
    
    // MARK: - Creation Operations
    func loadCreations(for moduleId: String) async throws -> [Creation] {
        let snapshot = try await db.collection("creations")
            .whereField("moduleId", isEqualTo: moduleId)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Creation.self)
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
    func loadComponents() async throws -> [Component] {
        let snapshot = try await db.collection("components").getDocuments()
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Component.self)
        }
    }
    
    func loadComponents(for category: ComponentCategory) async throws -> [Component] {
        let snapshot = try await db.collection("components")
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Component.self)
        }
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