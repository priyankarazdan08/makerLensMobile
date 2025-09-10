//
//  HeroCard.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/1/25.
//


import SwiftUI

struct HeroCard: View {
    let title: String
    let subtitle: String
    let description: String
    let actionText: String
    let onAction: () -> Void
    
    init(title: String = "Let's Learn", subtitle: String = "More!", description: String = "Discover new Arduino projects", actionText: String = "Get Started", onAction: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.actionText = actionText
        self.onAction = onAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 2)
                    
                    Button(action: onAction) {
                        Text(actionText)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppConstants.Colors.primaryPurple)
                            .padding(.horizontal, AppConstants.Spacing.lg)
                            .padding(.vertical, AppConstants.Spacing.sm)
                            .background(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, AppConstants.Spacing.sm)
                }
                
                Spacer()
                
                // Illustration
                VStack {
                    Image(systemName: "cpu")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                        .offset(x: 15, y: -10)
                }
                .padding(.trailing, AppConstants.Spacing.md)
            }
        }
        .padding(AppConstants.Spacing.lg)
        .background(
            LinearGradient(
                colors: [AppConstants.Colors.primaryPurple, AppConstants.Colors.mediumPurple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}