# typeset -U PATH path

#XDG
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_CACHE_HOME=$HOME/.cache/
export XDG_DATA_HOME=$HOME/.local/share
export XDG_DOWNLOAD_DIR=$HOME/dl
# export ZDOTDIR=$HOME/.config/zsh    # this is in my systemwide zshenv and regular zshenv

export PATH="$PATH:/$HOME/.local/appimages"
export PATH="$PATH:${$(find ~/.local/bin/ -type d -printf %p:)%%:}"

export TERM=xterm-256color
export EDITOR='nvim'
export VISUAL='nvim'
export TERMINAL='kitty'
export BROWSER='qutebrowser'
export MANPAGER='nvim +Man!'
export MANWIDTH=999


# this is to fix treesitter cli breakage. old npm install
export PATH="$HOME/.local/share/cargo/bin:$HOME/.local/.npm-global/bin:$PATH"


# ~/ Clean up:
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export LYNX_CFG_PATH="$XDG_CONFIG_HOME"/lynx.cfg
export NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/default/config
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export URLVIEW_CONFIG="$XDG_CONFIG_HOME/urlview/config"
export GOPATH="$XDG_DATA_HOME/go"
export GIT_CONFIG="$XDG_CONFIG_HOME/git/config" ## This breaks aur packages gives "ERROR not a clone of 'x repo'" # well as of 10-25-25 it works so renabled this. On new systems make sure to move .gitconfig to config, automate it.
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
# export PASSWORD_STORE_DIR="$XDG_DATA_HOME/.password-store"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
export MBSYNCRC="${XDG_CONFIG_HOME:-$HOME/.config}/mbsync/config" 
export STARDICT_DATA_DIR="$XDG_DATA_HOME"/dic
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export PYTHONSTARTUP="/etc/python/pythonrc"
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel 
export TERMINFO="$XDG_DATA_HOME"/terminfo
export _JAVA_AWT_WM_NONREPARENTING=1 # Fix for Java applications in dwm
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export ANSIBLE_HOME="${XDG_CONFIG_HOME}/ansible"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"
export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"
export W3M_DIR="$XDG_DATA_HOME"/w3m
export N_PREFIX="$HOME/.local/n"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
## Got this from luke, let's see if this makes less better 
export LESS=-R
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
# export QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme. # not sure if this is needed anymore for my wayland setup
export OLLAMA_MODELS=$XDG_DATA_HOME/ollama/models
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history  
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

[ ! -f "$XDG_CONFIG_HOME/shell/shortcutrc" ] && setsid -f shortcuts >/dev/null 2>&1


# with X removed this was needed or else tmux would launch hyprland within itself, weird behavior.
if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec dbus-run-session Hyprland
fi

# if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
#   startx ~/.config/x11/xinitrc
# fi
