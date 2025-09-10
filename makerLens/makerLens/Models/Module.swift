//
//  Module.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import Foundation
import FirebaseFirestore

struct Module: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let order: Int
    let unlockCriteria: String?
    let downloadSize: String
    var completionPercentage: Double = 0
    var assignmentsDue: Int = 0
    var isUnlocked: Bool = false
    var creations: [Creation] = []
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, order, unlockCriteria, downloadSize
        case completionPercentage, assignmentsDue, isUnlocked, creations
    }
}
