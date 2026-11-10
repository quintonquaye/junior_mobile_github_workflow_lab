
# Engineering work log

## Issue
- Issue: #02-Prevent duplicate IDs when case differs
- Branch: test/2-mpd-02-Prevent-duplicate-ids-when-case-differs
- Date: 11/5/2026

## Before implementation
- Problem in my own words: The team needs a consistent validation rule for Course ID's, which differ only by letter case, while preserving the normalized ID in the returned model.

- Current behavior (Observation): 
  * (Searching) - When searching for course, the results appear to be case-insensitive, returning the same results for case variables.

  * (Creating) - before testing functionality, I cannot verify with UI, feature is not created, after reproducing the functionality in flutter Unit test, when creating a duplicate course with a variant case, the course will still be created instead of rejected.

- Expected behavior: creating a course with the ID such as `PHOTO-101` must be rejected if `photo-101` already exists, and vice versa.


- Relevant code/layer: 
  * CourseRepository - is currently responsible for validating searched course ID duplicates and course creation duplicates.


- Assumptions or questions: 
  * Does this test refer to creating a course or searching for a course?

  * should the repository really control the logic for creating a course or should the business logic layer control that, while keeping the repository layer responsible for communicating with the database for storage and retrieving data, and only acting as the interface for database operations? 
  
  * is the current setup not going to make repository more complex to maintain in time?

  * How should we validate the input data to reject? use case-insensitive validation?



## Test plan
- [X] Happy path
- [X] Failure/edge case
- [X] Regression test
- [X] Existing related tests


## Investigation
- Reproduction steps based on test ideas:
* Happy path: adding valid course still works:
  - 1. Initialize `courseAPI` with seed course `photo-101` ID.
  - 2. Initialize `courseRepository` with `courseAPI`
  - 3. Observe whether creating a new course with the ID `photo-102` will fail or pass.

* Test expected duplicate behavior with same case:
  - 1. Initialize `courseAPI` with seed course `photo-101` ID.
  - 2. Initialize `courseRepository` with `courseAPI`
  - 3. Observe whether creating a new course with the same ID `photo-101` will fail or pass.
    
* Duplicate detection ignores case
  - 1. Initialize `courseAPI` with seed course `photo-101` ID.
  - 2. Initialize `courseRepository` with `courseAPI`
  - 3. Observe whether creating a new course with the ID `PHOTO-101` will fail or pass.

* Duplicate detection trims IDs before comparing
  - 1. Initialize `courseAPI` with seed course `photo-101` ID.    
  - 2. Initialize `courseRepository` with `courseAPI`
  - 3. Observe whether creating a new course with the ID ` photo-102 ` will fail or pass.

* A Duplicate attempt does not add another record
  - 1. Initialize `courseAPI` with seed course `photo-101` ID.
  - 2. Initialize `courseRepository` with `courseAPI`
  - 3. Observe whether creating a new course with the same ID `photo-101` does not create another record will fail or pass.

* A test cover both case directions and surrounding whitespace
  - 1. Initialize `courseAPI` with seed course `PHOTO-101` ID.
  - 2. Initialize `courseRepository` with `courseAPI`
  - 3. Observe whether creating a new course with the ID of inverse case and white space ` photo-101 `  will fail or pass.


---

- Initial test result:
  * Happy path - adding valid course still works:
    - adding a new valid non-duplicate course, test passed.

  * Test expected duplicate behavior with same case:
    - adding duplicate course with same courseID throws an ArgumentError exception, test passed.
      
  * Duplicate detection ignores case:
    - Initial expectation of duplicate courseID with different case to throw with an ArgumentError, test failed.

  * Duplicate detection trims IDs before comparing:
    - adding a new valid non-duplicate course with extra spaces, test passed.

  * A Duplicate attempt does not add another record: 
    - adding duplicate course with same courseID throws an ArgumentError exception, no new course is created, test passed.
    - before validation implementation, adding duplicate courseID with different case, a new course is created, test passed.

  * A test cover both case directions and surrounding whitespace:
    - adding a inverse input with seeded `"PHOTO-101"`, created new course duplicate with `" photo-101 "`, test passed


- Root cause evidence:
    * Valid Input:
      - Adding a new non-duplicate course passes validation and creates a new course in the courses list

    * Test expected duplicate behavior with same case:
      - Adding a duplicate course with the same courseID causes an isArgumentError.

    * Duplicate detection ignores case:
      - Because the course.id did not appear case-insensitive during current validation, it passes validation and creates a new course in the courses list.
    
    * Duplicate detection trims IDs before comparing:
      - All inputs are trimmed before validation. 

    * A Duplicate attempt does not add another record: 
      - When adding a duplicate course, no new record is created due to throwing an ArgumentError.
      - When adding a duplicate course with different case, passes validation, will create a new record.

    * A test cover both case directions and surrounding whitespace:
      - adding a inverse input with seeded `"PHOTO-101"`, created new course with `" photo-101 "`, trimmed input to `"photo-101"`, still passes validation and creates a course, because the course.id did not appear case-insensitive during current validation.


- Files inspected: 
    * [lib/repositories/course_repository.dart](../../lib/repositories/course_repository.dart)


## Implementation
- Changes made: 
  Updated createCourse validation check `var caseInsensitiveID = normalizedId.toLowerCase();` and updated the conditional check `if (existing.any((item) => item.id.toLowerCase() == caseInsensitiveID))` to include the `caseInsensitiveID` and check existing `item.id.toLowercase`. 

  * Duplicate detection ignores case: 
    - `await expectLater(future, throwsA(isArgumentError));` 
      * creating a course now properly throws a `isArgumentError` when checks with case-insensitivity.

  * Duplicate detection trims IDs before comparing
    * creating a course now properly throws a `isArgumentError` after trimming IDs and checking with case-insensitivity.
  
  * A Duplicate attempt does not add another record:
    - Because case-insensitive validation happens, this function now properly throws isArgumentError and as a result does not create a new course record.

  * A test cover both case directions and surrounding whitespace:
    - After adding case-insensitive validation checks on both existing items `item.id.toLowerCase()` and variable `caseInsensitiveID` this test now properly trims whitespace, throws an `ArgumentError`, and no new courses have been added.


- Why this layer was selected: 

  * The CourseRepository was selected because it owns the relevant data validation rule for course creation and is a direct interface with the courseAPI to get relevant data. 

  
- Alternatives considered:
  - Not yet created


## Verification
- `dart format .`:
  - Not yet created

- `flutter analyze`: 
  - 4 issues found: The variable name 'PHOTO101' isn't a lowerCamelCase identifier

- Focused test:
    * `flutter test test/repositories/course_repository_test.dart`
    - All (14) tests passed!

- Full `flutter test`:
    * flutter test
    - All (16) tests passed!

- Manual checks, if applicable: not applicable

## Review
- Diff reviewed: Not created yet

- Known limitations: 
    * Do not change title search behavior or add a new ID format.

- Follow-up issue(s): Not created yet

## Reflection
- Not yet created
