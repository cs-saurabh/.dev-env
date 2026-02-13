# Skill: GitHub CLI Workflows (Issues, Releases, Actions)

## PURPOSE
Handle GitHub-specific workflows beyond PRs -- issues, releases, workflow runs, gists, and repo management using `gh` CLI.

## ISSUES

### Create Issues
```bash
# Create with title and body
gh issue create \
  --title "Bug: dashboard crashes on empty dataset" \
  --body "$(cat <<'EOF'
## Description
The dashboard crashes when a widget receives an empty dataset from the API.

## Steps to Reproduce
1. Create a new dashboard
2. Add a chart widget
3. Don't configure a data source
4. Click "Preview"

## Expected Behavior
Should show an empty state placeholder

## Actual Behavior
White screen with console error: `Cannot read property 'map' of undefined`
EOF
)" \
  --label "bug,dashboard" \
  --assignee @me
```

### Manage Issues
```bash
# List open issues
gh issue list

# List issues assigned to you
gh issue list --assignee @me

# View issue details
gh issue view 456

# Close issue
gh issue close 456 --reason completed

# Reopen issue
gh issue reopen 456

# Add comment
gh issue comment 456 --body "Fixed in PR #789"

# Edit issue
gh issue edit 456 --add-label "in-progress"
```

## RELEASES

### Create Release
```bash
# Create release from tag
gh release create v1.2.3 \
  --title "Release 1.2.3" \
  --notes "$(cat <<'EOF'
## What's New
- Added widget configuration panel (#287)
- Fixed dashboard crash on empty dataset (#456)

## Breaking Changes
- None

## Upgrade Notes
- Run `npm install` to get new dependencies
EOF
)"

# Create release with auto-generated notes
gh release create v1.2.3 --generate-notes

# Create draft release
gh release create v1.2.3 --draft --generate-notes

# Upload assets to release
gh release upload v1.2.3 ./dist/app.zip ./dist/checksums.txt
```

### Manage Releases
```bash
# List releases
gh release list

# View release
gh release view v1.2.3

# Delete release
gh release delete v1.2.3

# Download release assets
gh release download v1.2.3
```

## GITHUB ACTIONS / WORKFLOW RUNS

### View Workflow Runs
```bash
# List recent workflow runs
gh run list

# List runs for specific workflow
gh run list --workflow=ci.yml

# View specific run details
gh run view <run-id>

# View run logs
gh run view <run-id> --log

# Watch a running workflow (live updates)
gh run watch <run-id>
```

### Trigger Workflows
```bash
# Trigger workflow dispatch
gh workflow run deploy.yml

# Trigger with inputs
gh workflow run deploy.yml -f environment=staging -f version=1.2.3

# List available workflows
gh workflow list
```

### Re-run Failed Workflows
```bash
# Re-run all jobs
gh run rerun <run-id>

# Re-run only failed jobs
gh run rerun <run-id> --failed
```

## GISTS

```bash
# Create gist from file
gh gist create path/to/file.ts --desc "Utility function for date formatting"

# Create public gist
gh gist create --public path/to/file.ts

# Create gist from multiple files
gh gist create file1.ts file2.ts

# List your gists
gh gist list

# View gist
gh gist view <gist-id>

# Edit gist
gh gist edit <gist-id>
```

## REPO MANAGEMENT

```bash
# Clone a repo
gh repo clone owner/repo

# Fork a repo
gh repo fork owner/repo --clone

# Create a new repo
gh repo create my-new-project --public --clone

# View repo info
gh repo view

# Open repo in browser
gh repo view --web

# Sync fork with upstream
gh repo sync owner/fork
```

## API ACCESS (Advanced)

```bash
# Make arbitrary GitHub API calls
gh api repos/{owner}/{repo}/pulls/123/comments

# POST request
gh api repos/{owner}/{repo}/issues -f title="New issue" -f body="Description"

# With pagination
gh api repos/{owner}/{repo}/issues --paginate

# GraphQL query
gh api graphql -f query='
  query {
    repository(owner: "owner", name: "repo") {
      pullRequests(last: 5, states: OPEN) {
        nodes { title number }
      }
    }
  }
'
```

## COMPOSITE WORKFLOWS

### Full Feature Delivery
```bash
# 1. Create issue for tracking
gh issue create --title "feat: widget config" --assignee @me --label feature

# 2. Create branch, implement, commit (handled by other skills)

# 3. Create PR linking the issue
gh pr create --title "feat(dashboard): add widget config" --body "Closes #<issue>"

# 4. After approval, merge
gh pr merge --squash --delete-branch

# 5. Create release if needed
gh release create v1.3.0 --generate-notes
```

### Quick Hotfix Delivery
```bash
# 1. Branch from main
git checkout main && git pull
git checkout -b hotfix/fix-auth-bypass

# 2. Fix, commit, push
git push -u origin HEAD

# 3. Create urgent PR
gh pr create --title "fix: critical auth bypass" --label "hotfix,urgent" --reviewer lead

# 4. After approval, merge immediately
gh pr merge --merge --delete-branch

# 5. Tag the fix
git checkout main && git pull
git tag -a v1.2.4 -m "Hotfix: auth bypass"
git push --tags
```
