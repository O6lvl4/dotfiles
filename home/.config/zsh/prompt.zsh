# A two-line prompt in plain zsh.
#
#   O6lvl4/dotfiles/bin  v2 ● ⇡1                         4.2s
#   ❯
#
# Inside ~/workspace/github.com the path starts at the owner; elsewhere it's ~/….
# `git status` runs in the background and is waited for briefly (60 ms): in
# most repos the prompt appears once, complete. In a huge one it appears at
# once (with the last known status for this directory) and redraws when git
# answers, so it never makes you wait to type.

zmodload zsh/datetime zsh/zselect
autoload -Uz add-zsh-hook
setopt prompt_subst

typeset -g _p_t0 _p_right _p_line _p_char='❯' _p_git_seg _p_git_dir _p_fd

_p_preexec() { _p_t0=$EPOCHREALTIME }

_p_git() {
  local line branch='' ahead=0 behind=0 staged=0 dirty=0 untracked=0 conflict=0
  for line in ${(f)"$(git status --porcelain=v2 --branch 2>/dev/null)"}; do
    case $line in
      '# branch.head '*) branch=${line#\# branch.head } ;;
      '# branch.oid '*)  [[ -z $branch || $branch == '(detached)' ]] && branch=${${line#\# branch.oid }[1,7]} ;;
      '# branch.ab '*)   ahead=${${(s: :)line}[3]#+} behind=${${(s: :)line}[4]#-} ;;
      '? '*) untracked=1 ;;
      'u '*) conflict=1 ;;
      [12]' '*)
        [[ ${line[3]} != . ]] && staged=1
        [[ ${line[4]} != . ]] && dirty=1 ;;
    esac
  done
  [[ -n $branch ]] || return
  [[ $branch == '(detached)' ]] && branch=${$(git rev-parse --short HEAD 2>/dev/null):-detached}
  local s="%F{141}${branch//\%/%%}%f"                            # a % in a branch name is text
  (( conflict ))  && s+=" %F{203}✖%f"
  (( staged ))    && s+=" %F{114}●%f"
  (( dirty ))     && s+=" %F{179}●%f"
  (( untracked )) && s+=" %F{8}●%f"
  (( ahead ))     && s+=" %F{117}⇡$ahead%f"
  (( behind ))    && s+=" %F{117}⇣$behind%f"
  print -rn -- "  $s"
}

_p_path() {
  local root=$WORKSPACE/github.com/
  if [[ $PWD == $root?* ]]; then
    local rel=${${PWD#$root}//\%/%%}
    if [[ $rel == */* ]]; then
      print -rn -- "%F{8}${rel%%/*}/%f%B${rel#*/}%b"
    else
      print -rn -- "%B$rel%b"
    fi
  else
    print -rn -- "%B%~%b"
  fi
}

_p_render() {
  local left="$(_p_path)$_p_git_seg"
  # Right-align the duration / exit code on the first line.
  local strip='%([BSUbfksu]|[FK]\{[^}]#\})'
  local plain_l=${(%)${left//$~strip/}} plain_r=${(%)${_p_right//$~strip/}}
  local pad=$(( COLUMNS - ${#plain_l} - ${#plain_r} ))
  (( pad < 2 )) && pad=2
  _p_line="$left${(l:$pad:: :)}$_p_right"
}

_p_git_done() {
  local fd=$1 seg=''
  IFS= read -r -u $fd seg
  zle -F $fd; exec {fd}<&-; _p_fd=''
  [[ $seg == $_p_git_seg ]] && return
  _p_git_seg=$seg; _p_render; zle reset-prompt
}

_p_git_start() {
  if [[ -n $_p_fd ]]; then zle -F $_p_fd 2>/dev/null; exec {_p_fd}<&-; _p_fd=''; fi
  [[ $PWD == $_p_git_dir ]] || { _p_git_seg=''; _p_git_dir=$PWD }   # never show another repo's status
  if [[ -o zle ]]; then
    exec {_p_fd}< <(_p_git; print)
    # Most repos answer within a few ms: wait that long, so the prompt is
    # drawn once. A slow one is drawn now and again when git answers.
    # (zselect, not read -t: read flushes the newline out alone first.)
    local seg
    if zselect -t 6 -r $_p_fd 2>/dev/null; then
      IFS= read -r -u $_p_fd seg
      exec {_p_fd}<&-; _p_fd=''
      _p_git_seg=$seg
    else
      zle -F $_p_fd _p_git_done
    fi
  else
    _p_git_seg=$(_p_git)                                           # no line editor: just wait
  fi
}

_p_precmd() {
  local code=$? took=''
  if [[ -n $_p_t0 ]]; then
    local -F s=$(( EPOCHREALTIME - _p_t0 ))
    local -i si=$s
    if (( si >= 60 )); then took="$(( si / 60 ))m$(( si % 60 ))s"
    elif (( s >= 2 )); then took=$(printf '%.1fs' $s); fi
    _p_t0=''
  fi
  _p_right=${took:+"%F{179}$took%f"}
  (( code )) && _p_right+="${_p_right:+  }%F{203}$code%f"
  _p_char="%F{$(( code ? 203 : 114 ))}❯%f"                         # fixed now: the redraw runs later
  _p_git_start
  _p_render
}

add-zsh-hook preexec _p_preexec
add-zsh-hook precmd  _p_precmd
# Single quotes: $_p_line is expanded at display time but its contents are not
# re-evaluated, so a branch called $(…) stays text.
PROMPT=$'\n''${_p_line}'$'\n''${_p_char} '
RPROMPT=''
