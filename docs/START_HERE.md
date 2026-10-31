# Start here: your first professional workflow

Welcome to the Junior Mobile Developer GitHub Workflow Lab. This is a deliberately small Flutter/Dart codebase with practice tickets. The goal is not to rush through all tickets. The goal is to practice a repeatable engineering process and leave evidence of your decisions.

## What you will practice

- Read a task and clarify expected behavior.
- Use GitHub Issues as the source of truth for work.
- Create a branch for one issue at a time.
- Reproduce a problem and write a failing regression test.
- Implement the smallest reasonable change.
- Run formatting, static analysis, and tests.
- Commit changes with useful messages.
- Open a pull request with test evidence and risk notes.
- Respond professionally to review feedback.
- Keep the issue, code, tests, and PR connected.

## Before starting

Install Flutter and Git, then verify in your terminal:

```bash
flutter --version
dart --version
git --version
```

Open this project folder in VS Code. Run:

```bash
flutter pub get
flutter test
flutter analyze
```

If a command fails because Flutter is not installed or configured, fix the environment first. Do not edit application code just to silence an environment problem.

## The workflow for every ticket

1. **Read** the full issue. Restate the problem in your own words.
2. **Clarify** assumptions. If the issue is ambiguous, write a concise question before coding.
3. **Plan** a small sequence of changes and identify the likely layer.
4. **Create a branch** from an up-to-date `main` branch.
5. **Reproduce** the defect or establish the current behavior.
6. **Write a test first** when practical. Confirm it fails for the expected reason.
7. **Implement** the smallest change that satisfies acceptance criteria.
8. **Verify** with format, analyze, and tests. Inspect the diff.
9. **Commit and push** the branch.
10. **Open a PR** using the template. Link the issue and report test results honestly.
11. **Respond to review** without defensiveness; make requested changes or explain a technical disagreement with evidence.
12. **Merge only when** required checks and approvals are satisfied. Delete the branch if appropriate.
13. **Close the loop** by confirming the issue is resolved and recording anything learned.

## Commands to know

```bash
# Inspect state
git status
git branch
git log --oneline -5

# Start work (replace 1 and issue-slug)
git switch main
git pull
git switch -c fix/1-reject-blank-course-ids

# Verify
dart format .
flutter analyze
flutter test

# Save work
git add .
git commit -m "fix: reject blank course IDs"
git push -u origin fix/1-reject-blank-course-ids
```

Do not copy the example branch or commit names blindly. Use the actual issue number and describe your change. If your `main` branch has uncommitted changes, stop and inspect `git status` before switching branches.

## What counts as good evidence?

- A test that demonstrates the previous behavior and now passes.
- A clear statement of the command you ran and whether it passed.
- A diff that only changes what the ticket requires.
- A PR description that explains behavior, implementation, testing, and risks.
- A professional response to review comments.

## Important learning rule

Do not treat the ticket's title as the entire specification. Read the context, acceptance criteria, constraints, and test ideas. If you discover the problem differs from the issue description, document the evidence and discuss scope before expanding the change.
