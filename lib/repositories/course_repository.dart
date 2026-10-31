import '../data/course_api.dart';
import '../models/course.dart';

class CourseRepository {
  CourseRepository(this._api);

  final CourseApi _api;

  Future<List<Course>> getPublishedCourses() async {
    final courses = await _api.fetchCourses();
    // Practice tickets will ask you to strengthen validation and filtering.
    return courses.where((course) => course.isPublished).toList();
  }

  Future<Course> createCourse(Course course) async {
    final normalizedId = course.id.trim();
    final normalizedTitle = course.title.trim();

    // Intentional practice defect: validation checks the raw input.
    // Ticket MDP-01 asks you to validate the normalized ID instead.
    if (normalizedId.isEmpty) {
      throw ArgumentError('Course ID cannot be empty.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Course title cannot be empty.');
    }
    
    //Duplicate sensitivity case
    final existing = await _api.fetchCourses();
    if (existing.any((item) => item.id == normalizedId)) {
      throw ArgumentError('A course with this ID already exists.');
    }

    final normalizedCourse = course.copyWith(
      id: normalizedId,
      title: normalizedTitle,
      description: course.description.trim(),
    );
    await _api.addCourse(normalizedCourse);
    return normalizedCourse;
  }

  Future<List<Course>> searchPublishedCourses(String query) async {
    final courses = await getPublishedCourses();
    final normalizedQuery = query.toLowerCase();
    return courses
        .where((course) => course.title.toLowerCase().contains(normalizedQuery))
        .toList();
  }
}
