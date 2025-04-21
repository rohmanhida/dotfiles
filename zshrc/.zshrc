# aliases
alias n="nvim"
alias mkdir="mkdir -p"
alias ls="ls -la --color"
alias v="gvim -v"
alias vim="gvim -v"

# plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY

# starship
eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# php stuff from laravel
export PATH="/home/rohmanhida/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/rohmanhida/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
