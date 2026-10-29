import 'package:flutter_test/flutter_test.dart';
import 'package:junior_mobile_github_workflow_lab/data/course_api.dart';
import 'package:junior_mobile_github_workflow_lab/models/course.dart';
import 'package:junior_mobile_github_workflow_lab/repositories/course_repository.dart';

void main() {
  group('CourseRepository starter behavior', () {
    test('returns published courses', () async {
      final repository = CourseRepository(CourseApi());

      final result = await repository.getPublishedCourses();

      expect(result, isNotEmpty);
      expect(result.every((course) => course.isPublished), isTrue);
    });

    test('trims course ID and title when creating a course', () async {
      final repository = CourseRepository(CourseApi());
      const course = Course(
        id: '  photo-303 ',
        title: '  Composition Basics  ',
        isPublished: true,
      );

      final created = await repository.createCourse(course);

      expect(created.id, 'photo-303');
      expect(created.title, 'Composition Basics');
    });

    test('rejects an empty ID', () async {
      final repository = CourseRepository(CourseApi());
      const course = Course(id: '', title: 'Composition', isPublished: true);

      expect(
        () => repository.createCourse(course),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('search is case-insensitive', () async {
      final repository = CourseRepository(CourseApi());

      final result = await repository.searchPublishedCourses('EXPOSURE');

      expect(result.map((course) => course.id), contains('photo-101'));
    });
  });
}
