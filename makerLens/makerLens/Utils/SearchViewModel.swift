//
//  SearchViewModel.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/2/25.
//

import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Creation] = []
    @Published var isSearching = false
    @Published var recentSearches: [String] = []
    @Published var selectedDifficulty: Difficulty?
    @Published var selectedType: CreationType?
    
    private let searchService = SearchService()
    private let firebaseService = FirebaseService.shared
    private var searchCancellable: AnyCancellable?
    
    init() {
        // Load recent searches from UserDefaults
        loadRecentSearches()
        
        // Debounce search
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task { @MainActor in
                    await self?.performSearch(searchText)
                }
            }
    }
    
    func performSearch(_ query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        do {
            // Search Firebase creations
            searchResults = try await searchService.searchCreations(
                query: query,
                difficulty: selectedDifficulty,
                type: selectedType
            )
            
            // Add to recent searches
            addRecentSearch(query)
            
        } catch {
            print("Search error: \(error)")
            searchResults = []
        }
        
        isSearching = false
    }
    
    private func addRecentSearch(_ search: String) {
        if !recentSearches.contains(search) {
            recentSearches.insert(search, at: 0)
            recentSearches = Array(recentSearches.prefix(10))
            saveRecentSearches()
        }
    }
    
    func removeRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
        saveRecentSearches()
    }
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
    
    func applyFilters() {
        Task { @MainActor in
            await performSearch(searchText)
        }
    }
}
