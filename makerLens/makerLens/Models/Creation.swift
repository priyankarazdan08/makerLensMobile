//
//  Creation.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Creation: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String              // "LED Brightness Control"
    let type: CreationType         // .project or .tutorial
    let difficulty: Difficulty     // .easy, .intermediate, .advanced, .superHard
    let components: [String]       // ["Arduino Uno", "LED", "220Ω Resistor"]
    let estimatedDuration: String? // "45 min" - NOW OPTIONAL
    let imageUrl: String          // Circuit diagram image
    let steps: [Step]
    let resources: CreationResources
    var isCompleted: Bool = false
    var isAssigned: Bool = false   // For school accounts
    var completedBy: [String] = [] // User IDs who completed this
    var quizQuestions: [QuizQuestion] = []
    let basePoints: Int
    let bonusPoints: Int
    
    var hasVideo: Bool {
        !resources.videos.isEmpty
    }
    
    var hasCode: Bool {
        !resources.code.isEmpty
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, type, difficulty, components
        case estimatedDuration, imageUrl, steps, resources
        case isCompleted, isAssigned, completedBy, quizQuestions
        case basePoints, bonusPoints
    }
    
    init(id: String? = nil, title: String, type: CreationType, difficulty: Difficulty, components: [String], estimatedDuration: String?, imageUrl: String, steps: [Step] = [], resources: CreationResources = CreationResources(), quizQuestions: [QuizQuestion] = [], basePoints: Int = 0, bonusPoints: Int = 0) {
        self.id = id
        self.title = title
        self.type = type
        self.difficulty = difficulty
        self.components = components
        self.estimatedDuration = estimatedDuration
        self.imageUrl = imageUrl
        self.steps = steps
        self.resources = resources
        self.quizQuestions = quizQuestions
        self.basePoints = basePoints
        self.bonusPoints = bonusPoints
    }
}

enum CreationType: String, Codable, CaseIterable {
    case project = "project"
    case tutorial = "tutorial"
}

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case superHard = "Super Hard"
    
    var color: String {
        switch self {
        case .easy: return "#7DD3C0"      // Light Teal
        case .intermediate: return "#5CBFB0"  // Medium Teal
        case .advanced: return "#A63A84"      // Medium Purple
        case .superHard: return "#8B1A7A"     // Primary Purple
        }
    }
}

struct CreationResources: Codable {
    let code: String
    let diagrams: [String]  // Array of image URLs
    let videos: [String]    // Array of video URLs
    let pdfUrl: String?     // PDF lesson download
    let codeFileUrl: String? // .ino file download
    let libraryUrl: String?  // .zip library download
    
    init(code: String = "", diagrams: [String] = [], videos: [String] = [], pdfUrl: String? = nil, codeFileUrl: String? = nil, libraryUrl: String? = nil) {
        self.code = code
        self.diagrams = diagrams
        self.videos = videos
        self.pdfUrl = pdfUrl
        self.codeFileUrl = codeFileUrl
        self.libraryUrl = libraryUrl
    }
}
