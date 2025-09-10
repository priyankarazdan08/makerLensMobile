//
//  HomeView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var modules: [Module] = SampleData.sampleModules
    @State private var currentUser = SampleData.sampleUser
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: AppConstants.Spacing.xl) {
                    // Your existing cute header - just cleaner
                    CleanerCuteHeaderView(user: currentUser)
                    
                    // Your existing welcome hero - more polished
                    PolishedWelcomeHeroCard()
                    
                    // Your existing quick actions - refined
                    RefinedQuickActionsSection()
                    
                    // UPDATED: Learning progress with spacers
                    CleanerLearningProgressSection(modules: modules)
                    
                    
                    // Your existing continue learning - polished
                    PolishedContinueLearningSection()
                    
                    // Your existing stats - refined
                    RefinedStatsOverviewSection(user: currentUser)
                    
                    Spacer(minLength: AppConstants.Spacing.xxl)
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.top, AppConstants.Spacing.md)
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Cleaner Cute Header (same concept, better execution)
struct CleanerCuteHeaderView: View {
    let user: User
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Hello")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text("👋")
                        .font(.system(size: 16))
                }
                
                Text(user.name.components(separatedBy: " ").first ?? "Maker")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Cleaner notification with subtle animation
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                        
                        // More subtle notification dot
                        Circle()
                            .fill(AppConstants.Colors.primaryPurple)
                            .frame(width: 6, height: 6)
                            .offset(x: 14, y: -14)
                    }
                }
                
                // More polished avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppConstants.Colors.lightTeal.opacity(0.8), AppConstants.Colors.mediumTeal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .shadow(color: AppConstants.Colors.lightTeal.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    UserAvatar(user: user, size: 44)
                }
            }
        }
    }
}

// MARK: - Polished Welcome Hero (same content, better visuals)
struct PolishedWelcomeHeroCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ready to build")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("amazing circuits?")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Let's start your Arduino journey today!")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 6)
                }
                
                Spacer()
                
                // Cleaner circuit icons with better spacing
                VStack(spacing: 12) {
                    Image(systemName: "cpu")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Image(systemName: "arrow.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Text("Start Learning")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(AppConstants.Colors.darkTeal)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(.white)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(AppConstants.Spacing.xl)
        .background(
            LinearGradient(
                colors: [AppConstants.Colors.mediumTeal, AppConstants.Colors.darkTeal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: AppConstants.Colors.mediumTeal.opacity(0.25), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Refined Quick Actions (same actions, cleaner design)
struct RefinedQuickActionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: AppConstants.Spacing.lg) {
                RefinedQuickActionCard(
                    title: "Scan Circuit",
                    icon: "camera.viewfinder",
                    color: AppConstants.Colors.lightTeal
                )
                
                RefinedQuickActionCard(
                    title: "Browse Projects",
                    icon: "folder.badge.plus",
                    color: AppConstants.Colors.mediumTeal
                )
                
                RefinedQuickActionCard(
                    title: "Learning Path",
                    icon: "map",
                    color: AppConstants.Colors.primaryPurple
                )
            }
        }
    }
}

struct RefinedQuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppConstants.Spacing.xl)
            .background(Color(.systemBackground))
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(isPressed ? 0.12 : 0.06), radius: isPressed ? 12 : 6, x: 0, y: isPressed ? 6 : 3)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .pressEvents {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = false
            }
        }
    }
}

// MARK: - UPDATED: Learning Progress with spacers like tutorial list
struct CleanerLearningProgressSection: View {
    let modules: [Module]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Your Journey")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("\(completedModules) of \(modules.count) modules completed 🎉")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, AppConstants.Spacing.xl)
            .padding(.top, AppConstants.Spacing.xl)
            .padding(.bottom, AppConstants.Spacing.lg)
            
            // Module list with spacers
            LazyVStack(spacing: 0) {
                ForEach(Array(modules.prefix(6).enumerated()), id: \.element.id) { index, module in
                    CleanerModuleCard(module: module)
                    
                    // Add spacer between items (but not after last item)
                    if index < min(modules.count, 6) - 1 {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 1)
                            .padding(.horizontal, AppConstants.Spacing.xl)
                    }
                }
            }
            .padding(.bottom, AppConstants.Spacing.xl)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    
    private var completedModules: Int {
        modules.filter { $0.completionPercentage >= 100 }.count
    }
}

struct CleanerModuleCard: View {
    let module: Module
    @State private var animateProgress = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Module Progress Circle (smaller, like tutorial images)
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 2.5)
                    .frame(width: 50, height: 50)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: animateProgress ? module.completionPercentage / 100 : 0)
                    .stroke(
                        module.completionPercentage >= 100 ?
                        AppConstants.Colors.lightTeal : AppConstants.Colors.primaryPurple,
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5).delay(Double(module.order) * 0.1), value: animateProgress)
                
                // Content
                if module.completionPercentage >= 100 {
                    Text("✅")
                        .font(.system(size: 14))
                } else if module.isUnlocked {
                    Text("\(module.order)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppConstants.Colors.primaryPurple)
                } else {
                    Text("🔒")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(8)
            .background(
                module.completionPercentage >= 100 ?
                AppConstants.Colors.lightTeal.opacity(0.1) :
                AppConstants.Colors.primaryPurple.opacity(0.08)
            )
            .cornerRadius(12)
            
            // Module Info
            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(module.isUnlocked ? .primary : .secondary)
                    .lineLimit(1)
                
                Text(module.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Progress percentage
            Text("\(Int(module.completionPercentage))%")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(module.completionPercentage >= 100 ? AppConstants.Colors.lightTeal : AppConstants.Colors.primaryPurple)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background((module.completionPercentage >= 100 ? AppConstants.Colors.lightTeal : AppConstants.Colors.primaryPurple).opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.horizontal, AppConstants.Spacing.xl)
        .padding(.vertical, AppConstants.Spacing.md)
        .opacity(module.isUnlocked ? 1.0 : 0.7)
        .onAppear {
            animateProgress = true
        }
    }
}

// MARK: - UPDATED: Professional Today's Goals with spacers
struct ProfessionalTodaysGoalsSection: View {
    @State private var goals = cuteDailyGoals
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's Goals")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Keep your streak alive! 🔥")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(completedGoals)/\(goals.count)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppConstants.Colors.primaryPurple)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(AppConstants.Colors.primaryPurple.opacity(0.1))
                    .cornerRadius(14)
            }
            .padding(.horizontal, AppConstants.Spacing.xl)
            .padding(.top, AppConstants.Spacing.xl)
            .padding(.bottom, AppConstants.Spacing.lg)
            
            // Goals list with spacers
            LazyVStack(spacing: 0) {
                ForEach(Array($goals.enumerated()), id: \.element.id) { index, $goal in
                    ProfessionalGoalRow(goal: $goal)
                    
                    // Add spacer between items (but not after last item)
                    if index < goals.count - 1 {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 1)
                            .padding(.horizontal, AppConstants.Spacing.xl)
                    }
                }
            }
            .padding(.bottom, AppConstants.Spacing.xl)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
    
    private var completedGoals: Int {
        goals.filter { $0.isCompleted }.count
    }
}

struct ProfessionalGoalRow: View {
    @Binding var goal: CuteDailyGoal
    
    var body: some View {
        HStack(spacing: 16) {
            // Goal Icon in rounded square (like tutorial images)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(goal.isCompleted ? AppConstants.Colors.lightTeal.opacity(0.2) : Color(.systemGray6))
                    .frame(width: 50, height: 50)
                
                Text(goal.emoji)
                    .font(.system(size: 20))
                
                // Checkmark overlay for completed
                if goal.isCompleted {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(AppConstants.Colors.lightTeal)
                                    .frame(width: 18, height: 18)
                                
                                Text("✓")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: 50, height: 50)
                }
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    goal.isCompleted.toggle()
                }
            }
            
            // Goal Info
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)
                    .strikethrough(goal.isCompleted)
                
                Text(goal.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Points badge
            Text("+\(goal.points)")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.orange.opacity(0.1))
                .cornerRadius(10)
        }
        .padding(.horizontal, AppConstants.Spacing.xl)
        .padding(.vertical, AppConstants.Spacing.md)
    }
}

// MARK: - Polished Continue Learning (same content, better design)
struct PolishedContinueLearningSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
            Text("Continue Watching")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 18) {
                // Better video thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [AppConstants.Colors.mediumTeal.opacity(0.3), AppConstants.Colors.darkTeal.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 88, height: 66)
                    
                    VStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.9))
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppConstants.Colors.darkTeal)
                        }
                        
                        Text("15m")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppConstants.Colors.darkTeal)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.white.opacity(0.9))
                            .cornerRadius(6)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("LED Brightness Control")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Learn PWM with potentiometers 💡")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Button(action: {}) {
                        Text("Continue")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(AppConstants.Colors.primaryPurple)
                            .cornerRadius(18)
                            .shadow(color: AppConstants.Colors.primaryPurple.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                }
                
                Spacer()
            }
        }
        .padding(AppConstants.Spacing.xl)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Refined Stats (same stats, cleaner presentation)
struct RefinedStatsOverviewSection: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 14) {
            RefinedStatCard(
                title: "Streak",
                value: "\(user.streak)",
                subtitle: "days",
                icon: "flame.fill",
                color: .red
            )
            
            RefinedStatCard(
                title: "Points",
                value: "\(user.points)",
                subtitle: "XP",
                icon: "star.fill",
                color: .orange
            )
            
            RefinedStatCard(
                title: "Done",
                value: "\(user.completedCreations.count)",
                subtitle: "projects",
                icon: "checkmark.circle.fill",
                color: AppConstants.Colors.lightTeal
            )
        }
    }
}

struct RefinedStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppConstants.Spacing.xl)
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Sample Data (same as before)
struct CuteDailyGoal: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let emoji: String
    let points: Int
    var isCompleted: Bool
}

private let cuteDailyGoals = [
    CuteDailyGoal(title: "Complete LED tutorial", subtitle: "Basic circuits", emoji: "💡", points: 15, isCompleted: true),
    CuteDailyGoal(title: "Practice coding", subtitle: "15 minutes", emoji: "💻", points: 10, isCompleted: false),
    CuteDailyGoal(title: "Build a circuit", subtitle: "Hands-on learning", emoji: "🔧", points: 25, isCompleted: false)
]
