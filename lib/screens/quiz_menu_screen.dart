import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../widgets/navigation_drawer.dart';
import 'comprehensive_quiz_screen.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Quiz Menu'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open Menu',
          ),
        ),
      ),
      drawer: const CustomNavigationDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColorLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.quiz,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dart Fundamentals Quiz',
                              style: GoogleFonts.roboto(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Test your knowledge with comprehensive questions',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quiz Categories
            Text(
              'Quiz Categories',
              style: AppTheme.heading2.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            
            // Comprehensive Quiz Card
            _buildQuizCard(
              context: context,
              title: 'Comprehensive Quiz',
              description: '30 questions covering all Dart fundamentals',
              icon: Icons.quiz,
              questionCount: 30,
              difficulty: 'All Levels',
              topics: [
                'Variables & Data Types',
                'Functions & Methods',
                'Classes & Objects',
                'Collections',
                'Async Programming',
                'Error Handling',
                'Null Safety',
                'Extensions & Mixins'
              ],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComprehensiveQuizScreen(),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Quick Quiz Card
            _buildQuizCard(
              context: context,
              title: 'Quick Quiz',
              description: '10 questions for a quick test',
              icon: Icons.flash_on,
              questionCount: 10,
              difficulty: 'Beginner',
              topics: [
                'Basic Syntax',
                'Variables',
                'Functions',
                'Control Flow'
              ],
              onTap: () {
                // Navigate to quick quiz
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quick Quiz coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Advanced Quiz Card
            _buildQuizCard(
              context: context,
              title: 'Advanced Quiz',
              description: 'Challenging questions for experts',
              icon: Icons.school,
              questionCount: 25,
              difficulty: 'Advanced',
              topics: [
                'Advanced OOP',
                'Async & Streams',
                'Generics',
                'Reflection',
                'Isolates'
              ],
              onTap: () {
                // Navigate to advanced quiz
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Advanced Quiz coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Features Section
            Text(
              'Quiz Features',
              style: AppTheme.heading2.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.timer,
              title: 'Timed Questions',
              description: 'Test your speed and accuracy',
            ),
            
            _buildFeatureCard(
              icon: Icons.analytics,
              title: 'Detailed Analytics',
              description: 'Track your progress and weak areas',
            ),
            
            _buildFeatureCard(
              icon: Icons.help_outline,
              title: 'Explanations',
              description: 'Learn from detailed explanations',
            ),
            
            _buildFeatureCard(
              icon: Icons.repeat,
              title: 'Retake Anytime',
              description: 'Practice until you master the concepts',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required int questionCount,
    required String difficulty,
    required List<String> topics,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.heading3.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$questionCount Q',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Difficulty and Topics
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getDifficultyColor(difficulty).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      difficulty,
                      style: AppTheme.bodySmall.copyWith(
                        color: _getDifficultyColor(difficulty),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Topics: ${topics.join(', ')}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Start Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryColorLight],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Start Quiz',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.heading3.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.successColor;
      case 'intermediate':
        return AppTheme.warningColor;
      case 'advanced':
        return AppTheme.errorColor;
      case 'all levels':
        return AppTheme.primaryColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
}
