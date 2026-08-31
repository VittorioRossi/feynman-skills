---
name: run-claude-skills
description: Build, install, verify and test-fire the claude-skills Claude Code plugin. Use when asked to run, install, build, validate, smoke-test, or check the feynman skills plugin, or to confirm a newly added skill is actually reachable by an agent.
---

# Running claude-skills

This repo is not an app — it is a Claude Code **plugin marketplace** holding
Agent Skills. "Running" it means getting the plugin registered and proving a
real agent can reach its skills. There is no server, no GUI, no test suite.

Paths below are relative to the repo root (`~/Projects/personal/claude-skills`).

## Prerequisites

Only the Claude Code CLI. No package manager, no build step, no dependencies.

```bash
claude plugin --help
```

## Run (agent path)

Use the driver. It validates manifests, checks every skill directory, syncs the
marketplace, prints the inventory, and optionally proves a skill is reachable:

```bash
./.claude/skills/run-claude-skills/driver.sh
```

To also fire a real headless agent and assert a skill id resolves (slower,
costs a token round-trip, takes ~30s):

```bash
./.claude/skills/run-claude-skills/driver.sh interview
```

Exits 0 on success, 1 with a `FAIL:` line on the first problem. Safe to
re-run; marketplace registration is idempotent.

## Adding a skill

Create `skills/<name>/SKILL.md` with `name:` and `description:` frontmatter,
then re-run the driver. Nothing else to edit — every directory under `skills/`
is picked up automatically.

## Adding an agent

Create `agents/<name>.md` with `name:` and `description:` frontmatter (see
[sub-agent docs](https://code.claude.com/docs/en/sub-agents) for the full
schema — `tools`, `model`, `skills` to preload, etc.), then re-run the driver.
Agents live at the plugin root next to `skills/`, not inside
`.claude-plugin/`; no manifest wiring is needed, same as skills.

## Gotchas

These are the traps, all hit for real in this repo:

- **The current session cannot see a newly added skill.** The skill list is
  frozen at session startup. After adding a skill, `claude plugin details`
  will show it while the running agent still insists it does not exist. This
  is expected — restart the session, or use the driver's fire test, which
  spawns a fresh agent.
- **`claude plugin validate --strict` does NOT catch a directory/frontmatter
  name mismatch.** It returned "✔ Validation passed" on a copy where
  `skills/the-faynman-skill/SKILL.md` declared `name: interview`. The
  **directory name wins** — the skill silently installs under the typo. The
  driver checks this explicitly because the official validator will not.
- **An empty or vague `description:` means the skill never auto-fires.** The
  description is the matcher Claude scans; it is not documentation. The driver
  fails on an empty one.
- **`claude plugin marketplace add` errors if the marketplace is already
  registered.** Use `update` from then on. The driver falls back automatically.

```bash
claude plugin marketplace update feynman-skills
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `FAIL: <dir>: frontmatter name 'x' != directory 'y'` | Rename the directory to match `name:`, or edit `name:`. `git mv skills/y skills/x` |
| Agent says the skill does not exist, but `plugin details` lists it | Session skill list is stale. Restart the session. |
| Inventory shows `Skills (0)` | No `skills/*/SKILL.md`, or the file lacks frontmatter. |
| Changes to a skill do not take effect | `claude plugin marketplace update feynman-skills` — the installed copy is read through the marketplace. |

## Inspect installed state

```bash
claude plugin list
```
