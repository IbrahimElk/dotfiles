export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gozilla"
 
# -----------------------------------------------------------
# tools
# -----------------------------------------------------------

alias sd='cd $(find * -type d | fzf)'

# -----------------------------------------------------------
# plugins 
# -----------------------------------------------------------

plugins=(git)
plugins+=(zsh-vi-mode)
plugins+=(zsh-syntax-highlighting)
plugins+=(zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------
# bindings
# -----------------------------------------------------------

# remap ... to alt-space
bindkey '^[,' autosuggest-accept
# remap alt+j to alt+n
bindkey "^[n" vi-down-line-or-history
# remap alt+k to alt+p
bindkey "^[p" vi-up-line-or-history

# -----------------------------------------------------------
# environment variables and PATH
# -----------------------------------------------------------

# nvm env variables
export NVM_DIR="$HOME/.nvm"
# this loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  

# Add RVM (ruby version manager) to PATH for scripting. 
export PATH="$PATH:$HOME/.rvm/bin"

# Created by `pipx` on 2024-11-10 11:06:03
export PATH="$PATH:/home/ibrahim/.local/bin"

# Created by `pipx` on 2024-11-10 11:06:03
export PATH="$PATH:/home/ibrahim/.local/bin"
[ -f "/home/ibrahim/.ghcup/env" ] && . "/home/ibrahim/.ghcup/env" # ghcup-env


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/ibrahim/.opam/opam-init/init.zsh' ]] || source '/home/ibrahim/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
. "/home/ibrahim/.deno/env"