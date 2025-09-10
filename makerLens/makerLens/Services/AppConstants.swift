//
//  AppConstants.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct AppConstants {
    // MARK: - Colors
    struct Colors {
        static let primaryPurple = Color(hex: "#8B1A7A")    // Primary buttons, active states
        static let mediumPurple = Color(hex: "#A63A84")     // Secondary elements, hover states
        static let lightTeal = Color(hex: "#7DD3C0")        // Success states, progress indicators
        static let mediumTeal = Color(hex: "#5CBFB0")       // Accent elements
        static let darkTeal = Color(hex: "#4BA89B")         // Text accents, links
        static let deepestTeal = Color(hex: "#3A8B7A")      // Dark mode elements, shadows
        
        // Gradient combinations
        static let primaryGradient = LinearGradient(
            colors: [primaryPurple, mediumPurple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let tealGradient = LinearGradient(
            colors: [lightTeal, mediumTeal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    struct Fonts {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let headline = Font.headline.weight(.medium)
        static let body = Font.body
        static let caption = Font.caption
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }
    
    // MARK: - Shadow
    struct Shadow {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let heavy = Color.black.opacity(0.3)
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions for Consistent Styling
extension View {
    func cardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .cornerRadius(AppConstants.CornerRadius.md)
            .shadow(color: AppConstants.Shadow.light, radius: 2, x: 0, y: 1)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .padding(.horizontal, AppConstants.Spacing.lg)
            .padding(.vertical, AppConstants.Spacing.md)
            .background(AppConstants.Colors.primaryGradient)
            .cornerRadius(AppConstants.CornerRadius.md)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(AppConstants.Colors.primaryPurple)
            .padding(.horizontal, AppConstants.Spacing.lg)
            .padding(.vertical, AppConstants.Spacing.md)
            .background(Color(.systemGray6))
            .cornerRadius(AppConstants.CornerRadius.md)
    }
}