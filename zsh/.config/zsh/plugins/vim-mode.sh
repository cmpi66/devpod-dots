#!/bin/sh

bindkey -v
export KEYTIMEOUT=25

# --- Menu completion vim keys ---
if [[ -o menucomplete ]]; then 
  bindkey -M menuselect '^h' vi-backward-char
  bindkey -M menuselect '^k' vi-up-line-or-history
  bindkey -M menuselect '^l' vi-forward-char
  bindkey -M menuselect '^j' vi-down-line-or-history
  bindkey -M menuselect '^[[Z' vi-up-line-or-history
fi

bindkey -v '^?' backward-delete-char

# -------------------------------------------------
# Cursor Shape Control (STEADY ONLY — NO BLINK)
# -------------------------------------------------

# 2 q = steady block
# 6 q = steady beam
# 4 q = steady underline (if you ever want replace mode)

function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[2 q' ;;       # steady block
        viins|main) echo -ne '\e[6 q' ;;  # steady beam
    esac
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins
    echo -ne '\e[6 q'
}
zle -N zle-line-init

# Force steady beam at startup
echo -ne '\e[6 q'

# Ensure steady beam before each command
preexec() {
    echo -ne '\e[6 q'
}

# -------------------------------------------------
# Emacs-like bindings in insert
# -------------------------------------------------

bindkey -M viins '^A' beginning-of-line 
bindkey -M viins '^E' end-of-line 

# -------------------------------------------------
# Text objects
# -------------------------------------------------

autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed

for m in viopp visual; do
  for c in {a,i}{\',\",\`}; do
      bindkey -M $m -- $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
      bindkey -M $m -- $c select-bracketed
  done
done

# -------------------------------------------------
# Surround functionality
# -------------------------------------------------

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Escape insert mode binding if defined
if [[ -n "${VI_MODE_ESC_INSERT}" ]]; then
    bindkey -M viins "${VI_MODE_ESC_INSERT}" vi-cmd-mode
fi

