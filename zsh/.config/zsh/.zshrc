# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
# plug "zap-zsh/vim"
# plug "cmpi66/zap-prompt"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "Aloxaf/fzf-tab"

# fix zsh extra files
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


#Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc"

source "$HOME/.config/zsh/plugins/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
# source "$HOME/.config/zsh/plugins/fzf-git.sh"
source "$HOME/.config/zsh/plugins/vim-mode.sh"

# Load local secrets if present
if [ -f "$HOME/.config/secrets/env" ]; then
  source "$HOME/.config/secrets/env"
fi

stty stop undef		# Disable ctrl-s to freeze terminal.

# keybinds
bindkey '^ ' autosuggest-accept
bindkey " " magic-space

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

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


# zle -N fzf-git-files-widget
# bindkey '^S' fzf-git-files-widget

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

export BAT_THEME="Catppuccin Macchiato"
export FZF_DEFAULT_OPTS=" \
--bind tab:down,shift-tab:up \
--layout=reverse --height 40% \
--color=bg:-1,bg+:-1,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

function precmd {
    if ! builtin zle; then
        print -n "\e]133;D\e\\"
    fi
}

function preexec {
    print -n "\e]133;C\e\\"
}

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
# eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
eval "$(uv generate-shell-completion zsh)"

# Load and initialise completion system
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
