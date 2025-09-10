//
//  DailyGoalCard.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct DailyGoalCard: View {
    @State private var dailyGoals: [DailyGoalItem] = sampleDailyGoals
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Goals")
                        .font(AppConstants.Fonts.headline)
                        .fontWeight(.semibold)
                    
                    Text("Keep your streak alive! 🔥")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(completedGoalsCount)/\(dailyGoals.count)")
                        .font(AppConstants.Fonts.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppConstants.Colors.primaryPurple)
                    
                    Text("completed")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress bar
            ProgressView(value: Double(completedGoalsCount), total: Double(dailyGoals.count))
                .progressViewStyle(LinearProgressViewStyle(tint: AppConstants.Colors.lightTeal))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            // Goal items
            VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                ForEach($dailyGoals) { $goal in
                    DailyGoalItemView(goal: $goal)
                }
            }
        }
        .padding(AppConstants.Spacing.lg)
        .cardStyle()
        .padding(.horizontal, AppConstants.Spacing.lg)
    }
    
    private var completedGoalsCount: Int {
        dailyGoals.filter { $0.isCompleted }.count
    }
}

struct DailyGoalItemView: View {
    @Binding var goal: DailyGoalItem
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.md) {
            // Checkbox
            Button(action: {
                withAnimation(AppConstants.Animation.quick) {
                    goal.isCompleted.toggle()
                }
            }) {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(goal.isCompleted ? AppConstants.Colors.lightTeal : .gray)
            }
            
            // Goal text
            VStack(alignment: .leading, spacing: 2) {
                Text(goal.title)
                    .font(AppConstants.Fonts.body)
                    .strikethrough(goal.isCompleted)
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)
                
                if !goal.description.isEmpty {
                    Text(goal.description)
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // XP reward
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
                Text("\(goal.xpReward)")
                    .font(AppConstants.Fonts.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
            }
        }
    }
}

// Sample data for daily goals
struct DailyGoalItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let xpReward: Int
    var isCompleted: Bool
}

private let sampleDailyGoals = [
    DailyGoalItem(title: "Complete LED tutorial", description: "Finish the basic LED circuit tutorial", xpReward: 15, isCompleted: true),
    DailyGoalItem(title: "Build resistor circuit", description: "Practice with resistor calculations", xpReward: 25, isCompleted: false),
    DailyGoalItem(title: "Code practice: 15 min", description: "Work on Arduino programming", xpReward: 10, isCompleted: false)
]
