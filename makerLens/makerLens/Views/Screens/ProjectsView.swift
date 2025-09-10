//
//  ProjectsView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var selectedTab = 0
    private let tabs = ["To Do", "In Progress", "Finished"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation with search + profile
                TopNavigationView(title: "Projects", showSearch: true, showProfile: true)
                
                // Tab Selector
                HStack {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text(tabs[index])
                                .font(AppConstants.Fonts.headline)
                                .foregroundColor(selectedTab == index ? AppConstants.Colors.primaryPurple : .secondary)
                                .padding(.vertical, AppConstants.Spacing.md)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .background(Color(.systemGray6))
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                // Content based on selected tab
                ScrollView {
                    VStack(spacing: AppConstants.Spacing.md) {
                        switch selectedTab {
                        case 0:
                            ToDoProjectsView()
                        case 1:
                            InProgressProjectsView()
                        case 2:
                            FinishedProjectsView()
                        default:
                            EmptyView()
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}