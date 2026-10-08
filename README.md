# dotfiles

A fresh Mac to a working setup in one line. **No sudo. No Homebrew. No framework.**

```sh
curl -fsSL https://raw.githubusercontent.com/O6lvl4/dotfiles/main/install | sh
```

Then, once per machine:

```sh
gh auth login
dot repos        # every repo → ~/workspace/github.com/<owner>/<repo>
```

## What you get

| | |
|---|---|
| **toolchains** | rust · go · node · python · ruby · almide — via [qusp](https://github.com/O6lvl4/qusp), bare commands in `~/.local/bin`, no shims, no shell hook |
| **binaries** | gh · qusp · codopsy — straight from GitHub releases, sha256-verified |
| **shell** | plain zsh, a two-line prompt in ~80 lines, `ws` to jump between repos |
| **git** | HTTPS authenticated by gh (no SSH keys), sane defaults, `git lg` |

## `dot`

```
dot up        link + tools + langs   (safe to re-run any time)
dot link      symlink home/ into $HOME
dot tools     install / update the binaries in ./tools
dot langs     install + globally pin the toolchains in ./langs
dot repos     clone every repo of the owners in ./repos
dot sync      dot repos, then fetch + fast-forward every repo
dot doctor    what is and isn't in place
dot edit      cd here
```

Everything is driven by three plain-text lists — [`tools`](tools), [`langs`](langs),
[`repos`](repos). Add a line, run `dot up`.

## `ws`

```sh
ws               # ~/workspace/github.com
ws qusp          # → O6lvl4/qusp   (tab-completes every local repo)
ws almide/almide # → clones it first if it isn't here yet
```

## Layout

```
home/                       mirrored into ~ as symlinks
  .zshenv                   ZDOTDIR, XDG, PATH
  .config/zsh/              .zshrc · .zprofile · prompt.zsh
  .config/git/              config · ignore
bin/dot                     the only command
install                     curl | sh bootstrap
tools  langs  repos         what to install
```

## Per-machine

Never committed, created empty by `dot link`:

- `~/.config/zsh/local.zsh` — env for this machine only. `dot link` writes
  `DEVELOPER_DIR` here automatically when Xcode is installed but its license
  was never accepted (and there's no sudo to accept it).
- `~/.config/git/local` — e.g. a work email under `[user]`.

Anything `dot link` replaces is moved to `<name>.pre-dot`, never deleted.
