# Pull request writing and collaboration

## PR description checklist

A reviewer should be able to answer these questions without opening every changed file:
1. Why is this change needed?
2. What behavior changed?
3. How was it tested?
4. What could be affected?
5. Is anything deliberately out of scope?

## Example of a concise PR summary

> This PR rejects course IDs that contain only whitespace. The repository now trims the input before validation and includes regression tests for spaces and tabs. Valid IDs with surrounding whitespace continue to be normalized.

## Report tests accurately

Good:
- `flutter test test/repositories/course_repository_test.dart` — passed.
- `flutter test` — passed (18 tests).
- `flutter analyze` — passed.

If a command failed:
- State the command.
- State the relevant failure.
- Explain whether it is caused by your change or an existing/environmental issue.
- Do not mark the PR fully verified until the blocker is resolved or clearly accepted by the team.

## Review reply examples

**Reviewer found a missing edge case**
> You're right; the current test covers an empty string but not whitespace-only input. I've added a tabs-only case and verified the focused test and full suite.

**You need clarification**
> I understand the goal. Should duplicate IDs be compared after trimming only, or should comparison also ignore case? That choice changes the repository's identifier contract.

**You disagree respectfully**
> I considered that approach. I kept the validation in the repository because all creation paths pass through it, and this matches the existing architecture. I added a test at the repository boundary to demonstrate the behavior. If the team prefers validation at the model boundary, I can adjust.

**A review comment is complete**
> Addressed in commit `<short-sha>`: the failed fetch now preserves the previous course list, and a regression test covers that state transition.

## Avoid

- “Done” with no detail.
- Claiming tests passed when they were not run.
- Hiding known limitations.
- Mixing unrelated refactors into a small bug fix.
- Treating review comments as personal criticism.
- Resolving conversations before the concern is addressed.
