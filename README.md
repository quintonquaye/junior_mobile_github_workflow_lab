# Junior Mobile Developer GitHub Workflow Lab

A hands-on Flutter/Dart practice repository for learning how to handle tickets professionally: investigate behavior, write tests, make scoped changes, use GitHub Issues and pull requests, and communicate with reviewers.

## Start

1. Install Flutter and Git.
2. Open this folder in VS Code.
3. Run:

   ```bash
   flutter pub get
   flutter test
   flutter analyze
   ```

4. Read [`docs/START_HERE.md`](docs/START_HERE.md).
5. Read [`docs/GITHUB_FROM_ZERO.md`](docs/GITHUB_FROM_ZERO.md) before creating your first GitHub issue.
6. Choose one ticket from [`docs/INDEPENDENT_PRACTICE_TICKETS.md`](docs/INDEPENDENT_PRACTICE_TICKETS.md).

## Project structure

```text
lib/
  controllers/       # UI-facing state and orchestration
  data/              # In-memory API substitute
  models/            # Data objects
  repositories/      # Validation, filtering, and data access
test/
  controllers/
  repositories/
docs/
  START_HERE.md
  GITHUB_FROM_ZERO.md
  ISSUE_WRITING_GUIDE.md
  TESTING_WORKFLOW.md
  PR_COMMUNICATION_GUIDE.md
  INDEPENDENT_PRACTICE_TICKETS.md
.github/
  ISSUE_TEMPLATE/
  PULL_REQUEST_TEMPLATE.md
  workflows/
```

## Architecture

`CourseHomePage → CourseController → CourseRepository → CourseApi`

- **UI:** displays course state and user interactions.
- **Controller:** coordinates operations and exposes loading/success/failure state.
- **Repository:** validates and normalizes input, filters and searches courses.
- **API substitute:** deterministic in-memory data; no credentials or internet service required.

## How to use the tickets

The ticket document contains 12 practice specifications. They are not automatically published as GitHub Issues. Create each Issue in your own GitHub repository, then work on one issue per branch and PR. MDP-07 is intentionally an alternate exercise that overlaps MDP-04; do not complete both sequentially as independent production changes.

## Suggested workflow

```bash
git status
git switch main
git pull
git switch -c fix/1-reject-blank-course-ids
# edit and test
dart format .
flutter analyze
flutter test
git diff
git add .
git commit -m "fix: reject blank course IDs"
git push -u origin fix/1-reject-blank-course-ids
```

Then open a PR on GitHub, complete the PR template, link the actual issue number (for example `Closes #1`), and respond to review comments.

## Learning goal

Success is not simply making all tests green. Success is showing a professional chain of reasoning: clear issue → focused test → minimal implementation → verification evidence → reviewable PR → respectful collaboration.
# junior_mobile_github_workflow_lab
