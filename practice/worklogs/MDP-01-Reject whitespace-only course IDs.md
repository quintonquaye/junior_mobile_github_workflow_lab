# Engineering work log

## Issue
- Issue: #01 MDP-01-Reject whitespace-only course IDs
- Branch: test/1-reject-whitespace-only-course-ids
- Date: 10/29/2026

## Before implementation
- Problem in my own words: CourseRepository is expected to reject empty ID entries and spaces with no meaningful characters, while still accepting valid inputs which have been normalized.

- Current behavior: Application rejects empty/invalid inputs, accepts valid inputs and trims extra whitespace before saving.

- Expected behavior: Application requires to reject invalid IDs with no meaningful characters after trimming. It should also accept and save courses with valid IDs whom have been trimmed of surrounding whitespace.

- Relevant code/layer: CourseRepository - it is currently responsible for normalizing and validating inputs before storing Course.

- Assumptions or questions: 
    * Are whitespace (more than 1) trimned?
    * Are empty/invalid inputs with 2 or more spaces thrown with ArgumentError?
    * Does the Repository layer need to be responsible for this validation action or can it be responsible elsewhere, such as the Display layer?


## Test plan
- [ ] Happy path
- [ ] Failure/edge case
- [ ] Regression test
- [ ] Existing related tests

## Investigation
- Reproduction steps based on test ideas:
    * Empty Input:
    - 1. Create a course with ID ''.
    - 2. Pass Course to `CourseRepository.createCourse()`
    - 3. Observe whether the operation rejects or accepts the action

    * Spaces-Only Input:
    - 1. Create a course with ID '  '.
    - 2. Pass Course to `CourseRepository.createCourse()`
    - 3. Observe whether the operation rejects or accepts the action

    * Tabs-Only Input:
    - 1. Create a course with ID '\t\t'.
    - 2. Pass Course to `CourseRepository.createCourse()`
    - 3. Observe whether the operation rejects or accepts the action

    * New-Line-Only Input:
    - 1. Create a course with ID '\n\n'.
    - 2. Pass Course to `CourseRepository.createCourse()`
    - 3. Observe whether the operation rejects or accepts the action

    * Valid Input with extra space:
    - 1. Create a course with ID ' PHO-101 '.
    - 2. Pass Course to `CourseRepository.createCourse()`
    - 3. Observe whether the operation rejects or accepts the action

    * Valid Input:
    - 1. Create a course with ID 'PHO-101'.
    - 2. Pass Course to `CourseRepository.createCourse()`
    - 3. Observe whether the operation rejects or accepts the action

---

- Initial test result:
    * Empty ID Input: 
      - Existing empty/invalid ID test passed with an ArgumentError.

    * Spaces-Only Input:
      - The new spaces-only validation test failed. 

    * Tabs-Only Input:
      - The new tabs-only validation test failed. 
    
    * New-Line-Only Input:
      - The New-Line-Only validation test failed.

    * Valid Input with spaces:
      - The existing valid input test passed.

    * Valid Input:
      - The existing valid input `equals()` test assumption failed when comparing the Course objects as equal
      - The existing valid input `identical()` test assumption failed when comparing the Course objets as identical
      - the existing valid input properties `equals()` test assumptions pass individually

- Root cause evidence:
    * Spaces-Only Input:
      - because the validation checks `course.id` not result of normalizedId.

    * Tabs-Only Input:
      - because the validation does not include checks for tabbed-space, in addition, only checks `course.id` not result of normalizedId
      
    * New-Line-Only Input:
      - because the validation does not include checks for new-line-space, in addition, only checks for `course.id` not result of normalizedId

    * Valid Input:
      - not created yet

- Files inspected: 
    * lib/controllers/course_controller.dart

## Implementation
- Changes made: Not created yet
- Why this layer was selected: Not created yet
- Alternatives considered: Not created yet

## Verification
- `dart format .`:
- `flutter analyze`:
- Focused test:
- Full `flutter test`:
- Manual checks, if applicable:

## Review
- Diff reviewed: Not created yet
- Known limitations: Not created yet
- Follow-up issue(s): Not created yet

## Reflection
- What I learned: Not created yet
- What I would do differently: Not created yet

