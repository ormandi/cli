# Prompt:
#
#   Set the bash prompt according to:
#    * the active virtualenv
#    * the branch of the current git repository
#    * the return value of the previous command
#
# LINEAGE:
#
#   Based on work by woods
#
#   https://gist.github.com/31967

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[0;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)
  # Set the final branch string.
  BRANCH="${PURPLE}${branch}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  set_git_branch

  # Set the bash prompt variable.
  PS1="${PYTHON_VIRTUALENV}${GREEN}\u@\h${COLOR_NONE}:${YELLOW}\w${COLOR_NONE}${BRANCH}${PROMPT_SYMBOL} "
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

# Make `ls` colorful by default.
alias ls='ls --color=auto'
alias ll='ls -lah'

# Add Homebrew to the `PATH`.
export PATH="/opt/homebrew/bin/:${PATH}"

# Add Rust to `PATH`
. "$HOME/.cargo/env"

# Initialize pyenv.
eval $(pyenv init --path)
export temp_file=$(mktemp)
pyenv init - > $temp_file
source $temp_file
pyenv virtualenv-init - > $temp_file
source $temp_file


# Bash completion.
# Use bash-completion, if available
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
# source ~/bash_completion/out/bazel-complete.bash

# Hide zshell warning.
export BASH_SILENCE_DEPRECATION_WARNING=1

# Add other aliases:
alias ssh_gcuda='gcloud compute ssh "cuda-examples-dev" --zone "us-central1-a" --project "cudaexamples"'
alias stop_gcuda='gcloud compute instances stop "cuda-examples-dev" --zone="us-central1-a"  --project="cudaexamples"'
alias start_gcuda='gcloud compute instances start "cuda-examples-dev" --zone="us-central1-a"  --project="cudaexamples"'