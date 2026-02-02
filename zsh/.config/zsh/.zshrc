# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
# plug "cmpi66/zap-prompt"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"

# fix zsh extra files
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_STATE_HOME"/zsh/history

#Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc"

source "$HOME/.config/zsh/plugins/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/fzf-git.sh"

stty stop undef		# Disable ctrl-s to freeze terminal.

# keybinds
bindkey '^ ' autosuggest-accept
fish_clipboard_copy() {
  print -rn -- "$BUFFER" | wl-copy
}

fish_clipboard_paste() {
  LBUFFER+=$(wl-paste)
}

zle -N fish_clipboard_copy
zle -N fish_clipboard_paste

bindkey -M vicmd 'yy' fish_clipboard_copy
bindkey -M vicmd 'Y'  fish_clipboard_copy
bindkey -M vicmd 'p'  fish_clipboard_paste


zle -N fzf-git-files-widget
bindkey '^S' fzf-git-files-widget

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

export BAT_THEME="Catppuccin Macchiato"
export FZF_DEFAULT_OPTS=" \
--bind tab:down,shift-tab:up \
--layout=reverse --height 40% \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"   
# eval "$(fnm env --use-on-cd --shell zsh)"
# eval "$(atuin init zsh)"
eval "$(mise activate zsh)"

# Load and initialise completion system
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

# needed for X now
xset r rate 180 50
