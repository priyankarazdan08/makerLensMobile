//
//  ComponentsData.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/23/25.
//


import Foundation

//let db = Firestore.firestore()

struct ComponentsData {
    static let allComponents: [Component] = [
        // MICROCONTROLLERS
        Component(
            id: "arduino-uno-r3",
            name: "Arduino Uno R3",
            description: "The most popular Arduino board with ATmega328P microcontroller. 14 digital pins (6 PWM), 6 analog inputs, 16MHz clock speed. Operating voltage: 5V, Flash memory: 32KB.",
            imageUrl: "",
            category: .microcontroller,
            creations: ["LED", "RGB LED", "Digital Inputs", "Serial Monitor Basics", "Active Buzzer", "Passive Buzzer", "Tilt Ball Switch", "Servo", "Ultrasonic Sensor", "Membrane Keypad", "DHT11 Temperature & Humidity", "Analog Joystick", "IR Receiver", "MAX7219 LED Matrix", "6-DOF IMU Sensor", "PIR Motion Sensor", "Water Level Sensor", "Real Time Clock", "Sound Sensor", "RC522 RFID", "LCD Display", "Eight LED with 74HC595", "DC Motors", "Stepper Motor", "EEPROM"]
        ),
        
        // BREADBOARDS & WIRES
        Component(
            id: "breadboard-830",
            name: "830 Tie-Points Breadboard",
            description: "Solderless prototyping board with 830 connection points. Metal strips connect holes in rows. Power rails run along edges for +5V and GND.",
            imageUrl: "",
            category: .breadboard,
            creations: ["LED", "RGB LED", "Digital Inputs", "Tilt Ball Switch", "Ultrasonic Sensor", "Membrane Keypad", "DC Motors"]
        ),
        
        Component(
            id: "jumper-wires-mm",
            name: "M-M Jumper Wires (Male to Male)",
            description: "Male-to-male jumper wires for connecting components on breadboard. Various colors for easy circuit identification.",
            imageUrl: "",
            category: .wire,
            creations: ["LED", "RGB LED", "Digital Inputs", "Servo", "Ultrasonic Sensor", "DC Motors"]
        ),
        
        Component(
            id: "jumper-wires-fm",
            name: "F-M DuPont Wires (Female to Male)",
            description: "Female-to-male DuPont wires for connecting modules with headers to Arduino or breadboard.",
            imageUrl: "",
            category: .wire,
            creations: ["Active Buzzer", "Passive Buzzer", "Membrane Keypad", "Real Time Clock"]
        ),
        
        Component(
            id: "usb-cable",
            name: "USB Cable (A to B)",
            description: "USB cable for connecting Arduino to computer for programming and power.",
            imageUrl: "",
            category: .connectivity,
            creations: ["LED", "RGB LED", "Digital Inputs", "Serial Monitor Basics", "Active Buzzer", "Passive Buzzer", "Tilt Ball Switch", "Servo", "Ultrasonic Sensor", "Membrane Keypad", "DHT11 Temperature & Humidity", "Analog Joystick", "IR Receiver", "MAX7219 LED Matrix", "6-DOF IMU Sensor", "PIR Motion Sensor", "Water Level Sensor", "Real Time Clock", "Sound Sensor", "RC522 RFID", "LCD Display", "Eight LED with 74HC595", "DC Motors", "Stepper Motor", "EEPROM"]
        ),
        
        // OUTPUT COMPONENTS
        Component(
            id: "led-5mm-red",
            name: "5mm Red LED",
            description: "Light-emitting diode. Longer leg is positive (+/anode), shorter leg is negative (-/cathode). Flat edge indicates negative side. MUST use with current-limiting resistor (typically 220Ω). Forward voltage: 2.0V, Current: 20mA.",
            imageUrl: "",
            category: .output,
            creations: ["LED", "Digital Inputs", "Tilt Ball Switch"]
        ),
        
        Component(
            id: "rgb-led",
            name: "RGB LED (Common Cathode)",
            description: "Contains 3 LEDs (red, green, blue) in one package. Longest leg is common cathode (connects to GND). Mix colors by controlling each LED brightness with PWM. Requires 3x 220Ω resistors (one per color).",
            imageUrl: "",
            category: .output,
            creations: ["RGB LED"]
        ),
        
        Component(
            id: "active-buzzer",
            name: "Active Buzzer",
            description: "Buzzer with built-in oscillator. Produces single fixed-tone beep when powered (5V). Black casing, green circuit board underneath. Easier than passive buzzer but can only produce one tone.",
            imageUrl: "",
            category: .output,
            creations: ["Active Buzzer"]
        ),
        
        Component(
            id: "passive-buzzer",
            name: "Passive Buzzer",
            description: "Buzzer requiring PWM signal to produce sound. Can play different musical notes and melodies (2kHz-5kHz). Green circuit board visible. More versatile than active buzzer.",
            imageUrl: "",
            category: .output,
            creations: ["Passive Buzzer"]
        ),
        
        Component(
            id: "servo-sg90",
            name: "SG90 Servo Motor",
            description: "Small servo motor that rotates 0-180 degrees. 3 wires: brown (GND), red (5V), orange (signal). Operating speed: 0.1 sec/60° at 4.8V. Stall torque: 1.6 kg/cm. Voltage: 3.5-6V. Weight: 9g.",
            imageUrl: "",
            category: .output,
            creations: ["Servo"]
        ),
        
        Component(
            id: "dc-motor",
            name: "3-6V DC Motor with Fan Blade",
            description: "Small DC motor for continuous rotation. Requires L293D motor driver IC and external power supply. Includes fan blade attachment.",
            imageUrl: "",
            category: .output,
            creations: ["DC Motors"]
        ),
        
        Component(
            id: "stepper-motor",
            name: "Stepper Motor",
            description: "Motor that moves in precise steps for accurate positioning. Requires ULN2003 driver board.",
            imageUrl: "",
            category: .output,
            creations: ["Stepper Motor"]
        ),
        
        Component(
            id: "led-matrix-max7219",
            name: "MAX7219 LED Matrix Display",
            description: "8x8 LED dot matrix display controlled by MAX7219 chip. Can display patterns, text, and animations using SPI communication.",
            imageUrl: "",
            category: .output,
            creations: ["MAX7219 LED Matrix"]
        ),
        
        Component(
            id: "lcd-1602",
            name: "LCD 1602 Display",
            description: "16x2 character LCD display with backlight. Can show 2 lines of 16 characters each. Uses parallel interface.",
            imageUrl: "",
            category: .output,
            creations: ["LCD Display"]
        ),
        
        Component(
            id: "led-eight-pack",
            name: "8x LED Pack",
            description: "Eight LEDs for use with 74HC595 shift register. Allows controlling multiple LEDs with minimal Arduino pins.",
            imageUrl: "",
            category: .output,
            creations: ["Eight LED with 74HC595"]
        ),
        
        // INPUT COMPONENTS
        Component(
            id: "push-button",
            name: "Tactile Push Button Switch",
            description: "4-pin momentary switch. Pins B-C connected, A-D connected. When pressed, bridges both pairs. Must span breadboard center gap.",
            imageUrl: "",
            category: .input,
            creations: ["Digital Inputs"]
        ),
        
        Component(
            id: "tilt-ball-switch",
            name: "Tilt Ball Switch",
            description: "Detects orientation and tilt. Contains conductive ball that rolls to short two poles when tilted. Simple alternative to accelerometers.",
            imageUrl: "",
            category: .input,
            creations: ["Tilt Ball Switch"]
        ),
        
        Component(
            id: "joystick-analog",
            name: "Analog Joystick Module",
            description: "2-axis analog joystick with button. Returns X and Y coordinates (0-1023) plus button press state.",
            imageUrl: "",
            category: .input,
            creations: ["Analog Joystick"]
        ),
        
        Component(
            id: "keypad-4x4",
            name: "4x4 Membrane Keypad",
            description: "16-key membrane keypad (0-9, A-D, *, #). Matrix scanning for multiple key detection.",
            imageUrl: "",
            category: .input,
            creations: ["Membrane Keypad"]
        ),
        
        Component(
            id: "ir-receiver",
            name: "IR Receiver Module",
            description: "Infrared receiver for remote control signals. Works with IR remote control. Supports protocols like NEC and RC5.",
            imageUrl: "",
            category: .input,
            creations: ["IR Receiver"]
        ),
        
        Component(
            id: "rfid-rc522",
            name: "RC522 RFID Module",
            description: "13.56MHz RFID reader/writer using SPI communication. Reads RFID cards and tags at ~5cm distance.",
            imageUrl: "",
            category: .input,
            creations: ["RC522 RFID"]
        ),
        
        // SENSORS
        Component(
            id: "ultrasonic-hcsr04",
            name: "HC-SR04 Ultrasonic Sensor",
            description: "Measures distance using ultrasonic waves (2cm-400cm). 4 pins: VCC, Trig, Echo, GND. Accuracy: ±3mm. Detection angle: 15°.",
            imageUrl: "",
            category: .sensor,
            creations: ["Ultrasonic Sensor"]
        ),
        
        Component(
            id: "dht11",
            name: "DHT11 Temperature & Humidity Sensor",
            description: "Digital sensor measuring temperature (0-50°C, ±2°C accuracy) and humidity (20-90%, ±5% RH accuracy). Uses single digital pin for communication.",
            imageUrl: "",
            category: .sensor,
            creations: ["DHT11 Temperature & Humidity"]
        ),
        
        Component(
            id: "pir-hcsr501",
            name: "HC-SR501 PIR Motion Sensor",
            description: "Passive infrared sensor detecting motion from body heat. Range: up to 7 meters. Detection angle: 120°. Has sensitivity and time-delay adjustment knobs.",
            imageUrl: "",
            category: .sensor,
            creations: ["PIR Motion Sensor"]
        ),
        
        Component(
            id: "water-level-sensor",
            name: "Water Level Detection Sensor",
            description: "Detects water level using exposed traces. Returns analog value (0-1023) based on water contact.",
            imageUrl: "",
            category: .sensor,
            creations: ["Water Level Sensor"]
        ),
        
        Component(
            id: "sound-sensor",
            name: "Sound Sensor Module",
            description: "Microphone sensor detecting sound levels. Returns both digital (threshold) and analog (level) outputs.",
            imageUrl: "",
            category: .sensor,
            creations: ["Sound Sensor"]
        ),
        
        Component(
            id: "mpu6050",
            name: "MPU-6050 6-DOF IMU Sensor",
            description: "Motion tracking sensor with 3-axis gyroscope and 3-axis accelerometer using I2C. Measures orientation, acceleration, and rotation. Gyro range: ±250 to ±2000°/s. Accel range: ±2g to ±16g.",
            imageUrl: "",
            category: .sensor,
            creations: ["6-DOF IMU Sensor"]
        ),
        
        // PASSIVE COMPONENTS
        Component(
            id: "resistor-220",
            name: "220Ω Resistor",
            description: "Current-limiting resistor (1/4 watt, ±5% tolerance). Color bands: Red-Red-Brown-Gold. No polarity - works either direction. Perfect for LEDs.",
            imageUrl: "",
            category: .passive,
            creations: ["LED", "RGB LED", "Digital Inputs", "Tilt Ball Switch"]
        ),
        
        Component(
            id: "resistor-1k",
            name: "1kΩ Resistor",
            description: "Current-limiting resistor (1/4 watt, ±5% tolerance). Color bands: Brown-Black-Red-Gold. No polarity.",
            imageUrl: "",
            category: .passive,
            creations: ["LED"]
        ),
        
        Component(
            id: "resistor-10k",
            name: "10kΩ Resistor",
            description: "Current-limiting resistor (1/4 watt, ±5% tolerance). Color bands: Brown-Black-Orange-Gold. No polarity.",
            imageUrl: "",
            category: .passive,
            creations: ["LED"]
        ),
        
        // POWER & CONNECTIVITY ICs/MODULES
        Component(
            id: "l293d-ic",
            name: "L293D Motor Driver IC",
            description: "Dual H-bridge motor driver IC for controlling DC motors. Can drive 2 motors bidirectionally. Output current: 600mA per channel. Voltage: 4.5V-36V.",
            imageUrl: "",
            category: .connectivity,
            creations: ["DC Motors"]
        ),
        
        Component(
            id: "74hc595-ic",
            name: "74HC595 Shift Register IC",
            description: "8-bit serial-in, parallel-out shift register. Expands digital outputs - control 8 LEDs with 3 Arduino pins.",
            imageUrl: "",
            category: .connectivity,
            creations: ["Eight LED with 74HC595"]
        ),
        
        Component(
            id: "ds1307-rtc",
            name: "DS1307 Real Time Clock Module",
            description: "Battery-backed real-time clock using I2C communication. Keeps track of time even when Arduino is off. Uses CR2032 coin cell battery. Accuracy: ±2 minutes/month.",
            imageUrl: "",
            category: .connectivity,
            creations: ["Real Time Clock"]
        ),
        
        Component(
            id: "uln2003-driver",
            name: "ULN2003 Stepper Driver Board",
            description: "Driver board for stepper motors. Provides sufficient current and control logic for precise motor stepping.",
            imageUrl: "",
            category: .connectivity,
            creations: ["Stepper Motor"]
        ),
        
        Component(
            id: "power-supply-module",
            name: "Breadboard Power Supply Module",
            description: "Provides regulated 3.3V and 5V power to breadboard. Input: 6.5-9V DC via 5.5mm x 2.1mm plug. Max output: 700mA. Independent rail control with LED indicator.",
            imageUrl: "",
            category: .power,
            creations: ["DC Motors"]
        ),
        
        Component(
            id: "9v-adapter",
            name: "9V 1A Power Adapter",
            description: "Wall adapter for external power supply. 5.5mm x 2.1mm plug.",
            imageUrl: "",
            category: .power,
            creations: ["DC Motors"]
        ),
        
        // ACCESSORIES
        Component(
            id: "ir-remote",
            name: "IR Remote Control",
            description: "Infrared remote control with multiple buttons using NEC protocol. Works with IR receiver module.",
            imageUrl: "",
            category: .connectivity,
            creations: ["IR Receiver"]
        ),
        
        Component(
            id: "rfid-card",
            name: "RFID Card/Tag",
            description: "13.56MHz RFID Mifare card or keychain tag for RC522 reader.",
            imageUrl: "",
            category: .connectivity,
            creations: ["RC522 RFID"]
        ),
        
        Component(
            id: "cr2032-battery",
            name: "CR2032 Coin Cell Battery",
            description: "3V lithium coin cell battery for Real Time Clock module backup power.",
            imageUrl: "",
            category: .power,
            creations: ["Real Time Clock"]
        )
    ]
}

// MARK: - FirebaseService Extension for Components
extension FirebaseService {
//    let db = Firestore.firestore()
    
    /// Upload all components to Firebase
    func uploadAllComponents() async throws {
        let components = ComponentsData.allComponents
        
        print("🚀 Starting upload of \(components.count) components...")
        
        for (index, component) in components.enumerated() {
            do {
                try await uploadComponent(component)
                print("✅ [\(index + 1)/\(components.count)] Uploaded: \(component.name)")
            } catch {
                print("❌ [\(index + 1)/\(components.count)] Failed to upload \(component.name): \(error.localizedDescription)")
            }
        }
        
        print("🎉 Component upload complete!")
    }
    
    /// Upload a single component
    private func uploadComponent(_ component: Component) async throws {
        guard let componentId = component.id else {
            throw NSError(domain: "ComponentUpload", code: 1, userInfo: [NSLocalizedDescriptionKey: "Component ID is nil"])
        }
        
        let data: [String: Any] = [
            "name": component.name,
            "description": component.description,
            "imageUrl": component.imageUrl,
            "category": component.category.rawValue,
            "creations": component.creations
        ]
        
        try await db.collection("components").document(componentId).setData(data)
    }
    
    /// Load all components from Firebase
    func loadComponents() async throws -> [Component] {
        let snapshot = try await db.collection("components").getDocuments()
        
        let loadedComponents = snapshot.documents.compactMap { document -> Component? in
            try? document.data(as: Component.self)
        }
        
        print("✅ Loaded \(loadedComponents.count) components from Firebase")
        return loadedComponents
    }
    
    /// Delete all components (use carefully!)
    func deleteAllComponents() async throws {
        let snapshot = try await db.collection("components").getDocuments()
        
        print("🗑️ Deleting \(snapshot.documents.count) components...")
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
        
        print("✅ All components deleted")
    }
}
