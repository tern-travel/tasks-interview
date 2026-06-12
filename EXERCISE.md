# The Exercise

This is the spec for the pair-programming interview. Read it end to end before
you start building — and skim [`README.md`](README.md) and [`CLAUDE.md`](CLAUDE.md)
first, since they describe how to run the app and how we write code here.

## What we're actually evaluating

We expect you to use AI (Claude Code or your tool of choice) — that's the point.
We are **not** scoring you on raw feature count. We're watching how you *operate*:

- **Scoping** — how you break the work into pieces and sequence them.
- **Driving the AI** — the context, files, and constraints you give it, and how
  you pull it back when it drifts.
- **Verifying** — whether you read the diff critically, run the app, and write
  tests against output you're unsure of.
- **Judgment** — the calls you make when the spec is ambiguous or the AI is
  wrong, and the trade-offs you can articulate.

Finishing every feature with code you can't defend is a weaker result than
finishing fewer with code you can stand behind. Talk us through your thinking as
you go.

## How we'd like you to work

- **Parallelize.** Several of the work areas below are independent. We want to
  see you move more than one forward at once — multiple Claude Code sessions,
  git worktrees, or multiple checkouts — while keeping each stream coherent.
- **Small PRs.** Create a personal base branch off `main` (e.g. your username)
  and open a **branch and PR per area** against it, rather than one giant diff.
- **Use the repo's tooling.** This repo ships `/plan` and `/review` Claude Code
  skills (see the README). We'd genuinely like to see you use them.
- **Reserve time to harden.** Before we review, pick the weakest thing the AI
  produced and improve it. Be ready to walk us through what you changed and why.

## The work

The features are grouped into areas. Within an area the pieces are related and
tend to touch the same files; across areas they're mostly independent — that's
the seam to parallelize along.

### 1. Task lifecycle

Foundational, and several later areas build on it.

- Allow a task to be **marked complete** (and un-completed) from the index.
- **Require a title** on every task. Handle the validation-failure path on both
  create and update — the controller currently has empty `# TODO` branches, so a
  failed save silently does nothing. The user should see what went wrong.

### 2. Assignment

- Let a user **assign a task to any user** in the system, and show the assignee
  on the index.
- Acceptance: the index should still render efficiently with the seeded data —
  don't introduce a query per task to show assignees.

### 3. Due dates, "Due Soon", and reminders

The meatiest area — the schema, the index query, and a mailer all hang off the
same new field, so think about the order you build these in.

- Let a user add a **due date** to a task.
- **"Due Soon"** — a section on the index showing tasks assigned to the current
  user that are due within the next 7 days. Decide what "within 7 days" means at
  the edges (does a task due today count? one due exactly 7 days out? one that's
  already overdue?) and make your choice deliberate — we'll ask.
- **Reminder email** — send the assignee an email the day before a task is due.
  Think about how you'd *verify* this works without waiting until tomorrow.

The seed data only fills in the columns that ship with the app, so once you add
a due date you'll have no tasks that are actually "due soon." Creating the data
you need to see and verify these features is part of the task.

### 4. List management

- **Filter** the task list by title.
- **Order** the list by name or by due date.
- The title is now searched on — consider what that means for the database. Note
  the seed data includes mixed-case titles; decide how sorting and filtering
  should treat case.

### 5. Make it stand out

Independent of the above and easy to parallelize.

- A **user profile page** with the ability to **upload an avatar**.
- **Spruce up the UI** with Tailwind — make it pop.
- A **GitHub Action** that runs the test suite on PRs.

### 6. Overdue tasks

Overdue tasks should **stand out** to the user. We've left this one deliberately
underspecified — decide what it should mean and where it belongs, and either ask
us or state your assumptions, the way you would with a thin ticket.

## Tests

Cover behavior you add or change — happy path and failure path. At minimum:

- A task's title is required.
- The index page loads and displays the seeded tasks.
- A task can be created through the form and then appears on the index.

We care more about tests that pin down real behavior (and that you can explain)
than about coverage for its own sake. Scrutinize AI-written tests the same way
you'd scrutinize AI-written code — a test that passes against wrong behavior is
worse than no test.
