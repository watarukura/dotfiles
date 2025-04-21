# path
fish_add_path "$HOME/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "/opt/homebrew/opt/openjdk/bin"
fish_add_path "/opt/homebrew/bin"
fish_add_path "$HOME/.local/share/aquaproj-aqua/bin/"
fish_add_path "/opt/homebrew/opt/mysql@8.0/bin"
fish_add_path "/opt/homebrew/sbin"
fish_add_path "/opt/homebrew/opt/curl/bin"
fish_add_path "$HOME/.npm-global/bin"
set -x EDITOR 'vim'

# less
set -x LESS '--no-init --IGNORE-CASE --RAW-CONTROL-CHARS --LONG-PROMPT'

# alias
alias la='ls -la'
alias ll='ls -l'
alias rm='rm -i'
alias mv='mv -i'
alias view='vim -R'
alias ls='gls --color=auto'
alias sed='gsed'
alias awk='gawk'
alias split='gsplit'
alias find='gfind'
alias xargs='gxargs'
alias zcat='gzcat'
alias date='gdate'
alias grep='ggrep'
alias du='gdu'
alias ping='ping -c 5'
alias pip='pip3'
alias python='python3'

# golang
set -x GOPATH ~/
set -x GO11MODULE on
set -x GOROOT (aqua which golang/go | sed -e 's;/bin/go$;;')

# direnv
direnv hook fish | source

# aws
complete -c aws -f -a '(
  begin
    set -lx COMP_SHELL fish
    set -lx COMP_LINE (commandline)
    aws_completer
  end
)'

# terraform
set -gx TF_PLUGIN_CACHE_DIR "$HOME/.terraform.d/plugin-cache"

# curl
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/curl/lib/pkgconfig"
set -gx CPPFLAGS "-I/opt/homebrew/opt/curl/include"
set -gx LDFLAGS "-L/opt/homebrew/opt/curl/lib"

# supership
if [ "$TERM_PROGRAM" != "vscode" ]
  starship init fish | source
else
  . (code --locate-shell-integration-path fish)
end

# functions
function brew_all_update
    brew update
    brew upgrade
    # mas upgrade
    brew doctor
end

function random_string
    cat /dev/urandom | base64 | fold -w 12 | head -n 1
end

function git_switch
    git branch | fzf | xargs git switch
end

function git_switch_delete
    git branch | fzf | xargs git branch -D
end

function date_dir
    set --local dir_name (date +'%Y%m%d')_$argv[1]
    mkdir -p $dir_name && cd $dir_name
end

function cdr
    set --local git_dir (git rev-parse --git-dir)
    cd "$git_dir/.."
end

function awsp
    aws configure list-profiles \
        | fzf
end

function git_branch_prune
    set --local org_repo (git config remote.origin.url | cut -d'/' -f4,5 | sed 's/.git$//')
    set --local protected_branches (gh api "https://api.github.com/repos/$org_repo/branches" | \
        jq -r '.[] | select(.protected == true) | .name' \
        | tr '\n' '|' | rev | cut -c2- | rev)
    set --local stale_branches (git branch | awk '{print $NF}' | grep -v -E "$protected_branches")
    if [ -n "$stale_branches" ]
        echo $stale_branches \
            | xargs git branch -d
    end
end
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/watarukura/Downloads/google-cloud-sdk/path.fish.inc' ]
  . "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
end

