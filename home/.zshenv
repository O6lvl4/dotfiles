# Every zsh, interactive or not. Keep it to environment only.
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_HOME=$HOME/.local/share
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export WORKSPACE=$HOME/workspace

typeset -U path
path=($HOME/.local/bin $path)

export LANG=${LANG:-en_US.UTF-8}
export EDITOR=${EDITOR:-vi}
export LESS=-FRX

# This machine only (DEVELOPER_DIR, tokens, work stuff). Never committed.
[[ -r $ZDOTDIR/local.zsh ]] && source $ZDOTDIR/local.zsh
