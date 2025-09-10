//
//  ProjectCard.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import SwiftUI

struct ProjectCard: View {
    let creation: Creation
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: creation.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: creation.difficulty.color).opacity(0.3), Color(hex: creation.difficulty.color).opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Image(systemName: "cpu")
                                .font(.system(size: 30))
                                .foregroundColor(Color(hex: creation.difficulty.color))
                        )
                }
                .frame(width: 280, height: 160)
                .clipped()
                
                // Like button
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isLiked.toggle()
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isLiked ? .red : .white)
                        .frame(width: 32, height: 32)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(AppConstants.Spacing.md)
            }
            
            // Content section
            VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                HStack {
                    DifficultyBadge(difficulty: creation.difficulty)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("4.8")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(creation.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: creation.type == .project ? "hammer.fill" : "book.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppConstants.Colors.mediumTeal)
                    
                    Text("\(creation.type.rawValue.capitalized) • \(creation.estimatedDuration)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if creation.hasVideo {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppConstants.Colors.darkTeal)
                    }
                    
                    if creation.hasCode {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(AppConstants.Colors.darkTeal)
                    }
                }
                
                // Components tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppConstants.Spacing.xs) {
                        ForEach(creation.components.prefix(2), id: \.self) { component in
                            Text(component)
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, AppConstants.Spacing.sm)
                                .padding(.vertical, 4)
                                .background(AppConstants.Colors.lightTeal.opacity(0.15))
                                .foregroundColor(AppConstants.Colors.darkTeal)
                                .cornerRadius(6)
                        }
                        
                        if creation.components.count > 2 {
                            Text("+\(creation.components.count - 2)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(AppConstants.Spacing.lg)
        }
        .frame(width: 280)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty
    
    var body: some View {
        Text(difficulty.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, AppConstants.Spacing.sm)
            .padding(.vertical, 4)
            .background(Color(hex: difficulty.color).opacity(0.15))
            .foregroundColor(Color(hex: difficulty.color))
            .cornerRadius(6)
    }
}
