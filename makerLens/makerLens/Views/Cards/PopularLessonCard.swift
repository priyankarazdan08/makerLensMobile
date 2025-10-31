//
//  PopularLessonCard.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/6/25.
//

import SwiftUI

struct PopularLessonCard: View {
    let title: String
    let description: String
    let difficulty: Difficulty
    let duration: String
    let components: [String]
    let iconName: String
    let color: Color
    let hasVideo: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                
                if hasVideo {
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 18, height: 18)
                                
                                Image(systemName: "play.fill")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(x: 8, y: -8)
                        }
                        Spacer()
                    }
                    .frame(width: 60, height: 60)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text(duration)
                            .font(.system(size: 12))
                    }
                    
                    Text("•")
                    
                    // Difficulty badge
                    Text(difficulty.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(difficultyColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(difficultyColor.opacity(0.15))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    // Components count
                    HStack(spacing: 4) {
                        Image(systemName: "cpu")
                            .font(.system(size: 11))
                        Text("\(components.count)")
                            .font(.system(size: 12))
                    }
                }
                .foregroundColor(.secondary)
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        case .superHard: return .purple
        }
    }
}
