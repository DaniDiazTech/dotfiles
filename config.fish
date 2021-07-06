
###############################################
### init.fish CONFIGURATION FILE OF DANIEL DIAZ ###
#
#  ____   ____
# |  _ \ |  _ \   Copyright (c) 2020 Daniel Diaz
# | | | || | | |
# | |_| || |_| |  http://www.github.com/Daniel1404/
# |____/ |____/
#

set fish_greeting #Supress annoying message
set TERM "termite"
set EDITOR "nvim"
set VISUAL "code"
set fish_vi_key_bindings

# Set local bin  Path
set PATH $HOME/.local/bin $PATH

# Sets the starship prompt
starship init fish | source

function mkdir-cd
    mkdir $argv && cd $argv
end

### SPARK ###
set -g spark_version 1.0.0

complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
complete -xc spark -n __fish_use_subcommand -a --version -d "$spark_version"
complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"

function spark -d "sparkline generator"
    if isatty
        switch "$argv"
            case {,-}-v{ersion,}
                echo "spark version $spark_version"
            case {,-}-h{elp,}
                echo "usage: spark [--min=<n> --max=<n>] <numbers...>  Draw sparklines"
                echo "examples:"
                echo "       spark 1 2 3 4"
                echo "       seq 100 | sort -R | spark"
                echo "       awk \\\$0=length spark.fish | spark"
            case \*
                echo $argv | spark $argv
        end
        return
    end

    command awk -v FS="[[:space:],]*" -v argv="$argv" '
        BEGIN {
            min = match(argv, /--min=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
            max = match(argv, /--max=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
        }
        {
            for (i = j = 1; i <= NF; i++) {
                if ($i ~ /^--/) continue
                if ($i !~ /^-?[0-9]/) data[count + j++] = ""
                else {
                    v = data[count + j++] = int($i)
                    if (max == "" && min == "") max = min = v
                    if (max < v) max = v
                    if (min > v ) min = v
                }
            }
            count += j - 1
        }
        END {
            n = split(min == max && max ? "▅ ▅" : "▁ ▂ ▃ ▄ ▅ ▆ ▇ █", blocks, " ")
            scale = (scale = int(256 * (max - min) / (n - 1))) ? scale : 1
            for (i = 1; i <= count; i++)
                out = out (data[i] == "" ? " " : blocks[idx = int(256 * (data[i] - min) / scale) + 1])
            print out
        }
    '
end
### END OF SPARK ###


### FUNCTIONS ###
# Spark functions
function letters
    cat $argv | awk -vFS='' '{for(i=1;i<=NF;i++){ if($i~/[a-zA-Z]/) { w[tolower($i)]++} } }END{for(i in w) print i,w[i]}' | sort | cut -c 3- | spark | lolcat
    printf  '%s\n' 'abcdefghijklmnopqrstuvwxyz'  ' ' | lolcat
end

function commits
    git log --author="$argv" --format=format:%ad --date=short | uniq -c | awk '{print $1}' | spark | lolcat
end


# aliases:

# git
alias g="git"
alias gsh="git show"
alias gl="git log"
alias gst="git status"
alias gc="git clone"
alias gcm="git commit -m"
alias grc="git rm -r --cached"
alias gph="git push origin" 
alias ginit="git init;touch README.md; git add README.md;git commit -m 'first commit';git branch -M main"

# Turns my home in a git repo
alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias config-s="config status"
alias config-a="config add"
alias config-m="config commit -m"
alias config-p="config push origin"

function gremote -a repo
        command git remote add origin git@github.com:Daniel1404/$repo.git
end


function gchanges -a message
        command git add ./ ; git commit -m $message ; git push origin
end

function config-changes -a message
        command /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME commit -m $message ; /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME push origin
end

# cd commands

alias ..="cd .."
alias ...="cd ../.."
alias 3..="cd ../../.."

# cp commands
alias cp="cp -r" # set cp to allways copy directories

# Development

alias p="python3"

alias pvenv="python3 -m venv .venv && source .venv/bin/activate.fish"

alias cl="clear"
alias cdM="cd ~/MEGAsync/"
alias cdMG="cd ~/MEGAsync/github"
alias cdC="cd ~/.config/"
# installing packages

alias install="yay -S" # install any pagckage
alias search="yay -Ss" # Search for a package
alias sync="yay -Syy" # sync the repos
alias update="sudo pacman -Syu" # Update the system, but not AUR
alias onlyAUR="yay -Sua --noconfirm" # Update onlyAUR

# Other aliases 
# Emacs

alias em="/usr/bin/emacs -nw" # for terminal
alias emacs="emacsclient -c -a 'emacs'" # For an instance

# VIM
alias vim="nvim"

# Aliases for Windows managers server
alias qtile_log="cd ~/.local/share/qtile; bat qtile.log"
alias qtile_server="Xephyr -br -ac -noreset -screen 1300x730 :1 & DISPLAY=:1 qtile"
alias awesome_server="Xephyr -br -ac -noreset -screen 1300x730 :1 & DISPLAY=:1 awesome ~/.config/awesome/rc.lua"


alias ls='exa -a --color=always --group-directories-first' # my preferred listing
alias la='exa -al --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
# alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'
