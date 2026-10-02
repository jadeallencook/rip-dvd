# rip-dvd

A small CLI wrapper around HandBrakeCLI for ripping DVDs on macOS.

## Requirements

- macOS
- [Homebrew](https://brew.sh)
- HandBrakeCLI (installed automatically if missing)

## Install

```
curl -fsSL https://raw.githubusercontent.com/jadeallencook/rip-dvd/main/install.sh | bash
```

This installs `rip-dvd` to `~/.local/bin`, adds that directory to your `PATH`
in `~/.zshrc` if it isn't already there, and installs HandBrakeCLI via
Homebrew if it's not already installed.

Restart your shell (or run `source ~/.zshrc`) after installing.

## Usage

```
rip-dvd [options]
```

| Option | Description |
| --- | --- |
| `--output=NAME` | Base name for the output file (default: current timestamp). |
| `--lang=CODE` | Audio language to select, e.g. `eng`, `fre` (default: `eng`). |
| `--title=N[:C]` | Rip a specific title number instead of the main feature. Optionally limit it to HandBrake chapter `C` or range `A-B`, e.g. `--title=16:1`. Works with `--season` and `--episode` to name a single episode; can't be combined with `--split`. |
| `--split` | Rip every title on the disc to separate files instead of just the main feature. |
| `--season=N` | Season number. Requires `--episode` and `--split` or `--title`; changes output naming to `OUTPUT \| Season N \| Episode M.mp4`, incrementing per title. |
| `--episode=N` | Starting episode number for the first title. Requires `--season` and `--split` or `--title`. |
| `--chapter=N` | With `--split`, rip only the Nth detected episode on the disc (1-based). Combined with `--season`/`--episode`, `--episode` is that single file's episode number. |
| `--update` | Download and install the latest version from GitHub (`main` branch). |
| `--version`, `-v` | Show the installed version. |
| `--help`, `-h` | Show usage help. |

Output files are written to `~/Downloads`.

### Ripping a season

```
rip-dvd --output="King of the Hill" --season=3 --episode=5 --split
```

Produces, in title order:

```
King of the Hill | Season 3 | Episode 5.mp4
King of the Hill | Season 3 | Episode 6.mp4
King of the Hill | Season 3 | Episode 7.mp4
King of the Hill | Season 3 | Episode 8.mp4
```

### Ripping a single episode

If one episode fails mid-batch (e.g. a scratched or copy-protected title),
the rest of the disc still rips and `rip-dvd` prints the flags to retry just
the failed ones. To rip only the 7th episode on the disc as episode 13:

```
rip-dvd --output="That 70s Show" --season=3 --episode=13 --split --chapter=7
```

Produces:

```
That 70s Show | Season 3 | Episode 13.mp4
```

### Episodes `--split` doesn't detect

`--split` picks episodes by finding the titles that share a common runtime.
If a disc authors an episode and a bonus clip as one title, it rips just the
episode chapter, as long as that title is part of the disc's Play All. An
unusually short episode is still skipped. After ripping, it lists every title
it skipped with its length and chapters, e.g.:

```
rip-dvd: titles not ripped (rip one with --title=N, or --title=N:C for only chapter(s) C):
rip-dvd:   title 1  3:35  chapters: 3:35
rip-dvd:   title 17  2:55:43  17 chapters (likely Play All)
rip-dvd:   title 18  6:17  chapters: 6:16
```

Rip a missed episode by title, optionally limited to its chapters:

```
rip-dvd --output="SpongeBob SquarePants" --season=1 --episode=1 --title=1
rip-dvd --output="SpongeBob SquarePants" --season=1 --episode=16 --title=16:1
```

## Update

```
rip-dvd --update
```

Reports the version you're on and the version it's updating to, or tells you
if you're already up to date. Check your current version with `rip-dvd --version`.
Or just re-run the install command above.

## Uninstall

```
rm ~/.local/bin/rip-dvd
```

Then remove the `PATH` line the installer added to `~/.zshrc`, if you no
longer need it there.
