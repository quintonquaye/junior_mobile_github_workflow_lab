import 'package:flutter_test/flutter_test.dart';
import 'package:junior_mobile_github_workflow_lab/data/course_api.dart';
import 'package:junior_mobile_github_workflow_lab/models/course.dart';
import 'package:junior_mobile_github_workflow_lab/repositories/course_repository.dart';

void main() {
  group("Reject whitespace-only course IDs", () {
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
  });

  group("Prevent duplicate ID's when case differs", () {
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

  group("02-Prevent duplicate IDs when case differs", () {
    test("Happy path: adding valid course still works", () async {
      ///Arange: setup a photography cours(photo-101), seed it into the courseAPI
      final photo101 = Course(
          id: "photo-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final photo102 = Course(
          id: "photo-102",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final courseApi = CourseApi(initialCourses: [photo101]);
      final courseRepository = CourseRepository(courseApi);

      //get course data
      final seedData = await courseRepository.getPublishedCourses();

      //My assumption is that the seeded data should come back as only 1
      expect(seedData.length, equals(1));

      ///Act: attempt to add PHOTO-101
      await courseRepository.createCourse(photo102);

      final newSeedData = await courseRepository.getPublishedCourses();

      // assmption is that new course has been created and added to the course list(2)
      expect(newSeedData.length, equals(2));
    });
    test("test expected duplicate behavior with same case", () async {
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      final photo101 = Course(
          id: "photo-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final courseApi = CourseApi(initialCourses: [photo101]);
      final courseRepository = CourseRepository(courseApi);

      //Act: create PHOTO-101 course
      final future = courseRepository.createCourse(photo101);

      //My assumption is that the course creation will fail, becuase the course.id will appear the same
      await expectLater(future, throwsA(isArgumentError));
    });

    test("Duplicate detection ignores case", () async {
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      final photo101 = Course(
          id: "photo-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final PHOTO101 = Course(
          id: "PHOTO-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final courseApi = CourseApi(initialCourses: [photo101]);
      final courseRepository = CourseRepository(courseApi);

      ///Act: create PHOTO-101 course
      final future = courseRepository.createCourse(PHOTO101);

      ///Assumption: My assumption is that the course creation will fail, becuase the course.id will appear the same
      ///after validation with case-insensitivity
      await expectLater(future, throwsA(isArgumentError));
    });

    test("Duplicate detection trims IDs before comparing", () async {
      ///Arange: setup a photography cours(photo-101), seed it into the courseAPI
      final photo101 = Course(
          id: "photo-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final PHOTO101 = Course(
          id: " PHOTO-101 ",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final photo102 = Course(
          id: " photo-102 ",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final courseApi = CourseApi(initialCourses: [photo101]);
      final courseRepository = CourseRepository(courseApi);

      ///Act: attempt to add PHOTO-101, this should fail with a throw is ArgumentError
      final future = courseRepository.createCourse(PHOTO101);
      await expectLater(future, throwsA(isArgumentError));

      ///Act: attempt to add photo-102
      await courseRepository.createCourse(photo102);
      final newSeedData = await courseRepository.getPublishedCourses();

      // assmption is that new course has been created and trimmed before added to the course list
      expect(newSeedData[1].id, equals("photo-102"));
    });

    test("A Duplicate attempt does not add another record", () async {
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      final photo101 = Course(
          id: "photo-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final PHOTO101 = Course(
          id: "PHOTO-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final courseApi = CourseApi(initialCourses: [photo101]);
      final courseRepository = CourseRepository(courseApi);

      //Act: create PHOTO-101 course
      final future = courseRepository.createCourse(photo101);

      //My assumption is that the course creation will fail, becuase the course.id will appear the same
      await expectLater(future, throwsA(isArgumentError));

      ///Get the courses list
      final courses = await courseRepository.getPublishedCourses();

      ///Assumption: My assumption is that because the isArgumentError is thrown, no new courses will be created
      await expectLater(courses.length, equals(1));

      ///Act: Call createCourse()
      ///Assumption this should also fail because, it is a duplicate and validation uses case insensitivity.
      final newFuture = courseRepository.createCourse(PHOTO101);
      await expectLater(newFuture, throwsA(isArgumentError));

      final newCourses = await courseRepository.getPublishedCourses();
      await expectLater(newCourses.length, equals(1));
    });

    test("A test cover both case directions and surrounding whitespace",
        () async {
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      final photo101 = Course(
          id: " photo-101 ",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final PHOTO101 = Course(
          id: "PHOTO-101",
          title: "Photo Basics",
          isPublished: true,
          description: "can do some cool photography things");

      final courseApi = CourseApi(initialCourses: [PHOTO101]);
      final courseRepository = CourseRepository(courseApi);

      ///Act: create PHOTO-101 course
      final future = courseRepository.createCourse(photo101);

      ///Asumption: this will fail due to the validation guards with case-insensitivity for both items checked
      await expectLater(future, throwsA(isArgumentError));

      ///Get the courses list
      final courses = await courseRepository.getPublishedCourses();

      ///Assumption: My assumption is that current published will show only 1 published course
      ///because no new course has been added
      await expectLater(courses.length, equals(1));
    });
  });
}
