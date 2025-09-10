//
//  UserProgress.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import Foundation
import FirebaseFirestore

struct UserProgress: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let creationId: String
    var currentStep: Int = 1
    var completedSteps: [Int] = []
    var progress: Double = 0.0  // 0.0 to 1.0
    var startedAt: Date = Date()
    var lastAccessedAt: Date = Date()
    var completedAt: Date?
    
    var isCompleted: Bool {
        completedAt != nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, userId, creationId, currentStep, completedSteps
        case progress, startedAt, lastAccessedAt, completedAt
    }
    
    init(id: String? = nil, userId: String, creationId: String) {
        self.id = id
        self.userId = userId
        self.creationId = creationId
    }
}