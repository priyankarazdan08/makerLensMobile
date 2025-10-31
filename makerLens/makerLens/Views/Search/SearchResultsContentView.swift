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
            
            // Search Results List View
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
                    LazyVStack(spacing: AppConstants.Spacing.sm) {
                        ForEach(viewModel.searchResults) { creation in
                            SearchResultListRow(creation: creation)
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

// MARK: - Search Result List Row (NO IMAGE - List Style)
struct SearchResultListRow: View {
    let creation: Creation
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.md) {
            // Icon on left
            Circle()
                .fill(AppConstants.Colors.primaryPurple.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: creation.type == .project ? "hammer.fill" : "book.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppConstants.Colors.primaryPurple)
                )
            
            // Project Info
            VStack(alignment: .leading, spacing: 4) {
                Text(creation.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                HStack(spacing: AppConstants.Spacing.xs) {
                    // Difficulty Badge
                    Text(creation.difficulty.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: creation.difficulty.color))
                        .cornerRadius(4)
                    
                    // Duration if available
                    if let duration = creation.estimatedDuration {
                        HStack(spacing: 2) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text(duration)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding(AppConstants.Spacing.md)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
