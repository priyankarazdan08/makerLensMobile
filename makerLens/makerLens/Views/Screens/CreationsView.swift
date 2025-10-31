//
//  CreationsView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/22/25.
//


import SwiftUI

struct CreationsView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var selectedTab = 0
    @State private var allCreations: [Creation] = []
    @State private var currentUser: User? = nil
    @State private var isLoading = true
    private let tabs = ["To Do", "In Progress", "Finished"]
    
    // Filter creations based on user progress
    var toDoCreations: [Creation] {
        guard let user = currentUser else { return [] }
        return allCreations.filter { creation in
            !user.completedCreations.contains(creation.id ?? "") &&
            !user.inProgressCreations.contains(creation.id ?? "")
        }
    }
    
    var inProgressCreations: [Creation] {
        guard let user = currentUser else { return [] }
        return allCreations.filter { creation in
            user.inProgressCreations.contains(creation.id ?? "")
        }
    }
    
    var finishedCreations: [Creation] {
        guard let user = currentUser else { return [] }
        return allCreations.filter { creation in
            user.completedCreations.contains(creation.id ?? "")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation with search + profile
                TopNavigationView(title: "Creations", showSearch: true, showProfile: true)
                
                // Tab Selector
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedTab = index
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(tabs[index])
                                    .font(.system(size: 16, weight: selectedTab == index ? .semibold : .medium))
                                    .foregroundColor(selectedTab == index ? AppConstants.Colors.primaryPurple : .secondary)
                                
                                // Active indicator
                                Rectangle()
                                    .fill(selectedTab == index ? AppConstants.Colors.primaryPurple : Color.clear)
                                    .frame(height: 3)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppConstants.Spacing.md)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                
                // Content based on selected tab
                if isLoading {
                    ProgressView("Loading your creations...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: AppConstants.Spacing.lg) {
                            switch selectedTab {
                            case 0:
                                CreationsListView(
                                    creations: toDoCreations,
                                    emptyMessage: "All caught up! 🎉\nNo new creations to start"
                                )
                            case 1:
                                CreationsListView(
                                    creations: inProgressCreations,
                                    emptyMessage: "No creations in progress\nStart one from the To Do tab!"
                                )
                            case 2:
                                CreationsListView(
                                    creations: finishedCreations,
                                    emptyMessage: "No completed creations yet\nFinish your first creation to see it here! 🏆"
                                )
                            default:
                                EmptyView()
                            }
                        }
                        .padding(AppConstants.Spacing.lg)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        do {
            // Load user first
            try await firebaseService.loadUser(userId: "test-user")
            currentUser = firebaseService.currentUser
            
            // Load all creations (both projects and tutorials)
            try await firebaseService.loadCreations()
            allCreations = firebaseService.creations
            
            print("✅ Loaded \(allCreations.count) creations")
            print("✅ To Do: \(toDoCreations.count)")
            print("✅ In Progress: \(inProgressCreations.count)")
            print("✅ Finished: \(finishedCreations.count)")
            
            isLoading = false
        } catch {
            print("❌ Error loading creations: \(error.localizedDescription)")
            isLoading = false
        }
    }
}

// MARK: - Creations List View
struct CreationsListView: View {
    let creations: [Creation]
    let emptyMessage: String
    
    var body: some View {
        if creations.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "tray")
                    .font(.system(size: 56))
                    .foregroundColor(.secondary.opacity(0.5))
                
                Text(emptyMessage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 80)
        } else {
            LazyVStack(spacing: AppConstants.Spacing.md) {
                ForEach(creations) { creation in
                    NavigationLink(destination: CreationDetailView(creation: creation)) {
                        CreationRowCard(creation: creation)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Creation Row Card
struct CreationRowCard: View {
    let creation: Creation
    
    var body: some View {
        HStack(spacing: 16) {
            // Type indicator icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(typeColor.opacity(0.15))
                    .frame(width: 60, height: 60)
                
                Image(systemName: typeIcon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(typeColor)
            }
            
            // Creation info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(creation.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    // Type badge
                    Text(creation.type.rawValue.capitalized)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(typeColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(typeColor.opacity(0.15))
                        .cornerRadius(6)
                }
                
                HStack(spacing: 12) {
                    // FIXED: Handle optional estimatedDuration
                    if let duration = creation.estimatedDuration {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text(duration)
                                .font(.system(size: 13))
                        }
                        
                        Text("•")
                    }
                    
                    Text(creation.difficulty.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: creation.difficulty.color))
                }
                .foregroundColor(.secondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(AppConstants.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
    private var typeColor: Color {
        creation.type == .project ? AppConstants.Colors.primaryPurple : AppConstants.Colors.mediumTeal
    }
    
    private var typeIcon: String {
        creation.type == .project ? "hammer.fill" : "book.fill"
    }
}
