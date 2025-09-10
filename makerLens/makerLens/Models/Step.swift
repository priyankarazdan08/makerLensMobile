//
//  Step.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import Foundation
import FirebaseFirestore

struct Step: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String           // "Connect Arduino to Breadboard"
    let content: String         // Instructions, explanations
    let stepNumber: Int         // Current step (1-6)
    let totalSteps: Int        // Total steps in creation
    let resources: StepResources
    let checkpoints: [String]   // Verification points
    var isCompleted: Bool = false
    let canSkip: Bool = true    // Allow skip functionality
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, stepNumber, totalSteps
        case resources, checkpoints, isCompleted, canSkip
    }
    
    init(id: String? = nil, title: String, content: String, stepNumber: Int, totalSteps: Int, resources: StepResources = StepResources(), checkpoints: [String] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.stepNumber = stepNumber
        self.totalSteps = totalSteps
        self.resources = resources
        self.checkpoints = checkpoints
    }
}

struct StepResources: Codable {
    let images: [String]        // Image URLs
    let codeSnippets: [String] // Code examples
    let videos: [String]       // Video URLs
    
    init(images: [String] = [], codeSnippets: [String] = [], videos: [String] = []) {
        self.images = images
        self.codeSnippets = codeSnippets
        self.videos = videos
    }
}