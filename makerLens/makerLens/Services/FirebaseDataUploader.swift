//
//  makerLens
//
//  Created by Priyanka Razdan on 10/21/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Quiz Question Model
struct QuizQuestion: Codable {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

// MARK: - Main Uploader Class
class FirebaseDataUploader {
    let db = Firestore.firestore()
    
    func uploadAllLessons() async throws {
        print("🚀 Starting upload of 6 lessons to Firebase...")
        let allLessons = [
            getLesson_7(),
            getLesson_8(),
            getLesson_9(),
            getLesson_10(),
            getLesson_11(),
            getLesson_12()
        ]
        
        var successCount = 0
        for lesson in allLessons {
            do {
                let data = try Firestore.Encoder().encode(lesson)
                try await db.collection("creations").document(lesson.id ?? "unknown").setData(data)
                print("✅ \(lesson.id ?? "unknown")")
                successCount += 1
            } catch {
                print("❌ \(lesson.id ?? "unknown"): \(error)")
            }
        }
        print("\n✅ Success: \(successCount)/6")
    }
}

// MARK: - LESSONS 7-12
extension FirebaseDataUploader {
    func getLesson_7() -> Creation {
        Creation(
            id: "7-tilt-ball-switch",
            title: "Tilt Ball Switch",
            type: .tutorial,
            difficulty: .easy,
            components: ["Arduino Uno R3", "Tilt Ball Switch", "LED", "220Ω Resistor", "Breadboard", "2x F-M Wires"],
            estimatedDuration: "30 min",
            imageUrl: "FIREBASE_STORAGE_URL_LESSON_7",
            steps: [
                Step(
                    id: "7-step-1",
                    title: "Gather Components",
                    content: """
                    Collect: 1x Arduino Uno R3, 1x tilt ball switch, 1x LED, 1x 220Ω resistor, 1x breadboard, and 2x F-M jumper wires.
                    
                    Tilt sensors (also called tilt ball switches) detect orientation or inclination. They're small, inexpensive, low-power, and easy to use.
                    """,
                    stepNumber: 1,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_7_STEP_1"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Tilt sensors have a cylindrical cavity with conductive ball inside",
                        "Also called mercury switches or rolling ball sensors",
                        "Much simpler than accelerometers but less precise",
                        "Popular for toys, gadgets, and appliances"
                    ]
                ),
                Step(
                    id: "7-step-2",
                    title: "Understanding Tilt Sensors",
                    content: """
                    Tilt sensors contain a free conductive mass (ball) inside a cavity. One end has two conductive poles.
                    
                    When oriented downward, the ball rolls onto the poles and shorts them, acting as a switch. When tilted, the connection breaks.
                    """,
                    stepNumber: 2,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_7_STEP_2"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Ball rolls to short two poles when tilted downward",
                        "Acts as a simple on/off switch",
                        "Won't wear out if used properly",
                        "Big ones can switch power directly"
                    ]
                ),
                Step(
                    id: "7-step-3",
                    title: "Wire the Circuit",
                    content: """
                    Connect tilt switch: one pin to Arduino Pin 2, other pin to GND using F-M wires.
                    Connect LED: anode (long leg) to Pin 13 through 220Ω resistor, cathode (short leg) to GND.
                    
                    The tilt switch acts as digital input triggering the LED.
                    """,
                    stepNumber: 3,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_7_STEP_3"],
                        codeSnippets: [
                            "// Connections:\n// Tilt Switch: Pin 2 and GND\n// LED: Pin 13 → 220Ω resistor → LED+ → LED- → GND"
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Tilt switch has 2 pins - connect one to Pin 2, one to GND",
                        "LED longer leg to Pin 13 through resistor",
                        "LED shorter leg to GND",
                        "No pull-up resistor needed - code uses INPUT_PULLUP"
                    ]
                ),
                Step(
                    id: "7-step-4",
                    title: "Upload the Code",
                    content: """
                    Open Ball_Switch.ino and upload. Code uses 'const' keyword for constants that can't be changed.
                    
                    Pin 13 controls LED, Pin 2 reads tilt switch. INPUT_PULLUP makes pin HIGH normally, LOW when switch closes.
                    """,
                    stepNumber: 4,
                    totalSteps: 5,
                    resources: StepResources(
                        images: [],
                        codeSnippets: [
                            """
                            const int ledPin = 13;
                            const int tiltPin = 2;
                            
                            void setup() {
                              pinMode(ledPin, OUTPUT);
                              pinMode(tiltPin, INPUT_PULLUP);
                            }
                            
                            void loop() {
                              int tiltState = digitalRead(tiltPin);
                              
                              if (tiltState == LOW) {
                                digitalWrite(ledPin, HIGH); // Tilted - LED ON
                              } else {
                                digitalWrite(ledPin, LOW);  // Upright - LED OFF
                              }
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "'const' makes variables read-only",
                        "INPUT_PULLUP: HIGH normally, LOW when closed",
                        "tiltState LOW = ball rolled, connection made",
                        "LED turns on when tilted, off when upright"
                    ]
                ),
                Step(
                    id: "7-step-5",
                    title: "Test Tilt Detection",
                    content: """
                    Tilt the sensor in different directions. When ball rolls onto contacts, LED lights. When upright, LED turns off.
                    
                    Try various angles to find trigger sensitivity. Different orientations will activate the switch.
                    """,
                    stepNumber: 5,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_7_STEP_5"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Tilt angle varies by sensor model",
                        "Try tilting in all directions",
                        "If no response, check wiring and orientation",
                        "Use for motion alarms, game controllers, orientation detection"
                    ]
                )
            ],
            resources: CreationResources(
                code: "",
                diagrams: ["FIREBASE_STORAGE_URL_7_SCHEMATIC"],
                videos: [],
                pdfUrl: nil,
                codeFileUrl: "FIREBASE_STORAGE_URL_7_CODE",
                libraryUrl: nil
            ),
            quizQuestions: [
                QuizQuestion(
                    question: "How does a tilt ball switch work?",
                    options: [
                        "Uses electronic sensors",
                        "Ball rolls and shorts two poles when tilted",
                        "Measures exact angle with accelerometer",
                        "Uses magnetic field detection"
                    ],
                    correctAnswer: 1,
                    explanation: "Tilt switches have a conductive ball inside. When tilted, the ball rolls onto two poles and creates an electrical connection, acting as a switch."
                ),
                QuizQuestion(
                    question: "What does 'const' keyword do in Arduino code?",
                    options: [
                        "Makes variable change faster",
                        "Creates read-only variable that can't be modified",
                        "Speeds up program execution",
                        "Allocates more memory"
                    ],
                    correctAnswer: 1,
                    explanation: "'const' makes a variable constant - its value cannot be changed after initialization. This prevents accidental modification and makes code safer."
                ),
                QuizQuestion(
                    question: "Why use INPUT_PULLUP mode for the tilt switch?",
                    options: [
                        "Makes it more sensitive",
                        "Activates internal resistor so pin reads HIGH normally",
                        "Increases voltage",
                        "Saves power"
                    ],
                    correctAnswer: 1,
                    explanation: "INPUT_PULLUP activates Arduino's internal pull-up resistor, keeping the pin HIGH normally. When switch closes and connects to ground, it reads LOW."
                ),
                QuizQuestion(
                    question: "What's an advantage of tilt switches over accelerometers?",
                    options: [
                        "More precise measurements",
                        "Much simpler and cheaper",
                        "Better accuracy",
                        "Digital output"
                    ],
                    correctAnswer: 1,
                    explanation: "Tilt switches are simpler, cheaper, and easier to use than accelerometers. They're perfect when you only need basic on/off orientation detection."
                ),
                QuizQuestion(
                    question: "What happens when digitalRead() returns LOW with a tilt switch?",
                    options: [
                        "Error occurred",
                        "Switch is tilted and ball has closed the connection",
                        "Switch is upright",
                        "Need to reset Arduino"
                    ],
                    correctAnswer: 1,
                    explanation: "LOW means the ball rolled onto the poles and closed the connection to ground. This indicates the switch is tilted enough to trigger."
                )
            ],
            basePoints: 10,
            bonusPoints: 0
        )
    }
    
    // MARK: - LESSON 8: Servo Motor
    func getLesson_8() -> Creation {
        Creation(
            id: "8-servo",
            title: "Servo Motor Control",
            type: .tutorial,
            difficulty: .intermediate,
            components: ["Arduino Uno R3", "SG90 Servo Motor", "3x M-M or F-M Wires"],
            estimatedDuration: "40 min",
            imageUrl: "FIREBASE_STORAGE_URL_LESSON_8",
            steps: [
                Step(
                    id: "8-step-1",
                    title: "Gather Components",
                    content: """
                    Collect: 1x Arduino Uno R3, 1x SG90 servo motor, and 3x jumper wires.
                    
                    Servos are geared motors that rotate 180 degrees with precise position control, perfect for robotics and automation.
                    """,
                    stepNumber: 1,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_8_STEP_1"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Servo has 3 wires: brown (GND), red (5V), orange (signal)",
                        "SG90 is micro servo - small but powerful",
                        "Controlled by PWM pulses from Arduino",
                        "Rotates 180 degrees (not continuous)"
                    ]
                ),
                Step(
                    id: "8-step-2",
                    title: "Understanding Servo Motors",
                    content: """
                    Servos rotate 180 degrees based on electrical pulse width. Arduino sends pulses telling the servo what angle to move to.
                    
                    SG90 specs: 0.12 sec/60° at 4.8V, torque 1.6kg/cm, voltage 3.5-6V, weight 134g, temp range -30°C to 60°C.
                    """,
                    stepNumber: 2,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_8_STEP_2"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Pulse width 500-2500 microseconds controls position",
                        "Built-in feedback maintains desired position",
                        "Enough torque for hobby projects (1.6kg/cm)",
                        "Gears reduce speed but increase torque"
                    ]
                ),
                Step(
                    id: "8-step-3",
                    title: "Wire the Servo",
                    content: """
                    Connect servo's three wires: brown to GND, red to 5V, orange to digital Pin 9.
                    
                    Signal wire (orange) must connect to PWM-capable pin for position control.
                    """,
                    stepNumber: 3,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_8_STEP_3"],
                        codeSnippets: [
                            "// Servo Wiring:\n// Brown wire → GND\n// Red wire → 5V\n// Orange/Yellow wire → Pin 9 (PWM)"
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Brown = Ground (GND)",
                        "Red = Power (5V)",
                        "Orange = Signal (Pin 9)",
                        "Pin 9 has PWM capability (~ symbol)"
                    ]
                ),
                Step(
                    id: "8-step-4",
                    title: "Install Servo Library and Upload Code",
                    content: """
                    Install Servo library (Sketch → Include Library → Add .ZIP Library → Servo.zip).
                    
                    Upload servo.ino. Code sweeps servo from 0° to 180° and back continuously, demonstrating full range of motion.
                    """,
                    stepNumber: 4,
                    totalSteps: 5,
                    resources: StepResources(
                        images: [],
                        codeSnippets: [
                            """
                            #include <Servo.h>
                            
                            Servo myservo;  // Create servo object
                            int pos = 0;    // Variable to store position
                            
                            void setup() {
                              myservo.attach(9);  // Servo on pin 9
                            }
                            
                            void loop() {
                              // Sweep 0 to 180 degrees
                              for (pos = 0; pos <= 180; pos++) {
                                myservo.write(pos);
                                delay(15);
                              }
                              // Sweep back 180 to 0
                              for (pos = 180; pos >= 0; pos--) {
                                myservo.write(pos);
                                delay(15);
                              }
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Servo.h library handles PWM signal generation",
                        "myservo.attach(9) connects servo to pin 9",
                        "myservo.write(angle) sets position 0-180°",
                        "delay(15) controls sweep speed"
                    ]
                ),
                Step(
                    id: "8-step-5",
                    title: "Test Servo Movement",
                    content: """
                    Watch servo arm sweep back and forth smoothly. Modify angles or add delays to change behavior.
                    
                    Try different positions, create patterns, or attach servo to mechanisms like robot arms or camera mounts.
                    """,
                    stepNumber: 5,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_8_STEP_5"],
                        codeSnippets: [
                            """
                            // Example: Stop at specific positions
                            myservo.write(0);     // Far left
                            delay(1000);
                            myservo.write(90);    // Center
                            delay(1000);
                            myservo.write(180);   // Far right
                            delay(1000);
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Servo should sweep smoothly 0-180-0 degrees",
                        "If jittery, check power supply (use USB)",
                        "Adjust delay() to change speed",
                        "Use for: robot arms, camera gimbals, automatic doors"
                    ]
                )
            ],
            resources: CreationResources(
                code: "FIREBASE_STORAGE_URL_8_CODE",
                diagrams: ["FIREBASE_STORAGE_URL_8_SCHEMATIC"],
                videos: [],
                pdfUrl: nil,
                codeFileUrl: nil,
                libraryUrl: nil
            ),
            quizQuestions: [
                QuizQuestion(
                    question: "What's the rotation range of a standard SG90 servo?",
                    options: ["90 degrees", "180 degrees", "360 degrees", "270 degrees"],
                    correctAnswer: 1,
                    explanation: "Standard servos like the SG90 rotate 180 degrees total (0° to 180°). They cannot rotate continuously like DC motors."
                ),
                QuizQuestion(
                    question: "What does myservo.write(90) do?",
                    options: [
                        "Rotates servo 90 times",
                        "Moves servo to 90 degree position (center)",
                        "Sets servo speed to 90",
                        "Turns servo off"
                    ],
                    correctAnswer: 1,
                    explanation: "myservo.write(90) commands the servo to move to the 90-degree position, which is center position for a 180-degree servo."
                ),
                QuizQuestion(
                    question: "Why must the servo signal wire connect to a PWM pin?",
                    options: [
                        "PWM provides more power",
                        "PWM creates precise pulse width signals to control position",
                        "Regular pins don't work",
                        "PWM is faster"
                    ],
                    correctAnswer: 1,
                    explanation: "Servos require PWM (Pulse Width Modulation) signals with precise timing to control position. PWM pins can generate these timed pulses."
                ),
                QuizQuestion(
                    question: "What's the purpose of the Servo library?",
                    options: [
                        "Makes servo faster",
                        "Generates correct PWM signals and simplifies servo control",
                        "Adds more power",
                        "Changes servo color"
                    ],
                    correctAnswer: 1,
                    explanation: "The Servo library handles all the complex PWM timing and provides simple commands like write() and attach() to control servos easily."
                ),
                QuizQuestion(
                    question: "What's the difference between a servo and DC motor?",
                    options: [
                        "Servos are faster",
                        "Servos have position control and limited rotation, DC motors rotate continuously",
                        "DC motors are more expensive",
                        "No difference"
                    ],
                    correctAnswer: 1,
                    explanation: "Servos provide precise position control within a limited range (usually 180°). DC motors rotate continuously but don't have built-in position control."
                )
            ],
            basePoints: 25,
            bonusPoints: 0
        )
    }
    
    // MARK: - LESSON 9: Ultrasonic Sensor
    func getLesson_9() -> Creation {
        Creation(
            id: "9-ultrasonic",
            title: "Ultrasonic Distance Sensor",
            type: .tutorial,
            difficulty: .intermediate,
            components: ["Arduino Uno R3", "HC-SR04 Ultrasonic Sensor", "Breadboard", "4x M-M Wires"],
            estimatedDuration: "45 min",
            imageUrl: "FIREBASE_STORAGE_URL_LESSON_9",
            steps: [
                Step(
                    id: "9-step-1",
                    title: "Gather Components",
                    content: """
                    Collect: 1x Arduino Uno R3, 1x HC-SR04 ultrasonic sensor, 1x breadboard, and 4x M-M jumper wires.
                    
                    HC-SR04 measures distance 2cm-400cm using ultrasonic sound waves at 40kHz (inaudible to humans).
                    """,
                    stepNumber: 1,
                    totalSteps: 6,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_9_STEP_1"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "HC-SR04 has 4 pins: VCC, Trig, Echo, GND",
                        "Range: 2cm to 400cm (about 13 feet)",
                        "Uses 40kHz ultrasonic frequency (inaudible)",
                        "Common in robotics, parking sensors, security systems"
                    ]
                ),
                Step(
                    id: "9-step-2",
                    title: "Understanding Ultrasonic Distance Measurement",
                    content: """
                    Sensor emits ultrasonic pulse, measures time for echo to return, calculates distance.
                    
                    Speed of sound: 340m/s. Formula: Distance = (Time × Speed) / 2. Divide by 2 because sound travels to object and back.
                    """,
                    stepNumber: 2,
                    totalSteps: 6,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_9_STEP_2"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Trig pin sends 10μs pulse to emit ultrasound",
                        "Echo pin goes HIGH while waiting for return signal",
                        "Measure Echo HIGH time to calculate distance",
                        "Works best on flat, hard surfaces perpendicular to sensor"
                    ]
                ),
                Step(
                    id: "9-step-3",
                    title: "Place Sensor on Breadboard",
                    content: """
                    Insert HC-SR04 into breadboard with pins spanning center gap. This provides stable mounting and easy connections.
                    
                    Sensor has two ultrasonic transducers (cylinders) on front - one transmits, one receives.
                    """,
                    stepNumber: 3,
                    totalSteps: 6,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_9_STEP_3"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Pins should span breadboard center gap",
                        "Two silver cylinders face outward (transmitter/receiver)",
                        "Mount securely to avoid false readings from vibration",
                        "Leave front clear of obstructions"
                    ]
                ),
                Step(
                    id: "9-step-4",
                    title: "Wire the Circuit",
                    content: """
                    Connect HC-SR04: VCC to 5V, GND to GND, Trig to Pin 12, Echo to Pin 11.
                    
                    Trig sends trigger pulse, Echo receives timing signal. Both are digital pins.
                    """,
                    stepNumber: 4,
                    totalSteps: 6,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_9_STEP_4"],
                        codeSnippets: [
                            "// HC-SR04 Wiring:\n// VCC → Arduino 5V\n// Trig → Arduino Pin 12\n// Echo → Arduino Pin 11\n// GND → Arduino GND"
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "VCC = 5V power supply",
                        "Trig = Trigger signal output (Pin 12)",
                        "Echo = Echo signal input (Pin 11)",
                        "GND = Ground connection"
                    ]
                ),
                Step(
                    id: "9-step-5",
                    title: "Install SR04 Library and Upload Code",
                    content: """
                    Install SR04 library then upload SR04_Example.ino.
                    
                    Code reads distance and displays on Serial Monitor. 'long' data type stores distance (4 bytes, range ±2 billion).
                    """,
                    stepNumber: 5,
                    totalSteps: 6,
                    resources: StepResources(
                        images: [],
                        codeSnippets: [
                            """
                            #include <SR04.h>
                            
                            #define TRIG_PIN 12
                            #define ECHO_PIN 11
                            
                            SR04 sr04 = SR04(ECHO_PIN, TRIG_PIN);
                            long distance;
                            
                            void setup() {
                              Serial.begin(9600);
                            }
                            
                            void loop() {
                              distance = sr04.Distance();
                              Serial.print(distance);
                              Serial.println(" cm");
                              delay(100);
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "SR04 library handles timing calculations",
                        "sr04.Distance() returns measurement in centimeters",
                        "Serial.begin(9600) starts serial communication",
                        "delay(100) = 10 readings per second"
                    ]
                ),
                Step(
                    id: "9-step-6",
                    title: "Test Distance Readings",
                    content: """
                    Open Serial Monitor (Ctrl+Shift+M). Distance readings in cm update continuously.
                    
                    Move hand or object closer/farther to see values change. Min reliable distance ~2-3cm, max 400cm.
                    """,
                    stepNumber: 6,
                    totalSteps: 6,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_9_STEP_6"],
                        codeSnippets: [
                            "// Change to inches:\ndistance = sr04.DistanceInch();"
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Readings should be stable when object is still",
                        "If unstable, check sensor isn't vibrating",
                        "Soft/angled surfaces may give inconsistent results",
                        "Use for: obstacle avoidance, parking assist, liquid level"
                    ]
                )
            ],
            resources: CreationResources(
                code: "FIREBASE_STORAGE_URL_9_CODE",
                diagrams: ["FIREBASE_STORAGE_URL_9_SCHEMATIC"],
                videos: [],
                pdfUrl: nil,
                codeFileUrl: nil,
                libraryUrl: nil
            ),
            quizQuestions: [
                QuizQuestion(
                    question: "How does HC-SR04 measure distance?",
                    options: [
                        "Uses laser beams",
                        "Emits ultrasonic pulse and measures echo return time",
                        "Uses infrared light",
                        "Magnetic field detection"
                    ],
                    correctAnswer: 1,
                    explanation: "HC-SR04 emits ultrasonic sound pulse (40kHz), then measures how long it takes for the echo to return. Time is converted to distance using speed of sound."
                ),
                QuizQuestion(
                    question: "What's the measurement range of HC-SR04?",
                    options: ["0-50cm", "2cm-400cm", "1m-10m", "5cm-100cm"],
                    correctAnswer: 1,
                    explanation: "HC-SR04 accurately measures distances from 2cm (minimum) to 400cm or about 4 meters (maximum). Below 2cm is unreliable."
                ),
                QuizQuestion(
                    question: "Why divide by 2 in distance calculation?",
                    options: [
                        "To convert units",
                        "Sound travels to object and back (round trip)",
                        "Sensor error correction",
                        "Arduino requirement"
                    ],
                    correctAnswer: 1,
                    explanation: "Sound travels TO the object AND back to the sensor. The measured time is for the round trip, so we divide by 2 to get one-way distance."
                ),
                QuizQuestion(
                    question: "What does 'long' data type mean in Arduino?",
                    options: [
                        "Very long text",
                        "32-bit integer (-2 billion to +2 billion)",
                        "Decimal number",
                        "Boolean value"
                    ],
                    correctAnswer: 1,
                    explanation: "'long' is a 32-bit integer that can store values from -2,147,483,648 to 2,147,483,647. Perfect for distance measurements that may exceed regular int range."
                ),
                QuizQuestion(
                    question: "What frequency does HC-SR04 use?",
                    options: ["40kHz (ultrasonic)", "20Hz (audible)", "1MHz (radio)", "100kHz (high frequency)"],
                    correctAnswer: 0,
                    explanation: "HC-SR04 uses 40kHz ultrasonic frequency - above human hearing range (20Hz-20kHz), so it's completely silent to us."
                ),
                QuizQuestion(
                    question: "Why might readings be inconsistent?",
                    options: [
                        "Too much light",
                        "Soft/angled surfaces scatter sound waves",
                        "Arduino is too fast",
                        "Need more power"
                    ],
                    correctAnswer: 1,
                    explanation: "Soft materials (fabric, foam) absorb sound, and angled surfaces reflect sound away. Hard, flat, perpendicular surfaces give best results."
                )
            ],
            basePoints: 25,
            bonusPoints: 0
        )
    }
    
    // MARK: - LESSON 10: Membrane Keypad
    func getLesson_10() -> Creation {
        Creation(
            id: "10-membrane-keypad",
            title: "Membrane Switch Keypad",
            type: .tutorial,
            difficulty: .intermediate,
            components: ["Arduino Uno R3", "4x4 Membrane Keypad", "8x F-M Wires"],
            estimatedDuration: "50 min",
            imageUrl: "FIREBASE_STORAGE_URL_LESSON_10",
            steps: [
                Step(
                    id: "10-step-1",
                    title: "Gather Components",
                    content: """
                    Collect: 1x Arduino Uno R3, 1x 4×4 membrane switch keypad, and 8x F-M DuPont wires.
                    
                    Keypad has 16 keys (0-9, A-D, *, #) but only 8 pins due to efficient matrix encoding.
                    """,
                    stepNumber: 1,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_10_STEP_1"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "16 keys: numbers 0-9, letters A-D, symbols * and #",
                        "Only 8 output pins (4 rows + 4 columns)",
                        "Matrix design reduces wiring complexity",
                        "Thin, flexible membrane construction"
                    ]
                ),
                Step(
                    id: "10-step-2",
                    title: "Understanding Matrix Keypads",
                    content: """
                    Keypad uses row-column matrix. Each key connects one row to one column.
                    
                    By scanning rows and reading columns, Arduino determines which key is pressed with only 8 pins instead of 16.
                    """,
                    stepNumber: 2,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_10_STEP_2"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "4 row wires + 4 column wires = 8 total",
                        "Arduino scans one row at a time",
                        "Checks which column responds to find key",
                        "Library handles all scanning automatically"
                    ]
                ),
                Step(
                    id: "10-step-3",
                    title: "Wire the Keypad",
                    content: """
                    Connect keypad's 8 pins to Arduino D9 through D2 (in order).
                    
                    Pin 1→D9, Pin 2→D8, Pin 3→D7, Pin 4→D6, Pin 5→D5, Pin 6→D4, Pin 7→D3, Pin 8→D2.
                    """,
                    stepNumber: 3,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_10_STEP_3"],
                        codeSnippets: [
                            """
                            // Keypad to Arduino Connections:
                            // Keypad Pin 1 → Arduino D9
                            // Keypad Pin 2 → Arduino D8
                            // Keypad Pin 3 → Arduino D7
                            // Keypad Pin 4 → Arduino D6
                            // Keypad Pin 5 → Arduino D5
                            // Keypad Pin 6 → Arduino D4
                            // Keypad Pin 7 → Arduino D3
                            // Keypad Pin 8 → Arduino D2
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Use F-M (Female-Male) DuPont wires",
                        "Connect in order: Pin 1 to D9, down to Pin 8 to D2",
                        "Keep wires organized to avoid confusion",
                        "First 4 pins = rows, last 4 = columns"
                    ]
                ),
                Step(
                    id: "10-step-4",
                    title: "Install Keypad Library and Upload Code",
                    content: """
                    Install Keypad library (Sketch → Include Library → Add .ZIP Library).
                    
                    Upload custom_keypad.ino. Code detects key presses and displays them on Serial Monitor.
                    """,
                    stepNumber: 4,
                    totalSteps: 5,
                    resources: StepResources(
                        images: [],
                        codeSnippets: [
                            """
                            #include <Keypad.h>
                            
                            const byte ROWS = 4;
                            const byte COLS = 4;
                            
                            char keys[ROWS][COLS] = {
                              {'1','2','3','A'},
                              {'4','5','6','B'},
                              {'7','8','9','C'},
                              {'*','0','#','D'}
                            };
                            
                            byte rowPins[ROWS] = {9, 8, 7, 6};
                            byte colPins[COLS] = {5, 4, 3, 2};
                            
                            Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);
                            
                            void setup() {
                              Serial.begin(9600);
                            }
                            
                            void loop() {
                              char key = keypad.getKey();
                              if (key) {
                                Serial.println(key);
                              }
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Keypad library handles matrix scanning",
                        "keys[][] array maps physical layout to characters",
                        "rowPins[] and colPins[] define Arduino connections",
                        "keypad.getKey() returns pressed key or NULL"
                    ]
                ),
                Step(
                    id: "10-step-5",
                    title: "Test Keypad Input",
                    content: """
                    Open Serial Monitor. Press different keys - they should appear in Serial Monitor instantly.
                    
                    Each press is detected and displayed. Use for PIN entry, calculator input, menu navigation, etc.
                    """,
                    stepNumber: 5,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_10_STEP_5"],
                        codeSnippets: [
                            """
                            // Project idea: Password lock
                            String password = "1234";
                            String input = "";
                            
                            void loop() {
                              char key = keypad.getKey();
                              if (key) {
                                input += key;
                                if (input.length() == 4) {
                                  if (input == password) {
                                    Serial.println("UNLOCKED!");
                                  } else {
                                    Serial.println("WRONG PASSWORD");
                                  }
                                  input = "";
                                }
                              }
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "All 16 keys should register correctly",
                        "If keys don't work, check pin order D9-D2",
                        "No debouncing needed - library handles it",
                        "Build: security systems, calculators, phone dialers, game controllers"
                    ]
                )
            ],
            resources: CreationResources(
                code: "FIREBASE_STORAGE_URL_10_CODE",
                diagrams: ["FIREBASE_STORAGE_URL_10_SCHEMATIC"],
                videos: [],
                pdfUrl: nil,
                codeFileUrl: nil,
                libraryUrl: nil
            ),
            quizQuestions: [
                QuizQuestion(
                    question: "Why does a 4x4 keypad with 16 keys only need 8 wires?",
                    options: [
                        "To save money",
                        "Matrix design: 4 rows + 4 columns = 8 total",
                        "Wireless technology",
                        "Shared ground"
                    ],
                    correctAnswer: 1,
                    explanation: "Matrix design: keys are arranged in 4 rows and 4 columns. Arduino scans rows and reads columns to determine which of the 16 keys is pressed using only 8 connections."
                ),
                QuizQuestion(
                    question: "What does keypad.getKey() return?",
                    options: [
                        "Always returns a number",
                        "Returns the pressed key character, or NULL if no key pressed",
                        "Returns voltage level",
                        "Returns TRUE or FALSE"
                    ],
                    correctAnswer: 1,
                    explanation: "keypad.getKey() returns the character of the pressed key (like '5', 'A', '*') if a key is pressed, or NULL (0) if no key is currently pressed."
                ),
                QuizQuestion(
                    question: "What's the purpose of the keys[][] array?",
                    options: [
                        "Stores key colors",
                        "Maps physical key positions to output characters",
                        "Counts how many times keys are pressed",
                        "Controls key brightness"
                    ],
                    correctAnswer: 1,
                    explanation: "The keys[][] array maps the physical layout of buttons to the characters you want them to output. It tells Arduino 'when row 1, column 1 is pressed, output character 1'."
                ),
                QuizQuestion(
                    question: "Why use F-M (Female-Male) wires for the keypad?",
                    options: [
                        "They're cheaper",
                        "Keypad has male pins, Arduino has female headers",
                        "They conduct better",
                        "Required by library"
                    ],
                    correctAnswer: 1,
                    explanation: "The membrane keypad connector has male pins sticking out. F-M wires have female connectors that fit these pins, and male ends that plug into Arduino's female headers."
                ),
                QuizQuestion(
                    question: "What's a practical use for a membrane keypad?",
                    options: [
                        "Displaying images",
                        "PIN entry systems, calculators, menu navigation",
                        "Measuring temperature",
                        "Playing music"
                    ],
                    correctAnswer: 1,
                    explanation: "Keypads are perfect for any project needing user input: security PIN codes, calculator buttons, phone dialers, menu selection, or game controllers."
                )
            ],
            basePoints: 25,
            bonusPoints: 0
        )
    }
    
    // MARK: - LESSON 11: DHT11 Temperature & Humidity Sensor
    func getLesson_11() -> Creation {
        Creation(
            id: "11-dht11",
            title: "DHT11 Temperature & Humidity Sensor",
            type: .tutorial,
            difficulty: .intermediate,
            components: ["Arduino Uno R3", "DHT11 Sensor Module", "3x F-M Wires"],
            estimatedDuration: "45 min",
            imageUrl: "FIREBASE_STORAGE_URL_LESSON_11",
            steps: [
                Step(
                    id: "11-step-1",
                    title: "Gather Components",
                    content: """
                    Collect: 1x Arduino Uno R3, 1x DHT11 temperature and humidity sensor module, and 3x F-M DuPont wires.
                    
                    DHT11 measures temperature (0-50°C) and humidity (20-90% RH) for weather stations and environmental monitoring.
                    """,
                    stepNumber: 1,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_11_STEP_1"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "DHT11 has 3 pins: VCC (+), DATA (signal), GND (-)",
                        "Temperature range: 0°C to 50°C (±2°C accuracy)",
                        "Humidity range: 20% to 90% RH (±5% accuracy)",
                        "Takes reading every 1-2 seconds maximum"
                    ]
                ),
                Step(
                    id: "11-step-2",
                    title: "Understanding DHT11 Sensor",
                    content: """
                    DHT11 uses digital signal output containing temperature and humidity data.
                    
                    Single-wire communication protocol sends 40 bits of data (humidity + temperature) every reading. Built-in calibration for accuracy.
                    """,
                    stepNumber: 2,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_11_STEP_2"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "Digital output - no analog pins needed",
                        "40-bit data: 16 bits humidity + 16 bits temp + 8 bit checksum",
                        "Low power consumption (0.3mA standby, 60mA active)",
                        "Slower than DHT22 but cheaper and good enough for most projects"
                    ]
                ),
                Step(
                    id: "11-step-3",
                    title: "Wire the DHT11 Sensor",
                    content: """
                    Connect DHT11 module: VCC to 5V, GND to GND, DATA to any digital pin (recommend Pin 2).
                    
                    The data pin can connect to any digital I/O pin on Arduino.
                    """,
                    stepNumber: 3,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_11_STEP_3"],
                        codeSnippets: [
                            "// DHT11 Wiring:\n// VCC → Arduino 5V\n// DATA → Arduino Digital Pin 2\n// GND → Arduino GND"
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "VCC = 5V power (red wire typically)",
                        "DATA = Signal pin (can be any digital pin)",
                        "GND = Ground (black wire typically)",
                        "Module version has built-in pull-up resistor"
                    ]
                ),
                Step(
                    id: "11-step-4",
                    title: "Install DHT Library and Upload Code",
                    content: """
                    Install DHT_nonblocking library. Upload DHT11_Example.ino.
                    
                    Code reads temperature (°C and °F) and humidity (% RH), displaying all three values on Serial Monitor every 2 seconds.
                    """,
                    stepNumber: 4,
                    totalSteps: 5,
                    resources: StepResources(
                        images: [],
                        codeSnippets: [
                            """
                            #include <dht_nonblocking.h>
                            #define DHT_SENSOR_TYPE DHT_TYPE_11
                            
                            static const int DHT_SENSOR_PIN = 2;
                            DHT_nonblocking dht_sensor(DHT_SENSOR_PIN, DHT_SENSOR_TYPE);
                            
                            void setup() {
                              Serial.begin(9600);
                            }
                            
                            void loop() {
                              float temperature, humidity;
                              
                              if (dht_sensor.measure(&temperature, &humidity)) {
                                Serial.print("Temp: ");
                                Serial.print(temperature, 1);
                                Serial.print(" C, ");
                                Serial.print(temperature * 9.0 / 5.0 + 32.0, 1);
                                Serial.print(" F, Humidity: ");
                                Serial.print(humidity, 1);
                                Serial.println(" %");
                              }
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "DHT_nonblocking library prevents blocking delays",
                        "dht_sensor.measure() returns true when new data ready",
                        "Formula: °F = (°C × 9/5) + 32",
                        "Update rate limited to ~1-2 seconds by sensor"
                    ]
                ),
                Step(
                    id: "11-step-5",
                    title: "Monitor Temperature and Humidity",
                    content: """
                    Open Serial Monitor. See temperature (°C and °F) and humidity (%) updating every 2 seconds.
                    
                    Breathe on sensor to see humidity spike. Hold ice near it to see temperature drop. Response time ~6-20 seconds.
                    """,
                    stepNumber: 5,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_11_STEP_5"],
                        codeSnippets: [
                            """
                            // Project idea: Comfort monitor
                            if (temperature > 27.0) {
                              Serial.println("TOO HOT!");
                            } else if (temperature < 18.0) {
                              Serial.println("TOO COLD!");
                            }
                            
                            if (humidity > 70.0) {
                              Serial.println("TOO HUMID!");
                            } else if (humidity < 30.0) {
                              Serial.println("TOO DRY!");
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Readings should be stable when conditions unchanged",
                        "If shows 'nan' or errors, check wiring and library",
                        "Sensor needs 1 second warmup after power on",
                        "Build: weather stations, greenhouse monitors, HVAC controls"
                    ]
                )
            ],
            resources: CreationResources(
                code: "FIREBASE_STORAGE_URL_11_CODE",
                diagrams: ["FIREBASE_STORAGE_URL_11_SCHEMATIC"],
                videos: [],
                pdfUrl: nil,
                codeFileUrl: nil,
                libraryUrl: nil
            ),
            quizQuestions: [
                QuizQuestion(
                    question: "What does DHT11 measure?",
                    options: [
                        "Only temperature",
                        "Temperature and humidity",
                        "Only humidity",
                        "Air pressure"
                    ],
                    correctAnswer: 1,
                    explanation: "DHT11 measures both temperature (0-50°C) and relative humidity (20-90% RH) in a single sensor package."
                ),
                QuizQuestion(
                    question: "How often can you read from DHT11?",
                    options: [
                        "1000 times per second",
                        "Once every 1-2 seconds maximum",
                        "Once per minute",
                        "Anytime instantly"
                    ],
                    correctAnswer: 1,
                    explanation: "DHT11 has built-in sampling rate limit of 1Hz (once per second). Reading faster won't give new data and may cause errors."
                ),
                QuizQuestion(
                    question: "What's the formula to convert Celsius to Fahrenheit?",
                    options: [
                        "F = C × 2",
                        "F = (C × 9/5) + 32",
                        "F = C + 32",
                        "F = C × 1.8"
                    ],
                    correctAnswer: 1,
                    explanation: "Fahrenheit = (Celsius × 9/5) + 32. For example: 25°C = (25 × 9/5) + 32 = 77°F."
                ),
                QuizQuestion(
                    question: "Why use DHT_nonblocking library?",
                    options: [
                        "It's faster",
                        "Prevents Arduino from freezing while waiting for sensor",
                        "More accurate readings",
                        "Uses less power"
                    ],
                    correctAnswer: 1,
                    explanation: "DHT_nonblocking prevents your Arduino code from pausing (blocking) while waiting for sensor measurements. Your code can do other tasks during the ~2 second wait."
                ),
                QuizQuestion(
                    question: "What does 'RH' mean in humidity readings?",
                    options: [
                        "Really Hot",
                        "Relative Humidity - percentage of moisture vs maximum possible",
                        "Room Height",
                        "Rapid Heating"
                    ],
                    correctAnswer: 1,
                    explanation: "RH (Relative Humidity) is the percentage of water vapor in air compared to the maximum amount air can hold at that temperature. 50% RH means air holds half the moisture it could at that temp."
                )
            ],
            basePoints: 25,
            bonusPoints: 0
        )
    }
    
    // MARK: - LESSON 12: Analog Joystick
    func getLesson_12() -> Creation {
        Creation(
            id: "12-joystick",
            title: "Analog Joystick Module",
            type: .tutorial,
            difficulty: .intermediate,
            components: ["Arduino Uno R3", "Thumb Joystick Module", "5x F-M Wires"],
            estimatedDuration: "40 min",
            imageUrl: "FIREBASE_STORAGE_URL_LESSON_12",
            steps: [
                Step(
                    id: "12-step-1",
                    title: "Gather Components",
                    content: """
                    Collect: 1x Arduino Uno R3, 1x analog thumb joystick module, and 5x F-M DuPont wires.
                    
                    Joystick provides X-Y analog position (0-1023) plus button press, perfect for game controllers and robot control.
                    """,
                    stepNumber: 1,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_12_STEP_1"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "5 pins: VCC, GND, VRx (X-axis), VRy (Y-axis), SW (button)",
                        "X and Y use potentiometers for analog output",
                        "Returns values 0-1023 (10-bit ADC)",
                        "Built-in push button activated by pressing stick down"
                    ]
                ),
                Step(
                    id: "12-step-2",
                    title: "Understanding Analog Joysticks",
                    content: """
                    Joystick contains two potentiometers (X and Y axes) that vary resistance based on stick position.
                    
                    Center position ≈ 512. Moving stick changes resistance, changing analog voltage read by Arduino. Button switch closes when pressed down.
                    """,
                    stepNumber: 2,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_12_STEP_2"],
                        codeSnippets: [],
                        videos: []
                    ),
                    checkpoints: [
                        "VRx (X-axis): Left = 0, Center ≈ 512, Right = 1023",
                        "VRy (Y-axis): Down = 0, Center ≈ 512, Up = 1023",
                        "SW (Switch): Normally HIGH, LOW when pressed",
                        "Self-centering spring returns stick to middle"
                    ]
                ),
                Step(
                    id: "12-step-3",
                    title: "Wire the Joystick",
                    content: """
                    Connect: VCC to 5V, GND to GND, VRx to A0, VRy to A1, SW (Key) to D7.
                    
                    X and Y connect to analog pins for reading position. Button connects to digital pin.
                    """,
                    stepNumber: 3,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_12_STEP_3"],
                        codeSnippets: [
                            """
                            // Joystick Wiring:
                            // VCC → Arduino 5V
                            // GND → Arduino GND
                            // VRx → Arduino Analog Pin A0 (X-axis)
                            // VRy → Arduino Analog Pin A1 (Y-axis)
                            // SW  → Arduino Digital Pin 7 (button)
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "VCC and GND provide power",
                        "VRx (X) and VRy (Y) output 0-5V analog signals",
                        "SW is digital: HIGH normally, LOW when pressed",
                        "Only need 4 wires if not using button (skip SW)"
                    ]
                ),
                Step(
                    id: "12-step-4",
                    title: "Upload Joystick Code",
                    content: """
                    Upload Analog_Joystick.ino. Code reads X, Y positions (0-1023) and button state, displaying all on Serial Monitor.
                    
                    No library needed - uses built-in analogRead() and digitalRead() functions.
                    """,
                    stepNumber: 4,
                    totalSteps: 5,
                    resources: StepResources(
                        images: [],
                        codeSnippets: [
                            """
                            const int VRx = A0;
                            const int VRy = A1;
                            const int SW = 7;
                            
                            void setup() {
                              Serial.begin(9600);
                              pinMode(SW, INPUT_PULLUP);
                            }
                            
                            void loop() {
                              int xValue = analogRead(VRx);
                              int yValue = analogRead(VRy);
                              int buttonState = digitalRead(SW);
                              
                              Serial.print("X: ");
                              Serial.print(xValue);
                              Serial.print(" | Y: ");
                              Serial.print(yValue);
                              Serial.print(" | Button: ");
                              Serial.println(buttonState == LOW ? "PRESSED" : "Released");
                              
                              delay(100);
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "analogRead() returns 0-1023 for position",
                        "digitalRead() returns HIGH (released) or LOW (pressed)",
                        "INPUT_PULLUP keeps button pin HIGH normally",
                        "delay(100) = 10 readings per second"
                    ]
                ),
                Step(
                    id: "12-step-5",
                    title: "Test Joystick Movement",
                    content: """
                    Open Serial Monitor. Move joystick in all directions - watch X and Y values change. Press button down - see "PRESSED".
                    
                    Center position should read approximately 512 on both axes. Edges read near 0 or 1023.
                    """,
                    stepNumber: 5,
                    totalSteps: 5,
                    resources: StepResources(
                        images: ["FIREBASE_STORAGE_URL_12_STEP_5"],
                        codeSnippets: [
                            """
                            // Project idea: Direction detector
                            if (xValue < 300) {
                              Serial.println("LEFT");
                            } else if (xValue > 700) {
                              Serial.println("RIGHT");
                            }
                            
                            if (yValue < 300) {
                              Serial.println("DOWN");
                            } else if (yValue > 700) {
                              Serial.println("UP");
                            }
                            
                            if (buttonState == LOW) {
                              Serial.println("FIRE!");
                            }
                            """
                        ],
                        videos: []
                    ),
                    checkpoints: [
                        "Center reads ~512 on both axes (may vary ±50)",
                        "Left/Down = 0, Right/Up = 1023",
                        "Button shows 0 when pressed, 1 when released",
                        "Build: game controllers, robot steering, camera gimbals, menu navigation"
                    ]
                )
            ],
            resources: CreationResources(
                code: "FIREBASE_STORAGE_URL_12_CODE",
                diagrams: ["FIREBASE_STORAGE_URL_12_SCHEMATIC"],
                videos: [],
                pdfUrl: nil,
                codeFileUrl: nil,
                libraryUrl: nil
            ),
            quizQuestions: [
                QuizQuestion(
                    question: "What range of values does analogRead() return for joystick position?",
                    options: ["0-255", "0-1023", "0-100", "-512 to +512"],
                    correctAnswer: 1,
                    explanation: "analogRead() returns 0-1023 (10-bit resolution). Arduino's ADC converts 0-5V analog signal to digital value 0-1023."
                ),
                QuizQuestion(
                    question: "What's the approximate center position value for the joystick?",
                    options: ["0", "512", "1023", "256"],
                    correctAnswer: 1,
                    explanation: "Center position reads approximately 512 (middle of 0-1023 range). It may vary slightly ±50 depending on joystick calibration."
                ),
                QuizQuestion(
                    question: "How does the joystick measure position?",
                    options: [
                        "Digital sensors",
                        "Two potentiometers vary resistance based on stick angle",
                        "Magnetic field",
                        "Optical sensors"
                    ],
                    correctAnswer: 1,
                    explanation: "Joystick uses two potentiometers (variable resistors) - one for X-axis, one for Y-axis. As stick moves, resistance changes, varying the analog voltage."
                ),
                QuizQuestion(
                    question: "What does SW (Switch) pin do?",
                    options: [
                        "Powers the joystick",
                        "Button activated by pressing stick down",
                        "Switches X and Y",
                        "Speed control"
                    ],
                    correctAnswer: 1,
                    explanation: "SW is a push button built into the joystick. Pressing the stick straight down activates this button, useful for 'fire' or 'select' actions."
                ),
                QuizQuestion(
                    question: "Why use INPUT_PULLUP for the button pin?",
                    options: [
                        "Makes button more sensitive",
                        "Keeps pin HIGH normally, LOW when button pressed",
                        "Increases voltage",
                        "Required by joystick"
                    ],
                    correctAnswer: 1,
                    explanation: "INPUT_PULLUP activates internal pull-up resistor, keeping pin HIGH (1) normally. When button pressed and connects to ground, it reads LOW (0)."
                ),
                QuizQuestion(
                    question: "What's a practical use for analog joystick?",
                    options: [
                        "Measuring temperature",
                        "Game controllers, robot steering, camera control",
                        "Playing music",
                        "Displaying text"
                    ],
                    correctAnswer: 1,
                    explanation: "Joysticks are perfect for any 2D control: game controllers, RC car steering, robot arm positioning, drone flight control, or camera gimbal movement."
                )
            ],
            basePoints: 25,
            bonusPoints: 0
        )
    }
}
