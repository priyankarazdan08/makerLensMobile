//
//  CameraView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/31/25.
//

// MARK: - Views/Camera/CameraView.swift (REPLACE your existing CameraView)
import SwiftUI
import UIKit
import AVFoundation

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImage: UIImage? {
        didSet {
            // Compress large images to prevent memory crashes
            if let image = selectedImage {
                let maxSize = CGSize(width: 1024, height: 1024)
                if image.size.width > maxSize.width || image.size.height > maxSize.height {
                    selectedImage = image.resized(to: maxSize)
                }
            }
        }
    }
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var imageSource: ImageSource = .camera
    @State private var showingAnalysis = false
    @State private var cameraAccessGranted = false
    @EnvironmentObject var firebaseService: FirebaseService

    
    var body: some View {
        NavigationView {
            VStack(spacing: AppConstants.Spacing.xl) {
                // Header
                VStack(spacing: AppConstants.Spacing.md) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 60))
                        .foregroundColor(AppConstants.Colors.primaryPurple)
                    
                    Text("Circuit Recognition")
                        .font(AppConstants.Fonts.title)
                    
                    Text("Take a photo or select an image of your Arduino circuit to identify components")
                        .font(AppConstants.Fonts.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppConstants.Spacing.lg)
                }
                
                // Selected Image Preview
                if let selectedImage = selectedImage {
                    VStack(spacing: AppConstants.Spacing.md) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(AppConstants.CornerRadius.md)
                            .shadow(radius: 4)
                        
                        Button(action: {
                            showingAnalysis = true
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Analyze Circuit")
                            }
                            .primaryButtonStyle()
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.selectedImage = nil
                            }
                        }) {
                            Text("Take Another Photo")
                                .secondaryButtonStyle()
                        }
                    }
                } else {
                    // Camera/Photo Selection Options
                    VStack(spacing: AppConstants.Spacing.lg) {
                        Button(action: {
                            checkCameraPermission()
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Capture Circuit Image")
                            }
                            .font(AppConstants.Fonts.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppConstants.Spacing.lg)
                            .background(AppConstants.Colors.primaryGradient)
                            .cornerRadius(AppConstants.CornerRadius.md)
                        }
                        
                        // Tips for better photos
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                            Text("📸 Tips for Better Recognition:")
                                .font(AppConstants.Fonts.headline)
                                .padding(.bottom, AppConstants.Spacing.xs)
                            
                            PhotoTipView(icon: "lightbulb", tip: "Ensure good lighting")
                            PhotoTipView(icon: "viewfinder", tip: "Keep circuit in center of frame")
                            PhotoTipView(icon: "hand.raised", tip: "Hold camera steady")
                            PhotoTipView(icon: "arrow.up.and.down", tip: "Take photo from above")
                        }
                        .padding(AppConstants.Spacing.lg)
                        .background(AppConstants.Colors.lightTeal.opacity(0.1))
                        .cornerRadius(AppConstants.CornerRadius.md)
                    }
                }
                
                Spacer()
            }
            .padding(AppConstants.Spacing.lg)
            .navigationTitle("Circuit Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            SafeImagePicker(selectedImage: $selectedImage, sourceType: imageSource == .camera ? .camera : .photoLibrary)
        }
        .confirmationDialog("Select Image Source", isPresented: $showingActionSheet) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) && cameraAccessGranted {
                Button("Take Photo") {
                    imageSource = .camera
                    showingImagePicker = true
                }
            }
            
            Button("Choose from Photos") {
                imageSource = .photoLibrary
                showingImagePicker = true
            }
            
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingAnalysis) {
            if let selectedImage = selectedImage {
                CircuitAnalysisView(image: selectedImage)
                    .environmentObject(firebaseService)  // ← ADD THIS LINE HERE
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraAccessGranted = true
            showingActionSheet = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.cameraAccessGranted = granted
                    if granted {
                        self.showingActionSheet = true
                    }
                }
            }
        case .denied, .restricted:
            cameraAccessGranted = false
            showingActionSheet = true
        @unknown default:
            break
        }
    }
}

struct PhotoTipView: View {
    let icon: String
    let tip: String
    
    var body: some View {
        HStack(spacing: AppConstants.Spacing.sm) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(AppConstants.Colors.darkTeal)
                .frame(width: 20)
            
            Text(tip)
                .font(AppConstants.Fonts.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Safe ImagePicker (Prevents GPU/Metal Issues)
struct SafeImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        
        // Prevent GPU/Metal texture issues
        picker.modalPresentationStyle = .fullScreen
        picker.videoQuality = .typeMedium // Reduce GPU load
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: SafeImagePicker
        
        init(_ parent: SafeImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Process image on background thread to prevent blocking
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = info[.originalImage] as? UIImage {
                    // Compress immediately to prevent memory issues
                    let compressedImage = image.compressed()
                    
                    DispatchQueue.main.async {
                        self.parent.selectedImage = compressedImage
                        picker.dismiss(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true)
                    }
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                picker.dismiss(animated: true)
            }
        }
    }
}

enum ImageSource {
    case camera
    case photoLibrary
}
// MARK: - Circuit Analysis View with Firebase Integration & Points
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CircuitAnalysisView: View {
    let image: UIImage
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var detectionManager = ComponentDetectionManager()
    
    @State private var isAnalyzing = true
    @State private var detectedComponents: [DetectedComponent] = []
    @State private var errorMessage: String?
    @State private var suggestedProjects: [ProjectSuggestion] = []
    @State private var isLoadingProjects = false
    @State private var pointsEarned: Int = 0
    @State private var showPointsAnimation = false
    
//    private let db = Firestore.firestore()
    private let pointsPerComponent = 35
    @EnvironmentObject var firebaseService: FirebaseService

    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: AppConstants.Spacing.lg) {
                        // Image with overlay
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(AppConstants.CornerRadius.md)
                                .clipped()
                            
                            if isAnalyzing {
                                RoundedRectangle(cornerRadius: AppConstants.CornerRadius.md)
                                    .fill(Color.black.opacity(0.3))
                                
                                VStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(1.5)
                                    
                                    Text("Analyzing Circuit...")
                                        .foregroundColor(.white)
                                        .font(AppConstants.Fonts.headline)
                                        .padding(.top)
                                    
                                    Text("Using AI to detect components")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(AppConstants.Fonts.caption)
                                }
                            }
                        }
                        .frame(maxHeight: 300)
                        
                        // Error Message
                        if let errorMessage = errorMessage {
                            VStack(spacing: AppConstants.Spacing.sm) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.largeTitle)
                                    .foregroundColor(.orange)
                                
                                Text("Detection Error")
                                    .font(AppConstants.Fonts.headline)
                                
                                Text(errorMessage)
                                    .font(AppConstants.Fonts.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Try Again") {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(AppConstants.Spacing.lg)
                        }
                        
                        if !isAnalyzing && errorMessage == nil {
                            // Points Earned Banner
                            if pointsEarned > 0 {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text("+\(pointsEarned) Points Earned!")
                                        .font(AppConstants.Fonts.headline)
                                        .fontWeight(.bold)
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        colors: [AppConstants.Colors.primaryPurple.opacity(0.8), AppConstants.Colors.mediumTeal.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(AppConstants.CornerRadius.md)
                                .scaleEffect(showPointsAnimation ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6).repeatCount(3, autoreverses: true), value: showPointsAnimation)
                            }
                            
                            // Analysis Results
                            VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                                HStack {
                                    Text("Detected Components:")
                                        .font(AppConstants.Fonts.headline)
                                    
                                    Spacer()
                                    
                                    Text("\(detectedComponents.count) found")
                                        .font(AppConstants.Fonts.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                if detectedComponents.isEmpty {
                                    VStack(spacing: AppConstants.Spacing.sm) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        
                                        Text("No components detected")
                                            .font(AppConstants.Fonts.body)
                                            .foregroundColor(.secondary)
                                        
                                        Text("Try taking another photo with better lighting")
                                            .font(AppConstants.Fonts.caption)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(AppConstants.Spacing.xl)
                                } else {
                                    LazyVStack(spacing: AppConstants.Spacing.sm) {
                                        ForEach(detectedComponents) { component in
                                            DetectedComponentRow(component: component)
                                        }
                                    }
                                }
                                
                                // Suggested Projects from Firebase
                                if !suggestedProjects.isEmpty {
                                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                                        Text("Suggested Projects:")
                                            .font(AppConstants.Fonts.headline)
                                        
                                        Text("Based on your detected components")
                                            .font(AppConstants.Fonts.caption)
                                            .foregroundColor(.secondary)
                                        
                                        if isLoadingProjects {
                                            HStack {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle())
                                                Text("Finding best projects...")
                                                    .font(AppConstants.Fonts.body)
                                                    .foregroundColor(.secondary)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                        } else {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: AppConstants.Spacing.md) {
                                                    ForEach(suggestedProjects) { project in
                                                        ProjectSuggestionCard(project: project)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.top)
                                }
                                
                                // Points Breakdown Info
                                if pointsEarned > 0 {
                                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                                        HStack {
                                            Image(systemName: "chart.bar.fill")
                                                .foregroundColor(AppConstants.Colors.primaryPurple)
                                            Text("How You Earned Points")
                                                .font(AppConstants.Fonts.headline)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                                            // Base points
                                            HStack {
                                                Text("Components Detected:")
                                                    .font(AppConstants.Fonts.body)
                                                    .foregroundColor(.secondary)
                                                Spacer()
                                                Text("\(detectedComponents.count) × 35 pts")
                                                    .font(AppConstants.Fonts.body)
                                                    .fontWeight(.semibold)
                                            }
                                            
                                            // Calculate multiplier info
                                            let basePoints = detectedComponents.count * pointsPerComponent
                                            if pointsEarned > basePoints {
                                                let multiplier = Double(pointsEarned) / Double(basePoints)
                                                
                                                Divider()
                                                
                                                HStack(alignment: .top) {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: "flame.fill")
                                                            .foregroundColor(.orange)
                                                            .font(.caption)
                                                        Text("Streak Bonus:")
                                                            .font(AppConstants.Fonts.body)
                                                            .foregroundColor(.secondary)
                                                    }
                                                    Spacer()
                                                    Text("\(String(format: "%.1f", multiplier))x multiplier")
                                                        .font(AppConstants.Fonts.body)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(AppConstants.Colors.primaryPurple)
                                                }
                                                
                                                Divider()
                                            }
                                            
                                            // Total
                                            HStack {
                                                Text("Total Earned:")
                                                    .font(AppConstants.Fonts.body)
                                                    .fontWeight(.bold)
                                                Spacer()
                                                Text("\(pointsEarned) points")
                                                    .font(AppConstants.Fonts.body)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(AppConstants.Colors.primaryPurple)
                                            }
                                        }
                                        .padding(AppConstants.Spacing.md)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.md)
                                                .fill(AppConstants.Colors.lightTeal.opacity(0.1))
                                        )
                                        
                                        // Tip about streaks
                                        if pointsEarned == detectedComponents.count * pointsPerComponent {
                                            HStack(alignment: .top, spacing: AppConstants.Spacing.sm) {
                                                Image(systemName: "lightbulb.fill")
                                                    .foregroundColor(.orange)
                                                    .font(.caption)
                                                
                                                Text("Keep scanning daily to build your streak and earn bonus multipliers!")
                                                    .font(AppConstants.Fonts.caption)
                                                    .foregroundColor(.secondary)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .padding(AppConstants.Spacing.sm)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.orange.opacity(0.1))
                                            )
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                            .padding(AppConstants.Spacing.lg)
                        }
                    }
                }
                .navigationTitle("Circuit Analysis")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            performDetection()
        }
    }
    
    
    // MARK: - Detection
    private func performDetection() {
        detectionManager.detectComponents(in: image) { components in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAnalyzing = false
                    
                    if let error = detectionManager.detectionError {
                        errorMessage = error
                    } else {
                        // Convert ML detection results to UI format
                        detectedComponents = components.map { mlComponent in
                            DetectedComponent(
                                name: mlComponent.name.replacingOccurrences(of: "-", with: " "),
                                confidence: Double(mlComponent.confidence),
                                category: categoryFromName(mlComponent.name)
                            )
                        }
                        
                        // Sort by confidence
                        detectedComponents.sort { $0.confidence > $1.confidence }
                        
                        // Award points
                        awardPoints(for: detectedComponents.count)
                        
                        // Get project suggestions from Firebase
                        if !detectedComponents.isEmpty {
                            fetchProjectSuggestions()
                        }
                    }
                }
            }
        }
    }
    
    private func awardPoints(for componentCount: Int) {
        guard firebaseService.currentUser != nil else {
            print("❌ No user logged in - cannot award points")
            return
        }
        
        let basePoints = componentCount * pointsPerComponent
        
        Task {
            do {
                // Use FirebaseService's built-in method
                try await firebaseService.awardPointsForScan(componentCount: componentCount, pointsPerComponent: pointsPerComponent)
                
                // Get the actual points earned (includes multiplier)
                if let userPoints = try? await firebaseService.getUserPoints() {
                    await MainActor.run {
                        self.pointsEarned = basePoints // For display purposes, show base points
                        withAnimation {
                            showPointsAnimation = true
                        }
                    }
                }
            } catch {
                print("❌ Error awarding points: \(error)")
            }
        }
    }
    
    // MARK: - Firebase Project Suggestions
    private func fetchProjectSuggestions() {
        isLoadingProjects = true
        
        // Map ML detection names to Firebase component IDs
        let detectedComponentIds = detectedComponents.compactMap { component -> String? in
            mapToFirebaseComponentId(component.name)
        }
        
        print("🔍 Detected component IDs: \(detectedComponentIds)")
        
        // Fetch matching components from Firebase
        firebaseService.db.collection("components").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching components: \(error)")
                isLoadingProjects = false
                return
            }
            
            guard let documents = snapshot?.documents else {
                isLoadingProjects = false
                return
            }
            
            // Build a dictionary: projectId -> count of matching components
            var projectScores: [String: Int] = [:]
            
            for doc in documents {
                let componentId = doc.documentID
                
                // Check if this component was detected
                if detectedComponentIds.contains(componentId) {
                    
                    // Get creations array from this component
                    if let creations = doc.data()["creations"] as? [String] {
                        for projectName in creations {
                            projectScores[projectName, default: 0] += 1
                        }
                    }
                }
            }
            
            print("📊 Project scores: \(projectScores)")
            
            // Sort projects by score (most matching components first)
            let sortedProjects = projectScores.sorted { $0.value > $1.value }
            
            // Get top 6 project names
            let topProjectNames = Array(sortedProjects.prefix(6).map { $0.key })
            
            // Fetch details for top projects
            fetchProjectDetailsByTitle(projectTitles: topProjectNames, scores: projectScores)
        }
    }
    
    private func fetchProjectDetailsByTitle(projectTitles: [String], scores: [String: Int]) {
        guard !projectTitles.isEmpty else {
            isLoadingProjects = false
            return
        }
        
        // Fetch creations where title matches
        firebaseService.db.collection("creations").whereField("title", in: projectTitles).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching project details: \(error)")
                isLoadingProjects = false
                return
            }
            
            guard let documents = snapshot?.documents else {
                isLoadingProjects = false
                return
            }
            
            var projects: [ProjectSuggestion] = []
            
            for doc in documents {
                let data = doc.data()
                let title = data["title"] as? String ?? "Untitled Project"
                let matchCount = scores[title] ?? 0
                
                let project = ProjectSuggestion(
                    id: doc.documentID,
                    title: title,
                    difficulty: data["difficulty"] as? String ?? "intermediate",
                    components: data["components"] as? [String] ?? [],
                    matchingComponentCount: matchCount
                )
                projects.append(project)
            }
            
            // Sort by match count
            projects.sort { $0.matchingComponentCount > $1.matchingComponentCount }
            
            DispatchQueue.main.async {
                self.suggestedProjects = projects
                self.isLoadingProjects = false
                print("✅ Found \(projects.count) matching projects")
            }
        }
    }
    
    // MARK: - Helper Functions
    private func mapToFirebaseComponentId(_ detectedName: String) -> String? {
        let normalized = detectedName.lowercased().replacingOccurrences(of: " ", with: "-")
        
        // Map common ML detection names to Firebase component IDs
        let mappings: [String: String] = [
            "arduino-uno": "arduino-uno-r3",
            "led-light": "led-5mm-red",
            "resistor": "resistor-220",
            "breadboard": "breadboard-830",
            "servo-motor": "servo-sg90",
            "sonar-sensor": "ultrasonic-hcsr04",
            "oled-display": "lcd-1602",
            "esp32": "arduino-uno-r3", // Fallback to Arduino if ESP32 not in DB
            "push-switch": "push-button",
            "tact-switch": "push-button",
            "buzzer": "active-buzzer"
        ]
        
        // Check if we have a direct mapping
        if let mapped = mappings[normalized] {
            return mapped
        }
        
        // Otherwise try to find partial match in component IDs
        // This helps match things like "resistor-220" when ML detects "resistor"
        if normalized.contains("resistor") {
            return "resistor-220"
        } else if normalized.contains("led") && !normalized.contains("oled") {
            return "led-5mm-red"
        } else if normalized.contains("arduino") {
            return "arduino-uno-r3"
        } else if normalized.contains("ultrasonic") || normalized.contains("sonar") {
            return "ultrasonic-hcsr04"
        } else if normalized.contains("servo") {
            return "servo-sg90"
        } else if normalized.contains("breadboard") {
            return "breadboard-830"
        }
        
        return nil
    }
    
    private func categoryFromName(_ name: String) -> String {
        let lowercased = name.lowercased()
        
        if lowercased.contains("arduino") || lowercased.contains("esp32") || lowercased.contains("nano") || lowercased.contains("mega") {
            return "Microcontroller"
        } else if lowercased.contains("led") || lowercased.contains("light") {
            return "LED"
        } else if lowercased.contains("resistor") {
            return "Resistor"
        } else if lowercased.contains("switch") || lowercased.contains("button") || lowercased.contains("tact") {
            return "Button"
        } else if lowercased.contains("breadboard") {
            return "Breadboard"
        } else if lowercased.contains("sensor") || lowercased.contains("sonar") || lowercased.contains("motion") || lowercased.contains("gas") || lowercased.contains("humidity") {
            return "Sensor"
        } else if lowercased.contains("display") || lowercased.contains("oled") || lowercased.contains("lcd") || lowercased.contains("segment") {
            return "Display"
        } else if lowercased.contains("capacitor") {
            return "Capacitor"
        } else if lowercased.contains("motor") || lowercased.contains("servo") {
            return "Motor"
        } else if lowercased.contains("diode") {
            return "Diode"
        } else if lowercased.contains("transistor") || lowercased.contains("mosfet") || lowercased.contains("bjt") || lowercased.contains("igbt") {
            return "Transistor"
        } else if lowercased.contains("module") || lowercased.contains("bluetooth") || lowercased.contains("wifi") || lowercased.contains("gsm") {
            return "Module"
        } else if lowercased.contains("battery") {
            return "Power"
        }
        
        return "Component"
    }
}

// MARK: - Project Suggestion Model
struct ProjectSuggestion: Identifiable {
    let id: String
    let title: String
    let difficulty: String
    let components: [String]
    let matchingComponentCount: Int
    
    var difficultyColor: Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "intermediate": return .orange
        case "advanced", "super-hard": return .red
        default: return .gray
        }
    }
    
    var difficultyIcon: String {
        switch difficulty.lowercased() {
        case "easy": return "star.fill"
        case "intermediate": return "star.leadinghalf.filled"
        case "advanced", "super-hard": return "flame.fill"
        default: return "star"
        }
    }
}

// MARK: - Project Suggestion Card
struct ProjectSuggestionCard: View {
    let project: ProjectSuggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
            HStack {
                Image(systemName: project.difficultyIcon)
                    .foregroundColor(project.difficultyColor)
                Text(project.difficulty.capitalized)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(project.difficultyColor)
            }
            
            Text(project.title)
                .font(AppConstants.Fonts.body)
                .fontWeight(.semibold)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text("\(project.matchingComponentCount)/\(project.components.count) components")
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Match percentage badge
                if project.matchingComponentCount > 0 {
                    Text("\(Int(Double(project.matchingComponentCount) / Double(project.components.count) * 100))%")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppConstants.Colors.lightTeal)
                        .foregroundColor(AppConstants.Colors.darkTeal)
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            Text("View Project")
                .font(AppConstants.Fonts.caption)
                .fontWeight(.medium)
                .foregroundColor(AppConstants.Colors.primaryPurple)
        }
        .padding(AppConstants.Spacing.md)
        .frame(width: 160, height: 150)
        .background(Color(.systemGray6))
        .cornerRadius(AppConstants.CornerRadius.md)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct DetectedComponent: Identifiable {
    let id = UUID()
    let name: String
    let confidence: Double
    let category: String
}

struct DetectedComponentRow: View {
    let component: DetectedComponent
    
    var body: some View {
        HStack {
            Image(systemName: componentIcon(for: component.category))
                .foregroundColor(AppConstants.Colors.primaryPurple)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text(component.name)
                    .font(AppConstants.Fonts.body)
                    .fontWeight(.medium)
                
                Text(component.category)
                    .font(AppConstants.Fonts.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(component.confidence * 100))%")
                .font(AppConstants.Fonts.caption)
                .fontWeight(.medium)
                .foregroundColor(AppConstants.Colors.darkTeal)
                .padding(.horizontal, AppConstants.Spacing.sm)
                .padding(.vertical, 4)
                .background(AppConstants.Colors.lightTeal.opacity(0.2))
                .cornerRadius(6)
        }
        .padding(AppConstants.Spacing.sm)
        .background(Color(.systemGray6))
        .cornerRadius(AppConstants.CornerRadius.sm)
    }
    
    private func componentIcon(for category: String) -> String {
        switch category.lowercased() {
        case "microcontroller": return "cpu"
        case "led": return "lightbulb"
        case "resistor": return "minus.circle" // Fixed: was "resistor" which doesn't exist
        case "button": return "button.programmable"
        case "breadboard": return "rectangle.grid.3x2"
        default: return "questionmark.circle"
        }
    }
}

struct SuggestedProjectCard: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(AppConstants.Fonts.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .padding(AppConstants.Spacing.md)
        .frame(width: 120, height: 80)
        .background(AppConstants.Colors.lightTeal.opacity(0.2))
        .cornerRadius(AppConstants.CornerRadius.sm)
    }
}

// MARK: - Enhanced UIImage Extension
extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func compressed() -> UIImage {
        // Compress to JPEG with 0.8 quality to reduce memory usage
        guard let data = self.jpegData(compressionQuality: 0.8),
              let compressedImage = UIImage(data: data) else {
            return self
        }
        
        // Resize if still too large
        let maxDimension: CGFloat = 1024
        if size.width > maxDimension || size.height > maxDimension {
            let scale = min(maxDimension / size.width, maxDimension / size.height)
            let newSize = CGSize(width: size.width * scale, height: size.height * scale)
            return compressedImage.resized(to: newSize) ?? compressedImage
        }
        
        return compressedImage
    }
}

// Mock data for testing
private let mockDetectedComponents = [
    DetectedComponent(name: "Arduino Uno R3", confidence: 0.95, category: "Microcontroller"),
    DetectedComponent(name: "LED (Red)", confidence: 0.88, category: "LED"),
    DetectedComponent(name: "220Ω Resistor", confidence: 0.82, category: "Resistor"),
    DetectedComponent(name: "Push Button", confidence: 0.76, category: "Button"),
    DetectedComponent(name: "Breadboard", confidence: 0.91, category: "Breadboard")
]
