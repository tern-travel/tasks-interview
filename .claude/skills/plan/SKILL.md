---
name: plan
description: Plan the implementation approach for a task before writing code. Enters Plan mode, explores the codebase, designs an approach, and presents it for approval before any implementation. Use before starting any non-trivial work.
argument-hint: "[task description or ticket context]"
allowed-tools: Read, Grep, Glob, Bash, Agent, EnterPlanMode, ExitPlanMode, AskUserQuestion
model: inherit
---

# Implementation Planning

Plan the approach for a task before writing any code. This is a small ERB-based
Rails app — keep the plan proportional to the work and grounded in `CLAUDE.md`
(the team's conventions). Favor reusing existing code over inventing new patterns.

## Input

<task_input>$ARGUMENTS</task_input>

## Guidance: briefing subagents

When you launch `Explore` or `Plan` agents (via the `Agent` tool), they start fresh
with zero context — they haven't seen this conversation. Brief each one like a
colleague who just walked in: what you're trying to accomplish and why, what you've
already learned or ruled out, and the specific files/areas to look at. Terse prompts
produce shallow work. Never offload synthesis onto an agent ("based on your
findings, implement it") — do the understanding yourself and tell the agent exactly
what you need.

## Step 1: Enter Plan mode

Call `EnterPlanMode` before doing anything else. Plan mode is **read-only**: you
will explore and design, but make no edits, commits, or other changes until the
user approves the plan and you exit plan mode.

## Step 2: Understand the request

Understand the task and the code around it. **Use only `Explore` agents here.**

- Launch **1 agent by default** (work in this app is usually isolated). Use up to
  **2 in parallel** (single message, multiple tool calls) only when scope is
  uncertain or several areas are involved.
- Actively look for existing controllers, models, helpers, partials, and patterns
  to reuse — don't propose new code when something suitable already exists.

## Step 3: Design the approach (skip for trivial tasks)

For anything non-trivial, launch **1 `Plan` agent** (up to 2 for a larger change
that benefits from comparing approaches) to design the implementation. Give it the
full context from Step 2 — file paths, code traces, requirements, constraints — and
ask for a concrete, step-by-step plan. Skip this step for typo fixes, one-liners,
or simple renames and design it yourself.

## Step 4: Clarify

Read the key files the agents flagged to confirm your understanding. Check the
emerging plan against the original request, and use `AskUserQuestion` to resolve
any remaining ambiguity before presenting.

## Step 5: Present the plan for approval

Call `ExitPlanMode` with a clear, scannable plan that covers:

- **Context** — why this change is being made: the problem and the intended outcome.
- **Approach** — your recommended approach only (not every alternative considered).
- **Changes** — the files to add or modify and what changes in each, referencing
  existing code to reuse (with file paths).
- **Testing** — how to verify end-to-end: which RSpec specs to add/run and the
  manual steps to confirm it works in the app.

The plan is ready when it covers what to change, which files, what existing code to
reuse, and how to verify — with all ambiguities resolved. If the user requests
changes, refine the plan and call `ExitPlanMode` again. Begin implementation only
after they approve.
