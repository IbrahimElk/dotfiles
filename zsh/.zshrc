export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gozilla"

# -----------------------------------------------------------
# tools
# -----------------------------------------------------------

alias sd='cd $(fd --type d --exclude .git| fzf)'
alias sf='cd $(fd --type f --exclude .git| fzf)'
alias tmx="tmux -L local"

# -----------------------------------------------------------
# plugins 
# -----------------------------------------------------------

# plugins=(git)
# plugins+=(zsh-vi-mode)
plugins+=(zsh-syntax-highlighting)
plugins+=(zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------
# bindings
# -----------------------------------------------------------

# # remap ... to alt-space
# bindkey '^[,' autosuggest-accept
# # remap alt+j to alt+n
# bindkey "^[n" vi-down-line-or-history
# # remap alt+k to alt+p
# bindkey "^[p" vi-up-line-or-history
# 
# # handle issue of vi-mode not using 
# # system clipboard
# source ~/.zclipboard

# -----------------------------------------------------------
# environment variables and PATH
# -----------------------------------------------------------

# shortcuts
export PROJECTS="$HOME/projects/"
export OPT="$HOME/opt/"
