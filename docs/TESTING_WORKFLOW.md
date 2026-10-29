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

## When testing takes longer than expected

Testing can take a substantial portion of a task, especially when learning. Time is not measured by how quickly you produce assertions. You are investigating behavior, selecting meaningful cases, confirming failure, and protecting against regressions.

If you are stuck for a while, record:
1. What you expected.
2. What actually happened.
3. The smallest reproduction.
4. What you tried.
5. The next question you need answered.

Ask for help with evidence rather than waiting silently or repeatedly trying random changes.
