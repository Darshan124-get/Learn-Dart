# Learn Dart - Offline

A comprehensive Flutter mobile application for learning Dart programming language offline. The app provides structured lessons, interactive quizzes, practical projects, and a searchable glossary - all designed to help beginners master Dart programming.

## Features

### 🎯 Core Learning Features
- **Structured Modules**: 10 comprehensive modules covering Dart from basics to advanced concepts
- **Interactive Lessons**: Detailed lessons with definitions, explanations, syntax, and code examples
- **Quiz System**: Multiple-choice quizzes with instant feedback and explanations
- **Final Projects**: Practical projects to apply learned concepts
- **Searchable Glossary**: Comprehensive dictionary of Dart terms and concepts

### 📱 App Features
- **Offline Learning**: All content stored locally in JSON assets
- **Internet Required**: App requires internet connection for AdMob integration
- **Modern UI**: Clean, minimal design with purple theme (#6A1B9A)
- **Responsive Design**: Optimized for mobile devices
- **AdMob Integration**: Banner ads for monetization

### 🎨 UI Design
- **Primary Color**: Purple (#6A1B9A)
- **Typography**: Google Fonts Roboto
- **Cards**: Light grey background with rounded corners
- **Buttons**: Rounded corners with purple fill and white text
- **Clean Layout**: Minimal and user-friendly interface

## Course Structure

### Module 1: Introduction to Dart
- What is Dart?
- Hello World Program
- Quiz: Introduction to Dart

### Module 2: Dart Basics
- Variables and Data Types
- Operators
- Comments
- Quiz: Dart Basics

### Module 3: Control Flow
- Conditional Statements
- Loops
- Quiz: Control Flow

### Module 4: Functions
- Defining Functions
- Parameters
- Quiz: Functions

### Module 5: Collections
- Lists (Arrays)
- Sets
- Maps (Key-Value pairs)
- Quiz: Collections

### Module 6: Object-Oriented Programming
- Classes and Objects
- Constructors
- Inheritance
- Polymorphism & Abstract Classes
- Interfaces & Mixins
- Quiz: OOP

### Module 7: Error Handling
- Exceptions
- try-catch-finally
- Quiz: Error Handling

### Module 8: Null Safety
- Nullable and non-nullable types
- Null operators (?, !, ??)
- Quiz: Null Safety

### Module 9: Async Programming
- Future
- async & await
- Quiz: Async Programming

### Module 10: Mini Projects
- Simple Calculator
- Student Grade Calculator
- To-Do List Manager
- Number Guessing Game
- Bank Account Manager
- Text Analyzer
- Final Comprehensive Quiz

## Technical Implementation

### Architecture
- **Models**: Data models for lessons, quizzes, modules, projects, and glossary
- **Services**: Data service for JSON loading, connectivity service for internet checks, AdMob service for ads
- **Screens**: Individual screens for each feature
- **Widgets**: Reusable UI components
- **Utils**: App theme and constants

### Dependencies
- `google_fonts`: Typography
- `connectivity_plus`: Internet connectivity checking
- `google_mobile_ads`: AdMob integration
- `provider`: State management
- `shared_preferences`: Local storage
- `json_annotation`: JSON handling

### Data Storage
All content is stored in JSON files in the `assets/data/` directory:
- `lessons.json`: Lesson content with definitions, explanations, syntax, and examples
- `quizzes.json`: Quiz questions with multiple choice options and explanations
- `modules.json`: Course module structure and metadata
- `projects.json`: Final project ideas with code examples and steps
- `glossary.json`: Searchable dictionary of Dart terms

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio or VS Code
- Android device or emulator

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### AdMob Setup
1. Create an AdMob account
2. Create a new app in AdMob console
3. Generate Ad Unit IDs
4. Replace test Ad Unit IDs in `lib/services/admob_service.dart`:
   ```dart
   // Replace with your actual Ad Unit ID
   static const String _bannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   ```
5. Update Android manifest with your App ID

## App Flow

1. **Splash Screen**: App initialization and internet connectivity check
2. **Internet Required Screen**: Shown if no internet connection
3. **Home Screen**: Module selection and navigation
4. **Lesson Screen**: Interactive lesson content with code examples
5. **Quiz Screen**: Multiple-choice questions with instant feedback
6. **Project Screen**: Final project ideas and code examples
7. **Glossary Screen**: Searchable dictionary of Dart terms

## Customization

### Adding New Content
1. Update JSON files in `assets/data/`
2. Follow existing data structure
3. Rebuild the app

### Theming
- Modify `lib/utils/app_theme.dart` for color and styling changes
- Update primary color, typography, and component styles

### AdMob Configuration
- Update Ad Unit IDs in `lib/services/admob_service.dart`
- Configure ad placement and frequency as needed

## Screenshots

The app features a modern, clean interface with:
- Purple-themed design matching the reference images
- Card-based layout for modules and content
- Interactive quiz system with instant feedback
- Code examples with syntax highlighting
- Searchable glossary with category filtering
- Banner ads integrated at the bottom of screens

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for typography
- AdMob for monetization support
- Dart community for inspiration and resources

---

**Learn Dart - Offline** - Master Dart programming with our comprehensive offline course!