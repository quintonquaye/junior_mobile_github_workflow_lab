# Testing workflow and work log

## Test-first loop

Use this sequence for each behavior change:

1. **Arrange:** create the model, repository, fake data, or API state needed.
2. **Act:** call the method or interact with the widget.
3. **Assert:** verify the externally observable result.
4. **Run the focused test:** verify it fails for the expected reason before the fix.
5. **Implement:** make the smallest change.
6. **Run the focused test again:** verify it passes.
7. **Run the full suite:** check for regressions.
8. **Analyze and format:** verify code quality and consistent formatting.
9. **Review the diff:** ensure the test is meaningful and no unrelated edits slipped in.

## Recommended verification commands

```bash
dart format .
flutter analyze
flutter test
```

Run the focused test while iterating, for example:

```bash
flutter test test/repositories/course_repository_test.dart
```

If you add a widget test, run that test file directly too. Record the actual output summary, not what you hoped would happen.

## Test case checklist

For each behavior, consider:
- Happy path.
- Empty input.
- Whitespace-only input.
- Boundary values.
- Case sensitivity.
- Duplicate data.
- Missing data.
- Dependency failure.
- Repeated calls/state transitions.
- Whether a failed operation accidentally changes existing state.

Not every feature needs every case. Choose cases based on the contract and risk.

---
# Commit timeline
```
main
  |
  └── fix/1-reject-blank-course-ids
         |
         ├── test: cover whitespace-only course IDs
         |
         ├── fix: reject whitespace-only course IDs
         |
         └── docs: complete MDP-01 engineering work log
```

Each commit represents a meaningful change.

Some example commit messages:
Commit message	What it communicates

test: cover whitespace-only course IDs	Added test coverage

fix: reject whitespace-only course IDs	Corrected the validation

docs: complete MDP-01 work log	Updated engineering documentation

You don't have to split every test and implementation into separate commits. For your current learning stage, combining the completed fix and its tests into one commit is perfectly reasonable.

---

## Work log template

Copy this into a personal note or `practice/worklogs/ISSUE-N.md`. Whether work logs are committed depends on the team. In this lab, commit a work log only if it is part of the ticket's deliverable or you intentionally want a public learning record.

```markdown
# Engineering work log

## Issue
- Issue:
- Branch:
- Date:

## Before implementation
- Problem in my own words:
- Current behavior:
- Expected behavior:
- Relevant code/layer:
- Assumptions or questions:

## Test plan
- [ ] Happy path
- [ ] Failure/edge case
- [ ] Regression test
- [ ] Existing related tests

## Investigation
- Reproduction steps:
- Initial test result:
- Root cause evidence:
- Files inspected:

## Implementation
- Changes made:
- Why this layer was selected:
- Alternatives considered:

## Verification
- `dart format .`:
- `flutter analyze`:
- Focused test:
- Full `flutter test`:
- Manual checks, if applicable:

## Review
- Diff reviewed:
- Known limitations:
- Follow-up issue(s):

## Reflection
- What I learned:
- What I would do differently:
```
---


# Details of Worklog 
Your engineering work log is a record of how you investigated a problem, made a decision, changed the code, verified the result, and evaluated your work.

Think of it as a laboratory notebook for software engineering. You are documenting evidence and decisions, not merely recording which files you edited.

I'll explain every line, what you should write there, and how it applies to your Flutter practice project.

## 1. Engineering work log

```
# Engineering work log
```

This is the title of the document.

An engineering work log records the work you perform on a specific engineering task, usually a GitHub Issue or ticket.

For example, if your ticket is to reject course IDs containing only spaces, the work log documents your process from investigating that bug to verifying the fix.

Purpose: Someone reviewing your work should be able to understand what you did and why without having to guess.

## 2. Issue

```
## Issue
- Issue:
- Branch:
- Date:
```

This section identifies the task and the Git work associated with it.

`- Issue:`

The GitHub Issue number and its title, or a reference to the ticket you're working on.

Example:

`Issue: #1 — Reject whitespace-only course IDs`

Why it matters: It connects your work log to the requirement you're trying to satisfy. In a professional team, multiple people may work on different issues simultaneously.

`- Branch:`

The Git branch where you are doing the work.

Example:

`Branch: fix/1-reject-blank-course-ids`

A branch is an independent line of development. It lets you work on a change without directly modifying the main branch.

Why it matters: It identifies where your changes belong and helps others trace the work through commits and pull requests.

If you haven't created a branch yet, you can write `Not created yet` and update it later.

`- Date:`

The date you worked on the task.

Example:

`Date: 2026-10-29`

For work spanning multiple days, you can keep a dated entry for each session or use one log with dated updates.

Why it matters: It helps you track progress and reconstruct when you performed an investigation or verification.

## 3. Before implementation

```
## Before implementation
- Problem in my own words:
- Current behavior:
- Expected behavior:
- Relevant code/layer:
- Assumptions or questions:
```

This section is completed before you start changing the implementation. You establish what the problem is and what you need to investigate.

`- Problem in my own words:`

Explain the problem as you understand it, without simply copying the ticket description.

Example:

> The repository is expected to reject course IDs that contain no meaningful characters, but IDs containing only spaces may be accepted.

Why it matters: Rephrasing a requirement checks whether you actually understand it. If you cannot explain the problem in your own words, you may need to investigate further before coding.

`- Current behavior:`

Describe what the application actually does right now.

Example:

> A course with an ID of three spaces is accepted by the repository.

This is a statement about observed behavior, not what you think should happen.

Why it matters: You need to establish the existing behavior before you can prove that a change corrected it.

`- Expected behavior:`

Describe what the application should do according to the requirement.

Example:

> The repository should reject IDs that contain only whitespace.

Why it matters: This establishes the acceptance criterion: the condition that must be satisfied for the task to be considered complete.

The current behavior and expected behavior are different for an important reason: one describes reality, and the other describes the requirement.

`- Relevant code/layer:`

Identify the code or architectural layer that appears responsible for the behavior.

Example:

> `CourseRepository`, because it validates course data before storing it.

Your application has several layers:

- UI: displays information and collects user input.
- Controller: coordinates application behavior and state.
- Repository: manages access to course data and relevant data rules.
- API/data source: provides the underlying data operations.

Why it matters: You want to change the correct layer rather than patching a symptom somewhere else.

At this stage, say `suspected: CourseRepository` if you have not confirmed it yet.

`- Assumptions or questions:`

Record things you are assuming, details that are unclear, and questions you need to answer before proceeding.

Example:

> Should IDs be trimmed before storage, or should whitespace-only IDs simply be rejected? Are leading and trailing spaces allowed on otherwise valid IDs?

Why it matters: Hidden assumptions lead to incorrect implementations. Recording questions helps you distinguish an actual requirement from your own interpretation.

You don't need to invent questions when everything is clear. Write `None identified` if appropriate.

## 4. Test plan

```
## Test plan
- [ ] Happy path
- [ ] Failure/edge case
- [ ] Regression test
- [ ] Existing related tests
```

This section describes the tests you intend to perform. It is a plan, not yet proof that the tests passed.

The square brackets represent checkboxes in Markdown:

- means not completed.
- means completed.

You should only check an item after you've performed the relevant verification.

`- [ ] Happy path`

Test the normal, valid scenario.

Example:

> A course with ID `photo101` can be created successfully.

A happy path is the ordinary situation where valid inputs and normal conditions produce the expected result.

Why it matters: A fix should not solve one problem by breaking normal functionality.

`- [ ] Failure/edge case`

Test invalid input, unusual conditions, or boundary cases.

Example:

> A course ID containing only spaces is rejected.

Other examples might include an empty ID, a missing description, or a duplicate ID, depending on the requirements.

Why it matters: Bugs often appear when inputs differ from the ordinary case.

`- [ ] Regression test`

Plan a test that protects against a known bug returning.

Example:

> Add a test proving that a whitespace-only course ID is rejected.

A regression test is often also a unit test. These labels describe different aspects of the same test: unit describes the scope, while regression describes the protective purpose.

Why it matters: The test remains in the suite and can catch future changes that accidentally reintroduce the defect.

`- [ ] Existing related tests`

Identify and run existing tests that could be affected by your change.

Example:

> Run the other `CourseRepository` tests to ensure valid course creation and existing validation behavior still work.

Why it matters: A new test might pass while an older behavior breaks. You need to check both the new requirement and nearby existing functionality.

Important distinction: These four items are a practical checklist, not four completely separate categories. A regression test may be an edge-case test, for example.

## 5. Investigation

```
## Investigation
- Reproduction steps:
- Initial test result:
- Root cause evidence:
- Files inspected:
```

This section records the evidence you collected to understand the problem.

It answers: How did you determine what was wrong?

`- Reproduction steps:`

Write the steps needed to make the problem happen.

Example:

1. Create a `Course` with ID `'   '`.
2. Pass the course to `CourseRepository.createCourse()`.
3. Observe whether the operation rejects the course or accepts it.

Why it matters: Reproducible steps let another developer independently confirm the bug instead of relying only on your description.

`- Initial test result:`

Record what happened when you first tested the existing behavior, before fixing it.

Example:

> The new whitespace-validation test failed because the repository accepted the invalid ID.

You might also record the command you ran, such as:

```
flutter test test/repositories/course_repository_test.dart
```

Why it matters: This establishes a baseline. You can later compare it with the result after the fix.

If you haven't run a test yet, write `Not run yet` rather than guessing.

`- Root cause evidence:`

Document the specific evidence explaining why the bug happens.

Example:

> The repository checks `course.id.isEmpty` directly. A string containing spaces is not empty, so the check does not reject it.

This is stronger than writing `The validation is broken` because it identifies the precise logic responsible.

Why it matters: Evidence-based diagnosis helps you fix the cause instead of hiding the symptom.

`- Files inspected:`

List the files you examined while investigating the issue.

Example:

- `lib/repositories/course_repository.dart`
- `lib/models/course.dart`
- `test/repositories/course_repository_test.dart`

Why it matters: This creates an investigation trail and helps explain how you reached your conclusion.

List files you actually inspected, not every file you could potentially have inspected.

## 6. Implementation

```
## Implementation
- Changes made:
- Why this layer was selected:
- Alternatives considered:
```

This section explains the solution you implemented and the reasoning behind it.

It answers: What did I change, and why was that the appropriate approach?

`- Changes made:`

Describe the actual code changes.

Example:

> Updated course ID validation to reject IDs that are empty after trimming whitespace. Added a unit test covering whitespace-only IDs.

Why it matters: It summarizes the implementation in terms of behavior, not just the number of lines or files changed.

`- Why this layer was selected:`

Explain why you made the change in that particular part of the architecture.

Example:

> The repository was selected because it owns the relevant data validation rule. Fixing it there protects callers beyond the UI.

Why it matters: Good engineering is not just about making code work; it's also about placing responsibility in an appropriate location.

You should still consider the existing architecture and requirements. Not every validation rule automatically belongs in the repository.

`- Alternatives considered:`

Record other reasonable solutions you thought about and why you did or didn't choose them.

Example:

> An alternative was to reject whitespace-only IDs in the UI. I chose repository-level validation because callers could bypass the UI and call the repository directly.

Why it matters: It shows that you considered the consequences of your decision rather than making the first change that appeared to work.

You don't need a long list. One meaningful alternative is enough when alternatives exist. If none were worth considering, say so.

## 7. Verification

```
## Verification
- `dart format .`:
- `flutter analyze`:
- Focused test:
- Full `flutter test`:
- Manual checks, if applicable:
```

This section records the checks you performed after making the change.

The distinction from the test plan is important:

- Test plan: What do I intend to check?
- Verification: What did I actually run, and what were the results?

`- dart format .`:

Records the result of running the Dart formatter:

```
dart format .
```

This formats Dart source files according to standard formatting conventions.

Example log entry:

> Passed; formatter reported no files needing changes.

Why it matters: Consistent formatting makes code easier to read and review. Formatting does not prove the logic is correct.

`- flutter analyze`:

Records the result of static analysis:

```
flutter analyze
```

The analyzer checks for issues such as certain type errors, invalid API usage, and potential code problems without needing to run the app through its normal user interface.

Example:

> Passed with no issues.

Or:

> Failed; analyzer reported an unused import.

Why it matters: It catches many problems before runtime, but a clean analysis does not guarantee correct behavior.

`- Focused test:`

Records the result of running tests directly related to your change.

Example:

```
flutter test test/repositories/course_repository_test.dart
```

Example result:

> Passed; whitespace-only IDs are rejected and valid IDs remain accepted.

Why it matters: Focused tests provide fast feedback while you work on a specific problem.

`- Full flutter test:`

Records the result of the entire automated test suite:

```
flutter test
```

Example:

> Passed; all tests completed successfully.

If a test fails, record which test failed and investigate it. Don't write `Passed` just because the test command finished running.

Why it matters: Your change may affect behavior outside the specific file you edited. The full suite helps catch those unintended effects.

`- Manual checks, if applicable:`

Record any relevant checks that you performed manually.

Example:

> Ran the app and confirmed that creating a valid course still works through the interface.

Manual checks may include trying a user workflow, checking a loading indicator, or inspecting an error message.

Why it matters: Automated tests don't necessarily cover every UI behavior or user experience.

If manual testing isn't relevant, write `Not applicable` and briefly explain why.

A useful rule: record the real result, including failures. A work log is an engineering record, not a report that everything went perfectly.

## 8. Review

```
## Review
- Diff reviewed:
- Known limitations:
- Follow-up issue(s):
```

This section helps you check whether your change is ready for another developer to review and whether anything remains unresolved.

`- Diff reviewed:`

A diff is the comparison showing what changed between versions of your files.

Example:

> Reviewed the Git diff. Confirmed the change is limited to repository validation and its test.

In VS Code, you can inspect changed files through Source Control and click each file to see additions and deletions.

Why it matters: It helps catch accidental edits, unrelated changes, missing tests, and mistakes before a pull request is submitted.

This is not the same as someone else reviewing your pull request. It's your own review before asking for theirs.

`- Known limitations:`

Record relevant problems, constraints, or unimplemented behavior that remains after your change.

Example:

> This change rejects whitespace-only IDs but does not introduce case-insensitive duplicate detection.

That limitation is relevant if duplicate detection is outside the current ticket.

Why it matters: It prevents reviewers from assuming that your change solves more than it actually does.

If there are no known limitations relevant to the task, write `None identified`.

`- Follow-up issue(s):`

Identify related work that should be handled separately, ideally by linking to a GitHub Issue.

Example:

> Follow-up: #2 — Prevent duplicate course IDs when capitalization differs.

Why it matters: It lets you keep the current ticket focused without losing track of other work you discovered.

Don't create a follow-up ticket for every minor thought. Use it when the work is genuinely separate or outside the current scope.

## 9. Reflection

```
## Reflection
- What I learned:
- What I would do differently:
```

This section is about your professional development, not just the code.

`- What I learned:`

Record the most important technical or process lesson you gained.

Example:

> I learned that checking whether a string is empty is different from checking whether it contains meaningful characters. I also learned to inspect existing tests before assuming coverage is missing.

Why it matters: It helps turn each ticket into reusable knowledge instead of a task you complete and immediately forget.

`- What I would do differently:`

Describe one specific improvement you'd make to your approach next time.

Example:

> Next time, I'll inspect the repository implementation and existing tests first, then write a failing test before changing the validation logic.

Why it matters: This encourages you to improve your process over time.

You don't need to criticize yourself. Sometimes the answer is `Nothing significant; the investigation and verification process worked well`.

## Putting the whole work log together

Here's how the sections fit into a real engineering workflow.

1\. Define the task

Issue · Before implementation

Understand the requirement, existing behavior, expected behavior, and likely code location.

2\. Investigate and plan

Test plan · Investigation

Decide what to test, reproduce the bug, inspect code, and gather evidence.

3\. Implement the solution

Implementation

Make a focused change and document the reasoning behind it.

4\. Verify and review

Verification · Review

Run formatting, analysis, and tests; inspect the diff; record remaining limitations.

5\. Learn from the task

Reflection

Record what you learned and how you can improve the next investigation.

## Three things to remember

1. You don't have to complete the entire work log at once. Fill in the initial sections before implementation, update investigation and implementation as you work, and complete verification and review afterward.
2. You are documenting evidence, not trying to make your work look perfect. Failed tests, incorrect initial assumptions, and discoveries are all legitimate parts of engineering.
3. The work log supports your work; it doesn't replace it. The code, tests, Git history, and pull request provide the actual evidence of what changed. The log explains your process and decisions.

For your practice project, this is a tool for learning to think like an engineer: define the problem, investigate it, form a conclusion based on evidence, make a controlled change, and verify that the result is correct.



## When testing takes longer than expected

Testing can take a substantial portion of a task, especially when learning. Time is not measured by how quickly you produce assertions. You are investigating behavior, selecting meaningful cases, confirming failure, and protecting against regressions.

If you are stuck for a while, record:
1. What you expected.
2. What actually happened.
3. The smallest reproduction.
4. What you tried.
5. The next question you need answered.

Ask for help with evidence rather than waiting silently or repeatedly trying random changes.

