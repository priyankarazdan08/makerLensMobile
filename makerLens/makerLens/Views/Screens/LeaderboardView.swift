//  LeaderboardView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var selectedScope = 0
    @State private var leaderboardEntries: [LeaderboardEntry] = []
    @State private var isLoading = false
    @State private var showingProfile = false
    private let scopes = ["Global", "School", "Friends"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation with profile button
                HStack {
                    Text("Leaderboard")
                        .font(AppConstants.Fonts.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showingProfile = true
                    }) {
                        UserAvatar(user: firebaseService.currentUser, size: 32)
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.vertical, AppConstants.Spacing.md)
                
                // Scope Selector
                HStack {
                    ForEach(0..<scopes.count, id: \.self) { index in
                        Button(action: {
                            selectedScope = index
                            loadLeaderboard()
                        }) {
                            Text(scopes[index])
                                .font(AppConstants.Fonts.headline)
                                .foregroundColor(selectedScope == index ? AppConstants.Colors.primaryPurple : .secondary)
                                .padding(.vertical, AppConstants.Spacing.md)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                ScrollView {
                    VStack(spacing: AppConstants.Spacing.md) {
                        // User's Current Rank Card
                        if let user = firebaseService.currentUser {
                            CurrentUserRankCard(user: user)
                        }
                        
                        // Points System Explanation
                        PointsSystemCard()
                        
                        // Leaderboard List
                        if isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            LazyVStack(spacing: AppConstants.Spacing.sm) {
                                ForEach(leaderboardEntries) { entry in
                                    LeaderboardRowView(entry: entry)
                                }
                            }
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                }
            }
            .sheet(isPresented: $showingProfile) {
                UserProfileView()
                    .environmentObject(firebaseService)
            }
            .onAppear {
                loadLeaderboard()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loadLeaderboard() {
        isLoading = true
        
        Task {
            do {
                leaderboardEntries = try await firebaseService.fetchLeaderboard(scope: scopes[selectedScope])
                
                // If Firebase returns empty OR we're in Global scope, generate fake data
                if leaderboardEntries.isEmpty || scopes[selectedScope] == "Global" {
                    print("⚠️ Leaderboard empty or Global scope, generating fake data...")
                    generateFakeLeaderboard()
                }
                
                isLoading = false
            } catch {
                print("❌ Error loading leaderboard: \(error)")
                // Generate fake data as fallback
                generateFakeLeaderboard()
                isLoading = false
            }
        }
    }
    
    private func generateFakeLeaderboard() {
        let fakeNames = [
            "Emma Johnson", "Liam Smith", "Olivia Williams", "Noah Brown",
            "Ava Jones", "Ethan Garcia", "Sophia Martinez", "Mason Rodriguez",
            "Isabella Davis", "Lucas Miller"
        ]
        
        leaderboardEntries = (1...10).map { index in
            LeaderboardEntry(
                userId: "fake_\(index)",
                username: fakeNames[index - 1],
                avatar: nil,
                xp: Int.random(in: 500...5000),
                rank: index,
                streak: Int.random(in: 1...15),
                movement: Int.random(in: -5...10)
            )
        }
    }
}

struct CurrentUserRankCard: View {
    let user: User
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.md) {
            HStack {
                Text("Your Rank")
                    .font(AppConstants.Fonts.headline)
                Spacer()
                Text("#\(user.currentRank)")
                    .font(AppConstants.Fonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppConstants.Colors.primaryPurple)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(user.xp) Points")
                        .font(AppConstants.Fonts.title)
                        .fontWeight(.bold)
                    Text("Total Points")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(user.streak)")
                            .font(AppConstants.Fonts.title)
                            .fontWeight(.bold)
                    }
                    Text("Day Streak (\(String(format: "%.1f", user.streakMultiplier))x multiplier)")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .cardStyle()
        .padding(AppConstants.Spacing.lg)
    }
}

struct PointsSystemCard: View {
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
            HStack {
                Text("Points System")
                    .font(AppConstants.Fonts.headline)
                Spacer()
                Button(action: { showingDetails.toggle() }) {
                    Image(systemName: showingDetails ? "chevron.up" : "chevron.down")
                        .foregroundColor(AppConstants.Colors.darkTeal)
                }
            }
            
            if showingDetails {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                    PointsBreakdownRow(activity: "Easy Tutorial/Project", points: "10 pts")
                    PointsBreakdownRow(activity: "Intermediate Tutorial/Project", points: "25 pts")
                    PointsBreakdownRow(activity: "Advanced Tutorial/Project", points: "50 pts")
                    PointsBreakdownRow(activity: "Super Hard Tutorial/Project", points: "100 pts")
                    PointsBreakdownRow(activity: "Free Build (Basic)", points: "15-30 pts")
                    PointsBreakdownRow(activity: "Free Build (Complex)", points: "40-75 pts")
                    
                    Divider()
                        .padding(.vertical, AppConstants.Spacing.xs)
                    
                    Text("Streak Multiplier:")
                        .font(AppConstants.Fonts.body)
                        .fontWeight(.semibold)
                    PointsBreakdownRow(activity: "3+ days", points: "1.5x")
                    PointsBreakdownRow(activity: "7+ days", points: "2x")
                    PointsBreakdownRow(activity: "14+ days", points: "2.5x")
                    PointsBreakdownRow(activity: "30+ days", points: "3x")
                }
                .padding(.top, AppConstants.Spacing.sm)
            }
        }
        .cardStyle()
        .padding(AppConstants.Spacing.lg)
        .animation(AppConstants.Animation.smooth, value: showingDetails)
    }
}

struct PointsBreakdownRow: View {
    let activity: String
    let points: String
    
    var body: some View {
        HStack {
            Text(activity)
                .font(AppConstants.Fonts.body)
            Spacer()
            Text(points)
                .font(AppConstants.Fonts.body)
                .fontWeight(.medium)
                .foregroundColor(AppConstants.Colors.primaryPurple)
        }
    }
}

struct LeaderboardRowView: View {
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.md) {
            // Rank Number
            Text("#\(entry.rank)")
                .font(AppConstants.Fonts.headline)
                .fontWeight(.bold)
                .foregroundColor(entry.rank <= 3 ? AppConstants.Colors.primaryPurple : .secondary)
                .frame(width: 40, alignment: .leading)
            
            // Avatar
            Circle()
                .fill(AppConstants.Colors.lightTeal)
                .frame(width: 40, height: 40)
                .overlay(
                    Group {
                        if let firstLetter = entry.username.first {
                            Text(String(firstLetter))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                )
            
            // User Info
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.username)
                    .font(AppConstants.Fonts.body)
                    .fontWeight(.medium)
                
                HStack(spacing: AppConstants.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    Text("\(entry.streak) day streak")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Points and Movement
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.xp) pts")
                    .font(AppConstants.Fonts.body)
                    .fontWeight(.semibold)
                
                HStack(spacing: 2) {
                    Image(systemName: entry.movement >= 0 ? "arrow.up" : "arrow.down")
                        .font(.caption2)
                        .foregroundColor(entry.movement >= 0 ? .green : .red)
                    Text("\(abs(entry.movement))")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(entry.movement >= 0 ? .green : .red)
                }
            }
        }
        .cardStyle()
        .padding(.horizontal, AppConstants.Spacing.lg)
        .padding(.vertical, AppConstants.Spacing.sm)
    }
}

// MARK: - User Profile View
struct UserProfileView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @Environment(\.dismiss) var dismiss
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""
    @State private var isEditing = false
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppConstants.Spacing.lg) {
                // Profile Header
                VStack(spacing: AppConstants.Spacing.md) {
                    UserAvatar(user: firebaseService.currentUser, size: 80)
                    
                    if isEditing {
                        TextField("Name", text: $editedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, AppConstants.Spacing.xl)
                    } else {
                        Text(firebaseService.currentUser?.name ?? "User")
                            .font(AppConstants.Fonts.title)
                            .fontWeight(.bold)
                    }
                    
                    if isEditing {
                        TextField("Email", text: $editedEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, AppConstants.Spacing.xl)
                    } else {
                        Text(firebaseService.currentUser?.email ?? "")
                            .font(AppConstants.Fonts.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, AppConstants.Spacing.xl)
                
                // Stats Card
                if let user = firebaseService.currentUser {
                    VStack(spacing: AppConstants.Spacing.md) {
                        HStack(spacing: AppConstants.Spacing.xl) {
                            StatItem(title: "Points", value: "\(user.xp)")
                            Divider()
                            StatItem(title: "Rank", value: "#\(user.currentRank)")
                            Divider()
                            StatItem(title: "Streak", value: "\(user.streak)")
                        }
                    }
                    .cardStyle()
                    .padding(.horizontal, AppConstants.Spacing.lg)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: AppConstants.Spacing.md) {
                    if isEditing {
                        Button(action: saveChanges) {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .primaryButtonStyle()
                        .disabled(isSaving)
                        
                        Button(action: {
                            isEditing = false
                            resetFields()
                        }) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .secondaryButtonStyle()
                    } else {
                        Button(action: {
                            isEditing = true
                            editedName = firebaseService.currentUser?.name ?? ""
                            editedEmail = firebaseService.currentUser?.email ?? ""
                        }) {
                            Text("Edit Profile")
                                .frame(maxWidth: .infinity)
                        }
                        .primaryButtonStyle()
                    }
                    
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .secondaryButtonStyle()
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.bottom, AppConstants.Spacing.xl)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func resetFields() {
        editedName = firebaseService.currentUser?.name ?? ""
        editedEmail = firebaseService.currentUser?.email ?? ""
    }
    
    private func saveChanges() {
        guard !editedName.isEmpty, !editedEmail.isEmpty else {
            errorMessage = "Name and email cannot be empty"
            showError = true
            return
        }
        
        isSaving = true
        
        Task {
            do {
                try await firebaseService.updateUserProfile(name: editedName, email: editedEmail)
                isEditing = false
                isSaving = false
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isSaving = false
            }
        }
    }
    
    private func signOut() {
        Task {
            do {
                try firebaseService.signOut()
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.xs) {
            Text(value)
                .font(AppConstants.Fonts.title)
                .fontWeight(.bold)
                .foregroundColor(AppConstants.Colors.primaryPurple)
            Text(title)
                .font(AppConstants.Fonts.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - LeaderboardEntry Model
struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let userId: String
    let username: String
    let avatar: String?
    let xp: Int
    let rank: Int
    let streak: Int
    let movement: Int
    
    init(userId: String, username: String, avatar: String? = nil, xp: Int, rank: Int, streak: Int, movement: Int = 0) {
        self.userId = userId
        self.username = username
        self.avatar = avatar
        self.xp = xp
        self.rank = rank
        self.streak = streak
        self.movement = movement
    }
}
