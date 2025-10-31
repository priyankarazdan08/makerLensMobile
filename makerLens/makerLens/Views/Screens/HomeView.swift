//
//  HomeView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var currentUser: User? = nil
    @State private var allCreations: [Creation] = []
    @State private var isLoading = true
    
    // Filter creations
    var toDoCount: Int {
        guard let user = currentUser else { return 0 }
        return allCreations.filter { creation in
            !user.completedCreations.contains(creation.id ?? "") &&
            !user.inProgressCreations.contains(creation.id ?? "")
        }.count
    }
    
    var inProgressCount: Int {
        guard let user = currentUser else { return 0 }
        return allCreations.filter { creation in
            user.inProgressCreations.contains(creation.id ?? "")
        }.count
    }
    
    var finishedCount: Int {
        currentUser?.completedCreations.count ?? 0
    }
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 28) {
                        // Clean Header
                        if let user = currentUser {
                            CleanHeaderView(user: user)
                        }
                        
                        // Welcome Hero Card
                        if let user = currentUser {
                            WelcomeHeroCard(userName: user.name.components(separatedBy: " ").first ?? "Maker")
                        }
                        
                        // Shortcuts Grid
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Shortcuts")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                NavigationLink(destination: CreationsView()) {
                                    ShortcutTile(
                                        icon: "list.bullet.clipboard",
                                        iconColor: .orange,
                                        number: toDoCount,
                                        label: "To Do"
                                    )
                                }
                                
                                NavigationLink(destination: CreationsView()) {
                                    ShortcutTile(
                                        icon: "clock.fill",
                                        iconColor: .blue,
                                        number: inProgressCount,
                                        label: "In Progress"
                                    )
                                }
                                
                                NavigationLink(destination: BuildView()) {
                                    ShortcutTile(
                                        icon: "camera.viewfinder",
                                        iconColor: AppConstants.Colors.primaryPurple,
                                        number: nil,
                                        label: "Scan Circuit"
                                    )
                                }
                                
                                NavigationLink(destination: ComponentsView()) {
                                    ShortcutTile(
                                        icon: "cpu",
                                        iconColor: AppConstants.Colors.mediumTeal,
                                        number: nil,
                                        label: "Components"
                                    )
                                }
                            }
                        }
                        
                        // Your Stats
                        if let user = currentUser {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Your Progress")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 14) {
                                    MiniStatCard(
                                        icon: "flame.fill",
                                        iconColor: .red,
                                        value: "\(user.streak)",
                                        label: "Day Streak"
                                    )
                                    
                                    MiniStatCard(
                                        icon: "star.fill",
                                        iconColor: .orange,
                                        value: "\(user.points)",
                                        label: "Points"
                                    )
                                    
                                    MiniStatCard(
                                        icon: "trophy.fill",
                                        iconColor: AppConstants.Colors.primaryPurple,
                                        value: "#\(user.currentRank)",
                                        label: "Rank"
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            await firebaseService.loadUser(userId: "test-user")
            currentUser = firebaseService.currentUser
            
            try await firebaseService.loadCreations()
            allCreations = firebaseService.creations
            
            isLoading = false
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            isLoading = false
        }
    }
}

// MARK: - Clean Header
struct CleanHeaderView: View {
    let user: User
    
    var body: some View {
        HStack {
            // Simple avatar with initials
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppConstants.Colors.lightTeal, AppConstants.Colors.mediumTeal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 54, height: 54)
                
                Text(userInitials)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: AppConstants.Colors.mediumTeal.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Spacer()
            
            // Bell icon
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 44, height: 44)
                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "bell")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    private var userInitials: String {
        let components = user.name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
}

// MARK: - Welcome Hero Card
struct WelcomeHeroCard: View {
    let userName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome, \(userName)! 👋")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Ready to get started")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                    
                    Text("with learning?")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "cpu")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Image(systemName: "arrow.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.trailing, 8)
            }
            
            NavigationLink(destination: CreationsView()) {
                HStack(spacing: 10) {
                    Text("Start Learning")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(AppConstants.Colors.darkTeal)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
                .background(.white)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
        }
        .padding(28)
        .background(
            LinearGradient(
                colors: [AppConstants.Colors.mediumTeal, AppConstants.Colors.darkTeal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .shadow(color: AppConstants.Colors.mediumTeal.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Shortcut Tile
struct ShortcutTile: View {
    let icon: String
    let iconColor: Color
    let number: Int?
    let label: String
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            if let number = number {
                Text("\(number)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Mini Stat Card
struct MiniStatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}
