---
name: pull-requests
agent: git-champ
type: workflow
description: "Create, manage, review, and merge pull requests using the GitHub CLI"
---

# Skill: Pull Request Management (gh CLI)

## PURPOSE
Create, manage, review, and merge pull requests using the GitHub CLI (`gh`).

## CREATING PULL REQUESTS

### Pre-Flight Checks
Before creating a PR, always:
```bash
# Ensure we're on the correct branch (not main/master)
git branch --show-current

# Ensure all changes are committed
git status

# Ensure branch is pushed to remote
git push -u origin HEAD

# Check if PR already exists for this branch
gh pr status
```

### Create PR
```bash
# Interactive (opens editor for title/body)
gh pr create

# With all flags specified
gh pr create \
  --title "feat(dashboard): add widget configuration panel" \
  --body "$(cat <<'EOF'
## Summary
- Added configurable widget settings with real-time preview
- Supports chart type selection, axis labels, and color themes

## Changes
- `src/dashboard/WidgetConfig.tsx` -- new configuration component
- `src/dashboard/hooks/useWidgetConfig.ts` -- config state management
- `src/api/widgets.ts` -- API endpoints for saving config

## Test Plan
- [ ] Unit tests for WidgetConfig component
- [ ] Integration test for config save/load cycle
- [ ] Manual test: change chart type and verify preview updates

Closes #287
EOF
)" \
  --base main \
  --reviewer teammate1,teammate2 \
  --label "feature,frontend"

# Create draft PR
gh pr create --draft --fill

# Auto-fill from commits
gh pr create --fill
```

### PR Description Best Practices
- **Summary**: 2-3 bullet points of what changed
- **Changes**: List key files and what changed in each
- **Test Plan**: How to verify the changes work
- **Issue Reference**: Link related issues with `Closes #N`
- **Screenshots**: Mention if UI changed (user can add manually)

## VIEWING & MANAGING PRS

### View PR Status
```bash
# See your PR status (current branch, created by you, review requested)
gh pr status

# List open PRs
gh pr list

# List your PRs
gh pr list --author @me

# View specific PR details
gh pr view 123
gh pr view 123 --web  # open in browser

# View PR diff
gh pr diff 123

# View PR checks status
gh pr checks 123
```

### Update PR
```bash
# Edit title/body
gh pr edit 123 --title "new title"
gh pr edit 123 --body "new description"

# Add reviewers
gh pr edit 123 --add-reviewer teammate1

# Add labels
gh pr edit 123 --add-label "needs-review"

# Mark draft as ready for review
gh pr ready 123

# Convert back to draft
gh pr ready 123 --undo
```

## REVIEWING PRS

```bash
# Approve a PR
gh pr review 123 --approve --body "LGTM, clean implementation"

# Request changes
gh pr review 123 --request-changes --body "$(cat <<'EOF'
A few things to address:
- The error handling in `fetchWidgets` should catch network errors
- Missing null check on `config.theme` before accessing `.colors`
EOF
)"

# Leave a comment (no approval/rejection)
gh pr review 123 --comment --body "Looks good overall, one question about the caching approach"

# View PR comments
gh api repos/{owner}/{repo}/pulls/123/comments
```

## MERGING PRS

```bash
# Merge with merge commit
gh pr merge 123 --merge

# Squash and merge (recommended for feature branches)
gh pr merge 123 --squash --delete-branch

# Rebase and merge
gh pr merge 123 --rebase

# Auto-merge when checks pass
gh pr merge 123 --auto --squash

# Disable auto-merge
gh pr merge 123 --disable-auto
```

## PR WORKFLOW PATTERNS

### Standard Feature PR
```bash
# 1. Ensure all work is committed and pushed
git push -u origin HEAD

# 2. Create PR with description
gh pr create \
  --title "feat(module): short description" \
  --body "..." \
  --base main

# 3. After review, squash and merge
gh pr merge --squash --delete-branch
```

### Draft -> Ready Workflow
```bash
# 1. Create draft while work is in progress
gh pr create --draft --fill

# 2. Push more commits as work progresses
# 3. When ready:
gh pr ready
```

### Hotfix PR
```bash
# 1. Create hotfix branch from main
git checkout main && git pull
git checkout -b hotfix/critical-fix

# 2. Make fix, commit, push
git push -u origin HEAD

# 3. Create PR with urgency label
gh pr create \
  --title "fix: critical auth bypass in session validation" \
  --body "..." \
  --label "hotfix,urgent" \
  --reviewer lead-dev
```

## ERROR HANDLING

Common `gh` errors and what to do:

| Error | Cause | Fix |
|-------|-------|-----|
| `GraphQL: No commits between main and branch` | Branch has no new commits | Check if you're on the right branch, or rebase |
| `pull request already exists` | PR already open for this branch | Use `gh pr view` to see it |
| `permission denied` | Not authenticated | Run `gh auth login` |
| `required status check is failing` | CI checks not passing | Fix failing checks, push again |
| `not mergeable` | Conflicts with base branch | Resolve conflicts first |

## SAFETY RULES

- Never merge your own PR without review (unless solo project)
- Always check `gh pr checks` before merging
- Use `--squash` for feature branches to keep clean history
- Use `--delete-branch` to clean up after merge
- For hotfixes, always notify the team (mention in PR body)
