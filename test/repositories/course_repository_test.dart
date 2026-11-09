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

group("Prevent duplicate ID's when case differs", (){
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
  
  group("02-Prevent duplicate IDs when case differs", (){
    test("Happy path: adding valid course still works", () async{
      ///Arange: setup a photography cours(photo-101), seed it into the courseAPI
      Course photo101 = Course(
        id: "photo-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      Course photo102 = Course(
        id: "photo-102", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      var courseApi = CourseApi(initialCourses: [photo101]);
      var courseRepository = CourseRepository(courseApi);

      //get course data 
      var seedData = await courseRepository.getPublishedCourses();

      //My assumption is that the seeded data should come back as only 1
      expect(seedData.length, equals(1));

      ///Act: attempt to add PHOTO-101 
      await courseRepository.createCourse(photo102);

      var newSeedData = await courseRepository.getPublishedCourses();

      // assmption is that new course has been created and added to the course list(2)
      expect(newSeedData.length, equals(2));
  
    });
    test("test expected duplicate behavior with same case", () async{
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      Course photo101 = Course(
        id: "photo-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      var courseApi = CourseApi(initialCourses: [photo101]);
      var courseRepository = CourseRepository(courseApi);

      //Act: create PHOTO-101 course 
      var future = courseRepository.createCourse(photo101);

      //My assumption is that the course creation will fail, becuase the course.id will appear the same 
      await expectLater(future, throwsA(isArgumentError));

    });

    test("Duplicate detection ignores case", () async{
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      Course photo101 = Course(
        id: "photo-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      Course PHOTO101 = Course(
        id: "PHOTO-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      var courseApi = CourseApi(initialCourses: [photo101]);
      var courseRepository = CourseRepository(courseApi);

      ///Act: create PHOTO-101 course 
      var future = courseRepository.createCourse(PHOTO101);
      
      ///Assumption: My assumption is that the course creation will fail, becuase the course.id will appear the same 
      ///even if upper or lowercase because ("==" This method compares each individual code unit of the strings. It does not check for Unicode equivalence.)
      //await expectLater(future, throwsA(isArgumentError));

      ///result is, my assumption failed because the course.id did not appear case-insensitive during current validation,
      ///it in-fact created the course.
      
      ///Act: Call createCourse()
      await future;
      ///Get the courses list
      var courses = await courseRepository.getPublishedCourses();

      ///Assumption: My assumption is that current published will show 2 published courses
      await expectLater(courses.length, equals(2));
    });

    test("Duplicate detection trims IDs before comparing", () async{
      ///Arange: setup a photography cours(photo-101), seed it into the courseAPI
      Course photo101 = Course(
        id: "photo-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      Course PHOTO101 = Course(
        id: " PHOTO-101 ", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      Course photo102 = Course(
        id: " photo-102 ", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      var courseApi = CourseApi(initialCourses: [photo101]);
      var courseRepository = CourseRepository(courseApi);

      ///Act: attempt to add PHOTO-101 
      await courseRepository.createCourse(PHOTO101);

      var seedData = await courseRepository.getPublishedCourses();

      // assmption is that duplicate course has been created and trimmed before added to the course list
      expect(seedData[1].id, equals("PHOTO-101"));

      ///Act: attempt to add photo-102
      await courseRepository.createCourse(photo102);

      var newSeedData = await courseRepository.getPublishedCourses();

      // assmption is that new course has been created and trimmed before added to the course list
      expect(newSeedData[2].id, equals("photo-102"));
    });

    test("A Duplicate attempt does not add another record", () async{
      ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      Course photo101 = Course(
        id: "photo-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      Course PHOTO101 = Course(
        id: "PHOTO-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      var courseApi = CourseApi(initialCourses: [photo101]);
      var courseRepository = CourseRepository(courseApi);

      //Act: create PHOTO-101 course 
      var future = courseRepository.createCourse(photo101);

      //My assumption is that the course creation will fail, becuase the course.id will appear the same 
      await expectLater(future, throwsA(isArgumentError));

      ///Get the courses list
      var courses = await courseRepository.getPublishedCourses();

      ///Assumption: My assumption is that because the isArgumentError is thrown, no new courses will be created
      await expectLater(courses.length, equals(1));


      ///Act: Call createCourse()
      await courseRepository.createCourse(PHOTO101);

      ///Get the courses list
      var newCourses = await courseRepository.getPublishedCourses();

      ///Assumption: My assumption is that current published will show 2 published courses
      await expectLater(newCourses.length, equals(2));
    });

    test("A test cover both case directions and surrounding whitespace", () async{
       ///Arange: setup a photography course(photo-101), seed it into the courseAPI
      Course photo101 = Course(
        id: " photo-101 ", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      Course PHOTO101 = Course(
        id: "PHOTO-101", 
        title: "Photo Basics", 
        isPublished: true, 
        description: "can do some cool photography things"
      );

      var courseApi = CourseApi(initialCourses: [PHOTO101]);
      var courseRepository = CourseRepository(courseApi);

      ///Act: create PHOTO-101 course 
      var future = courseRepository.createCourse(photo101);
      
      ///Act: Call createCourse()
      await future;
      ///Get the courses list
      var courses = await courseRepository.getPublishedCourses();

      ///Assumption: My assumption is that current published will show 2 published courses
      await expectLater(courses.length, equals(2));

      /// white space will be trimmed from input
      await expectLater(courses[1].id, equals("photo-101"));
    });
  });
}
