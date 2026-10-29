import '../models/course.dart';

/// In-memory API substitute. No network or Firebase account is required.
class CourseApi {
  CourseApi({List<Course>? initialCourses})
      : _courses = List<Course>.of(initialCourses ?? _defaultCourses);

  static final List<Course> _defaultCourses = [
    const Course(
      id: 'photo-101',
      title: 'Understanding Exposure',
      isPublished: true,
      description: 'Learn aperture, shutter speed, and ISO.',
    ),
    const Course(
      id: 'photo-102',
      title: 'Close-Up Photography',
      isPublished: true,
      description: 'Find, isolate, focus, and create.',
    ),
    const Course(
      id: 'draft-201',
      title: 'Advanced Studio Lighting',
      isPublished: false,
      description: 'A draft course used for practice.',
    ),
  ];

  final List<Course> _courses;
  bool shouldFailNextFetch = false;

  Future<List<Course>> fetchCourses() async {
    if (shouldFailNextFetch) {
      shouldFailNextFetch = false;
      throw Exception('Simulated course API failure');
    }
    return List<Course>.unmodifiable(_courses);
  }

  Future<void> addCourse(Course course) async {
    _courses.add(course);
  }

  Future<void> replaceCourses(List<Course> courses) async {
    _courses
      ..clear()
      ..addAll(courses);
  }
}
