# Agentic Development Environment

An orchestrator-first agentic development setup for **Cursor** and **Claude Code**. Instead of talking to a single AI agent, your IDE session runs a central **orchestrator** that classifies your intent, selects the right pipeline, and delegates to specialized subagents -- codebase exploration, planning, implementation, code review, debugging, and more.

You clone this repo once into `~/.dev-env/`, then link any of your project repos to it. Every linked project gets the full orchestrator + agent infrastructure without duplicating anything.

## Quick Start

### 1. Clone to `~/.dev-env/`

```bash
git clone https://github.com/<your-username>/dev-env.git ~/.dev-env
```

> The repo **must** live at `~/.dev-env/`. All orchestrator rules, agent definitions, and the setup script reference this path.

### 2. Run the setup script on your project

For every project repo you want to connect to the orchestrator, run:

```bash
~/.dev-env/setup-project.sh /path/to/your/project
```

You can also run it from inside a project directory:

```bash
cd ~/Work/projects/my-app
~/.dev-env/setup-project.sh .
```

**What the script does:**

| What it creates (in your project) | Points to |
|---|---|
| `.cursor/rules/orchestrator.md` (symlink) | `~/.dev-env/orchestrator/cursor-orchestrator-rule.md` |
| `.claude/agents/` (symlink) | `~/.dev-env/agents/` |
| `CLAUDE.md` (new file) | References `~/.dev-env/orchestrator/claude-orchestrator.md` |

- **Cursor** picks up the orchestrator rule from `.cursor/rules/` automatically (it's set to `alwaysApply: true`).
- **Claude Code** reads `CLAUDE.md` at session start and follows the orchestrator prompt inside it.
- Both IDEs end up loading the same orchestrator logic and the same agent definitions.

> **Note:** The script is safe to re-run. It updates existing symlinks and won't overwrite a `CLAUDE.md` that already exists (it will tell you if you need to add the orchestrator reference manually).

### 3. Create your local manifest

The orchestrator loads **two** manifest files:

| File | What it contains | Git tracked? |
|---|---|---|
| `orchestrator/manifest.yaml` | Agent registry, pipeline patterns, complexity signals | **Yes** -- shared with anyone who clones the repo |
| `orchestrator/manifest.local.yaml` | Your projects, your library experts | **No** -- gitignored, personal to you |

Since `manifest.local.yaml` is gitignored, it won't exist after a fresh clone. Create it:

```bash
touch ~/.dev-env/orchestrator/manifest.local.yaml
```

Then add your projects:

```yaml
# Local manifest -- your projects and library experts (gitignored)
projects:
  - name: my-app
    repo_path: ~/Work/projects/my-app
    stack: React, TypeScript
    summary: "Brief description of what this project does"
    related_to: []

  - name: my-api
    repo_path: ~/Work/projects/my-api
    stack: NestJS, PostgreSQL
    summary: "Backend API for my-app"
    related_to: [my-app]

library_experts: []
```

The orchestrator uses this to understand your project portfolio, route tasks to the right repos, and broker context across repos.

**Alternative -- let the orchestrator do it for you:** Instead of manually editing `manifest.local.yaml`, you can open any already-linked project in Cursor/Claude Code and just prompt:

```
"Add ~/Work/projects/my-app to the manifest"
```

The orchestrator will scan the repo with `codebase-intelligence` to auto-detect the stack and generate a summary, then hand off to the `config-master` agent to update the manifest and run the setup script -- all from a single prompt.

### 4. (Optional) Fill in your CLAUDE.md

The setup script creates a `CLAUDE.md` in your project with placeholder fields. Open it and fill in your project details:

```markdown
Read and follow all instructions in @~/.dev-env/orchestrator/claude-orchestrator.md

# Project Context

## Project
- Name: my-app
- Stack: React, TypeScript, Vite
- Description: Customer-facing dashboard application
```

This gives Claude Code project-specific context at session start.

### 5. Open your project and start working

Open the project in **Cursor** or **Claude Code**. The orchestrator is automatically active. Just describe your task naturally:

```
"How does the authentication flow work?"
"Add pagination to the users endpoint"
"Fix the bug where CSV export hangs on large datasets"
"Review my changes before I push"
"Commit my changes"
```

The orchestrator classifies your intent, selects the right agent pipeline, and handles it.

## How the Orchestrator Works

The orchestrator is the main agent in every session. It **never writes code directly** (except for trivial questions it can answer from memory). Instead, it:

1. **Classifies** your request -- what type of task, which repo(s), how complex
2. **Selects a pipeline** -- a sequence of specialized agents from the manifest
3. **Clarifies** ambiguity before dispatching any agent
4. **Delegates** to each agent in order, passing context between them
5. **Presents** the final result back to you

```
You (natural language task)
    |
    V
ORCHESTRATOR (classifies intent, selects pipeline, brokers context)
    |
    ├── codebase-intelligence  → understand existing code
    ├── planning               → break down complex tasks
    ├── implementation         → write/refactor code
    ├── code-review            → review quality & security
    ├── debugging              → diagnose bugs
    ├── infrastructure         → Docker, CI/CD, deployment
    ├── docs-and-contracts     → API docs, tech design docs
    ├── git-champ              → commits, branches, PRs, all git operations
    ├── git-conflict-resolver  → resolve merge/rebase conflicts
    ├── config-master          → manage the dev-env itself
    └── library-experts/       → per-library source code experts (user-specific)
```

### Pipeline Examples

The orchestrator picks the pipeline based on what you ask:

| You say | Pipeline |
|---|---|
| "How does the auth flow work?" | `codebase-intelligence` |
| "Add pagination to users API" | `codebase-intelligence → planning → implementation` |
| "Fix the broken CSV export" | `debugging → implementation` |
| "Review my changes" | `code-review` |
| "Commit my changes" | `git-champ` |
| "Resolve the merge conflicts" | `git-conflict-resolver` |
| "Dockerize the ETL service" | `infrastructure` |
| "Build the analytics dashboard" | `codebase-intelligence → planning → implementation → code-review` |
| "Add my new project to the manifest" | `codebase-intelligence → config-master` |
| "Create a library expert for shared-utils" | `codebase-intelligence → config-master` |

For simple tasks, it skips unnecessary agents. For complex tasks, it uses the full pipeline. The pipeline patterns are all defined in `manifest.yaml`.

## Directory Structure

```
~/.dev-env/
├── orchestrator/
│   ├── cursor-orchestrator-rule.md    # Cursor alwaysApply rule (symlinked into projects)
│   ├── claude-orchestrator.md         # Claude Code orchestrator prompt (referenced by CLAUDE.md)
│   ├── manifest.yaml                  # Shared: agent registry, pipelines, signals (git tracked)
│   └── manifest.local.yaml           # Local: your projects, library experts (gitignored)
├── agents/
│   ├── codebase-intelligence.md       # Agent system prompts
│   ├── planning.md
│   ├── implementation.md
│   ├── code-review.md
│   ├── debugging.md
│   ├── infrastructure.md
│   ├── docs-and-contracts.md
│   ├── git-champ.md
│   ├── git-conflict-resolver.md
│   ├── config-master.md               # Dev-env self-management agent
│   └── library-experts/
│       └── _template.md               # Template for creating new library experts
├── skills/                            # Agent-scoped skill files (loaded on-demand)
│   ├── codebase-intelligence/
│   ├── planning/
│   ├── implementation/
│   ├── code-review/
│   ├── debugging/
│   ├── infrastructure/
│   ├── docs-and-contracts/
│   ├── git-champ/
│   ├── git-conflict-resolver/
│   └── library-experts/
├── setup-project.sh                   # Per-project setup script
└── README.md                          # This file
```

## Managing the Dev-Env

You don't need to edit files manually. Just talk to the orchestrator -- it routes dev-env management tasks to the **config-master** agent:

```
"Add ~/Work/projects/my-new-app to the manifest"
"Create a library expert for our shared-utils package at ~/Work/projects/shared-utils"
"Write a react-patterns skill for the implementation agent"
"Add a migration agent that handles database migrations"
"Update the pipeline for code review tasks"
```

The config-master reads, creates, and updates files in `~/.dev-env/` automatically. When you ask to add a new project, the orchestrator first scans the repo with `codebase-intelligence` to auto-detect the stack and generate a summary, then hands off to `config-master` to update the manifest and run the setup script.

## Adding Library Experts

Library experts are specialized agents that understand a specific library's source code. They help you consume library components correctly or contribute changes to the library.

To add one manually:

1. Copy the template:
   ```bash
   cp ~/.dev-env/agents/library-experts/_template.md ~/.dev-env/agents/library-experts/your-lib.md
   ```
2. Edit the new file -- replace `{LIBRARY_NAME}`, `{LIBRARY_DISPLAY_NAME}`, `{SOURCE_PATH}`
3. Add the entry to `manifest.local.yaml` under `library_experts`:
   ```yaml
   library_experts:
     - name: your-lib-expert
       source_path: ~/Work/projects/your-lib
       description: "Expert on your-lib"
       skills_dir: ~/.dev-env/skills/library-experts/
       skills:
         - source-reading
         - usage-pattern-extraction
   ```

Or just ask the orchestrator: `"Create a library expert for your-lib at ~/Work/projects/your-lib"` and it will do all of this for you.

## Adding Skills

Skills are agent-scoped instruction files that live in `~/.dev-env/skills/{agent-name}/`. Each agent's system prompt references its skills directory. Skills are loaded on-demand when the agent spins up.

To author a new skill, create a markdown file in the appropriate skills directory. The agent will discover and load it automatically. Or ask the orchestrator to write one for you.

## What Gets Committed to Git (and What Doesn't)

| Git tracked (shared) | Gitignored (personal) |
|---|---|
| `orchestrator/manifest.yaml` | `orchestrator/manifest.local.yaml` |
| `orchestrator/cursor-orchestrator-rule.md` | `agents/library-experts/*` (except `_template.md`) |
| `orchestrator/claude-orchestrator.md` | |
| All agent definitions in `agents/` | |
| All skills in `skills/` | |
| `setup-project.sh` | |

When you clone this repo, you get all agents, skills, and pipeline patterns ready to go. You just need to create your `manifest.local.yaml` and link your projects.
