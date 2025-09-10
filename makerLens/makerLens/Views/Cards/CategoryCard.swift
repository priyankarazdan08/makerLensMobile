//
//  CategoryCard.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/1/25.
//


import SwiftUI

struct CategoryCard: View {
    let category: ComponentCategory
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppConstants.Colors.lightTeal.opacity(0.2), AppConstants.Colors.mediumTeal.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppConstants.Colors.primaryPurple)
            }
            
            Text(category.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 90)
        .padding(.vertical, AppConstants.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(isPressed ? 0.15 : 0.05), radius: isPressed ? 12 : 4, x: 0, y: isPressed ? 6 : 2)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.2), value: isPressed)
        .onTapGesture {
            // TODO: Navigate to category
        }
        .pressEvents {
            withAnimation(.spring(response: 0.2)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.spring(response: 0.2)) {
                isPressed = false
            }
        }
    }
}