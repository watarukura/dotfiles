# path
set -x PATH ~/bin $PATH
set -g fish_user_paths "/usr/local/opt/bzip2/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/libiconv/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/icu4c/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/php@8.0/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/bin" $fish_user_paths
set -g fish_user_paths "$HOME/.local/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths
set -g fish_user_paths "$HOME/.cargo/bin" $fish_user_paths
set -g fish_user_paths "$HOME/go/bin" $fish_user_paths
set -g fish_user_paths "/usr/local/opt/openjdk/bin" $fish_user_paths
set -g fish_user_paths "/Users/watarukura/.local/share/aquaproj-aqua/bin/" $fish_user_paths
fish_add_path /usr/local/opt/mysql-client@8.0/bin
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
set -x GOROOT /usr/local/opt/go/libexec

# pipenv
set -x PIPENV_VENV_IN_PROJECT true
#eval (pipenv --completion)

# direnv
eval (direnv hook fish)

# aws
complete -c aws -f -a '(begin; set -lx COMP_SHELL fish; set -lx COMP_LINE (commandline); /usr/local/bin/aws_completer; end)'

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

## openssl
set -gx LDFLAGS "-L/usr/local/opt/openssl@1.1/lib"
set -gx CPPFLAGS "-I/usr/local/opt/openssl@1.1/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/openssl@1.1/lib/pkgconfig"

# java
set -gx JAVA_HOME "/Library/Java/JavaVirtualMachines/adoptopenjdk-12.jdk/Contents/Home/"

# volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

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

function ssm
    set --local instance_id (aws ec2 describe-tags --filters "Name=resource-type,Values=instance" "Name=key,Values=Name" | jq -r '.Tags[] | [.ResourceId, .Value] | @csv' | tr -d '"' | fzf | awk -F, '{print $1}')
    aws ssm start-session --target $instance_id --document-name AWS-StartInteractiveCommand --parameters command="bash -i"
end

function php80
  if contains "8.1" (/usr/local/bin/php --version | /usr/local/bin/ggrep -m 1 -oP "PHP 8.[0-9]" | cut -d' ' -f2)
    brew unlink php && brew link --force --overwrite php@8.0
  else
    echo "already php8.0"
  end
end

function php82
  if contains "8.0" (/usr/local/bin/php --version | /usr/local/bin/ggrep -m 1 -oP "PHP 8.[0-9]" | cut -d' ' -f2)
    brew unlink php@8.0 && brew link --force --overwrite php
  else
    echo "already php8.2"
  end
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
  grep "profile .*Administrator" ~/.aws/config |
  cut -f2 -d' ' |
  tr -d ']' |
  fzf
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/watarukura/Downloads/google-cloud-sdk/path.fish.inc' ]
  . /Users/watarukura/Downloads/google-cloud-sdk/path.fish.inc
end

source /usr/local/opt/asdf/libexec/asdf.fish
