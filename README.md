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
| `--title=N` | Rip a specific title number instead of the main feature. |
| `--split` | Rip every title on the disc to separate files instead of just the main feature. |
| `--update` | Download and install the latest version from GitHub (`main` branch). |
| `--help`, `-h` | Show usage help. |

Output files are written to `~/Downloads`.

## Update

```
rip-dvd --update
```

Or just re-run the install command above.

## Uninstall

```
rm ~/.local/bin/rip-dvd
```

Then remove the `PATH` line the installer added to `~/.zshrc`, if you no
longer need it there.
