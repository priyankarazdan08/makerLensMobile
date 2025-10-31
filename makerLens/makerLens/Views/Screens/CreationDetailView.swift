//
//  CreationDetailView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/22/25.
//


import SwiftUI

struct CreationDetailView: View {
    let creation: Creation
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var currentUser: User?
    @Environment(\.dismiss) var dismiss
    
    @State private var isDownloading = false
    @State private var showDownloadAlert = false
    @State private var downloadMessage = ""
    @State private var downloadingResourceType = ""
    
    var isCompleted: Bool {
        currentUser?.completedCreations.contains(creation.id ?? "") ?? false
    }
    
    var isInProgress: Bool {
        currentUser?.inProgressCreations.contains(creation.id ?? "") ?? false
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppConstants.Spacing.xl) {
                // Header Section
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    // Type Badge
                    HStack {
                        Text(creation.type.rawValue.capitalized)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(creation.type == .project ? AppConstants.Colors.primaryPurple : AppConstants.Colors.mediumTeal)
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        if isCompleted {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Completed")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppConstants.Colors.lightTeal)
                        }
                    }
                    
                    // Title
                    Text(creation.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    // Meta Info
                    // Meta Info
                    HStack(spacing: 16) {
                        // Duration (only show if available)
                        if let duration = creation.estimatedDuration {
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .font(.system(size: 14))
                                Text(duration)
                                    .font(.system(size: 15))
                            }
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "chart.bar")
                                .font(.system(size: 14))
                            Text(creation.difficulty.rawValue)
                                .font(.system(size: 15))
                                .foregroundColor(Color(hex: creation.difficulty.color))
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 14))
                            Text("\(creation.steps.count) Steps")
                                .font(.system(size: 15))
                        }
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                // Components Required
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    Text("Components Required")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    ForEach(creation.components, id: \.self) { component in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppConstants.Colors.mediumTeal)
                            
                            Text(component)
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                // Steps Preview
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    Text("Steps Overview")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    ForEach(Array(creation.steps.enumerated()), id: \.element.id) { index, step in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppConstants.Colors.primaryPurple.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                
                                Text("\(step.stepNumber)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AppConstants.Colors.primaryPurple)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(step.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(step.content.prefix(80) + "...")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4)
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                // Resources
                if !creation.resources.code.isEmpty ||
                   !creation.resources.diagrams.isEmpty ||
                   creation.resources.pdfUrl != nil ||
                   creation.resources.codeFileUrl != nil ||
                   creation.resources.libraryUrl != nil {
                    
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                        Text("Resources")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        
                        // PDF Download Button
                        if let pdfUrl = creation.resources.pdfUrl, !pdfUrl.isEmpty {
                            DownloadResourceButton(
                                icon: "doc.text.fill",
                                title: "Download PDF Lesson",
                                subtitle: "Full lesson instructions",
                                color: AppConstants.Colors.mediumTeal,
                                isDownloading: isDownloading && downloadingResourceType == "PDF"
                            ) {
                                downloadResource(url: pdfUrl, type: "PDF")
                            }
                        }
                        
                        // Arduino Code Download
                        if let codeFileUrl = creation.resources.codeFileUrl, !codeFileUrl.isEmpty {
                            DownloadResourceButton(
                                icon: "chevron.left.forwardslash.chevron.right",
                                title: "Download Arduino Code",
                                subtitle: ".ino sketch file",
                                color: AppConstants.Colors.lightTeal,
                                isDownloading: isDownloading && downloadingResourceType == "Code"
                            ) {
                                downloadResource(url: codeFileUrl, type: "Code")
                            }
                        }
                        
                        // Library Download
                        if let libraryUrl = creation.resources.libraryUrl, !libraryUrl.isEmpty {
                            DownloadResourceButton(
                                icon: "shippingbox.fill",
                                title: "Download Library",
                                subtitle: ".zip library package",
                                color: AppConstants.Colors.primaryPurple,
                                isDownloading: isDownloading && downloadingResourceType == "Library"
                            ) {
                                downloadResource(url: libraryUrl, type: "Library")
                            }
                        }
                        
                        // Circuit Diagrams (existing)
                        if !creation.resources.diagrams.isEmpty {
                            ResourceButton(
                                icon: "photo",
                                title: "Circuit Diagram",
                                subtitle: "\(creation.resources.diagrams.count) images"
                            )
                        }
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                }
                
                if !creation.quizQuestions.isEmpty {
                    QuizSection(questions: creation.quizQuestions)
                }
                
                // Action Buttons
                VStack(spacing: AppConstants.Spacing.md) {
                    if isCompleted {
                        NavigationLink(destination: CreationLearningView(creation: creation)) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Review Lesson")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppConstants.Colors.mediumTeal)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    } else if isInProgress {
                        NavigationLink(destination: CreationLearningView(creation: creation)) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Continue Learning")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppConstants.Colors.primaryPurple)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    } else {
                        Button(action: { /* Start */ }) {
                            NavigationLink(destination: CreationLearningView(creation: creation)) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Start Learning")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppConstants.Colors.primaryPurple)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                        }
                    }
                    
                    Button(action: {
                        // TODO: Add to wishlist
                    }) {
                        HStack {
                            Image(systemName: "heart")
                            Text("Add to Wishlist")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, AppConstants.Spacing.lg)
                
                Spacer(minLength: 40)
            }
            .padding(.top, AppConstants.Spacing.xl)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Download Status", isPresented: $showDownloadAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(downloadMessage)
        }
        .task {
            currentUser = firebaseService.currentUser
            print("📋 Creation: \(creation.title)")
            print("📋 Number of steps: \(creation.steps.count)")
            for (index, step) in creation.steps.enumerated() {
                print("📋 Step \(index): stepNumber=\(step.stepNumber), title='\(step.title)'")
            }
        }
    }
}

struct ResourceButton: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppConstants.Colors.lightTeal.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(AppConstants.Colors.mediumTeal)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(AppConstants.Colors.mediumTeal)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4)
        }
    }
}

struct DownloadResourceButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let isDownloading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isDownloading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: color))
                } else {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(color)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4)
        }
        .disabled(isDownloading)
    }
}

// MARK: - Quiz Section (Multiple Choice)
struct QuizSection: View {
    let questions: [QuizQuestion]
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    
    var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }
    
    var isCorrect: Bool {
        selectedAnswer == currentQuestion.correctAnswer
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
            // Header
            HStack {
                Text("Knowledge Check")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                
                Spacer()
                
                Text("\(currentQuestionIndex + 1)/\(questions.count)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.primaryPurple)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppConstants.Colors.primaryPurple.opacity(0.15))
                    .cornerRadius(12)
            }
            
            // Quiz Card
            VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
                // Question
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppConstants.Colors.mediumTeal.opacity(0.15))
                            .frame(width: 32, height: 32)
                        
                        Text("Q")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppConstants.Colors.mediumTeal)
                    }
                    
                    Text(currentQuestion.question)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Options
                VStack(spacing: 12) {
                    ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                        QuizOptionButton(
                            text: option,
                            optionLetter: String(UnicodeScalar(65 + index)!), // A, B, C, D
                            isSelected: selectedAnswer == index,
                            isCorrect: index == currentQuestion.correctAnswer,
                            showResult: selectedAnswer != nil
                        ) {
                            if selectedAnswer == nil {
                                withAnimation {
                                    selectedAnswer = index
                                    showExplanation = true
                                }
                            }
                        }
                    }
                }
                
                // Explanation
                if showExplanation, let selected = selectedAnswer {
                    VStack(alignment: .leading, spacing: 12) {
                        Divider()
                        
                        // Result Badge
                        HStack {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isCorrect ? AppConstants.Colors.lightTeal : .red)
                            
                            Text(isCorrect ? "Correct!" : "Not quite...")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(isCorrect ? AppConstants.Colors.lightTeal : .red)
                        }
                        
                        // Explanation
                        Text(currentQuestion.explanation)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(AppConstants.Spacing.lg)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
            
            // Navigation Arrows
            HStack {
                Button(action: previousQuestion) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(currentQuestionIndex > 0 ? AppConstants.Colors.primaryPurple : .secondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .disabled(currentQuestionIndex == 0)
                
                Spacer()
                
                Button(action: nextQuestion) {
                    HStack(spacing: 8) {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(currentQuestionIndex < questions.count - 1 ? AppConstants.Colors.primaryPurple : .secondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .disabled(currentQuestionIndex == questions.count - 1)
            }
        }
        .padding(.horizontal, AppConstants.Spacing.lg)
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            withAnimation {
                selectedAnswer = nil
                showExplanation = false
                currentQuestionIndex += 1
            }
        }
    }
    
    private func previousQuestion() {
        if currentQuestionIndex > 0 {
            withAnimation {
                selectedAnswer = nil
                showExplanation = false
                currentQuestionIndex -= 1
            }
        }
    }
}
// MARK: - Quiz Option Button
struct QuizOptionButton: View {
    let text: String
    let optionLetter: String
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if !showResult {
            return isSelected ? AppConstants.Colors.primaryPurple.opacity(0.1) : Color(.systemGray6)
        }
        if isSelected {
            return isCorrect ? AppConstants.Colors.lightTeal.opacity(0.2) : Color.red.opacity(0.2)
        }
        if isCorrect {
            return AppConstants.Colors.lightTeal.opacity(0.2)
        }
        return Color(.systemGray6)
    }
    
    var borderColor: Color {
        if !showResult {
            return isSelected ? AppConstants.Colors.primaryPurple : Color.clear
        }
        if isSelected {
            return isCorrect ? AppConstants.Colors.lightTeal : .red
        }
        if isCorrect {
            return AppConstants.Colors.lightTeal
        }
        return Color.clear
    }
    
    var icon: String? {
        if !showResult { return nil }
        if isCorrect { return "checkmark.circle.fill" }
        if isSelected { return "xmark.circle.fill" }
        return nil
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Option Letter
                ZStack {
                    Circle()
                        .fill(isSelected && !showResult ? AppConstants.Colors.primaryPurple.opacity(0.15) : Color(.systemBackground))
                        .frame(width: 32, height: 32)
                    
                    Text(optionLetter)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(isSelected && !showResult ? AppConstants.Colors.primaryPurple : .secondary)
                }
                
                // Option Text
                Text(text)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                // Result Icon
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(isCorrect ? AppConstants.Colors.lightTeal : .red)
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
        }
        .disabled(showResult)
    }
}  // ← END OF QuizOptionButton

// MARK: - CreationDetailView Extension for Download
extension CreationDetailView {
    private func downloadResource(url: String, type: String) {
        isDownloading = true
        downloadingResourceType = type
        
        DownloadHelper.downloadFile(from: url) { result in
            isDownloading = false
            downloadingResourceType = ""
            
            switch result {
            case .success(let fileURL):
                // Show share sheet
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    DownloadHelper.shareFile(url: fileURL, from: rootViewController)
                }
                
                downloadMessage = "\(type) downloaded successfully! You can now save or share it."
                showDownloadAlert = true
                
            case .failure(let error):
                downloadMessage = "Download failed: \(error.localizedDescription)\n\nMake sure you're using a valid HTTPS URL from Firebase Storage."
                showDownloadAlert = true
            }
        }
    }
}
