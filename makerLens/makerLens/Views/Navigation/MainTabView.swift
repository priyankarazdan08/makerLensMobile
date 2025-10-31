//
//  MainTabView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var firebaseService: FirebaseService
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
//            ExploreView()
//                .tabItem {
//                    Image(systemName: selectedTab == 1 ? "magnifyingglass.circle.fill" : "magnifyingglass")
//                    Text("Explore")
//                }
//                .tag(1)
            
            CreationsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "folder.fill" : "folder")
                    Text("Creations")
                }
                .tag(2)
            
            ComponentsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "book.fill" : "book")
                    Text("Components")
                }
                .tag(3)
            
            BuildView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "camera.fill" : "camera")
                    Text("Build")
                }
                .tag(4)
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: selectedTab == 5 ? "trophy.fill" : "trophy")
                    Text("Leaderboard")
                }
                .tag(5)
        }
        .accentColor(AppConstants.Colors.primaryPurple)
    }
}
