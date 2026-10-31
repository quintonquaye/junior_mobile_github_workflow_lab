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

    //Duplicate sensitivity case
    test('search is case-insensitive', () async {
      final repository = CourseRepository(CourseApi());

      final result = await repository.searchPublishedCourses('EXPOSURE');

      expect(result.map((course) => course.id), contains('photo-101'));
    });

    test("Spaces-only ID is rejected with ArgumentError", () async {
      ///Arrange
      final repository = CourseRepository(CourseApi());

      ///Act
      const course = Course(id: '  ', title: 'Composition', isPublished: true);

      ///Assert - in this modified `createCourse()` my assumption is that the validation will throw an ArgumentError,
      ///pasing the test
      await expectLater(repository.createCourse(course), throwsArgumentError);
    });

    test("Tabs-only ID is reject with ArgumentError", () async {
      ///Arrange
      final repository = CourseRepository(CourseApi());

      ///Act
      const course =
          Course(id: '\t\t', title: 'Composition', isPublished: true);

      ///Assert - in this modified `createCourse()` my assumption is that the validation will throw an ArgumentError,
      ///pasing the test
      await expectLater(repository.createCourse(course), throwsArgumentError);
    });

    test("New-Line-Only input is rejected with ArgumentError", () async {
      ///Arrange
      final repository = CourseRepository(CourseApi());

      ///Act
      const course =
          Course(id: '\n\n', title: 'Composition', isPublished: true);

      ///Assert - in this modified `createCourse()` my assumption is that the validation will throw an ArgumentError,
      ///pasing the test
      await expectLater(repository.createCourse(course), throwsArgumentError);
    });

    test("Existing valid input", () async {
      ///Arrange:
      final repository = CourseRepository(CourseApi());

      ///Act:
      const course =
          Course(id: 'PHO_101', title: 'Composition', isPublished: true);

      ///call `createCourse()`
      final result = await repository.createCourse(course);

      ///Assert: my assumption is the in this current `createCourse()` the test will pass.
      ///Returning value is a normalized course.
      //expect(result, equals(course));

      ///finding: this result failed because the testing expectation is 'eventhough the properties are identical,
      ///they occupy separate object identities

      ///checking identites
      //expect(identical(result, course), isTrue);
      ///finding: this test also fails that they are not identical

      ///testing each property individually to find differences
      expect(result.id, equals("PHO_101"));
      expect(result.title, equals("Composition"));
      expect(result.isPublished, isTrue);
      expect(result.description, isEmpty);
      //results: each returned property is of the same value, but when compared in identical,
      //result in a failure
    });
  });
}
