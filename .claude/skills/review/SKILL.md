---
name: review
description: Run a multi-agent code review of a pull request, branch, or the current changes. Routes the diff to focused review agents (Rails conventions, security, simplicity, testing), synthesizes findings by severity, and optionally posts them to the PR. Use when asked to review a PR or changes.
argument-hint: "[PR number, GitHub URL, or branch name — omit to review current branch]"
---

# /review

Perform a focused code review using parallel review agents. This is a small,
ERB-based Rails app — keep the review proportional to the change and grounded in
`CLAUDE.md` (the team's conventions). Favor a few high-signal findings over a long
list of nitpicks; `standardrb` already handles formatting.

## 1. Determine the target

Interpret `$ARGUMENTS`:

- **Numeric** (e.g. `42`) → that pull request number.
- **GitHub URL** → that pull request.
- **Branch name** → that branch.
- **Empty** → the current branch's changes vs `main`.

Then get the diff to review:

- **PR**: `gh pr view <n> --json number,title,body,headRefName,files` for metadata,
  and `gh pr diff <n>` for the diff. You don't need to check out the branch — review
  the diff directly. If deeper local inspection is needed, offer to
  `gh pr checkout <n>` first.
- **Branch**: `git diff main...<branch>`.
- **Current branch**: `git diff main...HEAD` (and mention any uncommitted changes
  from `git status`).

If there's no diff to review, say so and stop.

## 2. Classify the changed files

Bucket the changed paths into the categories present in this repo:

- **Ruby** — `app/**/*.rb` (excluding `app/views/`), `lib/`
- **Views** — `app/views/**`, `app/helpers/**`
- **Migrations** — `db/migrate/*.rb`, `db/schema.rb`
- **Tests** — `spec/**`
- **Config** — `config/**`, `Gemfile`, `Gemfile.lock`
- **Routes** — `config/routes.rb`

## 3. Dispatch review agents in parallel

Run only the agents whose trigger categories are present. **Emit all triggered
agents in a single message** (multiple `Agent` tool calls in one assistant turn) so
they run concurrently, then read their results.

Give each agent the diff (or the list of changed files plus instructions to read
them) and the PR title/description for context.

| Agent | Triggers on |
| --- | --- |
| `review-rails` | Ruby, Views, Config, Routes, Migrations |
| `review-security` | Ruby, Views, Config, Migrations |
| `review-simplicity` | Ruby, Views, Tests |
| `review-testing` | Ruby, Views, Tests |

If the change is tiny or docs-only and no category triggers a meaningful agent,
just review it inline rather than spawning agents.

## 4. Assess scope

Before synthesizing, sanity-check the change as a whole (per `CLAUDE.md`):

- Does it do one logical thing? Flag unrelated changes and suggest splitting.
- Watch for scope creep — unrelated deletions/refactors that could mask regressions.
- If the PR is large, note that smaller, incremental PRs are preferred.

## 5. Synthesize findings

Combine the agents' findings:

1. Deduplicate overlapping findings.
2. If agents conflict (e.g. simplicity vs. a security suggestion), state the
   tension and make a recommendation with reasoning.
3. Confirm each finding is real and grounded in the diff — drop anything
   speculative or already handled.
4. Assign a final severity to each.

**Severity:**
- 🔴 **Critical** — blocks merge (broken behavior, security/data exposure).
- 🟠 **Important** — should fix (reliability, convention, missing tests).
- 🟡 **Nice-to-have** — optional (cleanups, minor improvements).

## 6. Present the review

Lead with a short summary table, then the findings grouped by severity.

```markdown
## Code Review — <PR #/branch>: <title>

| Severity | Count | Action |
| --- | --- | --- |
| 🔴 Critical | X | Blocks merge |
| 🟠 Important | X | Recommended |
| 🟡 Nice-to-have | X | Optional |

### 🔴 Critical
- **<title>** — `file:line` — <problem>. <suggestion>

### 🟠 Important
- ...

### 🟡 Nice-to-have
- ...

**Agents run:** review-rails, review-security, ...
```

For each finding give the location, the problem, and a concrete suggestion (a short
code snippet when it helps). Use a collaborative tone — questions over commands
("do we need this?", "we might…") — distinguish blockers from suggestions, and call
out anything done well. If there are no issues, say so clearly.

## 7. Post to the PR (only when reviewing a PR)

Offer to post the review as a PR comment:

- Write the markdown to a temp file and run
  `gh pr comment <n> --body-file <file>`, then remove the temp file.
- Truncate at ~65,000 characters (GitHub's limit) with a note to see the full
  output in the terminal.
- If posting fails, warn but don't fail — the terminal output is the primary
  artifact.

Skip this step for branch / current-branch reviews unless asked.
