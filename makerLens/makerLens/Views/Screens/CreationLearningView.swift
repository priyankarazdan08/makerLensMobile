//
//  CreationLearningView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 10/23/25.
//

import SwiftUI

struct CreationLearningView: View {
    let creation: Creation
    @EnvironmentObject var firebaseService: FirebaseService
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStepIndex = 0
    @State private var completedSteps: Set<Int> = []
    @State private var showQuiz = false
    @State private var currentQuizIndex = 0
    @State private var earnedPoints = 0
    @State private var showCompletionCelebration = false
    @State private var quizAnswers: [Int: Int] = [:] // questionIndex: selectedAnswer
    
    var currentStep: Step {
        creation.steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(creation.steps.count)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Progress
                headerView
                
                // Main Content
                ScrollView {
                    VStack(spacing: AppConstants.Spacing.xl) {
                        // Step Card
                        stepContentCard
                        
                        // Circuit Diagram (at the end)
                        if currentStepIndex == creation.steps.count - 1 {
                            circuitDiagramSection
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(AppConstants.Spacing.lg)
                }
                
                // Navigation Footer
                navigationFooter
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(AppConstants.Colors.primaryPurple)
                }
            }
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(
                questions: creation.quizQuestions,
                onComplete: handleQuizCompletion
            )
        }
        .sheet(isPresented: $showCompletionCelebration) {
            CompletionCelebrationView(
                creation: creation,
                earnedPoints: earnedPoints,
                onDismiss: {
                    showCompletionCelebration = false
                    dismiss()
                }
            )
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(creation.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Step \(currentStepIndex + 1) of \(creation.steps.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Points indicator
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppConstants.Colors.lightTeal)
                    Text("\(creation.basePoints)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppConstants.Colors.lightTeal.opacity(0.15))
                .cornerRadius(12)
            }
            .padding(.horizontal, AppConstants.Spacing.lg)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [AppConstants.Colors.primaryPurple, AppConstants.Colors.mediumTeal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, AppConstants.Spacing.lg)
        }
        .padding(.vertical, AppConstants.Spacing.md)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
    
    // MARK: - Step Content Card
    private var stepContentCard: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.lg) {
            // Step Number Badge
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppConstants.Colors.primaryPurple.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Text("\(currentStep.stepNumber)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(AppConstants.Colors.primaryPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Step \(currentStep.stepNumber)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Text(currentStep.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
            }
            
            Divider()
            
            // Main Content
            Text(currentStep.content)
                .font(.system(size: 17))
                .foregroundColor(.primary)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
            
            // Images - Only show if there are valid, non-empty image URLs
            if !currentStep.resources.images.isEmpty {
                VStack(spacing: AppConstants.Spacing.md) {
                    ForEach(currentStep.resources.images, id: \.self) { imageUrl in
                        // Only render if URL is not empty
                        if !imageUrl.isEmpty {
                            AsyncImage(url: URL(string: imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.1), radius: 8)
                                case .failure:
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
            }
            
            // Code Snippets
            if !currentStep.resources.codeSnippets.isEmpty {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    HStack {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                            .foregroundColor(AppConstants.Colors.mediumTeal)
                        Text("Code Example")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    
                    ForEach(Array(currentStep.resources.codeSnippets.enumerated()), id: \.offset) { index, code in
                        VStack(alignment: .leading, spacing: 0) {
                            // Code header
                            HStack {
                                Text("Arduino Code")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button(action: {
                                    UIPasteboard.general.string = code
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "doc.on.doc")
                                        Text("Copy")
                                    }
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppConstants.Colors.mediumTeal)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            
                            // Code content
                            ScrollView(.horizontal, showsIndicators: true) {
                                Text(code)
                                    .font(.system(size: 14, design: .monospaced))
                                    .foregroundColor(.primary)
                                    .padding(12)
                            }
                            .background(Color(.systemBackground))
                        }
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                }
            }
            
            // Checkpoints
            if !currentStep.checkpoints.isEmpty {
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppConstants.Colors.lightTeal)
                        Text("Key Points")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(Array(currentStep.checkpoints.enumerated()), id: \.offset) { index, checkpoint in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(AppConstants.Colors.lightTeal.opacity(0.15))
                                        .frame(width: 24, height: 24)
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(AppConstants.Colors.lightTeal)
                                }
                                
                                Text(checkpoint)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(AppConstants.Spacing.md)
                    .background(AppConstants.Colors.lightTeal.opacity(0.08))
                    .cornerRadius(12)
                }
            }
        }
        .padding(AppConstants.Spacing.lg)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }
    
    // MARK: - Circuit Diagram Section
    private var circuitDiagramSection: some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
            HStack {
                Image(systemName: "cpu")
                    .foregroundColor(AppConstants.Colors.primaryPurple)
                Text("Circuit Diagram")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
            }
            
            if !creation.resources.diagrams.isEmpty {
                ForEach(creation.resources.diagrams, id: \.self) { diagramUrl in
                    AsyncImage(url: URL(string: diagramUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.1), radius: 12)
                        case .failure:
                            VStack(spacing: 12) {
                                Image(systemName: "bolt.horizontal.circle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.secondary)
                                Text("Circuit diagram unavailable")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "bolt.horizontal.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No circuit diagram available")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }
            
            Text("💡 Tip: Take your time to match the connections exactly as shown in the diagram.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(AppConstants.Spacing.md)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding(AppConstants.Spacing.lg)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }
    
    // MARK: - Navigation Footer
    private var navigationFooter: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: AppConstants.Spacing.md) {
                // Previous Button
                Button(action: previousStep) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(currentStepIndex > 0 ? AppConstants.Colors.primaryPurple : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .disabled(currentStepIndex == 0)
                
                // Next/Finish Button
                Button(action: nextStep) {
                    HStack(spacing: 8) {
                        Text(currentStepIndex == creation.steps.count - 1 ? "Finish" : "Next")
                        Image(systemName: currentStepIndex == creation.steps.count - 1 ? "checkmark" : "chevron.right")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [AppConstants.Colors.primaryPurple, AppConstants.Colors.mediumTeal],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
            }
            .padding(AppConstants.Spacing.lg)
        }
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
    }
    
    // MARK: - Navigation Actions
    private func previousStep() {
        if currentStepIndex > 0 {
            withAnimation {
                currentStepIndex -= 1
            }
        }
    }
    
    private func nextStep() {
        // Mark current step as completed
        completedSteps.insert(currentStepIndex)
        
        if currentStepIndex < creation.steps.count - 1 {
            // Move to next step
            withAnimation {
                currentStepIndex += 1
            }
        } else {
            // Finished all steps - show quiz if available
            if !creation.quizQuestions.isEmpty {
                showQuiz = true
            } else {
                // No quiz - complete immediately
                completeCreation(quizScore: 0)
            }
        }
    }
    
    private func handleQuizCompletion(correctAnswers: Int) {
        let totalQuestions = creation.quizQuestions.count
        let quizBonus = correctAnswers == totalQuestions ? creation.bonusPoints : 0
        completeCreation(quizScore: quizBonus)
    }
    
    private func completeCreation(quizScore: Int) {
        earnedPoints = creation.basePoints + quizScore
        
        Task {
            do {
                // Update user progress
                if let userId = firebaseService.currentUser?.id {
                    try await firebaseService.completeCreation(
                        userId: userId,
                        creationId: creation.id ?? "",
                        pointsEarned: earnedPoints
                    )
                }
                
                // Show celebration
                await MainActor.run {
                    showCompletionCelebration = true
                }
            } catch {
                print("❌ Error completing creation: \(error)")
            }
        }
    }
}

// MARK: - Quiz View
struct QuizView: View {
    let questions: [QuizQuestion]
    let onComplete: (Int) -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var shuffledQuestions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int?] = []
    @State private var showExplanation = false
    @State private var correctCount = 0

    var currentQuestion: QuizQuestion {
        shuffledQuestions.isEmpty ? questions[currentQuestionIndex] : shuffledQuestions[currentQuestionIndex]
    }

    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress
                VStack(spacing: 12) {
                    HStack {
                        Text("Question \(currentQuestionIndex + 1) of \(shuffledQuestions.count)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(correctCount) correct")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppConstants.Colors.lightTeal)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppConstants.Colors.mediumTeal)
                                .frame(width: geometry.size.width * Double(currentQuestionIndex + 1) / Double(shuffledQuestions.count), height: 6)

                        }
                    }
                    .frame(height: 6)
                }
                .padding(AppConstants.Spacing.lg)
                .background(Color(.systemBackground))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.xl) {
                        // Question
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(AppConstants.Colors.mediumTeal.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                    
                                    Text("Q")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(AppConstants.Colors.mediumTeal)
                                }
                                
                                Text(currentQuestion.question)
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Options
                        VStack(spacing: 12) {
                            ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                                QuizOptionButton(
                                    text: option,
                                    optionLetter: String(UnicodeScalar(65 + index)!),
                                    isSelected: selectedAnswers[safe: currentQuestionIndex] == index,
                                    isCorrect: index == currentQuestion.correctAnswer,
                                    showResult: showExplanation
                                ) {
                                    selectAnswer(index)
                                }
                            }
                        }
                        
                        // Explanation
                        if showExplanation {
                            VStack(alignment: .leading, spacing: 12) {
                                Divider()
                                
                                HStack {
                                    Image(systemName: selectedAnswers[safe: currentQuestionIndex] == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(selectedAnswers[safe: currentQuestionIndex] == currentQuestion.correctAnswer ? AppConstants.Colors.lightTeal : .red)
                                    
                                    Text(selectedAnswers[safe: currentQuestionIndex] == currentQuestion.correctAnswer ? "Correct!" : "Not quite...")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(selectedAnswers[safe: currentQuestionIndex] == currentQuestion.correctAnswer ? AppConstants.Colors.lightTeal : .red)
                                }
                                
                                Text(currentQuestion.explanation)
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(AppConstants.Spacing.md)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                }
                .background(Color(.systemGroupedBackground))
                
                // Navigation
                VStack(spacing: 0) {
                    Divider()
                    
                    Button(action: nextQuestion) {
                        Text(currentQuestionIndex == shuffledQuestions.count - 1 ? "Finish Quiz" : "Next Question")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(showExplanation ? AppConstants.Colors.primaryPurple : Color.secondary)
                            .cornerRadius(16)
                    }
                    .disabled(!showExplanation)
                    .padding(AppConstants.Spacing.lg)
                }
                .background(Color(.systemBackground))
            }
            .navigationTitle("Knowledge Check")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            shuffledQuestions = questions.shuffled()
            selectedAnswers = Array(repeating: nil, count: shuffledQuestions.count)
        }
    }
    
    private func selectAnswer(_ index: Int) {
        guard !showExplanation else { return }
        
        withAnimation {
            selectedAnswers[currentQuestionIndex] = index
            showExplanation = true
            
            if index == currentQuestion.correctAnswer {
                correctCount += 1
            }
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < shuffledQuestions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
                showExplanation = false
            }
        } else {
            onComplete(correctCount)
            dismiss()
        }
    }
}

// MARK: - Completion Celebration View
struct CompletionCelebrationView: View {
    let creation: Creation
    let earnedPoints: Int
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            AppConstants.Colors.primaryPurple.opacity(0.95).ignoresSafeArea()
            
            VStack(spacing: AppConstants.Spacing.xl) {
                Spacer()
                
                // Celebration Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 12) {
                    Text("🎉 Amazing Work!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("You completed")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(creation.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Points Earned
                VStack(spacing: 8) {
                    Text("Points Earned")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 30))
                        Text("\(earnedPoints)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(AppConstants.Colors.lightTeal)
                }
                .padding(AppConstants.Spacing.xl)
                .background(Color.white.opacity(0.15))
                .cornerRadius(20)
                
                Spacer()
                
                Button(action: onDismiss) {
                    Text("Continue Learning")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppConstants.Colors.primaryPurple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, AppConstants.Spacing.xl)
            }
            .padding(.vertical, AppConstants.Spacing.xl)
        }
    }
}


// MARK: - Array Extension for Safe Access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
