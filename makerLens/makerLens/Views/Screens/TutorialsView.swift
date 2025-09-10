//
//  TutorialsView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct TutorialsView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var components: [Component] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppConstants.Spacing.lg) {
                    // Top Navigation with search + profile
                    TopNavigationView(title: "Tutorials", showSearch: true, showProfile: true)
                    
                    // Component Library Header
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                        Text("Component Library")
                            .font(AppConstants.Fonts.headline)
                            .padding(.horizontal, AppConstants.Spacing.lg)
                        
                        Text("Learn about Arduino components and how to use them")
                            .font(AppConstants.Fonts.body)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, AppConstants.Spacing.lg)
                    }
                    
                    // Component Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppConstants.Spacing.md) {
                        ForEach(ComponentCategory.allCases, id: \.self) { category in
                            ComponentCategoryCard(category: category)
                        }
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                    
                    Spacer()
                }
                .padding(.vertical, AppConstants.Spacing.md)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}