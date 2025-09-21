class Project {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String estimatedTime;
  final List<String> features;
  final List<String> learningOutcomes;
  final String codeExample;
  final List<String> steps;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedTime,
    required this.features,
    required this.learningOutcomes,
    required this.codeExample,
    required this.steps,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'Beginner',
      estimatedTime: json['estimatedTime'] ?? '2-3 hours',
      features: List<String>.from(json['features'] ?? []),
      learningOutcomes: List<String>.from(json['learningOutcomes'] ?? []),
      codeExample: json['codeExample'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'features': features,
      'learningOutcomes': learningOutcomes,
      'codeExample': codeExample,
      'steps': steps,
    };
  }
}
