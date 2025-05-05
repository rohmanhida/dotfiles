# terminal like vim
set -o vi

# aliases
alias n="nvim"
alias mkdir="mkdir -p"
alias ls="ls -la --color"
alias v="vim"
alias le="~/.scripts/fzf_listoldfiles.sh"
alias of="~/.scripts/search_with_zoxide.sh"
alias rt="~/.scripts/remove_transparency.sh"
alias fman="compgen -c | fzf | xargs man"

# plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt APPENDHISTORY
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_ALL_DUPS     # Keep only the most recent duplicate
setopt HIST_FIND_NO_DUPS        # Prevent showing duplicates when searching

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout default --border --color=hl:#2dd4bf"
export FZF_TMUX_OPTS=" -p90%,70%"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

