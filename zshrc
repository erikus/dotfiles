# erik's zshrc - interactive shell configuration

# --- Completion ---
autoload -U compinit
compinit

# Source site-specific configs
for rc in ~/.bashrc.*(N); do
  source "$rc"
done

# Ignore unlikely file extensions in completion
FIGNORE='.o:~:.class:.pyc'

# --- Aliases ---
alias ls="ls --color=auto"
alias sl="ls"
alias tree='tree -Csu'
alias p="ps x -o pgrp,pid,cmd"

alias srcc="source ~/.zshrc"
alias vi="vim -X"
alias on="screen -x -R"

alias vg="vi ~/.gitconfig"
alias vv="vi ~/.vimrc"
alias vzr="vi ~/.zshrc"
alias vze="vi ~/.zshenv"

# --- Key bindings ---

# Navigation
bindkey "^[[1;5D" backward-word           # ctrl-left
bindkey "^[[1;5C" forward-word            # ctrl-right
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# History search
bindkey '^F' history-beginning-search-backward
bindkey '^G' history-beginning-search-forward
bindkey '^R' history-incremental-pattern-search-backward

# Editing
bindkey '^S' menu-complete
bindkey '^L' clear-screen
bindkey '^P' yank
bindkey '^W' backward-kill-word

autoload edit-command-line
zle -N edit-command-line
bindkey '^O' edit-command-line

# Custom backward-kill-word that respects shell word boundaries
function zsh-backward-kill-word() {
  local WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
  zle .backward-kill-word
}
zle -N zsh-backward-kill-word
bindkey '^D' zsh-backward-kill-word

# Terminal key bindings via termcap
bindkey "^[[5C" forward-word              # shift-right
bindkey ";5C" forward-word                # shift-right
bindkey ";2C" forward-word                # shift-right
bindkey "^[[5D" backward-word             # shift-left
bindkey ";5D" backward-word               # shift-left
bindkey ";2D" backward-word               # shift-left
bindkey -r "^[[5;"

{ local saveterm="$TERM"; TERM=xterm-vt220-full
bindkey "$(echotc %i)" forward-word       # shift-right
bindkey "$(echotc \#3)" yank              # shift-insert
bindkey "$(echotc \#4)" backward-word     # shift-left
bindkey "$(echotc \*7)" end-of-history    # shift-end
TERM="$saveterm" } 2> /dev/null

bindkey "$(echotc @7)" end-of-line        # end
bindkey "$(echotc kD)" delete-char        # delete
bindkey "$(echotc kI)" overwrite-mode     # insert
bindkey "$(echotc kN)" down-history       # page down
bindkey "$(echotc kP)" up-history         # page up
bindkey "$(echotc kb)" backward-delete-char  # backspace
bindkey "$(echotc kd)" down-line-or-history  # down arrow
bindkey "$(echotc kh)" beginning-of-line  # home
bindkey "$(echotc kl)" backward-char      # left arrow
bindkey "$(echotc kr)" forward-char       # right arrow
bindkey "$(echotc ku)" up-line-or-history # up arrow
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

# --- Prompt ---
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

  function hardstatus { print -n "\e]0;" && print -Rn "$@" && print -n "\a" }
  function windowname { [[ -n "$WINDOW" ]] && print -n "\ek" && print -Rn "$@" && print -n "\e\\" }

  function precmd {
    local cmd_status=$?
    print -Rn "$reset$bold$blue"
    jobs
    hardstatus "$(print -Pn "[%m:%~] %%")"
    windowname "$(print -Pn "%2~%#")"
    if [[ -n "$precmd_cmd" && $cmd_status -ne 0 ]]; then
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

  typeset -gH PS1="%{$reset$bold$cyan%}%m%{$white%}:%{$yellow%}%~%{$reset$bold%}\${WINDOW:+.s$WINDOW}%# %{$reset%}"
  typeset -gH PROMPT prompt
  typeset -gH POSTEDIT="$reset"
}

setup_prompt

# --- History ---
if [[ -z "$HISTFILE" ]]; then
  typeset -r HISTFILE=~/.zsh_history
  typeset -r HISTSIZE=90000
  typeset -r SAVEHIST=90000
fi

# --- Syntax highlighting ---
local _zsh_hl
if [[ $(uname) = Darwin ]]; then
  _zsh_hl=/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  _zsh_hl=/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f "$_zsh_hl" ]]; then
  source "$_zsh_hl"
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan'
fi

# --- npm completion ---
if type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
fi

# --- Optional environment-specific configs ---
# Source bash/legacy compatibility settings if present
[[ -f "${ZDOTDIR:-$HOME}/.zshrc.compat" ]] && source "${ZDOTDIR:-$HOME}/.zshrc.compat"
# Source special settings if present
[[ -f "${ZDOTDIR:-$HOME}/.zshrc.special" ]] && source "${ZDOTDIR:-$HOME}/.zshrc.special"
