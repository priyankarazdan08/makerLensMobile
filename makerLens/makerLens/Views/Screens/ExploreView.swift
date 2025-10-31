//
//  ExploreView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//
//
//  ExploreView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

//import SwiftUI
//
//struct ExploreView: View {
//    @EnvironmentObject var firebaseService: FirebaseService
//    @State private var featuredCreations: [Creation] = []
//    @State private var allLessons: [Creation] = []
//    @State private var isLoading = true
//    
//    var body: some View {
//        NavigationView {
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 0) {
//                    // Use consistent TopNavigationView (this handles search now)
//                    TopNavigationView(title: "Explore", showSearch: true, showProfile: true)
//                    
//                    if isLoading {
//                        // Loading state
//                        ProgressView("Loading creations...")
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .padding(.top, 100)
//                    } else {
//                        // Hero Section - "Let's Learn More!"
//                        HeroCard(
//                            title: "Let's Learn",
//                            subtitle: "More!",
//                            description: "Discover new Arduino projects"
//                        ) {
//                            // TODO: Navigate to getting started
//                        }
//                        .padding(.horizontal, AppConstants.Spacing.lg)
//                        .padding(.top, AppConstants.Spacing.lg)
//                        
//                        // Featured Projects Section
//                        if !featuredCreations.isEmpty {
//                            VStack(spacing: AppConstants.Spacing.lg) {
//                                SectionHeader(
//                                    title: "Featured Projects",
//                                    actionTitle: "See All"
//                                ) {
//                                    // TODO: Navigate to all projects
//                                }
//                                
//                                ScrollView(.horizontal, showsIndicators: false) {
//                                    HStack(spacing: AppConstants.Spacing.lg) {
//                                        ForEach(featuredCreations) { creation in
//                                            NavigationLink(destination: CreationDetailView(creation: creation)) {
//                                                ProjectCard(creation: creation)
//                                            }
//                                            .buttonStyle(PlainButtonStyle())
//                                        }
//                                    }
//                                    .padding(.horizontal, AppConstants.Spacing.lg)
//                                }
//                            }
//                            .padding(.top, AppConstants.Spacing.xl)
//                        }
//                        
//                        // Categories Section
//                        VStack(spacing: AppConstants.Spacing.lg) {
//                            SectionHeader(title: "Categories")
//                            
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: AppConstants.Spacing.md) {
//                                    ForEach(ComponentCategory.allCases, id: \.self) { category in
//                                        CategoryCard(category: category) as CategoryCard
//                                    }
//                                }
//                                .padding(.horizontal, AppConstants.Spacing.lg)
//                            }
//                        }
//                        .padding(.top, AppConstants.Spacing.xl)
//                        
//                        AllLessonsSection(lessons: allLessons)
//                        
//                        Spacer(minLength: AppConstants.Spacing.xxl)
//                    }
//                }
//            }
//            .background(Color(.systemGroupedBackground))
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .task {
//            await loadData()
//        }
//    }
//    
//    private func loadData() async {
//        do {
//            // Load all creations from Firebase
//            try await firebaseService.loadCreations()
//            
//            // Get creations from FirebaseService
//            allLessons = firebaseService.creations
//            
//            // Featured creations are the first 5 or filter by some criteria
//            featuredCreations = Array(firebaseService.creations.prefix(5))
//            
//            print("✅ Loaded \(allLessons.count) creations in ExploreView")
//            
//            isLoading = false
//        } catch {
//            print("❌ Error loading creations: \(error.localizedDescription)")
//            isLoading = false
//        }
//    }
//}
//
//struct AllLessonsSection: View {
//    let lessons: [Creation]
//    @State private var selectedDifficulty = "All"
//    
//    var filteredLessons: [Creation] {
//        if selectedDifficulty == "All" {
//            return lessons
//        }
//        return lessons.filter { $0.difficulty.rawValue == selectedDifficulty }
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            // Header
//            HStack {
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("All Lessons")
//                        .font(.system(size: 20, weight: .bold, design: .rounded))
//                        .foregroundColor(.primary)
//                    
//                    Text("\(filteredLessons.count) lessons available")
//                        .font(.system(size: 15, weight: .medium))
//                        .foregroundColor(.secondary)
//                }
//                
//                Spacer()
//            }
//            .padding(.horizontal, AppConstants.Spacing.xl)
//            .padding(.top, AppConstants.Spacing.xl)
//            .padding(.bottom, AppConstants.Spacing.lg)
//            
//            // Difficulty filter chips
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 10) {
//                    ForEach(["All", "Easy", "Intermediate", "Advanced", "Super Hard"], id: \.self) { difficulty in
//                        DifficultyChip(
//                            title: difficulty,
//                            isSelected: selectedDifficulty == difficulty
//                        ) {
//                            withAnimation(.spring(response: 0.3)) {
//                                selectedDifficulty = difficulty
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal, AppConstants.Spacing.xl)
//            }
//            .padding(.bottom, AppConstants.Spacing.md)
//            
//            // Lessons list with spacers
//            if filteredLessons.isEmpty {
//                VStack(spacing: 12) {
//                    Image(systemName: "tray")
//                        .font(.system(size: 48))
//                        .foregroundColor(.secondary.opacity(0.5))
//                    
//                    Text("No lessons found")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.secondary)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 60)
//            } else {
//                LazyVStack(spacing: 0) {
//                    ForEach(Array(filteredLessons.enumerated()), id: \.element.id) { index, lesson in
//                        NavigationLink(destination: CreationDetailView(creation: lesson)) {
//                            LessonRow(lesson: lesson)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        
//                        // Add spacer between items (but not after last item)
//                        if index < filteredLessons.count - 1 {
//                            Rectangle()
//                                .fill(Color(.systemGray5))
//                                .frame(height: 1)
//                                .padding(.horizontal, AppConstants.Spacing.xl)
//                        }
//                    }
//                }
//                .padding(.bottom, AppConstants.Spacing.xl)
//            }
//        }
//        .background(Color(.systemBackground))
//        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
//    }
//}
//
//struct LessonRow: View {
//    let lesson: Creation
//    
//    var body: some View {
//        HStack(spacing: 16) {
//            // Lesson thumbnail
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color(.systemGray6))
//                    .frame(width: 66, height: 66)
//                
//                if lesson.hasVideo {
//                    Image(systemName: "play.rectangle.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(AppConstants.Colors.mediumTeal)
//                } else {
//                    Image(systemName: "doc.text.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(AppConstants.Colors.primaryPurple)
//                }
//                
//                if lesson.isCompleted {
//                    VStack {
//                        HStack {
//                            Spacer()
//                            ZStack {
//                                Circle()
//                                    .fill(AppConstants.Colors.lightTeal)
//                                    .frame(width: 20, height: 20)
//                                
//                                Image(systemName: "checkmark")
//                                    .font(.system(size: 10, weight: .bold))
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        Spacer()
//                    }
//                    .frame(width: 66, height: 66)
//                }
//            }
//            
//            // Lesson Info
//            VStack(alignment: .leading, spacing: 6) {
//                Text(lesson.title)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.primary)
//                    .lineLimit(2)
//                
//                HStack(spacing: 12) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "clock")
//                            .font(.system(size: 12))
//                        Text(lesson.estimatedDuration)
//                            .font(.system(size: 13))
//                    }
//                    
//                    Text("•")
//                        .foregroundColor(.secondary)
//                    
//                    Text(lesson.difficulty.rawValue)
//                        .font(.system(size: 13, weight: .medium))
//                        .foregroundColor(difficultyColor(lesson.difficulty))
//                }
//                .foregroundColor(.secondary)
//            }
//            
//            Spacer()
//            
//            // Arrow
//            Image(systemName: "chevron.right")
//                .font(.system(size: 14, weight: .semibold))
//                .foregroundColor(.secondary)
//        }
//        .padding(.horizontal, AppConstants.Spacing.xl)
//        .padding(.vertical, AppConstants.Spacing.md)
//    }
//    
//    private func difficultyColor(_ difficulty: Difficulty) -> Color {
//        switch difficulty {
//        case .easy: return .green
//        case .intermediate: return .orange
//        case .advanced: return .red
//        case .superHard: return .purple
//        }
//    }
//}
//
//struct DifficultyChip: View {
//    let title: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(.system(size: 13, weight: .semibold))
//                .foregroundColor(isSelected ? .white : .primary)
//                .padding(.horizontal, 14)
//                .padding(.vertical, 8)
//                .background(
//                    isSelected ?
//                    AppConstants.Colors.primaryPurple :
//                    Color(.systemGray6)
//                )
//                .cornerRadius(16)
//        }
//    }
//}
