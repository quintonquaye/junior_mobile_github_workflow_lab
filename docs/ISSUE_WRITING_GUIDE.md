# How to write a useful GitHub issue

## A reliable structure

### Title
Describe the behavior or outcome, not just “bug” or “fix issue.”

Weak: `Fix course validation`

Better: `Reject course IDs containing only whitespace`

### Context
Where does the behavior occur? Which method, screen, or user action is involved?

### Current behavior
Describe what actually happens. Include a minimal example or reproduction steps.

### Expected behavior
State the intended behavior in observable terms.

### Acceptance criteria
Use checkboxes. Each item should be testable and clear enough to review.

### Test ideas
List important cases. These are suggestions, not necessarily a complete test implementation.

### Scope boundaries
State what should not change so the ticket does not silently grow.

## Good acceptance criteria

Weak: “Validation should be better.”

Better:
- [ ] An ID containing spaces only is rejected with `ArgumentError`.
- [ ] An ID containing tabs only is rejected.
- [ ] A valid ID with surrounding whitespace is trimmed before storage.
- [ ] Existing valid ID behavior remains unchanged.

## Clarifying questions

Ask a specific question that blocks implementation:

> Should IDs be compared case-sensitively for duplicate detection? The current implementation treats `photo-101` and `PHOTO-101` as different IDs. I can preserve this behavior or normalize comparisons, but the intended contract should be explicit.

Do not ask questions already answered by the issue. If a reasonable assumption is low risk, state it in the issue/PR and proceed when team norms allow.
