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

// MARK: - Circuit Analysis View with Error Handling
struct CircuitAnalysisView: View {
    let image: UIImage
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnalyzing = true
    @State private var detectedComponents: [DetectedComponent] = []
    
    var body: some View {
        NavigationView {
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
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                    
                    if !isAnalyzing {
                        // Analysis Results
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                            Text("Detected Components:")
                                .font(AppConstants.Fonts.headline)
                            
                            LazyVStack(spacing: AppConstants.Spacing.sm) {
                                ForEach(detectedComponents) { component in
                                    DetectedComponentRow(component: component)
                                }
                            }
                            
                            // Suggested Projects
                            Text("Suggested Projects:")
                                .font(AppConstants.Fonts.headline)
                                .padding(.top)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppConstants.Spacing.md) {
                                    ForEach(suggestedProjects, id: \.self) { project in
                                        SuggestedProjectCard(title: project)
                                    }
                                }
                                .padding(.horizontal, AppConstants.Spacing.lg)
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
        .onAppear {
            // Simulate analysis delay with proper animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAnalyzing = false
                    detectedComponents = mockDetectedComponents
                }
            }
        }
    }
    
    private var suggestedProjects: [String] {
        ["LED Blink", "Button Control", "Potentiometer Reading", "Servo Control"]
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
