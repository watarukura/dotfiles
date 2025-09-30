# path
fish_add_path "$HOME/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "/opt/homebrew/opt/openjdk/bin"
fish_add_path "$HOME/.local/share/aquaproj-aqua/bin/"
fish_add_path "/opt/homebrew/bin"
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
set -x GOROOT (go env GOROOT)
fish_add_path "$GOROOT/bin"

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
    if [ (count $argv) -eq 0 ]
        cat /dev/urandom | base64 | fold -w 12 | head -n 1
    else
        cat /dev/urandom | base64 | fold -w $argv[1] | head -n 1
    end
end

function git_switch
    git branch | fzf | xargs git switch
end

function git_switch_delete
    git branch | fzf | xargs git branch -D
end

function date_dir
    set --local dir_name $HOME/Documents/(date +'%Y%m%d')_$argv[1]
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

function clear_storage
    aqua vacuum -d 1
    uv cache clean
    docker system prune --volumes
    brew cleanup
    go clean -modcache
    nix-collect-garbage
    npm cache clean --force
end

function switch-php
    if test (count $argv) -ne 1
        echo "Usage: switch-php <version>"
        echo "Example: switch-php 8.2"
        return 1
    end

    set --local php_version $argv[1]
    set --local old_php_version (php --version | head -1 | grep -oP "[789]\.[0-9]+\.[0-9]+" | cut -d'.' -f1,2)

    if not brew list | grep -q "php@$php_version"
        echo "php@$php_version is not installed."
        return 1
    end

    echo "Switching from PHP $old_php_version to PHP $php_version ..."

    remove_path "/opt/homebrew/opt/php@$old_php_version/bin"
    brew link --overwrite --force php@$php_version
    fish_add_path "/opt/homebrew/opt/php@$php_version/bin"
    source ~/.config/fish/config.fish

    if brew services list | grep -q "php@$php_version"
        echo "Restarting php@$php_version service..."
        brew services restart php@$php_version
    end

    php -v
end

function remove_path
  if set -l index (contains -i "$argv" $fish_user_paths)
    set -e fish_user_paths[$index]
    echo "Removed $argv from the path"
  end
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

function gitnew
    set -l branch $argv[1]
    set -l base release
    if [ (count $argv) -ge 2 ]
      set -l base $argv[2]
    end
    git switch -c $branch $base
    git config branch.$branch.gh-merge-base $base
end

function memo
    set memo_dir "$HOME/documents/kurashidian/kurashidian/memo"
    set template "$memo_dir/template.md"
    set today (date +%Y-%m-%d)
    set today_file "$memo_dir/$today.md"
    set editor vim

    if [ "$argv[1]" = "list" ]
        ls $memo_dir | fzf | xargs -o -I{} $editor $memo_dir/{}
        return
    end
    if [ "$argv[1]" = "cd" ]
        cd $memo_dir
        return
    end

    # 前回日付を取得
    pushd $memo_dir
    set prev (basename \
        (ls | grep -oP "[0-9]{4}-[0-9]{2}-[0-9]{2}.md" | sort | grep -v "$today" | tail -1) \
        .md)
    popd

    # 今日のメモがなければ作成
    if test -e $today_file
        echo "Opening today's memo: $today_file"
    else if test -e $template
        echo "Creating new memo from template: $today_file"
        # <[[]] を <[[前日]] に書き換えて新規作成
        sed "s/<\[\[\]\]/<\[\[$prev\]\]/" $template > $today_file
    else
        echo "Template not found: $template"
        return 1
    end

    # 前回のメモに当日のメモへのリンク
    if test -e "$prev"
        gsed -i "s;\[\[\]\]>;\[\[$today\]\]>;" "$prev"
    end

    $editor $today_file
end

# zoxide
# https://blog.atusy.net/2025/05/09/zoxide-with-ghq/
zoxide init fish --no-cmd | source
function __zoxide_list_missing
  diff \
    ( zoxide query --list | sort | psub ) \
    ( ghq list -p | sort | psub ) \
    | grep '^> ' | string replace -r '^> ' ''
end

function __zoxide_add_missing
  set -l missing ( __zoxide_list_missing )
  if test ( count $missing ) -gt 0
    zoxide add $missing
  end
end

function zi --description 'zoxide wwith ghq'
  __zoxide_add_missing
  __zoxide_zi $argv || true
end


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/watarukura/Downloads/google-cloud-sdk/path.fish.inc' ]
  . "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
end

