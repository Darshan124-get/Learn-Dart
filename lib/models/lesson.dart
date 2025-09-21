class Lesson {
  final String id;
  final String moduleId;
  final String title;
  final String content;
  final String definition;
  final String explanation;
  final String syntax;
  final String example;
  final List<String> keyPoints;

  Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.content,
    required this.definition,
    required this.explanation,
    required this.syntax,
    required this.example,
    required this.keyPoints,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      moduleId: json['moduleId'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      definition: json['definition'] ?? '',
      explanation: json['explanation'] ?? '',
      syntax: json['syntax'] ?? '',
      example: json['example'] ?? '',
      keyPoints: List<String>.from(json['keyPoints'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleId': moduleId,
      'title': title,
      'content': content,
      'definition': definition,
      'explanation': explanation,
      'syntax': syntax,
      'example': example,
      'keyPoints': keyPoints,
    };
  }
}
