#!/usr/bin/env bash
# Driver for the claude-skills plugin: validate -> install -> verify -> fire.
# There is no server or GUI here; "running" this project means getting the
# plugin registered and proving a real agent can reach its skills.
#
# Usage: .claude/skills/run-claude-skills/driver.sh [skill-name]
#   no args -> validate, sync marketplace, print inventory
#   skill   -> also run a headless agent and assert that skill id resolves
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
MARKET="feynman-skills"
PLUGIN="feynman"
fail() { echo "FAIL: $*" >&2; exit 1; }

echo "== repo: $REPO"

# 1. Manifests. --strict catches unknown fields the runtime would silently eat.
claude plugin validate "$REPO" --strict || fail "manifest validation"

# 2. Every skills/*/ dir must have SKILL.md whose `name:` matches the dir name.
#    Mismatch installs the skill under the DIRECTORY name, silently.
for d in "$REPO"/skills/*/; do
  [ -d "$d" ] || continue
  dir=$(basename "$d")
  [ -f "$d/SKILL.md" ] || fail "$dir: no SKILL.md"
  nm=$(sed -n 's/^name: *//p' "$d/SKILL.md" | head -1)
  [ "$nm" = "$dir" ] || fail "$dir: frontmatter name '$nm' != directory '$dir'"
  sed -n 's/^description: *//p' "$d/SKILL.md" | head -1 | grep -q . \
    || fail "$dir: empty description (skill will never auto-fire)"
  echo "   ok: $dir"
done

# 2b. Every agents/*.md file must have `name:` matching its filename stem.
for f in "$REPO"/agents/*.md; do
  [ -f "$f" ] || continue
  base=$(basename "$f" .md)
  nm=$(sed -n 's/^name: *//p' "$f" | head -1)
  [ "$nm" = "$base" ] || fail "agents/$base.md: frontmatter name '$nm' != filename '$base'"
  sed -n 's/^description: *//p' "$f" | head -1 | grep -q . \
    || fail "agents/$base.md: empty description (agent will never auto-fire)"
  echo "   ok: agents/$base"
done

# 3. Register. `add` errors if already present, so update in that case.
claude plugin marketplace add "$REPO" 2>/dev/null \
  || claude plugin marketplace update "$MARKET" >/dev/null \
  || fail "marketplace sync"
claude plugin install "$PLUGIN@$MARKET" 2>/dev/null >/dev/null || true

# 4. Inventory is the authority on what actually got picked up.
claude plugin details "$PLUGIN" || fail "plugin not installed"

# 5. Fire test: a fresh agent must resolve the skill id. This is the only
#    check that proves reachability -- the current session's skill list is
#    frozen at startup and will NOT show newly added skills.
if [ $# -ge 1 ]; then
  want="$PLUGIN:$1"
  echo "== fire test: $want"
  got=$(cd "$REPO" && claude -p \
    "List your available skills whose id contains '$1'. Reply with just the skill id, nothing else." \
    --model haiku 2>&1 | tail -1)
  echo "   agent said: $got"
  case "$got" in *"$want"*) echo "   ok: reachable" ;;
    *) fail "agent could not see $want" ;; esac
fi
echo "PASS"
