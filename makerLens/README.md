# makerLens

An interactive iOS app for learning Arduino and electronics through hands-on projects, tutorials, and circuit scanning.

## Project Goal

makerLens transforms electronics education by providing an engaging, gamified learning platform where users can:

- **Learn Arduino programming** through interactive tutorials and step-by-step guides
- **Scan and analyze circuits** using AI-powered camera recognition
- **Build real projects** with guided instructions and component lists  
- **Track progress** with achievements, streaks, and skill progression
- **Explore electronics concepts** through visual, hands-on learning
- **Join a community** of makers and learners

The app bridges the gap between theoretical electronics knowledge and practical implementation, making hardware learning accessible and fun for beginners while providing advanced resources for experienced makers.

## Project Structure

```
makerLens/
├── makerLens.xcodeproj/          # Xcode project configuration
├── makerLens/                    # Main application source
│   ├── makerLensApp.swift        # App entry point with Firebase setup
│   ├── ContentView.swift         # Root view container
│   ├── GoogleService-Info.plist  # Firebase configuration
│   │
│   ├── Models/                   # Data models and business logic
│   │   ├── Component.swift       # Electronic components
│   │   ├── Creation.swift        # User projects/creations
│   │   ├── Module.swift          # Learning modules
│   │   ├── Step.swift            # Tutorial steps
│   │   ├── User.swift            # User profiles
│   │   └── UserProgress.swift    # Progress tracking
│   │
│   ├── Services/                 # App configuration
│   │   └── AppConstants.swift    # Colors, spacing, constants
│   │
│   ├── Utils/                    # Utilities and services
│   │   ├── FirebaseService.swift # Firebase integration
│   │   ├── SampleData.swift      # Development mock data
│   │   ├── SearchService.swift   # Search functionality
│   │   └── SearchViewModel.swift # Search state management
│   │
│   ├── Views/                    # UI components and screens
│   │   ├── Camera/
│   │   │   └── CameraView.swift  # Circuit scanning interface
│   │   │
│   │   ├── Cards/                # Reusable card components
│   │   │   ├── CategoryCard.swift
│   │   │   ├── CourseProgressCard.swift
│   │   │   ├── DailyGoalCard.swift
│   │   │   ├── HeroCard.swift
│   │   │   ├── ModuleCard.swift
│   │   │   ├── ModuleProgressView.swift
│   │   │   ├── ProjectCard.swift
│   │   │   └── UpNextCard.swift
│   │   │
│   │   ├── Navigation/           # App navigation
│   │   │   ├── MainTabView.swift # Main tab bar controller
│   │   │   └── TopNavigationView.swift
│   │   │
│   │   ├── Screens/              # Main application screens
│   │   │   ├── BuildView.swift   # Project creation interface
│   │   │   ├── ExploreView.swift # Content discovery
│   │   │   ├── HomeView.swift    # Dashboard and overview
│   │   │   ├── LeaderboardView.swift # Community rankings
│   │   │   ├── ProjectsView.swift # User project gallery
│   │   │   └── TutorialsView.swift # Learning content
│   │   │
│   │   ├── Search/               # Search functionality
│   │   │   ├── SearchFilterView.swift
│   │   │   ├── SearchResultsContentView.swift
│   │   │   └── SearchView.swift
│   │   │
│   │   └── Shared/               # Reusable UI components
│   │       ├── PressEventModifier.swift # Touch interactions
│   │       ├── ProgressDots.swift # Progress indicators
│   │       ├── SectionHeader.swift # Section headers
│   │       └── UserAvatar.swift  # User profile images
│   │
│   └── Assets.xcassets/          # App icons, colors, images
│       ├── AccentColor.colorset/
│       └── AppIcon.appiconset/
└── README.md                     # This file
```

## Technologies Used

### Core Technologies
- **Swift** - Primary programming language
- **SwiftUI** - Modern declarative UI framework
- **Xcode** - Integrated development environment

### Backend & Database
- **Firebase** - Complete backend-as-a-service solution
  - **FirebaseCore** - Core Firebase SDK
  - **FirebaseFirestore** - NoSQL cloud database
  - **FirebaseAuth** - User authentication
  - **FirebaseStorage** - Cloud file storage
  - **FirebaseDatabase** - Real-time database
  - **FirebaseAI** - AI/ML capabilities for circuit recognition

### iOS Features
- **Camera** - Circuit scanning and image capture
- **Core Graphics** - Custom animations and progress indicators
- **Foundation** - Core iOS framework functionality

### Architecture
- **MVVM Pattern** - Model-View-ViewModel architecture
- **ObservableObject** - Reactive state management
- **EnvironmentObject** - Dependency injection

## Key Features

- **Circuit Scanning** - AI-powered circuit recognition and analysis
- **Interactive Tutorials** - Step-by-step Arduino learning modules
- **Project Builder** - Guided project creation with component lists
- **Progress Tracking** - Achievements, streaks, and skill progression
- **Smart Search** - Find projects, components, and tutorials easily
- **Community Features** - Leaderboards and shared projects
- **Gamification** - Points, daily goals, and achievement system

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd makerLens
   ```

2. **Open in Xcode**
   ```bash
   open makerLens.xcodeproj
   ```

3. **Configure Firebase**
   - Ensure `GoogleService-Info.plist` is properly configured
   - Set up Firebase project with Firestore, Auth, and Storage

4. **Build and Run**
   - Select your target device or simulator
   - Build and run the project (⌘+R)

## App Navigation

The app features a tab-based navigation with five main sections:

- **Home** - Dashboard with progress, daily goals, and quick actions
- **Explore** - Discover new projects and learning content  
- **Build** - Create and manage your electronics projects
- **Projects** - View your completed and in-progress projects
- **Tutorials** - Access structured learning modules and guides

## Design Principles

- **Clean, Modern UI** - Following iOS design guidelines
- **Accessibility First** - VoiceOver support and inclusive design
- **Responsive Design** - Optimized for all iOS device sizes
- **Intuitive Navigation** - Clear user flow and information hierarchy
- **Engaging Interactions** - Smooth animations and tactile feedback

## Future Roadmap

- AR circuit visualization
- Real-time collaboration on projects
- Advanced AI circuit analysis
- Integration with popular Arduino IDEs
- Community marketplace for project sharing
- Offline learning capabilities

---

*Built with love for the maker community*