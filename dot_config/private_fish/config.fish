# path
fish_add_path "$HOME/bin"
fish_add_path "/usr/local/opt/bzip2/bin"
fish_add_path "/usr/local/opt/libiconv/bin"
fish_add_path "/usr/local/opt/icu4c/bin"
fish_add_path "/usr/local/opt/icu4c/sbin"
fish_add_path "/usr/local/sbin"
fish_add_path "/usr/local/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "/usr/local/opt/openssl/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "/opt/homebrew/opt/openjdk/bin"
fish_add_path "/opt/homebrew/bin"
fish_add_path "$HOME/.local/share/aquaproj-aqua/bin/"
fish_add_path "/usr/local/opt/mysql-client@8.0/bin"
fish_add_path "/opt/homebrew/opt/mysql@8.0/bin"
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
eval (direnv hook fish)

# aws
complete -c aws -f -a '(
  begin
    set -lx COMP_SHELL fish
    set -lx COMP_LINE (commandline)
    aws_completer
  end
)'

# lua
set -g fish_user_paths "/usr/local/opt/luajit-openresty/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/curl/bin" $fish_user_paths
set -gx PKG_CONFIG_PATH "/usr/local/opt/luajit-openresty/lib/pkgconfig"
set -gx CPPFLAGS "-I/usr/local/opt/luajit-openresty/include"
set -gx LDFLAGS "-L/usr/local/opt/luajit-openresty/lib"

# curl
set -gx PKG_CONFIG_PATH "/usr/local/opt/curl/lib/pkgconfig"
set -gx CPPFLAGS "-I/usr/local/opt/curl/include"
set -gx LDFLAGS "-L/usr/local/opt/curl/lib"

# supership
starship init fish | source

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
  grep "\[profile " ~/.aws/config |
  grep -v "^;" |
  cut -f2 -d' ' |
  tr -d ']' |
  fzf
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/watarukura/Downloads/google-cloud-sdk/path.fish.inc' ]
  . "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
end

