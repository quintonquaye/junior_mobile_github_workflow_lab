# Independent practice tickets

These are **practice specifications**, not pre-created GitHub Issues. Create a GitHub Issue for each ticket you work on and copy the title, context, expected behavior, and acceptance criteria into it. Each ticket should be handled on its own branch and PR. Unless the ticket says otherwise, start from the latest `main` and do not combine unrelated tickets into one PR.

Do not solve all tickets in one large commit. For each ticket, practice the full workflow in `START_HERE.md`.

---

## MDP-01 — Reject whitespace-only course IDs

**Type:** Bug · **Suggested label:** `bug`, `good first issue`

### Context
`CourseRepository.createCourse` rejects an empty ID, but a string containing spaces or tabs is not meaningful. IDs are trimmed before saving, so validation should use the normalized value.

### Current behavior to investigate
Try creating a course with `id: '   '` and another with `id: '\t\t'`. Record the observed behavior before changing code.

### Expected behavior
Reject an ID if it contains no meaningful characters after trimming. Keep accepting valid IDs that have accidental surrounding whitespace, and store the trimmed ID.

### Acceptance criteria
- [ ] A spaces-only ID is rejected with `ArgumentError`.
- [ ] A tabs-only ID is rejected with `ArgumentError`.
- [ ] An ID such as `' photo-303 '` is stored as `photo-303`.
- [ ] Existing valid course creation still works.
- [ ] Regression tests describe the behavior.

### Test ideas
Test empty, spaces-only, tabs-only, and valid surrounding whitespace. Assert the exception type and normalized saved value.

### Scope boundaries
Do not change duplicate-ID case sensitivity in this ticket.

---

## MDP-02 — Prevent duplicate IDs when case differs

**Type:** Bug · **Suggested label:** `bug`

### Context
Course IDs identify records. The team needs a consistent rule for whether IDs differ only by letter case. For this exercise, use a **case-insensitive uniqueness rule** while preserving the user's normalized ID casing in the returned model.

### Expected behavior
Creating `PHOTO-101` must be rejected if `photo-101` already exists, and vice versa.

### Acceptance criteria
- [ ] Duplicate detection trims IDs before comparing.
- [ ] Duplicate detection ignores case.
- [ ] A unique ID is still accepted.
- [ ] A duplicate attempt does not add another record.
- [ ] Tests cover both case directions and surrounding whitespace.

### Test ideas
Seed an existing `photo-101`; attempt `PHOTO-101`, `' photo-101 '`, and an unrelated ID. Verify the stored record count or API contents.

### Scope boundaries
Do not change title search behavior or add a new ID format.

---

## MDP-03 — Trim search input before searching

**Type:** Bug · **Suggested label:** `bug`, `good first issue`

### Context
Search is case-insensitive, but a user may accidentally type spaces before or after the query. The search should treat those spaces as accidental input.

### Expected behavior
Searching for `'  Exposure  '` should produce the same results as searching for `'Exposure'`.

### Acceptance criteria
- [ ] Leading and trailing query whitespace is ignored.
- [ ] Search remains case-insensitive.
- [ ] An empty or whitespace-only query follows a clearly documented behavior.
- [ ] Tests cover normal, padded, mixed-case, and whitespace-only queries.

### Test ideas
Before implementation, decide and document whether a blank query should return all published courses or an empty list. Use the existing product behavior as evidence, and state your chosen assumption in the issue/PR.

### Scope boundaries
Do not add description search; that is a separate ticket.

---

## MDP-04 — Search course descriptions as well as titles

**Type:** Enhancement · **Suggested label:** `enhancement`

### Context
Students may remember a topic from a course description rather than its title. Search should match published courses by title or description.

### Expected behavior
Searching for `aperture` should find “Understanding Exposure” because its description mentions aperture.

### Acceptance criteria
- [ ] Title matches are still found.
- [ ] Description matches are found.
- [ ] Matching remains case-insensitive.
- [ ] Unpublished courses are never returned by search.
- [ ] Tests cover title-only and description-only matches.

### Test ideas
Use the default course data plus a custom course with a distinctive description. Verify both matching and non-matching cases.

### Scope boundaries
Do not introduce ranking, pagination, or fuzzy matching.

---

## MDP-05 — Preserve existing course state after a failed reload

**Type:** Bug · **Suggested label:** `bug`

### Context
A refresh may fail because the API is unavailable. A temporary failure should not erase data that was successfully loaded earlier.

### Expected behavior
After a successful load, if the next fetch fails, the controller should report failure and an error message while preserving the last successfully loaded course list.

### Acceptance criteria
- [ ] First load succeeds and stores courses.
- [ ] A later fetch failure sets status to `failure`.
- [ ] The error message is populated.
- [ ] Previously loaded courses remain unchanged.
- [ ] A later successful retry restores `success` and clears the error.

### Test ideas
Use `CourseApi.shouldFailNextFetch` to control the failure. Assert the full state before and after each transition.

### Scope boundaries
Do not redesign the controller's state model or add a networking package.

---

## MDP-06 — Do not add a course to controller state after creation fails

**Type:** Bug · **Suggested label:** `bug`

### Context
The controller owns the UI-facing course list. A failed create operation must not make the UI appear to contain a course that the repository did not save.

### Expected behavior
If creation fails due to an invalid or duplicate ID, the controller list remains unchanged and an error message is available.

### Acceptance criteria
- [ ] Successful creation adds exactly one course to controller state.
- [ ] Failed creation returns `null`.
- [ ] Failed creation does not change the course list.
- [ ] Failed creation exposes a useful error message.
- [ ] Tests cover both success and failure.

### Test ideas
Load courses first, capture the list IDs, attempt duplicate creation, and verify the IDs are unchanged.

### Scope boundaries
Do not add edit/delete functionality.

---

## MDP-07 — Make course descriptions optional in search results without breaking titles

**Type:** Enhancement · **Suggested label:** `enhancement`

### Context
The current search checks only titles. Product requirements now say that a search term may match either the title or description. This ticket is intentionally separate from MDP-04: implement it only after discussing the API/behavior contract with a reviewer, or use it as an alternate implementation exercise in a fresh branch.

### Expected behavior
Search results include a course if the query matches its title or its description, ignoring case.

### Acceptance criteria
- [ ] Title matching still works.
- [ ] Description matching works.
- [ ] Matching one course through both fields returns it only once.
- [ ] Unpublished courses remain excluded.
- [ ] Tests verify no duplicate result entries.

### Test ideas
Create one course whose title and description both contain the query. Assert its ID appears once.

### Scope boundaries
Do not add ranking or sorting.

**Note:** This ticket overlaps MDP-04 by design. Treat it as an alternate ticket, not a ticket to complete after MDP-04 in the same codebase. If you complete MDP-04, mark this one as “superseded by prior work” in your learning notes.

---

## MDP-08 — Add a controller test for successful creation

**Type:** Testing · **Suggested label:** `testing`

### Context
The controller has a `createCourse` method, but the starter tests do not fully document its success contract.

### Expected behavior
A successful create returns the created course, adds it to controller state once, and leaves `errorMessage` clear.

### Acceptance criteria
- [ ] Test demonstrates successful creation.
- [ ] Returned ID and title are correct after normalization.
- [ ] Controller list contains the created course exactly once.
- [ ] Error state is clear after success.
- [ ] Test is deterministic and uses in-memory dependencies.

### Test ideas
Use a unique ID and verify both the returned model and controller state.

### Scope boundaries
Do not change production code unless the test exposes a genuine defect. If production behavior already satisfies the contract, the test-only PR is a valid result.

---

## MDP-09 — Add a regression test for failed API fetch

**Type:** Testing · **Suggested label:** `testing`

### Context
The API substitute can simulate a fetch failure. The repository should propagate the failure, while the controller should convert it into a UI-facing failure state.

### Expected behavior
A fetch failure must be observable and handled at the correct layer.

### Acceptance criteria
- [ ] A repository test verifies fetch failures are not silently converted to an empty success result.
- [ ] A controller test verifies `failure` status and a non-null error message.
- [ ] Tests do not depend on network access or timing delays.
- [ ] Existing success-path tests remain green.

### Test ideas
Use `shouldFailNextFetch`. Be explicit about which layer owns propagation and which layer owns presentation state.

### Scope boundaries
Do not introduce mocks or a new testing library unless you justify why the existing in-memory seam is insufficient.

---

## MDP-10 — Improve error messages for invalid course creation

**Type:** Enhancement · **Suggested label:** `enhancement`

### Context
Callers need to distinguish an invalid ID from an invalid title without parsing vague text. Preserve the current exception type unless the issue discussion explicitly agrees to change it.

### Expected behavior
An empty/whitespace ID and an empty/whitespace title each produce a clear, specific `ArgumentError`.

### Acceptance criteria
- [ ] Invalid ID produces a specific message.
- [ ] Invalid title produces a specific message.
- [ ] Tests assert the contract without relying on fragile full stack traces.
- [ ] Valid creation remains unchanged.

### Test ideas
Use `throwsA(isA<ArgumentError>())` plus message checks appropriate to the existing Dart version and test style.

### Scope boundaries
Do not create a global error-handling framework.

---

## MDP-11 — Add widget tests for loading, error, and empty states

**Type:** Testing · **Suggested label:** `testing`

### Context
The home page shows a progress indicator, an error message, and an empty state. Those states are important user-facing behavior and should be covered.

### Expected behavior
The page communicates loading, failure, and no-results states without crashing or showing misleading content.

### Acceptance criteria
- [ ] A widget test can verify a loading indicator while loading is pending.
- [ ] A failure state displays an error message.
- [ ] An empty successful result displays “No courses found.”
- [ ] Tests clean up pending work and do not rely on real network calls.
- [ ] Test names explain the user-visible behavior.

### Test ideas
You may need a controllable fake repository or a small dependency seam. Keep the test seam simple and production-relevant.

### Scope boundaries
Do not redesign the entire visual system or add screenshot/golden testing.

---

## MDP-12 — Document and automate the verification workflow

**Type:** Documentation / CI · **Suggested label:** `documentation`, `testing`

### Context
Contributors need a repeatable way to run formatting, static analysis, and tests before opening a PR. The repository should also run these checks automatically for proposed changes.

### Expected behavior
A contributor can find the exact local commands, and GitHub Actions runs the required checks for pull requests.

### Acceptance criteria
- [ ] README or workflow documentation lists setup and verification commands.
- [ ] A GitHub Actions workflow runs on pull requests and pushes to `main`.
- [ ] The workflow installs Flutter dependencies.
- [ ] Formatting, analysis, and tests are checked.
- [ ] The PR description documents the checks run locally.
- [ ] The workflow uses supported actions and a stable Flutter setup.

### Test ideas
Validate the YAML structure, inspect the Actions run, and intentionally observe how a failing check appears on the PR before restoring a passing state.

### Scope boundaries
Do not add deployment, publishing, signing, or release automation.
