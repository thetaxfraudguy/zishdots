eval "$(brew shellenv)"

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR="vim"
export VISUAL="vim"
export LESS="-F -X -R"

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
export HIST_STAMPS="yyyy-mm-dd"

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

setopt HIST_SAVE_NO_DUPS

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

alias ls="ls -A --color=auto"

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

#AWS
export AWS_PAGER=

avs () { profile=$1; shift; aws-vault exec $profile -- "$@"; }
s3cat() { aws s3 cp "s3://$1" -; }

complete -C aws_completer aws

# Docker
alias d="docker"
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcd="docker-compose down"

dlogin () { docker exec -it $1 /bin/sh; }
drun () { docker run -it --rm $1 /bin/sh; }

# Git
alias g="git"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gl="git log"
alias gpl="git pull"
alias gps="git push"

gdl () { git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done; }

# FZF
. $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh
. $HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh

# Golang
export GOPATH="$HOME/Projects/Go"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
export GOPRIVATE="github.com/huntresslabs"
# Mise-en-place
eval "$($HOMEBREW_PREFIX/bin/mise activate zsh)"

#Postgres
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

# Terraform
alias tf="terraform"
alias tfi="terraform init"
alias tfv="terraform validate"
alias tff="terraform fmt -recursive"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfaa="terraform apply -auto-approve"
alias tfdoc="terraform-docs markdown table --output-file README.md --output-mode inject ."

# Starship
eval "$(starship init zsh)"

# Secret Secrets
test -s "$HOME/.secret_secrets" && . "$HOME/.secret_secrets"
