# AGENTS.md

Guidance for AI coding agents working in this repo.

## What this is

`rip-dvd` is a standalone bash script (`bin/rip-dvd`) that wraps HandBrakeCLI
to rip DVDs on macOS, plus a curl-able `install.sh`. There is no build step —
`bin/rip-dvd` is the shipped artifact, installed as-is to `~/.local/bin`.

## Conventions

- **Bump `VERSION` in `bin/rip-dvd`** on every change that ships, so
  `rip-dvd --update` reports a meaningful "updating from vX to vY". Patch for
  fixes, minor for new flags/features.
- **Commit messages** follow `feat|fix(component): message` (component is
  usually `cli`), with a short body explaining *why*, ending with the
  standard `Co-Authored-By` attribution line used in this project's history.
- Keep `bin/rip-dvd` portable to bash 3.2 (macOS's default `/usr/bin/env bash`
  may resolve to it) — avoid associative arrays and other bash 4+ features.
- The Bash tool runs through the user's shell (zsh), not bash directly. When
  testing bash-specific syntax (`BASH_REMATCH`, arrays, `[[ =~ ]]`), invoke it
  explicitly via `bash -c` or a heredoc piped to `bash`, not inline.
- Update `README.md`'s option table and `print_help()`/usage strings together
  whenever a flag is added or changed — they should never drift apart.

## Testing changes

There's no test suite; this is validated against a real optical drive:

1. `bash -n bin/rip-dvd` — syntax check before anything else.
2. For scan/detection logic changes, extract the relevant block into a temp
   script and run it against the currently loaded disc via
   `drutil status` to get the device, then `HandBrakeCLI -i "$disk" --scan -t 0`
   to inspect real title/chapter/duration output — don't guess at DVD
   authoring structure from log excerpts alone. Print an easy to compare table
   (title/duration/chapters) when debugging detection heuristics like the
   `--split` episode-clustering logic.
3. Only run a live `HandBrakeCLI` rip (not just `--scan`) when explicitly
   asked to — it can take a long time and there is currently no way to cancel
   a batch `--split` rip cleanly from a tool call.

## Known fragile area

The `--split` episode-detection logic in `bin/rip-dvd` (duration-bucket
clustering to find the real episode titles among Play-All and junk/menu
titles) is a heuristic, not a guarantee — it has already needed one bug fix
(junk titles outnumbering episodes and winning the cluster vote). Treat
changes here carefully and verify against a real scan before considering the
fix done.
