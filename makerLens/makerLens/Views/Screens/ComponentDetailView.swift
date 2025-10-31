//
//  ComponentDetailView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/22/25.
//


import SwiftUI

struct ComponentDetailView: View {
    let component: Component
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var relatedCreations: [Creation] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    // Component Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppConstants.Colors.lightTeal.opacity(0.15))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: component.category.icon)
                            .font(.system(size: 48, weight: .medium))
                            .foregroundColor(AppConstants.Colors.mediumTeal)
                    }
                    
                    // Category Badge
                    Text(component.category.rawValue)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppConstants.Colors.mediumTeal)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppConstants.Colors.mediumTeal.opacity(0.15))
                        .cornerRadius(8)
                    
                    // Name
                    Text(component.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    // Description
                    Text(component.description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                // Used In Projects
                if !component.creations.isEmpty {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                        HStack {
                            Text("Used in Creations")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            
                            Spacer()
                            
                            Text("\(component.creations.count)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppConstants.Colors.primaryPurple)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AppConstants.Colors.primaryPurple.opacity(0.15))
                                .cornerRadius(8)
                        }
                        
                        if !relatedCreations.isEmpty {
                            ForEach(relatedCreations.prefix(3)) { creation in
                                NavigationLink(destination: CreationDetailView(creation: creation)) {
                                    RelatedCreationRow(creation: creation)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            if component.creations.count > 3 {
                                Button(action: {}) {
                                    Text("See all \(component.creations.count) projects")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(AppConstants.Colors.primaryPurple)
                                }
                            }
                        } else {
                            Text("Loading creations...")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                }
                
                // Tutorials
//                if !component.tutorials.isEmpty {
//                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
//                        Text("Learn About This")
//                            .font(.system(size: 20, weight: .bold, design: .rounded))
//                        
//                        Text("Check out these tutorials to learn more about this component")
//                            .font(.system(size: 15))
//                            .foregroundColor(.secondary)
//                    }
//                    .padding(.horizontal, AppConstants.Spacing.lg)
//                }
                
                Spacer(minLength: 40)
            }
            .padding(.top, AppConstants.Spacing.xl)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadRelatedCreations()
        }
    }
    
    private func loadRelatedCreations() async {
        // First, ensure creations are loaded
        if firebaseService.creations.isEmpty {
            do {
                try await firebaseService.loadCreations()
                print("✅ Loaded creations for component view")
            } catch {
                print("❌ Error loading creations: \(error)")
                return
            }
        }
        
        // Load creations that use this component
        // Match by TITLE instead of ID since Firebase stores titles
        relatedCreations = firebaseService.creations.filter { creation in
            component.creations.contains(creation.title)
        }
        
        print("✅ Found \(relatedCreations.count) related creations for \(component.name)")
        print("📋 Component creations list: \(component.creations)")
    }
}

struct RelatedCreationRow: View {
    let creation: Creation
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .frame(width: 50, height: 50)
                
                Image(systemName: creation.type == .project ? "hammer.fill" : "book.fill")
                    .foregroundColor(creation.type == .project ? AppConstants.Colors.primaryPurple : AppConstants.Colors.mediumTeal)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(creation.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                // Handle optional duration
                if let duration = creation.estimatedDuration {
                    Text("\(duration) • \(creation.difficulty.rawValue)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                } else {
                    Text(creation.difficulty.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
