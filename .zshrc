# erik's global zshrc file

# default prompt color
PROMPT_COLOR='\[\e\[0;39m\]'
PROMPT_COLOR2='\[\e\[0;39m\]'

autoload -U compinit
compinit

# source site specific resources
for bashrc in `/bin/ls -a ~ | grep bashrc.`
do
  if [ -f ~/$bashrc ]; then
    source ~/$bashrc
  fi
done

# Don't use ^D to exit
set -o ignoreeof

# turn off the bell
set bell-style none

# Don't put duplicate lines in the history.
export HISTCONTROL=erasedups
# export HISTIGNORE=" *:[^./]*([^ ])"

# command line prompt, in color
#PS1="$PROMPT_COLOR\h:$PROMPT_COLOR2\w$PROMPT_COLOR\$\[\e[0m\] "

# ignore unlikely files
FIGNORE='.o:~:.class'

# grep colors
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# make subversion happy
export SVN_EDITOR=/usr/bin/vim
export EDITOR=/usr/bin/vim

# make files only mine by default
umask 027

function gvd() {
  DISPLAY= P4DIFF=vimdiff g4 diff $@
}

function exit() {
  if [ -e $STY ]; then
    unfunction exit
    exit
  fi
  echo "You're in screen, don't exit!"
}

function _exit() {
  unfunction exit
  exit
}

# aliases
alias ls="ls --color=auto --block-size=K"
alias sl="ls"
alias tree='tree -Csu'
alias cat='cat -v'
alias p="ps x -o pgrp,pid,cmd"

alias srcc="source ~/.zshrc"
alias vi="vim -X"
alias on="screen -x -R"

bindkey '^F' history-beginning-search-backward
bindkey '^G' history-beginning-search-forward
bindkey '^D' kill-word
bindkey "$(echotc @7)" end-of-line           # end

bindkey '^S' menu-complete

autoload edit-command-line
zle -N edit-command-line
bindkey '^O' edit-command-line

bindkey '^L' clear-screen
bindkey '^P' yank
bindkey '^W' backward-kill-word

# This doesn't appear to be in the version of zsh I'm running (4.3)
function xxx-bash-backward-kill-word() {
  local WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
  zle .backward-kill-word
}
zle -N xxx-bash-backward-kill-word xxx-bash-backward-kill-word
bindkey '^D' xxx-bash-backward-kill-word
bindkey "^[[5C" forward-word          # shift-right
bindkey ";5C" forward-word          # shift-right
bindkey ";2C" forward-word          # shift-right
bindkey "^[[5D" backward-word        # shift-left
bindkey ";5D" backward-word        # shift-left
bindkey ";2D" backward-word        # shift-left
bindkey -r "^[[5;"  # shift-left
{ local saveterm="$TERM"; TERM=xterm-vt220-full
bindkey "$(echotc %i)" forward-word          # shift-right
bindkey "$(echotc \#3)" yank                 # shift-insert
bindkey "$(echotc \#4)" backward-word        # shift-left
bindkey "$(echotc \*7)" end-of-history       # shift-end
TERM="$saveterm" } 2> /dev/null
bindkey "$(echotc @7)" end-of-line           # end
bindkey "$(echotc kD)" delete-char           # delete
bindkey "$(echotc kI)" overwrite-mode        # insert
bindkey "$(echotc kN)" down-history          # page down
bindkey "$(echotc kP)" up-history            # page up
bindkey "$(echotc kb)" backward-delete-char  # backspace
bindkey "$(echotc kd)" down-line-or-history  # down arrow
bindkey "$(echotc kh)" beginning-of-line     # home
bindkey "$(echotc kl)" backward-char         # left arrow
bindkey "$(echotc kr)" forward-char          # right arrow
bindkey "$(echotc ku)" up-line-or-history    # up arrow
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

# stolen from ambrose
function setup_prompt {
  typeset -gH reset="$(echotc me)"
  typeset -gH bold="$(echotc md)"
  typeset -gH underline="$(echotc us)"
  typeset -gH black="$(echotc AF 0 0 0)"
  typeset -gH red="$(echotc AF 1 1 1)"
  typeset -gH green="$(echotc AF 2 2 2)"
  typeset -gH yellow="$(echotc AF 3 3 3)"
  typeset -gH blue="$(echotc AF 4 4 4)"
  typeset -gH magenta="$(echotc AF 5 5 5)"
  typeset -gH cyan="$(echotc AF 6 6 6)"
  typeset -gH white="$(echotc AF 7 7 7)"
  typeset -gH reverse="$(echotc mr)"
  # set screen hardstatus, or xterm icon name and window title
  function hardstatus { print -n "\e]0;" && print -Rn "$@" && print -n "\a" }
  # set screen window title
  function windowname { [[ -n "$WINDOW" ]] && print -n "\ek" && print -Rn "$@" && print -n "\e\\" }

  function precmd {
    local cmd_status=$?
    print -Rn "$reset$bold$blue"
    jobs
    hardstatus "$(print -Pn "[%m:%~] %%")"
    windowname "$(print -Pn "%2~%#")"
    if [ -n "$precmd_cmd" -a $cmd_status -ne 0 ]; then
      print -Rn "$reset$bold$red"
      print "$cmd_status: $precmd_cmd"
    fi
    precmd_cmd=''
  }
  function preexec {
    print -n "$reset"
    local cmd="$1"
    precmd_cmd=$cmd
    if [[ "$cmd[(w)1]" == "fg" ]]; then
      cmd="$cmd %%"
      jobs "$cmd[(w)2]" 2> /dev/null | read cmd cmd cmd cmd
    fi
    cmd="$(print -Rn " $cmd" | tr -cs '[:print:]' ' ')"
    hardstatus "$(print -Pn "[%m:%~]")""$cmd"
    windowname "$(print -Pn "%2~:")""$cmd"
  }

  typeset -gH PS1="%{$reset$bold$cyan%}%m%{$white%}:%{$yellow%}\${PWD##$HOME/#}%{$reset$bold%}\${WINDOW:+.s$WINDOW}%# %{$reset%}"
  typeset -gH PROMPT prompt
  typeset -gH POSTEDIT="$reset"
}

setup_prompt

# history
if [ -z "$HISTFILE" ]; then
  typeset -r HISTFILE=~/.bash_history
  typeset -r HISTSIZE=90000
  typeset -r SAVEHIST=90000
fi

source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
#ZSH_HIGHLIGHT_PATTERNS+=('rm -rf ' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan'
