//
//  TopNavigationView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import SwiftUI

struct TopNavigationView: View {
    let title: String
    let showSearch: Bool
    let showProfile: Bool
    @State private var searchText = ""
    @State private var showingSearch = false // ADD THIS LINE
    
    init(title: String, showSearch: Bool = false, showProfile: Bool = false) {
        self.title = title
        self.showSearch = showSearch
        self.showProfile = showProfile
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppConstants.Fonts.largeTitle)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: AppConstants.Spacing.md) {
                if showSearch {
                    Button(action: {
                        showingSearch = true // UPDATE THIS ACTION
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(AppConstants.Colors.darkTeal)
                    }
                }
                
                if showProfile {
                    Button(action: {
                        // TODO: Implement profile
                    }) {
                        Circle()
                            .fill(AppConstants.Colors.lightTeal)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                if !showSearch && !showProfile {
                    Button(action: {
                        // TODO: Implement menu
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(AppConstants.Colors.darkTeal)
                    }
                }
            }
        }
        .padding(.horizontal, AppConstants.Spacing.lg)
        .sheet(isPresented: $showingSearch) { // ADD THIS SHEET
            SearchView()
        }
    }
}
