# Skill: Smart Commit Messages

## PURPOSE
Analyze code changes and draft precise, meaningful commit messages that describe the "why" not just the "what."

## COMMIT WORKFLOW

### Step 1: Gather Change Context
```bash
# See all changes -- staged, unstaged, untracked
git status

# See what's staged for commit
git diff --cached --stat

# See actual staged content changes
git diff --cached

# See unstaged changes
git diff --stat

# See recent commit style for convention matching
git log --oneline -10
```

### Step 2: Analyze Changes
Categorize what changed:
- **New files**: What feature/module do they add?
- **Modified files**: What behavior changed? Bug fix? Enhancement? Refactor?
- **Deleted files**: What was removed and why?
- **Renamed/moved files**: Restructuring? Refactoring?

### Step 3: Draft Commit Message

#### Conventional Commits Format (if repo uses it)
```
<type>(<scope>): <short description>

<optional body -- explain WHY, not WHAT>

<optional footer -- breaking changes, issue refs>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring without behavior change
- `style`: Formatting, whitespace (no logic change)
- `test`: Adding/updating tests
- `docs`: Documentation changes
- `chore`: Build, config, dependencies
- `perf`: Performance improvement
- `ci`: CI/CD changes

**Examples:**
```
feat(auth): add JWT refresh token rotation

Implement automatic token rotation on refresh to prevent token reuse
attacks. Refresh tokens are now single-use with a 7-day sliding window.

Closes #142
```

```
fix(dashboard): prevent crash when widget data is empty

generateWidgetPayloads was accessing sectionFilters[sectionId] without
checking if builder initialized the filters object. Added null check
with empty object fallback.
```

#### Simple Format (if repo doesn't use conventional commits)
Match whatever `git log --oneline -10` shows. Common patterns:
- `Add user profile page with avatar upload`
- `Fix pagination offset calculation for filtered results`
- `Update dependencies and fix security vulnerabilities`

### Step 4: Present for Approval
Always show the user:
1. Files that will be committed (staged)
2. Files that will NOT be committed (unstaged/untracked)
3. The proposed commit message
4. Ask for confirmation before executing

### Step 5: Execute
```bash
# Stage specific files if needed
git add <files>

# Commit with HEREDOC for multi-line messages
git commit -m "$(cat <<'EOF'
feat(dashboard): add widget configuration panel

Implement configurable widget settings with real-time preview.
Supports chart type selection, axis labels, and color themes.

Closes #287
EOF
)"
```

## SMART MESSAGE RULES

- **Lead with WHY**: "prevent crash when..." not "add null check to..."
- **Be specific**: "fix pagination offset for filtered results" not "fix bug"
- **One logical change per commit**: Don't bundle unrelated changes
- **50/72 rule**: Subject line ≤ 50 chars, body lines ≤ 72 chars
- **Imperative mood**: "add feature" not "added feature" or "adds feature"
- **No period** at end of subject line
- **Reference issues** when applicable: `Closes #123`, `Fixes #456`

## HANDLING MULTIPLE LOGICAL CHANGES

If `git status` shows changes that belong to different logical units:
```
I see changes across multiple concerns:
1. Bug fix in auth module (src/auth/*)
2. New dashboard feature (src/dashboard/*)
3. Updated test fixtures (tests/fixtures/*)

I recommend splitting into 3 commits. Shall I:
A. Stage and commit them separately (recommended)
B. Commit everything together with a broader message
```

## FILES TO NEVER COMMIT (warn user)
- `.env`, `.env.local`, `.env.production`
- `credentials.json`, `service-account.json`
- `*.pem`, `*.key`, private keys
- `node_modules/`, `__pycache__/`, `.venv/`
- `.DS_Store`, `Thumbs.db`
