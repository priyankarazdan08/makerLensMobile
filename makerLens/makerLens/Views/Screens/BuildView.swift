//
//  BuildView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct BuildView: View {
    @State private var showingCamera = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppConstants.Spacing.xl) {
                // Top Navigation (no search/profile for Build)
                TopNavigationView(title: "Build")
                
                Spacer()
                
                // Camera Integration Section
                VStack(spacing: AppConstants.Spacing.lg) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 80))
                        .foregroundColor(AppConstants.Colors.mediumTeal)
                    
                    Text("Circuit Recognition")
                        .font(AppConstants.Fonts.title)
                    
                    Text("Point your camera at your Arduino circuit to identify components and get project suggestions")
                        .font(AppConstants.Fonts.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, AppConstants.Spacing.xl)
                    
                    Button(action: {
                        showingCamera = true
                    }) {
                        Text("Open Camera")
                            .primaryButtonStyle()
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, AppConstants.Spacing.md)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingCamera) {
            CameraView()
        }
    }
}

// MARK: - Placeholder Views for Project Tabs
struct ToDoProjectsView: View {
    var body: some View {
        VStack {
            Text("📋 To Do Projects")
                .font(AppConstants.Fonts.headline)
            Text("Your assigned or recommended projects will appear here")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct InProgressProjectsView: View {
    var body: some View {
        VStack {
            Text("🔨 In Progress")
                .font(AppConstants.Fonts.headline)
            Text("Projects you're currently working on will appear here")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct FinishedProjectsView: View {
    var body: some View {
        VStack {
            Text("✅ Finished Projects")
                .font(AppConstants.Fonts.headline)
            Text("Your completed projects will appear here")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Placeholder Card Views
struct FeaturedProjectCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: AppConstants.CornerRadius.md)
            .fill(AppConstants.Colors.tealGradient)
            .frame(width: 200, height: 120)
            .overlay(
                VStack {
                    Text("Featured Project")
                        .font(AppConstants.Fonts.headline)
                        .foregroundColor(.white)
                    Text("Coming Soon")
                        .font(AppConstants.Fonts.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            )
    }
}

struct ComponentCategoryCard: View {
    let category: ComponentCategory
    
    var body: some View {
        VStack(spacing: AppConstants.Spacing.sm) {
            Image(systemName: category.icon)
                .font(.largeTitle)
                .foregroundColor(AppConstants.Colors.mediumTeal)
            
            Text(category.rawValue)
                .font(AppConstants.Fonts.headline)
        }
        .cardStyle()
        .padding(AppConstants.Spacing.lg)
    }
}
