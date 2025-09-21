import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';
import '../models/module.dart';
import '../models/project.dart';
import '../models/glossary_item.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Module> _modules = [];
  List<Lesson> _lessons = [];
  List<Quiz> _quizzes = [];
  List<Project> _projects = [];
  List<GlossaryItem> _glossary = [];

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Future<void> loadData() async {
    if (_isLoaded) return;

    try {
      // Load modules
      final modulesJson = await rootBundle.loadString('assets/data/modules.json');
      final modulesList = json.decode(modulesJson) as List<dynamic>;
      _modules = modulesList.map((json) => Module.fromJson(json)).toList();

      // Load lessons
      final lessonsJson = await rootBundle.loadString('assets/data/lessons.json');
      final lessonsList = json.decode(lessonsJson) as List<dynamic>;
      _lessons = lessonsList.map((json) => Lesson.fromJson(json)).toList();

      // Load quizzes
      final quizzesJson = await rootBundle.loadString('assets/data/quizzes.json');
      final quizzesList = json.decode(quizzesJson) as List<dynamic>;
      _quizzes = quizzesList.map((json) => Quiz.fromJson(json)).toList();

      // Load projects
      final projectsJson = await rootBundle.loadString('assets/data/projects.json');
      final projectsList = json.decode(projectsJson) as List<dynamic>;
      _projects = projectsList.map((json) => Project.fromJson(json)).toList();

      // Load glossary
      final glossaryJson = await rootBundle.loadString('assets/data/glossary.json');
      final glossaryList = json.decode(glossaryJson) as List<dynamic>;
      _glossary = glossaryList.map((json) => GlossaryItem.fromJson(json)).toList();

      _isLoaded = true;
    } catch (e) {
      print('Error loading data: $e');
      throw Exception('Failed to load app data');
    }
  }

  // Module methods
  List<Module> getModules() => _modules;
  Module? getModuleById(String id) {
    try {
      return _modules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  // Lesson methods
  List<Lesson> getLessons() => _lessons;
  List<Lesson> getLessonsByModuleId(String moduleId) {
    return _lessons.where((lesson) => lesson.moduleId == moduleId).toList();
  }
  Lesson? getLessonById(String id) {
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  // Quiz methods
  List<Quiz> getQuizzes() => _quizzes;
  List<Quiz> getQuizzesByModuleId(String moduleId) {
    return _quizzes.where((quiz) => quiz.moduleId == moduleId).toList();
  }
  Quiz? getQuizById(String id) {
    try {
      return _quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (e) {
      return null;
    }
  }

  // Project methods
  List<Project> getProjects() => _projects;
  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  // Glossary methods
  List<GlossaryItem> getGlossary() => _glossary;
  List<GlossaryItem> searchGlossary(String query) {
    if (query.isEmpty) return _glossary;
    
    final lowercaseQuery = query.toLowerCase();
    return _glossary.where((item) =>
      item.term.toLowerCase().contains(lowercaseQuery) ||
      item.definition.toLowerCase().contains(lowercaseQuery) ||
      item.category.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  List<String> getGlossaryCategories() {
    return _glossary.map((item) => item.category).toSet().toList()..sort();
  }

  List<GlossaryItem> getGlossaryByCategory(String category) {
    return _glossary.where((item) => item.category == category).toList();
  }
}
