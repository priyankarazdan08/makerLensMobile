//
//  SearchResultsContentView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/2/25.
//


import SwiftUI

struct SearchResultsContentView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Sort and Filter Bar
            HStack {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 12))
                        Text("Sort")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 12))
                        Text("Filter")
                            .font(.system(size: 14, weight: .medium))
                        
                        if hasActiveFilters {
                            Circle()
                                .fill(AppConstants.Colors.primaryPurple)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, AppConstants.Spacing.lg)
            .padding(.vertical, AppConstants.Spacing.sm)
            
            // Search Results Grid (2 columns like your image)
            if viewModel.isSearching {
                ProgressView("Searching...")
                    .padding(AppConstants.Spacing.xl)
            } else if viewModel.searchResults.isEmpty {
                VStack(spacing: AppConstants.Spacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    
                    Text("No results found")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("Try different search terms")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(AppConstants.Spacing.xl)
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 20) {
                        ForEach(viewModel.searchResults) { creation in
                            SearchResultCard(creation: creation)
                        }
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                    .padding(.top, AppConstants.Spacing.md)
                }
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        viewModel.selectedDifficulty != nil || viewModel.selectedType != nil
    }
}

// MARK: - Search Result Card (like your grid images)
struct SearchResultCard: View {
    let creation: Creation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Project Image
            AsyncImage(url: URL(string: creation.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(AppConstants.Colors.primaryPurple.opacity(0.1))
                    .overlay(
                        Image(systemName: creation.type == .project ? "hammer.fill" : "book.fill")
                            .font(.system(size: 30))
                            .foregroundColor(AppConstants.Colors.primaryPurple)
                    )
            }
            .frame(height: 120)
            .cornerRadius(12)
            .clipped()
            
            // Project Info
            VStack(alignment: .leading, spacing: 6) {
                Text(creation.title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                // Difficulty Badge
                Text(creation.difficulty.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: creation.difficulty.color))
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
