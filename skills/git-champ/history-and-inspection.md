---
name: history-and-inspection
agent: git-champ
type: patterns
description: "Navigate git history, inspect changes, compare branches, and find information across the timeline"
---

# Skill: History, Diffs, and Inspection

## PURPOSE
Navigate git history, inspect changes, compare branches, and find information across the repository timeline.

## VIEWING HISTORY

### Log Formats
```bash
# Compact one-line log
git log --oneline -20

# Detailed log with stats
git log --stat -10

# Graph view (branch topology)
git log --oneline --graph --all --decorate -20

# Log for specific file
git log --oneline -- path/to/file.ts

# Log for specific author
git log --author="saurabh" --oneline -10

# Log with date range
git log --after="2026-01-01" --before="2026-02-01" --oneline

# Log commits that modified a string
git log -S "functionName" --oneline

# Log commits whose diff contains a regex
git log -G "pattern" --oneline
```

### Show Specific Commit
```bash
# Full commit details with diff
git show <commit-hash>

# Just the files changed
git show --stat <commit-hash>

# Show a file at a specific commit
git show <commit-hash>:path/to/file.ts
```

## DIFFS

### Working Directory Diffs
```bash
# Unstaged changes
git diff

# Staged changes (ready to commit)
git diff --cached
git diff --staged   # same as --cached

# All changes (staged + unstaged)
git diff HEAD

# Diff for specific file
git diff -- path/to/file.ts

# Stats only (files changed, insertions, deletions)
git diff --stat
```

### Branch Comparisons
```bash
# What's in feature that's not in main
git diff main..feature/widget-config

# What changed since branching from main
git diff main...feature/widget-config

# Just file names that differ
git diff --name-only main..feature/widget-config

# Stat summary
git diff --stat main..feature/widget-config
```

### Commit Comparisons
```bash
# Diff between two commits
git diff <commit1>..<commit2>

# What changed in the last commit
git diff HEAD~1..HEAD
```

## FINDING THINGS

### Blame (Who Changed What)
```bash
# See who last modified each line
git blame path/to/file.ts

# Blame specific line range
git blame -L 50,80 path/to/file.ts

# Ignore whitespace changes in blame
git blame -w path/to/file.ts
```

### Bisect (Find Bug-Introducing Commit)
```bash
# Start bisect
git bisect start

# Mark current as bad
git bisect bad

# Mark known good commit
git bisect good <known-good-hash>

# Git checks out middle commit -- test it, then:
git bisect good   # if this commit is fine
git bisect bad    # if this commit has the bug

# When found, git reports the first bad commit

# Clean up
git bisect reset
```

### Search Across History
```bash
# Find commits that added/removed a string
git log -S "searchTerm" --oneline

# Find commits where diff matches regex
git log -G "regex_pattern" --oneline

# Find when a file was deleted
git log --diff-filter=D --summary -- "**/filename.ts"

# Find when a file was added
git log --diff-filter=A --summary -- "**/filename.ts"
```

## STATUS AND STATE

### Current State
```bash
# Full status
git status

# Short status
git status -s

# Show current branch and tracking info
git status -b -s
```

### Remote State
```bash
# List remotes
git remote -v

# Show remote details
git remote show origin

# Check what would be fetched
git fetch --dry-run
```

### Tags
```bash
# List tags
git tag -l

# List tags matching pattern
git tag -l "v1.*"

# Show tag details
git show v1.2.3

# Create annotated tag
git tag -a v1.2.3 -m "Release 1.2.3"

# Push tags
git push --tags
git push origin v1.2.3  # specific tag
```

## USEFUL COMBINATIONS

### "What did I do today?"
```bash
git log --author="$(git config user.name)" --after="midnight" --oneline
```

### "What's different between my branch and main?"
```bash
git log --oneline main..HEAD
git diff --stat main...HEAD
```

### "Who last modified this function?"
```bash
git log -S "functionName" --oneline
git blame -L <start>,<end> path/to/file.ts
```

### "What branches contain this commit?"
```bash
git branch --contains <commit-hash>
```

### "Show me the file at a previous point"
```bash
git show HEAD~5:path/to/file.ts
```
