export ZDOTDIR=$HOME/.config/zsh   
# export GPG_TTY=$(tty) # apparently this line isn't needed it works either way here. On arch this line hinders the pinentry program 
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
