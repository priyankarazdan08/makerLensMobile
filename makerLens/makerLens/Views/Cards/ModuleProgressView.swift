//
//  ModuleProgressView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct ModuleProgressView: View {
    let modules: [Module]
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.lg) {
            // Header
            HStack {
                Text("Your Progress")
                    .font(AppConstants.Fonts.headline)
                Spacer()
                Text("\(completedModules)/\(modules.count) Modules")
                    .font(AppConstants.Fonts.body)
                    .foregroundColor(AppConstants.Colors.darkTeal)
            }
            .padding(.horizontal, AppConstants.Spacing.lg)
            
            // Module Circles (2 rows of 3)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: AppConstants.Spacing.lg) {
                ForEach(modules.prefix(6)) { module in
                    ModuleCircleView(module: module)
                }
            }
            .padding(.horizontal, AppConstants.Spacing.lg)
        }
    }
    
    private var completedModules: Int {
        modules.filter { $0.completionPercentage >= 100 }.count
    }
}

struct ModuleCircleView: View {
    let module: Module
    @State private var animateProgress = false
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(AppConstants.Colors.lightTeal.opacity(0.3), lineWidth: 4)
                    .frame(width: 70, height: 70)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: animateProgress ? module.completionPercentage / 100 : 0)
                    .stroke(
                        module.completionPercentage >= 100 ? 
                        AppConstants.Colors.lightTeal : AppConstants.Colors.primaryPurple,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(-90))
                    .animation(AppConstants.Animation.slow.delay(Double(module.order) * 0.1), value: animateProgress)
                
                // Module number or checkmark
                if module.completionPercentage >= 100 {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppConstants.Colors.lightTeal)
                } else {
                    Text("\(module.order)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(module.isUnlocked ? AppConstants.Colors.primaryPurple : .gray)
                }
            }
            
            // Module title
            Text(module.title)
                .font(AppConstants.Fonts.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(module.isUnlocked ? .primary : .secondary)
                .lineLimit(2)
                .frame(maxWidth: 80)
            
            // Progress percentage
            Text("\(Int(module.completionPercentage))%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .opacity(module.isUnlocked ? 1.0 : 0.6)
        .onAppear {
            animateProgress = true
        }
    }
}
