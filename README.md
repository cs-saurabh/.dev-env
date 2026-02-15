# Agentic Development Environment

Orchestrator-first agentic development setup for Cursor and Claude Code.

## Architecture

The main agent in every session acts as an **orchestrator** -- it classifies intent, plans execution pipelines, delegates to specialized subagents, brokers context between them, and presents final results. It never executes tasks directly (except trivial questions).

```
claude-mem (persistent memory)
    |
    V
ORCHESTRATOR (main agent)
├── codebase-intelligence  (understand code)
├── planning               (break down tasks)
├── implementation         (write code)
├── code-review            (review quality)
├── debugging              (diagnose bugs)
├── infrastructure         (DevOps/Docker/CI)
├── docs-and-contracts     (documentation)
├── config-master          (dev-env self-management)
└── library-experts/       (library source code experts, user-specific)
```

## Directory Structure

```
~/.dev-env/
├── orchestrator/
│   ├── cursor-orchestrator-rule.md    # Cursor alwaysApply rule
│   ├── claude-orchestrator.md         # Claude Code CLAUDE.md content
│   ├── manifest.yaml                  # Shared: agents, pipelines, signals (git tracked)
│   └── manifest.local.yaml           # Local: projects, library experts (gitignored)
├── agents/
│   ├── codebase-intelligence.md       # Agent definitions
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
│       └── _template.md               # Template for new library experts
├── skills/                            # Agent-scoped skills
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

## Setup

### 1. Link a Project

Run the setup script for each project repo:

```bash
~/.dev-env/setup-project.sh ~/Work/projects/your-project
```

This creates:
- `.cursor/rules/orchestrator.md` -> symlink to orchestrator rule
- `.claude/agents/` -> symlink to agent definitions
- `CLAUDE.md` -> references the orchestrator prompt

### 2. Update the Local Manifest

Edit `~/.dev-env/orchestrator/manifest.local.yaml` to add your project. This file is gitignored -- it's your personal setup.

If the file doesn't exist yet, create it:

```yaml
# Local manifest -- your projects and library experts (gitignored)
projects:
  - name: your-project
    repo_path: ~/Work/projects/your-project
    stack: React, TypeScript
    summary: "Brief description of what this project does"
    related_to: [related-project-name]

library_experts: []
```

### 3. Start Working

Open your project in Cursor or Claude Code. The orchestrator is automatically active. Just describe your task naturally -- the orchestrator will classify it, select the right pipeline, and delegate to specialized agents.

## Manifest Split (Shared vs Local)

The manifest is split into two files for shareability:

| File | Content | Git Tracked |
|------|---------|-------------|
| `manifest.yaml` | Agents, pipeline patterns, complexity signals | Yes (shared) |
| `manifest.local.yaml` | Your projects, your library experts | No (gitignored) |

When you clone this repo, you get all the agents, skills, and pipelines ready to go. You just need to create your own `manifest.local.yaml` with your projects and library experts (see step 2 above).

## Managing the Dev-Env

Instead of manually editing files, just talk to the orchestrator:

```
"Add my new project argus-frontend to the manifest"
"Create a library expert for our shared-utils package at ~/Work/projects/shared-utils"
"Write a react-patterns skill for the implementation agent"
"Add a migration agent that handles database migrations"
```

The orchestrator routes these to the **config-master** agent, which reads, creates, and updates files in `~/.dev-env/` automatically.

## Adding a New Library Expert

1. Copy the template:
   ```bash
   cp ~/.dev-env/agents/library-experts/_template.md ~/.dev-env/agents/library-experts/your-lib-expert.md
   ```
2. Edit the new file -- replace `{LIBRARY_NAME}`, `{LIBRARY_DISPLAY_NAME}`, `{SOURCE_PATH}`
3. Add the library expert to `manifest.local.yaml` under `library_experts`

## Adding Skills (Follow-Up)

Skills are agent-scoped instruction files that live in `~/.dev-env/skills/{agent-name}/`. Each agent's system prompt references its skills directory. Skills are loaded on-demand when the agent spins up.

To author a new skill, create a markdown file in the appropriate skills directory. The agent will discover and load it automatically.

## How It Works

1. You type a task in Cursor/Claude Code
2. The orchestrator classifies the intent and complexity
3. It selects a pipeline pattern from the manifest (e.g., codebase-intelligence -> planning -> implementation)
4. It runs pre-flight clarification if the task is ambiguous
5. It delegates to each agent in the pipeline, brokering context between them
6. It presents the final result to you
7. claude-mem captures the session for future memory
