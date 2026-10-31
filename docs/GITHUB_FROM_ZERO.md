# GitHub from zero: Issues, branches, commits, and pull requests

## 1. Repository and local folder

A **repository** is the project plus its version history. Your local repository is on your computer; the remote repository is hosted on GitHub. `origin` is the conventional name for the remote.

```bash
git clone <your-repository-url>
cd junior_mobile_github_workflow_lab
git remote -v
```

Create a GitHub repository for this practice project. For a beginner-friendly route, create an empty repository on GitHub (do not initialize it with a README if you already have one locally), then connect and push:

```bash
git remote add origin <your-repository-url>
git branch -M main
git push -u origin main
```

Replace the placeholder with your actual repository URL. Never paste a password or access token into a public issue, PR, commit, or chat.

## 2. What an Issue is

An **Issue** describes a problem, improvement, or task. It is a shared conversation and a record of why the work exists. An issue should help another developer understand the problem without having to guess.

A useful issue contains:
- Context: where the behavior occurs.
- Current behavior: what happens now.
- Expected behavior: what should happen instead.
- Reproduction steps or a clear scenario.
- Acceptance criteria: observable conditions for completion.
- Test ideas: important cases to verify.
- Scope boundaries: what is intentionally not part of the ticket.

On GitHub: open the repository → **Issues** → **New issue**. Choose a template if available, fill it out, and submit. GitHub assigns a number, such as `#3`. Use that number in your branch, commit/PR discussion, and links.

## 3. Labels and milestones

Suggested labels:
- `bug`: behavior is wrong.
- `enhancement`: a new or improved capability.
- `documentation`: docs/templates only.
- `testing`: test coverage or test infrastructure.
- `good first issue`: small and well-scoped.
- `needs-clarification`: a requirement needs an answer.
- `blocked`: work cannot proceed until a dependency is resolved.

A milestone groups related issues toward a goal. Labels and milestones help triage work; they do not replace clear descriptions.

## 4. Branches

A branch isolates your work from `main`. Use one branch per issue unless the team explicitly asks otherwise.

Branch naming examples:
- `fix/12-reject-whitespace-id`
- `test/14-cover-fetch-failure`
- `docs/15-document-test-workflow`
- `feat/16-add-course-description-search`

Before creating a branch, inspect `git status`. Do not discard changes you do not understand.

## 5. Commits

A commit is a named snapshot of changes. Keep commits focused and explain the intent.

Examples:
- `test: cover whitespace-only course IDs`
- `fix: reject whitespace-only course IDs`
- `docs: clarify pull request testing steps`

Do not claim a test passed if you did not run it. Do not commit generated build output or secrets.

## 6. Pull requests

A **pull request (PR)** asks teammates to review your branch and merge it into the target branch. A PR is not just “my code is done.” It explains why the change exists, what changed, how it was verified, and what reviewers should pay attention to.

A good PR:
- Links the issue, often with `Closes #12`.
- Summarizes the behavior change.
- Lists tests and commands with real outcomes.
- Describes risks, limitations, and deliberate non-changes.
- Includes screenshots for meaningful UI changes when useful.
- Is small enough to review.
- Responds to feedback and keeps the branch up to date according to team practice.

## 7. Review etiquette

When a reviewer leaves a comment:
1. Read it fully.
2. Identify whether it is a question, suggestion, required change, or disagreement.
3. If clear, make the change and reply with what changed.
4. If unclear, ask a focused question.
5. If you disagree, explain the trade-off and provide evidence (tests, API contract, or project convention).
6. Re-run relevant checks after editing.
7. Resolve a conversation only when the concern has actually been addressed, following the team's rules.

Professional response example:

> Good catch. The current test only covers an empty string, not a whitespace-only value. I added a regression test for spaces and tabs, then updated validation to reject IDs with no meaningful characters. `flutter test` passes.

Avoid: “It works on my machine,” “fixed” with no context, or resolving a comment without addressing it.

## 8. How an issue and PR connect

A healthy chain is:

`Issue → branch → failing test/reproduction → implementation → verification → PR → review → merge → issue closed`

Use `Closes #<issue-number>` in the PR description when the PR fully resolves the issue. If it only partially addresses the issue, link it without auto-closing, and explain what remains.

## 9. If you make a mistake

- Wrong branch before committing: check `git status`, then switch/create the correct branch carefully.
- Commit on `main` but not pushed: a branch can usually be created at the commit before moving `main`, but inspect the history first.
- Commit already pushed to shared `main`: do not rewrite shared history casually. Coordinate with the repository owner; a follow-up branch/PR or a revert is often safer.
- Accidentally staged a file: `git restore --staged <path>` unstages it without deleting the working copy.
- Unsure what a command will do: inspect `git status` and ask before using destructive commands.

## 10. Practice repository etiquette

This is your learning repository, but act as if teammates are watching. Keep discussion respectful, state uncertainty honestly, avoid giant unrelated changes, and make the work easy to review.
