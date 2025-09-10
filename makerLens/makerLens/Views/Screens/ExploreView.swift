//
//  ExploreView.swift
//  makerLens
//
//  Created by Priyanka Razdan on 8/30/25.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var firebaseService: FirebaseService
    @State private var featuredCreations = SampleData.sampleCreations
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Use consistent TopNavigationView (this handles search now)
                    TopNavigationView(title: "Explore", showSearch: true, showProfile: true)
                    
                    // Hero Section - "Let's Learn More!"
                    HeroCard(
                        title: "Let's Learn",
                        subtitle: "More!",
                        description: "Discover new Arduino projects"
                    ) {
                        // TODO: Navigate to getting started
                    }
                    .padding(.horizontal, AppConstants.Spacing.lg)
                    .padding(.top, AppConstants.Spacing.lg)
                    
                    // Featured Projects Section
                    VStack(spacing: AppConstants.Spacing.lg) {
                        SectionHeader(
                            title: "Featured Projects",
                            actionTitle: "See All"
                        ) {
                            // TODO: Navigate to all projects
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppConstants.Spacing.lg) {
                                ForEach(featuredCreations) { creation in
                                    ProjectCard(creation: creation)
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.lg)
                        }
                    }
                    .padding(.top, AppConstants.Spacing.xl)
                    
                    // Categories Section
                    VStack(spacing: AppConstants.Spacing.lg) {
                        SectionHeader(title: "Categories")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppConstants.Spacing.md) {
                                ForEach(ComponentCategory.allCases, id: \.self) { category in
                                    CategoryCard(category: category) as CategoryCard
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.lg)
                        }
                    }
                    .padding(.top, AppConstants.Spacing.xl)
                    
                    // Popular Courses Section
                    VStack(spacing: AppConstants.Spacing.lg) {
                        SectionHeader(
                            title: "Popular Courses",
                            actionTitle: "View All"
                        ) {
                            // TODO: Navigate to all courses
                        }
                        
                        VStack(spacing: AppConstants.Spacing.md) {
                            CourseProgressCard(
                                title: "Arduino Fundamentals",
                                description: "Learn the basics of Arduino programming",
                                progress: 0.75,
                                iconName: "cpu",
                                color: AppConstants.Colors.primaryPurple
                            )
                            
                            CourseProgressCard(
                                title: "Sensor Integration",
                                description: "Master working with various sensors",
                                progress: 0.45,
                                iconName: "sensor.tag.radiowaves.forward",
                                color: AppConstants.Colors.mediumTeal
                            )
                            
                            CourseProgressCard(
                                title: "IoT Projects",
                                description: "Build connected Arduino projects",
                                progress: 0.20,
                                iconName: "wifi",
                                color: AppConstants.Colors.lightTeal
                            )
                        }
                        .padding(.horizontal, AppConstants.Spacing.lg)
                    }
                    .padding(.top, AppConstants.Spacing.xl)
                    
                    Spacer(minLength: AppConstants.Spacing.xxl)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
