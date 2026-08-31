# claude-skills

Vittorio's personal [Agent Skills](https://code.claude.com/docs/en/skills), packaged as a
[Claude Code](https://claude.com/claude-code) plugin marketplace.

Skills are plain directories holding a `SKILL.md`, a portable, agent-agnostic format. The plugin wrapper is a Claude Code convenience; any agent that can read a Markdown instruction file can use these.

## Installation

### Claude Code (recommended)

```
/plugin marketplace add vittoriorossi/claude-skills
/plugin install feynman@claude-skills
```

Skills then show up as `feynman:<skill-name>` and are invoked like any other skill.

To update later:

```
/plugin marketplace update claude-skills
```

To develop against a local clone instead of GitHub:

```
/plugin marketplace add ~/Projects/personal/claude-skills
```

### Claude Code, without the plugin system

Copy the skills straight into your skills directory. Per-user:

```bash
git clone https://github.com/vittoriorossi/claude-skills.git
cp -r claude-skills/skills/* ~/.claude/skills/
```

Or per-project, so the skills are committed alongside a repo — copy into `.claude/skills/` of that project instead.

### Claude Desktop, claude.ai, and the Claude API

Zip an individual skill directory (the zip must contain `SKILL.md` at its root) and upload it as a skill:

```bash
cd skills/<skill-name> && zip -r ../../<skill-name>.zip .
```

Upload it in Settings → Capabilities → Skills, or `POST /v1/skills` on the API.

### Other agents (Cursor, Codex, Copilot, Gemini CLI, …)

There is no shared installer, but `SKILL.md` is just Markdown with YAML frontmatter, so the content ports directly. Pick whichever your agent reads:

| Agent | Where to put it |
|---|---|
| Codex / anything reading `AGENTS.md` | Append the skill body to `AGENTS.md`, or keep it as its own file and link to it |
| Cursor | `.cursor/rules/<skill-name>.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Gemini CLI | `GEMINI.md` |
| Anything else | Point the agent at `skills/<skill-name>/SKILL.md` and tell it to follow the file |

Two caveats when porting: the frontmatter `description` is what makes a skill load *on demand*
— agents without that mechanism will read the whole file every time, so keep skills short if
you rely on this. And skills that ship `scripts/` assume the agent can execute local commands.

## Layout

```
.claude-plugin/
  marketplace.json   # marketplace listing (what `marketplace add` reads)
  plugin.json        # plugin manifest (name, version, author)
skills/
  <skill-name>/SKILL.md
agents/
  <agent-name>.md      # subagents, dispatched via the Agent tool
```

## Credits

The packaging layout and the marketplace/plugin manifest structure were taken from
[mattpocock/skills](https://github.com/mattpocock/skills), used as the starting template.
