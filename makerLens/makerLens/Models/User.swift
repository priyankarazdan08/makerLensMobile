//
//  User.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

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
    let accountType: AccountType        // .individual or .school
    let schoolId: String?               // nil for individual accounts
    var completedCreations: [String] = []   // Array of Creation IDs
    var wishlistCreations: [String] = []    // Array of Creation IDs
    var inProgressCreations: [String] = []  // Array of Creation IDs
    
    // UPDATED: Points System
    var points: Int = 0                 // Legacy XP points (keep for compatibility)
    var totalPoints: Int = 0            // NEW: Total points from scans + lessons
    var totalScans: Int = 0             // NEW: Number of component scans performed
    var lastScanDate: Date?             // NEW: Last time user scanned components
    
    var streak: Int = 0                 // Daily streak
    var dailyGoals: [String: DailyGoal] = [:]  // Date-keyed goals
    
    // NEW: Leaderboard fields (all optional to work with existing Firebase data)
    var rank: Int?                      // Current leaderboard rank
    var rankMovement: Int?              // +/- rank change from previous
    var lastActivityDate: Date?         // Last time user earned points (for streak calc)
    var school: String?                 // School name for school-based leaderboard
    var friends: [String]?              // Array of user IDs for friends leaderboard
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, accountType
        case completedCreations, wishlistCreations, inProgressCreations
        case points, totalPoints, totalScans, lastScanDate
        case streak, dailyGoals
        case schoolId = "schoolID"
        case rank, rankMovement, lastActivityDate, school, friends
    }
    
    init(id: String? = nil, name: String, email: String, accountType: AccountType, schoolId: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.accountType = accountType
        self.schoolId = schoolId
        self.completedCreations = []
        self.wishlistCreations = []
        self.inProgressCreations = []
        self.points = 0
        self.totalPoints = 0
        self.totalScans = 0
        self.lastScanDate = nil
        self.streak = 0
        self.dailyGoals = [:]
        self.rank = nil
        self.rankMovement = nil
        self.lastActivityDate = nil
        self.school = nil
        self.friends = nil
    }
    
    // MARK: - Computed Properties
    
    /// Display name for leaderboard (first name or full name)
    var displayName: String {
        return name.components(separatedBy: " ").first ?? name
    }
    
    /// Combined points (legacy + new system)
    var allPoints: Int {
        return points + totalPoints
    }
    
    /// XP for leaderboard (uses totalPoints, not legacy points)
    var xp: Int {
        return totalPoints
    }
    
    /// Current rank with safe fallback
    var currentRank: Int {
        return rank ?? 999
    }
    
    /// Rank movement with safe fallback
    var currentRankMovement: Int {
        return rankMovement ?? 0
    }
    
    /// Has scanned today
    var hasScannedToday: Bool {
        guard let lastScan = lastScanDate else { return false }
        return Calendar.current.isDateInToday(lastScan)
    }
    
    /// Days since last scan
    var daysSinceLastScan: Int? {
        guard let lastScan = lastScanDate else { return nil }
        return Calendar.current.dateComponents([.day], from: lastScan, to: Date()).day
    }
    
    /// Streak multiplier based on current streak
    var streakMultiplier: Double {
        switch streak {
        case 30...:
            return 3.0
        case 14...:
            return 2.5
        case 7...:
            return 2.0
        case 3...:
            return 1.5
        default:
            return 1.0
        }
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

// MARK: - User Extensions for Points Display

extension User {
    /// Format points for display (e.g., "1,250 pts")
    var formattedPoints: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: allPoints)) ?? "\(allPoints)"
    }
    
    /// Get user level based on points (every 500 points = 1 level)
    var level: Int {
        return (allPoints / 500) + 1
    }
    
    /// Points needed for next level
    var pointsToNextLevel: Int {
        let nextLevelThreshold = level * 500
        return nextLevelThreshold - allPoints
    }
    
    /// Progress to next level (0.0 - 1.0)
    var levelProgress: Double {
        let currentLevelBase = (level - 1) * 500
        let pointsInCurrentLevel = Double(allPoints - currentLevelBase)
        return pointsInCurrentLevel / 500.0
    }
}
