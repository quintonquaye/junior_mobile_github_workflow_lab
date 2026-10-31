class Course {
  const Course({
    required this.id,
    required this.title,
    required this.isPublished,
    this.description = '',
  });

  final String id;
  final String title;
  final bool isPublished;
  final String description;

  Course copyWith({
    String? id,
    String? title,
    bool? isPublished,
    String? description,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      isPublished: isPublished ?? this.isPublished,
      description: description ?? this.description,
    );
  }
}
