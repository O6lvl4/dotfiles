# A two-line prompt in plain zsh. One `git status` per prompt, nothing else.
#
#   O6lvl4/dotfiles/bin  v2 ● ⇡1                         4.2s
#   ❯
#
# Inside ~/workspace/github.com the path starts at the owner; elsewhere it's ~/….

zmodload zsh/datetime
autoload -Uz add-zsh-hook
setopt prompt_subst

typeset -g _p_t0 _p_line1

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
  local s="%F{141}$branch%f"
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
    local rel=${PWD#$root}
    if [[ $rel == */* ]]; then
      print -rn -- "%F{8}${rel%%/*}/%f%B%F{255}${rel#*/}%f%b"
    else
      print -rn -- "%B%F{255}$rel%f%b"
    fi
  else
    print -rn -- "%B%F{255}%~%f%b"
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

  local left="$(_p_path)$(_p_git)"
  local right=${took:+"%F{179}$took%f"}
  (( code )) && right+="${right:+  }%F{203}$code%f"

  # Right-align the duration / exit code on the first line.
  local strip='%([BSUbfksu]|[FK]\{[^}]#\})'
  local plain_l=${(%)${left//$~strip/}} plain_r=${(%)${right//$~strip/}}
  local lw=${#plain_l} rw=${#plain_r}
  local pad=$(( COLUMNS - lw - rw ))
  (( pad < 2 )) && pad=2
  print -P -- "\n$left${(l:$pad:: :)}$right"

  PROMPT="%(?.%F{114}.%F{203})❯%f "
}

add-zsh-hook preexec _p_preexec
add-zsh-hook precmd  _p_precmd
PROMPT='❯ '
RPROMPT=''
