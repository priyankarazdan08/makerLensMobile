//
//  ComponentsView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/22/25.
//


import SwiftUI

struct ComponentsView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var components: [Component] = []
    @State private var searchText = ""
    @State private var selectedCategory: ComponentCategory? = nil
    @State private var isLoading = true
    
    var filteredComponents: [Component] {
        var filtered = components
        
        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation
                TopNavigationView(title: "Components", showSearch: true, showProfile: true)
                
                if isLoading {
                    ProgressView("Loading components...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xl) {
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                
                                TextField("Search components...", text: $searchText)
                                    .font(.system(size: 16))
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal, AppConstants.Spacing.lg)
                            .padding(.top, AppConstants.Spacing.md)
                            
                            // Category Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    CategoryFilterChip(
                                        title: "All",
                                        isSelected: selectedCategory == nil
                                    ) {
                                        selectedCategory = nil
                                    }
                                    
                                    ForEach(ComponentCategory.allCases, id: \.self) { category in
                                        CategoryFilterChip(
                                            title: category.rawValue,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.horizontal, AppConstants.Spacing.lg)
                            }
                            
                            // Components Grid/List
                            if filteredComponents.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "cpu")
                                        .font(.system(size: 56))
                                        .foregroundColor(.secondary.opacity(0.5))
                                    
                                    Text("No components found")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 80)
                            } else {
                                LazyVStack(spacing: AppConstants.Spacing.md) {
                                    ForEach(filteredComponents) { component in
                                        NavigationLink(destination: ComponentDetailView(component: component)) {
                                            ComponentCard(component: component)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, AppConstants.Spacing.lg)
                            }
                            
                            Spacer(minLength: 40)
                        }
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await loadComponents()
        }
    }
    
    private func loadComponents() async {
        do {
            components = try await firebaseService.loadComponents()
            print("✅ Loaded \(components.count) components")
            isLoading = false
        } catch {
            print("❌ Error loading components: \(error.localizedDescription)")
            isLoading = false
        }
    }
}

// MARK: - Category Filter Chip
struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    AppConstants.Colors.primaryPurple :
                    Color(.systemBackground)
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(isSelected ? 0.1 : 0.05), radius: 4)
        }
    }
}

// MARK: - Component Card
struct ComponentCard: View {
    let component: Component
    
    var body: some View {
        HStack(spacing: 16) {
            // Component icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppConstants.Colors.lightTeal.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: component.category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppConstants.Colors.mediumTeal)
            }
            
            // Component info
            VStack(alignment: .leading, spacing: 6) {
                Text(component.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(component.description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(component.category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppConstants.Colors.mediumTeal)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(AppConstants.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}
