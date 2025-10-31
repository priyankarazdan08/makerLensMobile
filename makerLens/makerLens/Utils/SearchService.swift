//
//  SearchService.swift
//  makerLens
//
//  Created by Priyanka Razdan on 9/2/25.
//


import Firebase
import FirebaseFirestore

class SearchService {
    private let db = Firestore.firestore()
    
    // MARK: - Search Creations in Firebase
    func searchCreations(query: String, difficulty: Difficulty?, type: CreationType?) async throws -> [Creation] {
        var creationsQuery = db.collection("creations").limit(to: 50)
        
        // Apply filters to Firebase query
        if let difficulty = difficulty {
            creationsQuery = creationsQuery.whereField("difficulty", isEqualTo: difficulty.rawValue)
        }
        
        if let type = type {
            creationsQuery = creationsQuery.whereField("type", isEqualTo: type.rawValue)
        }
        
        let snapshot = try await creationsQuery.getDocuments()
        let allCreations = snapshot.documents.compactMap { doc -> Creation? in
            try? doc.data(as: Creation.self)
        }
        
        // Client-side text filtering (Firebase doesn't support full-text search easily)
        return allCreations.filter { creation in
            let titleMatch = creation.title.lowercased().contains(query.lowercased())
            let componentMatch = creation.components.contains { $0.lowercased().contains(query.lowercased()) }
            return titleMatch || componentMatch
        }
    }
    
    // MARK: - Search Components
    func searchComponents(query: String, category: ComponentCategory?) async throws -> [Component] {
        var componentsQuery = db.collection("components").limit(to: 50)
        
        if let category = category {
            componentsQuery = componentsQuery.whereField("category", isEqualTo: category.rawValue)
        }
        
        let snapshot = try await componentsQuery.getDocuments()
        let allComponents = snapshot.documents.compactMap { doc -> Component? in
            try? doc.data(as: Component.self)
        }
        
        return allComponents.filter { component in
            let nameMatch = component.name.lowercased().contains(query.lowercased())
            let descriptionMatch = component.description.lowercased().contains(query.lowercased())
            return nameMatch || descriptionMatch
        }
    }
    
    // MARK: - Search Modules
    func searchModules(query: String) async throws -> [Module] {
        let snapshot = try await db.collection("modules").getDocuments()
        let allModules = snapshot.documents.compactMap { doc -> Module? in
            try? doc.data(as: Module.self)
        }
        
        return allModules.filter { module in
            let titleMatch = module.title.lowercased().contains(query.lowercased())
            let descriptionMatch = module.description.lowercased().contains(query.lowercased())
            return titleMatch || descriptionMatch
        }
    }
}
