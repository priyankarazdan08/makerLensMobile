//
//  SearchFilterView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/2/25.
//


import SwiftUI

struct SearchFilterView: View {
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.xl) {
                    // Difficulty Filter
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
                        HStack {
                            Text("Difficulty")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                            
                            Button("Clear") {
                                viewModel.selectedDifficulty = nil
                            }
                            .font(.system(size: 14))
                            .foregroundColor(AppConstants.Colors.primaryPurple)
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                DifficultyFilterButton(
                                    difficulty: difficulty,
                                    isSelected: viewModel.selectedDifficulty == difficulty
                                ) {
                                    viewModel.selectedDifficulty = viewModel.selectedDifficulty == difficulty ? nil : difficulty
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Content Type Filter
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
                        HStack {
                            Text("Content Type")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                            
                            Button("Clear") {
                                viewModel.selectedType = nil
                            }
                            .font(.system(size: 14))
                            .foregroundColor(AppConstants.Colors.primaryPurple)
                        }
                        
                        HStack(spacing: 12) {
                            ForEach(CreationType.allCases, id: \.self) { type in
                                TypeFilterButton(
                                    type: type,
                                    isSelected: viewModel.selectedType == type
                                ) {
                                    viewModel.selectedType = viewModel.selectedType == type ? nil : type
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(AppConstants.Spacing.lg)
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Clear All") {
                    viewModel.selectedDifficulty = nil
                    viewModel.selectedType = nil
                }
                .foregroundColor(AppConstants.Colors.primaryPurple)
            )
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    viewModel.applyFilters()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppConstants.Colors.primaryPurple)
                        .cornerRadius(12)
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                .padding(.bottom, AppConstants.Spacing.lg)
                .background(Color(.systemBackground))
            }
        }
    }
}

struct DifficultyFilterButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue.uppercased())
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isSelected ? .white : Color(hex: difficulty.color))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color(hex: difficulty.color) : Color(hex: difficulty.color).opacity(0.1))
                .cornerRadius(8)
        }
    }
}

struct TypeFilterButton: View {
    let type: CreationType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue.capitalized)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : AppConstants.Colors.primaryPurple)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? AppConstants.Colors.primaryPurple : AppConstants.Colors.primaryPurple.opacity(0.1))
                .cornerRadius(20)
        }
    }
}