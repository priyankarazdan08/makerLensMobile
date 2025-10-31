//
//  SampleData.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//


import Foundation

struct SampleData {
    // MARK: - Sample Modules
//    static let sampleModules: [Module] = [
//        Module(
//            id: "module1",
//            title: "Part 1 Preparation", 
//            description: "Setup and basic concepts",
//            order: 1,
//            unlockCriteria: nil,
//            downloadSize: "124.5 MB"
//        ).applying {
//            $0.completionPercentage = 100
//            $0.isUnlocked = true
//        },
//        
//        Module(
//            id: "module2",
//            title: "Part 2 Module Learning",
//            description: "Component-by-component tutorials", 
//            order: 2,
//            unlockCriteria: "complete module1",
//            downloadSize: "274.9 MB"
//        ).applying {
//            $0.completionPercentage = 65
//            $0.isUnlocked = true
//        },
//        
//        Module(
//            id: "module3",
//            title: "Part 3 Multi-module",
//            description: "Complex integrated projects",
//            order: 3, 
//            unlockCriteria: "complete module2",
//            downloadSize: "189.2 MB"
//        ).applying {
//            $0.completionPercentage = 25
//            $0.isUnlocked = true
//        },
//        
//        Module(
//            id: "module4",
//            title: "Part 4 Advanced",
//            description: "Creative applications",
//            order: 4,
//            unlockCriteria: "complete module3", 
//            downloadSize: "356.7 MB"
//        ).applying {
//            $0.completionPercentage = 0
//            $0.isUnlocked = false
//        },
//        
//        Module(
//            id: "module5",
//            title: "Part 5 Expert",
//            description: "Master-level projects",
//            order: 5,
//            unlockCriteria: "complete module4",
//            downloadSize: "423.1 MB"
//        ).applying {
//            $0.completionPercentage = 0
//            $0.isUnlocked = false
//        },
//        
//        Module(
//            id: "module6",
//            title: "Part 6 Innovation",
//            description: "Create your own projects",
//            order: 6,
//            unlockCriteria: "complete module5",
//            downloadSize: "298.8 MB"
//        ).applying {
//            $0.completionPercentage = 0
//            $0.isUnlocked = false
//        }
//    ]
    
    // MARK: - Sample Creations
    static let sampleCreations: [Creation] = [
        Creation(
            id: "creation1",
            title: "LED Brightness Control",
            type: .project,
            difficulty: .easy,
            components: ["Arduino Uno", "LED", "220Ω Resistor", "Potentiometer"],
            estimatedDuration: "45 min",
            imageUrl: "https://via.placeholder.com/300x200/7DD3C0/FFFFFF?text=LED+Circuit",
            resources: CreationResources(
                code: "int ledPin = 9;\nvoid setup() {\n  // code here\n}",
                diagrams: ["diagram1.png"],
                videos: ["intro-video.mp4"]
            )
        ),
        
        Creation(
            id: "creation2", 
            title: "Temperature Sensor Reading",
            type: .tutorial,
            difficulty: .intermediate,
            components: ["Arduino Uno", "DHT22 Sensor", "Breadboard", "Jumper Wires"],
            estimatedDuration: "1h 15min",
            imageUrl: "https://via.placeholder.com/300x200/5CBFB0/FFFFFF?text=Temp+Sensor",
            resources: CreationResources(
                code: "#include <DHT.h>\nDHT dht(2, DHT22);",
                diagrams: ["temp-diagram.png"],
                videos: []
            )
        ),
        
        Creation(
            id: "creation3",
            title: "Smart Traffic Light System", 
            type: .project,
            difficulty: .advanced,
            components: ["Arduino Uno", "RGB LEDs", "Ultrasonic Sensor", "Servo Motor"],
            estimatedDuration: "2h 30min",
            imageUrl: "https://via.placeholder.com/300x200/A63A84/FFFFFF?text=Traffic+Light",
            resources: CreationResources(
                code: "// Advanced traffic system code",
                diagrams: ["traffic-diagram.png", "wiring-diagram.png"],
                videos: ["traffic-demo.mp4"]
            )
        )
    ]
    
    // MARK: - Sample User
    static let sampleUser = User(
        id: "user123",
        name: "Arduino Maker",
        email: "maker@example.com",
        accountType: .individual
    ).applying {
        $0.points = 2847
        $0.streak = 7
        $0.completedCreations = ["creation1"]
        $0.inProgressCreations = ["creation2"]
//        $0.moduleProgress = [
//            "module1": 100,
//            "module2": 65,
//            "module3": 25
//        ]
    }
    
    // MARK: - Sample Components  
    static let sampleComponents: [Component] = [
        Component(
            id: "arduino-uno",
            name: "Arduino Uno R3",
            description: "Microcontroller board based on ATmega328P",
            imageUrl: "https://via.placeholder.com/150x150/8B1A7A/FFFFFF?text=Arduino",
            category: .microcontroller,
            creations: ["creation1", "creation2", "creation3"],
        ),
        
        Component(
            id: "led", 
            name: "LED (5mm)",
            description: "Light Emitting Diode - Red, Green, Blue",
            imageUrl: "https://via.placeholder.com/150x150/7DD3C0/FFFFFF?text=LED",
            category: .output,
            creations: ["creation1", "creation3"],
        ),
        
        Component(
            id: "resistor",
            name: "Resistor Pack",
            description: "220Ω, 1kΩ, 10kΩ resistors for current limiting",
            imageUrl: "https://via.placeholder.com/150x150/5CBFB0/FFFFFF?text=Resistor",
            category: .passive,
            creations: ["creation1", "creation2"],
        )
    ]
}

// MARK: - Extension for applying mutations to struct instances
extension Module {
    func applying(_ mutations: (inout Self) -> Void) -> Self {
        var copy = self
        mutations(&copy)
        return copy
    }
}

extension User {
    func applying(_ mutations: (inout Self) -> Void) -> Self {
        var copy = self
        mutations(&copy)
        return copy
    }
}
