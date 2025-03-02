export DO_NOT_TRACK=1
export GPG_TTY=$(tty)

alias ls="lsd"
alias tf="terraform"
alias ws="pnpm --filter"
alias ll="ls -ll"
alias htop="btop"
alias cd2="cd ../../"
alias cls="clear"

export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-autosuggestions node kubectl gh docker docker-compose cp brew rust ssh tmux vagrant yarn terraform scw pip postgres python pyenv npm helm golang fzf fluxcd bun)

source $ZSH/oh-my-zsh.sh

export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

source <(fzf --zsh)

eval "$(starship init zsh)"

. /opt/homebrew/etc/profile.d/z.sh

. <(flux completion zsh)
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH=":$HOME/.local/bin:$PATH"

eval "$(scw autocomplete script shell=zsh)"

. "$HOME/.local/bin/env"
