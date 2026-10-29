import '../models/course.dart';
import '../repositories/course_repository.dart';

enum CourseLoadStatus { initial, loading, success, failure }

class CourseController {
  CourseController(this._repository);

  final CourseRepository _repository;

  CourseLoadStatus status = CourseLoadStatus.initial;
  List<Course> courses = const [];
  String? errorMessage;

  Future<void> loadCourses() async {
    status = CourseLoadStatus.loading;
    errorMessage = null;

    try {
      courses = await _repository.getPublishedCourses();
      status = CourseLoadStatus.success;
    } catch (error) {
      errorMessage = error.toString();
      status = CourseLoadStatus.failure;
    }
  }

  Future<List<Course>> search(String query) {
    return _repository.searchPublishedCourses(query);
  }

  Future<Course?> createCourse(Course course) async {
    // Intentional practice defect: optimistic state update is not rolled back
    // if the repository rejects the request. Ticket MDP-06 asks you to fix it.
    courses = [...courses, course];
    try {
      final created = await _repository.createCourse(course);
      courses = [
        ...courses.where((item) => item.id != course.id),
        created,
      ];
      errorMessage = null;
      return created;
    } catch (error) {
      errorMessage = error.toString();
      return null;
    }
  }
}
