//
//  SearchView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/2/25.
//


import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBarView(searchText: $viewModel.searchText)
                
                // Content based on search state
                if viewModel.searchText.isEmpty {
                    SearchEmptyStateView(viewModel: viewModel)
                } else {
                    SearchResultsContentView(viewModel: viewModel)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Filters") {
                    showingFilters = true
                }
                .foregroundColor(AppConstants.Colors.primaryPurple)
            )
        }
        .sheet(isPresented: $showingFilters) {
            SearchFilterView(viewModel: viewModel)
        }
    }
}

// MARK: - Search Bar Component
struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search projects, tutorials, components...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, AppConstants.Spacing.lg)
        .padding(.vertical, AppConstants.Spacing.md)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, AppConstants.Spacing.lg)
        .padding(.vertical, AppConstants.Spacing.md)
    }
}

// MARK: - Empty State (Recent Searches)
struct SearchEmptyStateView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.xl) {
                // Recent Searches Section
                if !viewModel.recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                        HStack {
                            Text("RECENT SEARCHES")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, AppConstants.Spacing.lg)
                            
                            Spacer()
                        }
                        
                        ForEach(viewModel.recentSearches.prefix(5), id: \.self) { search in
                            RecentSearchRow(
                                searchText: search,
                                onTap: { viewModel.searchText = search },
                                onDelete: { viewModel.removeRecentSearch(search) }
                            )
                        }
                    }
                }
                
                // Popular Arduino Searches
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    Text("POPULAR SEARCHES")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, AppConstants.Spacing.lg)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppConstants.Spacing.md) {
                        ForEach(popularArduinoSearches, id: \.self) { search in
                            Button(action: {
                                viewModel.searchText = search
                            }) {
                                Text(search)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppConstants.Colors.primaryPurple)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(AppConstants.Colors.primaryPurple.opacity(0.1))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                }
                
                Spacer()
            }
            .padding(.top, AppConstants.Spacing.lg)
        }
    }
    
    private let popularArduinoSearches = [
        "LED", "Arduino Uno", "Sensor", "PWM",
        "Servo", "LCD", "Bluetooth", "Motor",
        "Resistor", "Breadboard", "Button", "Potentiometer"
    ]
}

struct RecentSearchRow: View {
    let searchText: String
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTap) {
                HStack {
                    Text(searchText)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, AppConstants.Spacing.lg)
        .padding(.vertical, AppConstants.Spacing.sm)
    }
}
