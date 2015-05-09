

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Added to deploy rails on Bluehost
export HPATH=$HOME
export GEM_HOME=$HPATH/ruby/gems
export GEM_PATH=$GEM_HOME:/lib64/ruby/gems/1.9.3
export GEM_CACHE=$GEM_HOME/cache
export PATH=$PATH:$HPATH/ruby/gems/bin
export PATH=$PATH:$HPATH/ruby/gems

# display git branch and set color for status

COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[1;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"
function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"


  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "$branch "
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "$commit "
  fi
}

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_status {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  else
    local folder=${PWD##*/}
    echo "$folder "
  fi
}

function git_branch_color {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  if [[ $(git_branch) =~ "master" ]]; then
    echo -e $COLOR_YELLOW
  else
    echo -e $COLOR_BLUE
  fi
}

PS1="\[\$(git_color)\]"  # colors git status
PS1+="\$(git_status)"    # shows current folder
PS1+="\[\$(git_branch_color)\]" # colors master branch yellow
PS1+="\$(git_branch)"           # prints current branch
PS1+="\[$COLOR_RESET\]"   # '#' for root, else '$'
PS1+="Feed Me: "
export PS1

# Load git completions
git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
test -s $git_completion_script && source $git_completion_script
source ~/.git-completion.sh

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex
# Force ls to use colors (G) and use humanized file sizes (h)
alias ls='ls -Gh'

function mix {
  (
    cd /Users/stupo/spoton
    for dir in $(ls)
    do 
      echo "$dir"
      if [[ ! "$dir" =~ "mixins" ]] && [[ ! "$dir" =~ "ups" ]] && [[ ! "$dir" =~ "nginx" ]]; then
        (
          pwd
          cd /Users/stupo/spoton/"$dir"
          npm install -f spoton
        )
      fi
    done
  )
}
export mix