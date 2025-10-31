//
//  Component.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import Foundation
import FirebaseFirestore

struct Component: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let description: String
    let imageUrl: String       // STL 3D model file URL
    let category: ComponentCategory
    let creations: [String]     // Array of creation titles using this component
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, imageUrl, category, creations
    }
    
    init(id: String? = nil, name: String, description: String, imageUrl: String, category: ComponentCategory, creations: [String] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
        self.creations = creations
    }
}

enum ComponentCategory: String, Codable, CaseIterable {
    case microcontroller = "Microcontroller"
    case sensor = "Sensor"
    case output = "Output"
    case input = "Input"
    case passive = "Passive"
    case connectivity = "Connectivity"
    case power = "Power"
    case breadboard = "Breadboard"
    case wire = "Wire"
    
    var icon: String {
        switch self {
        case .microcontroller: return "cpu"
        case .sensor: return "sensor.tag.radiowaves.forward"
        case .output: return "lightbulb"
        case .input: return "button.programmable"
        case .passive: return "resistor"
        case .connectivity: return "cable.connector"
        case .power: return "battery.100"
        case .breadboard: return "rectangle.grid.3x2"
        case .wire: return "cable.connector.horizontal"
        }
    }
}
