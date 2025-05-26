# terminal like vim
set -o vi

# aliases
alias n="nvim"
alias mkdir="mkdir -p"
alias ls="eza --long -a --sort=type --color=always --icons=always --no-user --no-permissions"
alias v="vim"
alias le="~/.scripts/fzf_listoldfiles.sh"
alias of="~/.scripts/search_with_zoxide.sh"
alias fman="compgen -c | fzf | xargs man"
alias c="clear"
alias youtube="mov-cli -s youtube"
alias capture='tmux has-session -t capture 2>/dev/null && tmux attach-session -t capture || tmux new-session -d -s capture '\''ffplay -f v4l2 -framerate 60 -input_format mjpeg -i "/dev/video2" -vf "setpts=N/(60*TB)"'\'' \; split-window -h '\''ffplay -f pulse -i "alsa_input.usb-MACROSILICON_UGREEN_HDMI_Capture_20230424-02.analog-stereo"'\'' \; attach'

export FUNCNEST=100

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
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_DEFAULT_OPTS="--height 50% --layout default --border --color=hl:#2dd4bf"
export FZF_TMUX_OPTS=" -p90%,70%"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# my scripts
export PATH="/home/rohmanhida/.scripts:$PATH"
