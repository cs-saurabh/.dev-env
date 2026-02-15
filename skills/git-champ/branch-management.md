---
name: branch-management
agent: git-champ
type: patterns
description: "Handle all branch operations including creating, switching, tracking, deleting, and renaming"
---

# Skill: Branch Management

## PURPOSE
Handle all branch operations -- creating, switching, tracking, deleting, renaming, and managing remote branches.

## COMMON OPERATIONS

### Create and Switch to New Branch
```bash
# From current branch
git checkout -b feature/widget-config

# From a specific branch
git checkout -b feature/widget-config origin/develop

# Using switch (modern syntax)
git switch -c feature/widget-config
```

### Branch Naming Conventions
Follow the repo's convention. Common patterns:
- `feature/description` -- new feature
- `fix/description` -- bug fix
- `hotfix/description` -- urgent production fix
- `refactor/description` -- code restructuring
- `chore/description` -- maintenance tasks

### List Branches
```bash
git branch              # local branches
git branch -r           # remote branches
git branch -a           # all branches
git branch -v           # with last commit info
git branch --merged     # branches merged into current
git branch --no-merged  # branches not yet merged
```

### Delete Branches
```bash
# Delete local branch (safe -- won't delete if unmerged)
git branch -d feature/old-feature

# Delete local branch (force -- even if unmerged, CONFIRM WITH USER FIRST)
git branch -D feature/old-feature

# Delete remote branch
git push origin --delete feature/old-feature
```

### Track Remote Branch
```bash
# Set upstream for current branch
git push -u origin feature/widget-config

# Track existing remote branch
git branch --set-upstream-to=origin/feature/widget-config
```

### Rename Branch
```bash
# Rename current branch
git branch -m new-name

# Rename specific branch
git branch -m old-name new-name

# Update remote after rename
git push origin --delete old-name
git push -u origin new-name
```

### Sync with Remote
```bash
# Fetch all remote changes (doesn't merge)
git fetch --all --prune

# Pull current branch
git pull

# Pull with rebase (cleaner history)
git pull --rebase

# Update local branch from remote
git fetch origin && git merge origin/main
```

## BRANCH WORKFLOW PATTERNS

### Feature Branch Workflow
```bash
# Start feature from latest main
git checkout main && git pull
git checkout -b feature/new-feature

# Work, commit, push
git push -u origin feature/new-feature

# When ready, create PR
gh pr create --base main
```

### Keeping Feature Branch Up to Date
```bash
# Option A: Merge main into feature (preserves history)
git checkout feature/my-feature
git merge main

# Option B: Rebase onto main (cleaner history, only if not shared)
git checkout feature/my-feature
git rebase main
```

## SAFETY PROTOCOLS

- Before deleting: check if branch has unmerged commits (`git branch --no-merged`)
- Before force operations: always `git stash` uncommitted work first
- Before rebasing: confirm branch hasn't been pushed/shared with others
- Always `git fetch --prune` before listing remote branches to get current state
