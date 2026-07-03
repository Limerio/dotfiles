export DO_NOT_TRACK=1
export GPG_TTY=$(tty)

alias ls="lsd"
alias tf="terraform"
alias ws="pnpm --filter"
alias ll="ls -ll"
alias htop="btop"
alias cd2="cd ../../"
alias cls="clear"
alias grep="ripgrep"
alias analyze-codebase='cloc . --exclude-dir=.git,node_modules,build,dist,out,coverage,.next,.nuxt,.svelte-kit,.turbo,.cache,.parcel-cache,vendor,target,bin,obj,__pycache__,.pytest_cache,.mypy_cache,.ruff_cache,.tox,.venv,venv,env,.eggs,htmlcov,.gradle --exclude-ext=lock,min.js,min.css,map,pyc,pyo,pyd,so,dylib,dll,class,o,a'

export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-autosuggestions zsh-interactive-cd node kubectl gh docker docker-compose cp brew rust ssh tmux vagrant yarn terraform scw pip postgres python pyenv npm helm golang fzf fluxcd bun)

source $ZSH/oh-my-zsh.sh

export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

source <(fzf --zsh)

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

. /opt/homebrew/etc/profile.d/z.sh

export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH=":$HOME/.local/bin:$PATH"
export PATH="~/emsdk:$PATH"
export PATH="~/emsdk/upstream/emscripten:$PATH"

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
