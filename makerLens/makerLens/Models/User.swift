//
//  User.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let accountType: AccountType    // .individual or .school
    let schoolId: String?          // nil for individual accounts
    var completedCreations: [String] = []  // Array of Creation IDs
    var wishlistCreations: [String] = []   // Array of Creation IDs
    var inProgressCreations: [String] = [] // Array of Creation IDs
    var points: Int = 0            // XP points
    var streak: Int = 0            // Daily streak
    var dailyGoals: [String: DailyGoal] = [:]  // Date-keyed goals
    var moduleProgress: [String: Double] = [:] // Module completion percentages
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, accountType, schoolId
        case completedCreations, wishlistCreations, inProgressCreations
        case points, streak, dailyGoals, moduleProgress
    }
    
    init(id: String? = nil, name: String, email: String, accountType: AccountType, schoolId: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.accountType = accountType
        self.schoolId = schoolId
    }
}

enum AccountType: String, Codable, CaseIterable {
    case individual = "individual"
    case school = "school"
}

struct DailyGoal: Codable {
    let target: String        // "Complete 2 projects today"
    let progress: String      // "1/2"
    var completed: Bool = false
    let date: String         // ISO date string
    
    init(target: String, progress: String = "0/1", date: Date = Date()) {
        self.target = target
        self.progress = progress
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.date = formatter.string(from: date)
    }
}
