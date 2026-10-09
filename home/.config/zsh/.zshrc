# Interactive zsh. No framework, no plugin manager, no brew.

# ── options ─────────────────────────────────────────────────────────────
setopt auto_cd auto_pushd pushd_ignore_dups pushd_silent
setopt extended_glob glob_dots no_beep interactive_comments
setopt hist_ignore_all_dups hist_ignore_space hist_reduce_blanks share_history inc_append_history
HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=100000 SAVEHIST=100000
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# ── completion ──────────────────────────────────────────────────────────
# Completions for release-installed tools, regenerated when the binary changes.
_zcomp=$XDG_CACHE_HOME/zsh/completions
[[ -d $_zcomp ]] || mkdir -p $_zcomp
typeset -g _zregen=0
() {
  local tool gen
  for tool gen in \
      gh   'gh completion -s zsh'    qusp 'qusp completions zsh' \
      rg   'rg --generate complete-zsh' fd 'fd --gen-completions zsh' \
      bat  'bat --completion zsh'; do
    (( $+commands[$tool] )) || continue
    [[ -s $_zcomp/_$tool && $_zcomp/_$tool -nt $commands[$tool] ]] && continue
    ${=gen} >| $_zcomp/_$tool 2>/dev/null
    _zregen=1
  done
}
fpath=($_zcomp $fpath)
unset _zcomp

# -C skips the slow security scan; rebuild the dump when a completion changed.
autoload -Uz compinit
(( _zregen )) && rm -f $XDG_CACHE_HOME/zsh/zcompdump
compinit -d $XDG_CACHE_HOME/zsh/zcompdump -C
unset _zregen
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{8}── %d%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

# ── keys ────────────────────────────────────────────────────────────────
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P'   up-line-or-beginning-search
bindkey '^N'   down-line-or-beginning-search
bindkey '^X^E' edit-command-line

# fzf: ^R history, ^T files, M-c cd
[[ -t 0 ]] && (( $+commands[fzf] )) && source <(fzf --zsh)   # needs a real terminal

# ── aliases ─────────────────────────────────────────────────────────────
export CLICOLOR=1
[[ $OSTYPE == darwin* ]] && _c=-G || _c=--color=auto     # BSD ls vs GNU ls
alias ls="ls $_c" ll="ls -lAh $_c" la="ls -A $_c"
unset _c
alias g=git
alias ..='cd ..' ...='cd ../..'
alias reload='exec zsh'

# ── workspace: ~/workspace/<host>/<owner>/<repo> ────────────────────────
# ws                 → pick a repo with fzf (workspace root without fzf)
# ws dotfiles        → the repo named dotfiles (else starting with, else containing it; fzf picks among several)
# ws O6lvl4/qusp     → that repo, cloned from github.com if it isn't here yet
# ws <host>/<o>/<r>  → cloned into ~/workspace/<host>/ from https://<host>/<o>/<r>
# Any dir in ~/workspace with a dot in its name is a host. An alias host is
# pointed at a real one with git's url.insteadOf, and its .envrc (direnv)
# applies to the clone too, so a second account needs nothing in here.
ws() {
  local root=$WORKSPACE
  if [[ -z $1 ]]; then
    (( $+commands[fzf] )) || { cd $root; return }
    local -a repos=( $root/*.*/*/*(/N) )
    local pick
    pick=$(print -rl -- ${repos#$root/} | fzf --height=40% --reverse --prompt='ws ❯ ') || return
    cd $root/$pick; return
  fi
  local -a hit
  case $1 in
    */*/*) [[ -d $root/$1 ]] || _ws_clone ${1%%/*} ${1#*/} || return
           cd $root/$1; return ;;
    */*)   hit=( $root/*.*/$1(/N) )
           (( $#hit )) || { _ws_clone github.com $1 || return; hit=( $root/github.com/$1 ) } ;;
    *)     local q=${(b)1}                                     # exact, then prefix, then anywhere
           hit=( $root/*.*/*/$~q(/N) )
           (( $#hit )) || hit=( $root/*.*/*/(#i)$~q*(/N) )
           (( $#hit )) || hit=( $root/*.*/*/(#i)*$~q*(/N) ) ;;
  esac
  (( $#hit )) || { print -u2 "ws: no repo named $1"; return 1 }
  if (( $#hit > 1 && $+commands[fzf] )); then                 # several: pick one
    local pick
    pick=$(print -rl -- ${hit#$root/} | fzf --height=40% --reverse --prompt="ws $1 ❯ ") || return
    cd $root/$pick; return
  fi
  (( $#hit > 1 )) && print -u2 "ws: also ${(j:, :)${hit[2,-1]#$root/}}"
  cd $hit[1]
}
_ws_clone() {   # <host> <owner>/<repo>
  local dir=$WORKSPACE/$1
  local -a run=()
  [[ -f $dir/.envrc ]] && (( $+commands[direnv] )) && run=(direnv exec $dir)
  $run git clone https://$1/$2.git $dir/$2
}
_ws() {
  local root=$WORKSPACE
  local -a repos=( $root/*.*/*/*(/N) )
  repos=( ${repos#$root/*/} )
  # Any case, prefix first; only when nothing starts with it, anywhere in the name.
  compadd -M 'm:{a-zA-Z}={A-Za-z}' -- $repos ${repos:t} ||
    compadd -M 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*' -- $repos ${repos:t}
}
compdef _ws ws

# `dot edit` jumps into the dotfiles repo; everything else goes to bin/dot.
dot() { [[ $1 == edit ]] && cd ${$(command dot edit)} || command dot "$@" }

# ── direnv: per-directory env (e.g. which gh account a tree pushes as) ──
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# ── prompt ──────────────────────────────────────────────────────────────
source $ZDOTDIR/prompt.zsh
