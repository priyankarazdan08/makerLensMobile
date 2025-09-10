//
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
    private let scopes = ["Global", "School", "Friends"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation with profile only
                TopNavigationView(title: "Leaderboard", showProfile: true)
                
                // Scope Selector
                HStack {
                    ForEach(0..<scopes.count, id: \.self) { index in
                        Button(action: {
                            selectedScope = index
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
                        CurrentUserRankCard()
                        
                        // Points System Explanation
                        PointsSystemCard()
                        
                        // Leaderboard List
                        LazyVStack(spacing: AppConstants.Spacing.sm) {
                            ForEach(1...10, id: \.self) { rank in
                                LeaderboardRowView(rank: rank)
                            }
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CurrentUserRankCard: View {
    var body: some View {
        VStack(spacing: AppConstants.Spacing.md) {
            HStack {
                Text("Your Rank")
                    .font(AppConstants.Fonts.headline)
                Spacer()
                Text("#42")
                    .font(AppConstants.Fonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppConstants.Colors.primaryPurple)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("2,847 XP")
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
                        Text("7")
                            .font(AppConstants.Fonts.title)
                            .fontWeight(.bold)
                    }
                    Text("Day Streak (2.4x multiplier)")
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
                    PointsBreakdownRow(activity: "Easy Tutorial/Project", points: "10 XP")
                    PointsBreakdownRow(activity: "Intermediate Tutorial/Project", points: "25 XP")
                    PointsBreakdownRow(activity: "Advanced Tutorial/Project", points: "50 XP")
                    PointsBreakdownRow(activity: "Super Hard Tutorial/Project", points: "100 XP")
                    PointsBreakdownRow(activity: "Free Build (Basic)", points: "15-30 XP")
                    PointsBreakdownRow(activity: "Free Build (Complex)", points: "40-75 XP")
                    
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
    let rank: Int
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.md) {
            // Rank Number
            Text("#\(rank)")
                .font(AppConstants.Fonts.headline)
                .fontWeight(.bold)
                .foregroundColor(rank <= 3 ? AppConstants.Colors.primaryPurple : .secondary)
                .frame(width: 40, alignment: .leading)
            
            // Avatar
            Circle()
                .fill(AppConstants.Colors.lightTeal)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            // User Info
            VStack(alignment: .leading, spacing: 2) {
                Text("Arduino Maker \(rank)")
                    .font(AppConstants.Fonts.body)
                    .fontWeight(.medium)
                
                HStack(spacing: AppConstants.Spacing.xs) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)
                    Text("\(Int.random(in: 1...15)) day streak")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Points and Movement
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int.random(in: 500...5000)) XP")
                    .font(AppConstants.Fonts.body)
                    .fontWeight(.semibold)
                
                let movement = Int.random(in: -5...10)
                HStack(spacing: 2) {
                    Image(systemName: movement >= 0 ? "arrow.up" : "arrow.down")
                        .font(.caption2)
                        .foregroundColor(movement >= 0 ? .green : .red)
                    Text("\(abs(movement))")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(movement >= 0 ? .green : .red)
                }
            }
        }
        .cardStyle()
        .padding(.horizontal, AppConstants.Spacing.lg)
        .padding(.vertical, AppConstants.Spacing.sm)
    }
}

// MARK: - LeaderboardEntry Model (Add this to your models if not already there)
struct LeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let userId: String
    let username: String
    let avatar: String?
    let xp: Int
    let rank: Int
    let streak: Int
    let movement: Int // +3 places, -1 place, etc.
    
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