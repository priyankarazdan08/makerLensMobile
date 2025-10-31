//
//  ComponentDetectionManager.swift
//  makerLens
//
//  Computer Vision Component Detection System
//  Detects 61 Arduino component types in real-time
//

import Vision
import CoreML
import UIKit
import AVFoundation
import Combine
import SwiftUI

// MARK: - Detection Manager
class ComponentDetectionManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var detectedComponents: [MLDetectedComponent] = []
    @Published var isProcessing = false
    @Published var detectionError: String?
    @Published var fps: Double = 0
    
    // MARK: - Private Properties
    private var model: VNCoreMLModel?
    private var requests = [VNRequest]()
    private let confidenceThreshold: Float = 0.25
    private let iouThreshold: Float = 0.45
    private var lastFrameTime = Date()
    private var frameCount = 0
    
    // MARK: - Initialization
    override init() {
        super.init()
        setupModel()
    }
    
    private func setupModel() {
        // Try to load the CoreML model
        guard let modelURL = Bundle.main.url(
            forResource: "best",
            withExtension: "mlmodelc"
        ) else {
            detectionError = "Model file not found. Please add 'best.mlmodelc' to your project."
            print("❌ Failed to find model file")
            return
        }
        
        do {
            let mlModel = try MLModel(contentsOf: modelURL)
            model = try VNCoreMLModel(for: mlModel)
            setupVisionRequest()
            print("✅ Component detection model loaded successfully")
        } catch {
            detectionError = "Failed to load model: \(error.localizedDescription)"
            print("❌ Failed to load model: \(error)")
        }
    }
    
    private func setupVisionRequest() {
        guard let model = model else { return }
        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            self?.processDetections(request: request, error: error)
        }
        
        request.imageCropAndScaleOption = .scaleFill
        requests = [request]
    }
    
    // MARK: - Image Detection
    func detectComponents(in image: UIImage, completion: @escaping ([MLDetectedComponent]) -> Void) {
        guard let ciImage = CIImage(image: image) else {
            completion([])
            return
        }
        
        isProcessing = true
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                try handler.perform(self.requests)
                // Wait for processing to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isProcessing = false
                    completion(self.detectedComponents)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.detectionError = "Detection failed: \(error.localizedDescription)"
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Process Detections
    private func processDetections(request: VNRequest, error: Error?) {
        guard error == nil else {
            DispatchQueue.main.async {
                self.detectionError = error?.localizedDescription
                self.isProcessing = false
            }
            return
        }
        
        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            DispatchQueue.main.async {
                self.isProcessing = false
            }
            return
        }
        
        var components: [MLDetectedComponent] = []
        
        for observation in results {
            guard let topLabel = observation.labels.first,
                  topLabel.confidence > confidenceThreshold else {
                continue
            }
            
            let component = MLDetectedComponent(
                name: topLabel.identifier,
                confidence: topLabel.confidence,
                boundingBox: observation.boundingBox
            )
            
            components.append(component)
        }
        
        // Apply Non-Maximum Suppression
        let filteredComponents = applyNMS(components: components)
        
        DispatchQueue.main.async {
            self.detectedComponents = filteredComponents
            self.isProcessing = false
            self.detectionError = nil
        }
    }
    
    // MARK: - Non-Maximum Suppression
    private func applyNMS(components: [MLDetectedComponent]) -> [MLDetectedComponent] {
        guard components.count > 1 else { return components }
        
        var result: [MLDetectedComponent] = []
        var sorted = components.sorted { $0.confidence > $1.confidence }
        
        while !sorted.isEmpty {
            let best = sorted.removeFirst()
            result.append(best)
            
            sorted = sorted.filter { component in
                let iou = calculateIOU(best.boundingBox, component.boundingBox)
                return iou < iouThreshold || best.name != component.name
            }
        }
        
        return result
    }
    
    // Calculate Intersection over Union
    private func calculateIOU(_ box1: CGRect, _ box2: CGRect) -> Float {
        let intersection = box1.intersection(box2)
        if intersection.isNull { return 0 }
        
        let intersectionArea = intersection.width * intersection.height
        let union = box1.width * box1.height + box2.width * box2.height - intersectionArea
        
        return Float(intersectionArea / union)
    }
}

// MARK: - ML Detected Component Model
struct MLDetectedComponent: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let confidence: Float
    let boundingBox: CGRect
    
    var displayName: String {
        return name.replacingOccurrences(of: "-", with: " ")
    }
    
    var confidencePercentage: String {
        return String(format: "%.0f%%", confidence * 100)
    }
    
    var confidenceColor: Color {
        if confidence > 0.8 { return .green }
        if confidence > 0.5 { return .orange }
        return .red
    }
    
    static func == (lhs: MLDetectedComponent, rhs: MLDetectedComponent) -> Bool {
        return lhs.id == rhs.id
    }
}
