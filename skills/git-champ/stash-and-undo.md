# Skill: Stash and Undo Operations

## PURPOSE
Safely stash work-in-progress and undo commits/changes without losing data.

## STASH OPERATIONS

### Save Work in Progress
```bash
# Stash all tracked changes (staged + unstaged)
git stash

# Stash with a descriptive message (recommended)
git stash push -m "WIP: dashboard filter refactor"

# Stash including untracked files
git stash push -u -m "WIP: including new test files"

# Stash only specific files
git stash push -m "WIP: only auth changes" -- src/auth/
```

### Restore Stashed Work
```bash
# Apply most recent stash (keeps it in stash list)
git stash apply

# Apply and remove from stash list
git stash pop

# Apply a specific stash
git stash apply stash@{2}

# Apply specific stash and remove it
git stash pop stash@{2}
```

### Manage Stash List
```bash
# List all stashes
git stash list

# Show stash contents
git stash show            # summary
git stash show -p         # full diff
git stash show stash@{1}  # specific stash

# Drop a stash
git stash drop stash@{0}

# Clear all stashes (DESTRUCTIVE -- confirm with user)
git stash clear
```

## UNDO OPERATIONS

### Undo Last Commit (Keep Changes)
```bash
# Undo last commit, keep changes staged
git reset --soft HEAD~1

# Undo last commit, keep changes unstaged
git reset HEAD~1          # same as --mixed

# Undo last N commits
git reset --soft HEAD~3   # undo last 3 commits
```

### Undo Last Commit (Discard Changes -- DANGEROUS)
```bash
# ALWAYS CONFIRM WITH USER FIRST
# This permanently destroys the commit and all changes
git reset --hard HEAD~1
```

### Undo Staged Changes (Unstage)
```bash
# Unstage a specific file
git restore --staged path/to/file.ts

# Unstage all files
git restore --staged .
```

### Undo Unstaged Changes (Discard Modifications)
```bash
# CONFIRM WITH USER -- this discards work
# Discard changes to specific file
git restore path/to/file.ts

# Discard all unstaged changes
git restore .
```

### Undo a Pushed Commit (Safe -- Creates Revert Commit)
```bash
# Revert a specific commit (creates a new commit that undoes it)
git revert <commit-hash>

# Revert last commit
git revert HEAD

# Revert without auto-committing (review first)
git revert --no-commit <commit-hash>
```

### Recover Deleted Commits (Reflog)
```bash
# Find the lost commit
git reflog

# Restore to a specific reflog entry
git reset --hard HEAD@{3}

# Or create a new branch at the lost commit
git checkout -b recovery-branch HEAD@{3}
```

## UNDO DECISION TREE

```
Want to undo a commit?
├── Was it pushed to remote?
│   ├── YES: Use `git revert` (safe, creates new commit)
│   └── NO: Use `git reset --soft HEAD~1` (keeps changes)
│
Want to discard all uncommitted work?
├── Staged changes: `git restore --staged .`
├── Unstaged changes: `git restore .` (CONFIRM WITH USER)
└── Both + untracked: `git reset --hard && git clean -fd` (VERY DANGEROUS)

Want to save work for later?
└── Use `git stash push -m "description"`
```

## SAFETY RULES

- **Always `git stash` before any reset/rebase/undo** to preserve a safety net
- **Never `git reset --hard` without confirming with user** -- it destroys work
- **Prefer `git revert` for pushed commits** -- don't rewrite shared history
- **Use `git reflog` to recover** -- git rarely truly deletes data within 30 days
- **Show what will be lost** before any destructive operation
