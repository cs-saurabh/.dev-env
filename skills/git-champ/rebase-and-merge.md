---
name: rebase-and-merge
agent: git-champ
type: patterns
description: "Handle advanced git history operations safely and correctly"
---

# Skill: Rebase, Merge, and Cherry-Pick

## PURPOSE
Handle advanced git history operations -- rebasing, merging, and cherry-picking -- safely and correctly.

## REBASE

### Interactive Rebase (Clean Up History Before PR)
```bash
# Rebase last N commits interactively
# NOTE: Never use -i flag in automated context. Provide instructions and let user do it,
# or use non-interactive rebase approaches.
git rebase -i HEAD~5  # user must run this manually in their terminal
```

When user wants to squash/reorder commits, explain:
```
Commands available in interactive rebase:
- pick   = keep commit as-is
- squash = merge into previous commit
- fixup  = like squash but discard this commit's message
- reword = keep commit but edit the message
- drop   = remove the commit entirely
- edit   = pause to amend the commit
```

### Non-Interactive Rebase (Sync with Base Branch)
```bash
# Rebase current branch onto main
git fetch origin
git rebase origin/main

# If conflicts occur:
# 1. Resolve conflicts in the files
# 2. git add <resolved-files>
# 3. git rebase --continue

# Abort if things go wrong
git rebase --abort
```

### Rebase vs Merge Decision
```
Use REBASE when:
- Branch is local only (not pushed/shared)
- You want clean, linear history
- Preparing a branch for PR

Use MERGE when:
- Branch has been pushed and others are working on it
- You want to preserve the exact branching history
- Merging a PR into main
```

## MERGE

### Basic Merge
```bash
# Merge feature branch into current branch
git merge feature/widget-config

# Merge with no fast-forward (always create merge commit)
git merge --no-ff feature/widget-config

# Merge but don't auto-commit (review first)
git merge --no-commit feature/widget-config
```

### Handling Merge Conflicts
```bash
# 1. See which files have conflicts
git status

# 2. For each conflicted file, the conflict markers look like:
# <<<<<<< HEAD
# your changes
# =======
# incoming changes
# >>>>>>> feature/branch

# 3. Resolve conflicts manually or with tools

# 4. After resolving:
git add <resolved-files>
git merge --continue   # or git commit
```

### Abort a Merge
```bash
# If merge goes wrong, abort to return to pre-merge state
git merge --abort
```

## CHERRY-PICK

### Pick Specific Commits
```bash
# Cherry-pick a single commit
git cherry-pick <commit-hash>

# Cherry-pick without committing (stage changes only)
git cherry-pick --no-commit <commit-hash>

# Cherry-pick a range of commits
git cherry-pick <oldest-hash>^..<newest-hash>
```

### Cherry-Pick Use Cases
- Backporting a fix from develop to a release branch
- Pulling a specific feature commit into a hotfix branch
- Recovering a commit from a deleted branch

### Cherry-Pick Conflicts
```bash
# If conflict occurs during cherry-pick:
# 1. Resolve conflicts
git add <resolved-files>
git cherry-pick --continue

# Or abort
git cherry-pick --abort
```

## ADVANCED OPERATIONS

### Squash Last N Commits (Non-Interactive)
```bash
# Soft reset to squash last 3 commits into one
git reset --soft HEAD~3
git commit -m "feat(dashboard): implement complete widget system"
```

### Fixup a Previous Commit
```bash
# Stage the fix
git add <fixed-files>

# Create a fixup commit targeting a specific commit
git commit --fixup=<target-commit-hash>

# Then auto-squash (user runs interactively)
git rebase -i --autosquash HEAD~5
```

### Move Commits to a Different Branch
```bash
# Scenario: committed to main by mistake, need to move to feature branch

# 1. Note the commit hashes to move
git log --oneline -5

# 2. Create new branch at current point
git branch feature/accidental-work

# 3. Reset main back
git reset --hard HEAD~N  # N = number of commits to move

# 4. Switch to feature branch
git checkout feature/accidental-work
```

## CONFLICT RESOLUTION CHECKLIST

When conflicts occur during rebase/merge/cherry-pick:
1. Run `git status` to list all conflicted files
2. For each file, show the user the conflict markers
3. Explain what "ours" vs "theirs" means in current context:
   - **During merge**: ours = current branch, theirs = incoming branch
   - **During rebase**: ours = branch being rebased onto, theirs = your commits
   - **During cherry-pick**: ours = current branch, theirs = picked commit
4. Resolve or ask user for guidance on ambiguous conflicts
5. Stage resolved files: `git add <files>`
6. Continue the operation: `git rebase --continue` / `git merge --continue` / `git cherry-pick --continue`

## SAFETY RULES

- **Never rebase commits that have been pushed and shared** -- inform user of consequences
- **Always `git stash` before rebase** to preserve any uncommitted work
- **Always confirm before `git reset --hard`** -- it's irreversible
- **After rebase of pushed branch**, user must force push: warn them
- **Cherry-pick creates duplicate commits** -- note this when cherry-picking between long-lived branches
