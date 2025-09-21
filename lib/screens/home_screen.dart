import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/module.dart';
import '../services/data_service.dart';
import '../utils/app_theme.dart';
import '../widgets/module_card.dart';
import '../widgets/navigation_drawer.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';
import 'quiz_menu_screen.dart';
import 'project_screen.dart';
import 'glossary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  List<Module> _modules = [];

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  void _loadModules() {
    _modules = _dataService.getModules();
    setState(() {});
  }

  void _navigateToModule(Module module) {
    if (module.lessons.isNotEmpty) {
      // Navigate to first lesson
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonScreen(
            moduleId: module.id,
            lessonId: module.lessons.first,
          ),
        ),
      );
    } else if (module.quizzes.isNotEmpty) {
      // Navigate to first quiz
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            quizId: module.quizzes.first,
          ),
        ),
      );
    }
  }

  void _navigateToProjects() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProjectScreen()),
    );
  }

  void _navigateToGlossary() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GlossaryScreen()),
    );
  }

  void _navigateToQuizMenu() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const QuizMenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Learn Dart'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open Menu',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz),
            onPressed: _navigateToQuizMenu,
            tooltip: 'Take Quiz',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToGlossary,
            tooltip: 'Search Glossary',
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColorLight,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Learn Dart!',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Master Dart programming with our comprehensive offline course',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // Modules Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modules',
                    style: AppTheme.heading2.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  ..._modules.map((module) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ModuleCard(
                      module: module,
                      onTap: () => _navigateToModule(module),
                    ),
                  )),
                  
                  // Projects Card
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.build,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        'Final Projects',
                        style: AppTheme.heading3.copyWith(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Apply your Dart knowledge with practical projects',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _navigateToProjects,
                    ),
                  ),
                  
                  // Glossary Card
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.book,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        'Glossary',
                        style: AppTheme.heading3.copyWith(fontSize: 16),
                      ),
                      subtitle: Text(
                        'Search Dart terms and definitions',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _navigateToGlossary,
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
}
