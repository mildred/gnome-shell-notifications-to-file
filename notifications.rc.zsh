autoload colors
colors

_notifs_seen=()
_notifs_shown=false

_notifs_text(){
  cat "$XDG_RUNTIME_DIR/notifications" "${XDG_DATA_HOME:-$HOME/.local/share}/notifications" 2>/dev/null
}

precmd_notifications(){
  if [[ $_notifs_shown == true ]]; then
    _notifs_shown=false
    return
  fi

  local notif_text="$(_notifs_text)"
  local notifs=("${(f)notif_text}")
  for n in "${notifs[@]}"; do
    local seen=false
    local urg="${n[1]}"
    for n2 in "${_notifs_seen[@]}"; do
      if [[ "$n" == "$n2" ]]; then
        seen=true
        break
      fi
    done

    if [[ $seen == true ]] && [[ $urg != C ]]; then
      continue
    fi

    _notif_show "$n"

    _notifs_seen+=("$n")
  done
}

notif(){
  local notif_text="$(_notifs_text)"
  local notifs=("${(f)notif_text}")
  for n in "${notifs[@]}"; do
    _notif_show "$n"
  done
  _notifs_shown=true
}

_notif_show(){
  local n="$1"
  local urg="${n[1]}"
  case $urg in
    L)
      echo -n "$fg[black]$n[1,2]$fg[cyan]"
      ;;
    N)
      echo -n "$fg[black]$n[1,2]$fg_bold[cyan]"
      ;;
    C)
      echo -n "$fg[black]$n[1,2]$fg_bold[red]"
      ;;
    *)
      echo -n "${n[1,2]}"
      ;;
  esac

  echo "${n[3,-1]}$terminfo[sgr0]"
}

precmd_functions=("${(@)precmd_functions:#precmd_notifications}")
precmd_functions=(${precmd_functions[@]} "precmd_notifications")

