class Module {
  final String id;
  final String title;
  final String description;
  final String level;
  final List<String> lessons;
  final List<String> quizzes;
  final String color;
  final String icon;
  final String estimatedTime;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.lessons,
    required this.quizzes,
    required this.color,
    required this.icon,
    required this.estimatedTime,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      level: json['level'] ?? 'Beginner',
      lessons: List<String>.from(json['lessons'] ?? []),
      quizzes: List<String>.from(json['quizzes'] ?? []),
      color: json['color'] ?? '#6A1B9A',
      icon: json['icon'] ?? 'code',
      estimatedTime: json['estimatedTime'] ?? '2-3 hours',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level': level,
      'lessons': lessons,
      'quizzes': quizzes,
      'color': color,
      'estimatedTime': estimatedTime,
    };
  }
}
