---
name: error-diagnosis
agent: git-champ
type: workflow
description: "Diagnose git and gh CLI errors, explain them clearly, and provide the correct fix"
---

# Skill: Git Error Diagnosis

## PURPOSE
Diagnose git and gh CLI errors, explain them in plain language, and provide the correct fix.

## COMMON GIT ERRORS

### Authentication & Permission Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `fatal: Authentication failed` | Git can't verify your identity with the remote | `gh auth login` or check SSH keys with `ssh -T git@github.com` |
| `Permission denied (publickey)` | SSH key not recognized by GitHub | Add SSH key: `gh ssh-key add ~/.ssh/id_ed25519.pub` |
| `remote: Permission to X denied to Y` | Your account doesn't have push access to this repo | Check repo permissions, or fork and use fork remote |
| `The requested URL returned error: 403` | Access forbidden -- wrong credentials or no access | Re-authenticate: `gh auth login --hostname github.com` |

### Push/Pull Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `! [rejected] main -> main (non-fast-forward)` | Remote has commits you don't have locally | `git pull --rebase origin main` then push again |
| `error: failed to push some refs` | Same as above -- remote is ahead | Pull first: `git pull` or `git pull --rebase` |
| `fatal: The current branch has no upstream branch` | Branch isn't tracking a remote branch | `git push -u origin HEAD` |
| `CONFLICT (content): Merge conflict in file.ts` | Same lines changed in both branches | Resolve conflicts manually, then `git add` + `git commit` |
| `Your local changes would be overwritten by merge` | You have uncommitted changes that conflict with incoming | `git stash` first, then pull, then `git stash pop` |

### Commit Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `nothing to commit, working tree clean` | No changes to commit | Check if changes are in the right directory |
| `Changes not staged for commit` | Files are modified but not added to staging | `git add <files>` before committing |
| `error: pathspec 'file' did not match any files` | The file path doesn't exist or is misspelled | Check path with `git status` |

### Branch Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `fatal: A branch named 'X' already exists` | Branch name is taken | Choose a different name or delete the old one |
| `error: The branch 'X' is not fully merged` | Trying to delete a branch with unmerged work | Use `-D` to force (after confirming with user) or merge first |
| `fatal: 'X' is not a commit and a branch 'Y' cannot be created from it` | The source ref doesn't exist | Check spelling, run `git fetch` first |

### Rebase Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `CONFLICT during rebase` | Conflicting changes while replaying commits | Resolve, `git add`, `git rebase --continue` |
| `You have unstaged changes. Please commit or stash them` | Can't rebase with uncommitted work | `git stash` first |
| `Cannot rebase: You have unstaged changes` | Same as above | `git stash push -m "pre-rebase"` |

### Stash Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `No stash entries found` | Stash list is empty | Nothing to pop/apply |
| `CONFLICT when applying stash` | Stashed changes conflict with current state | Resolve conflicts, then `git stash drop` the applied stash |

## COMMON GH CLI ERRORS

### Authentication

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `could not determine current user` | gh is not authenticated | `gh auth login` |
| `HTTP 401: Bad credentials` | Token expired or invalid | `gh auth refresh` or `gh auth login` |
| `authentication required` | Not logged in for this host | `gh auth login --hostname <host>` |

### PR Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `GraphQL: No commits between X and Y` | PR branch has no new commits vs base | Ensure you're on the right branch with new commits |
| `a]pull request already exists for this branch` | PR already open | `gh pr view` to see existing PR |
| `pull request create failed: GraphQL: was submitted too quickly` | Rate limited | Wait a moment and retry |
| `Pull request is not mergeable` | Has conflicts or failing checks | Resolve conflicts or fix failing CI |
| `required status check "X" is expected` | CI check hasn't run or is pending | Wait for CI, or push to trigger it |

### Repo Errors

| Error | Plain Language | Fix |
|-------|---------------|-----|
| `could not determine base repo` | Not in a git repo or no remote set | `cd` into repo, or `git remote add origin <url>` |
| `repository not found` | Repo doesn't exist or you don't have access | Check repo name/owner, check permissions |

## DIAGNOSIS WORKFLOW

When an error occurs:

### Step 1: Capture the Error
```bash
# Run the failed command again to capture full output
<command> 2>&1
```

### Step 2: Check State
```bash
# Always check current state after an error
git status
git branch --show-current
git remote -v
```

### Step 3: Explain to User
Format:
```
## Error: [short description]

**What happened:** [plain language explanation]
**Why it happened:** [root cause]
**How to fix it:**
1. [step-by-step fix]
```

### Step 4: Execute Fix (with user approval)
- For safe fixes (pull, fetch, add): execute directly
- For destructive fixes (reset, force push): ask user first

## RECOVERY FROM BAD STATE

### Stuck in Rebase
```bash
# Option 1: Continue (if conflicts are resolved)
git rebase --continue

# Option 2: Abort and go back to before rebase
git rebase --abort
```

### Stuck in Merge
```bash
# Abort the merge
git merge --abort
```

### Stuck in Cherry-Pick
```bash
# Abort the cherry-pick
git cherry-pick --abort
```

### Detached HEAD
```bash
# See where you are
git log --oneline -5

# Option 1: Go back to a branch
git checkout main

# Option 2: Create a branch here (if you made commits)
git checkout -b recovery-branch
```

### Everything Is Broken
```bash
# Nuclear option: reflog shows everything
git reflog

# Find the last known good state and reset to it
git reset --hard HEAD@{N}
```
