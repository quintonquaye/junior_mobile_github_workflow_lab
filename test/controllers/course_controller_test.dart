import 'package:flutter_test/flutter_test.dart';
import 'package:junior_mobile_github_workflow_lab/controllers/course_controller.dart';
import 'package:junior_mobile_github_workflow_lab/data/course_api.dart';
import 'package:junior_mobile_github_workflow_lab/repositories/course_repository.dart';

void main() {
  group('CourseController starter behavior', () {
    test('loads courses and sets success status', () async {
      final controller = CourseController(CourseRepository(CourseApi()));

      await controller.loadCourses();

      expect(controller.status, CourseLoadStatus.success);
      expect(controller.courses, isNotEmpty);
      expect(controller.errorMessage, isNull);
    });

    test('records a fetch failure', () async {
      final api = CourseApi()..shouldFailNextFetch = true;
      final controller = CourseController(CourseRepository(api));

      await controller.loadCourses();

      expect(controller.status, CourseLoadStatus.failure);
      expect(controller.errorMessage, isNotNull);
    });
  });
}
