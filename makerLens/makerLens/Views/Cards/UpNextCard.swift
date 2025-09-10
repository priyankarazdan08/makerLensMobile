//
//  UpNextCard.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct UpNextCard: View {
    @State private var upNextItem = sampleUpNext
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
            // Header
            HStack {
                Text("Up Next")
                    .font(AppConstants.Fonts.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "arrow.right.circle")
                        .font(.title3)
                        .foregroundColor(AppConstants.Colors.darkTeal)
                }
            }
            
            // Content
            HStack(spacing: AppConstants.Spacing.md) {
                // Thumbnail
                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.sm)
                    .fill(AppConstants.Colors.mediumTeal.opacity(0.2))
                    .frame(width: 80, height: 60)
                    .overlay(
                        VStack {
                            Image(systemName: upNextItem.type == "Video" ? "play.circle.fill" : "wrench.and.screwdriver")
                                .font(.title2)
                                .foregroundColor(AppConstants.Colors.primaryPurple)
                            
                            if upNextItem.type == "Video" {
                                Text(upNextItem.duration)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(upNextItem.title)
                        .font(AppConstants.Fonts.body)
                        .fontWeight(.medium)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: upNextItem.type == "Video" ? "play.rectangle" : "hammer")
                            .font(.caption)
                            .foregroundColor(AppConstants.Colors.mediumTeal)
                        
                        Text("\(upNextItem.type) • \(upNextItem.duration)")
                            .font(AppConstants.Fonts.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(upNextItem.description)
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            // Action button
            Button(action: {}) {
                Text("Continue Learning")
                    .font(AppConstants.Fonts.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppConstants.Spacing.sm)
                    .background(AppConstants.Colors.primaryGradient)
                    .cornerRadius(AppConstants.CornerRadius.sm)
            }
        }
        .padding(AppConstants.Spacing.lg)
        .cardStyle()
        .padding(.horizontal, AppConstants.Spacing.lg)
    }
}

// Sample data for up next
struct UpNextItem {
    let title: String
    let type: String
    let duration: String
    let description: String
}

private let sampleUpNext = UpNextItem(
    title: "LED Brightness Control",
    type: "Video",
    duration: "15 min",
    description: "Learn how to control LED brightness using PWM and potentiometers"
)