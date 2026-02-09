# erik's zshenv - environment variables and shell options
# Loaded for all shells (interactive and non-interactive)

# --- Shell options ---

# History
setopt extended_history
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_no_store

# Globbing and matching
setopt bad_pattern
setopt brace_ccl
setopt extended_glob
setopt glob
setopt glob_dots
setopt glob_subst
setopt equals
setopt nomatch

# Completion
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
setopt complete_aliases
setopt complete_in_word
setopt auto_list
setopt list_ambiguous
setopt list_packed
setopt list_types

# Directory navigation
setopt chase_links
setopt pushd_ignore_dups
setopt pushd_to_home
setopt mark_dirs

# Job control
setopt long_list_jobs
setopt hup
setopt notify

# Misc
setopt bang_hist
setopt clobber
setopt csh_junkie_history
setopt exec
setopt function_argzero
setopt hash_cmds
setopt hash_dirs
setopt interactive_comments
setopt multios
setopt prompt_cr
setopt prompt_subst
setopt rc_expand_param
setopt rc_quotes
setopt rcs
setopt rm_star_silent
setopt short_loops
setopt sh_word_split
setopt unset
setopt typeset_silent
setopt ignore_eof
setopt zle 2> /dev/null

# Explicitly disabled options
unsetopt always_to_end
unsetopt auto_menu
unsetopt rec_exact
unsetopt print_exit_value
unsetopt always_last_prompt
unsetopt auto_cd
unsetopt auto_name_dirs
unsetopt auto_pushd
unsetopt auto_resume
unsetopt beep
unsetopt bg_nice
unsetopt bsd_echo
unsetopt cdable_vars
unsetopt correct
unsetopt correct_all
unsetopt csh_junkie_loops
unsetopt csh_junkie_quotes
unsetopt csh_null_glob
unsetopt err_exit
unsetopt flow_control
unsetopt global_rcs
unsetopt glob_assign
unsetopt glob_complete
unsetopt hash_list_all
unsetopt hist_allow_clobber
unsetopt hist_beep
unsetopt hist_verify
unsetopt ignore_braces
unsetopt ksh_arrays
unsetopt ksh_option_print
unsetopt list_beep
unsetopt local_options
unsetopt mail_warning
unsetopt magic_equal_subst
unsetopt menu_complete
unsetopt null_glob
unsetopt numeric_glob_sort
unsetopt overstrike
unsetopt path_dirs
unsetopt posix_builtins
unsetopt pushd_minus
unsetopt pushd_silent
unsetopt sh_file_expansion
unsetopt sh_glob
unsetopt sh_option_letters
unsetopt single_line_zle
unsetopt sun_keyboard_hack

# --- Resource limits ---
ulimit -SHc unlimited -SHt unlimited -SHf unlimited -SHd unlimited -SHv unlimited -Ss 256000 -Sn unlimited 2> /dev/null
ulimit -Sc 0
umask 027

# --- Shell variables ---
IFS="$(print -n ' \t\n\r')"
NULLCMD=:
READNULLCMD=:
SAVEHIST=1000000

# --- Environment variables ---
export TERM=xterm-256color
export EDITOR=vim
export VISUAL=vim
export LC_ALL=en_US.UTF-8
export LESS='-cfiQMwx -h20 -j10 -y20 -z-3 -#8'
export LESSCHARSET=latin1
export LISTER='ls -LF'
export PARINIT='rTbgqR B=.,?_A_a Q=_s>|:'
export RSYNC_RSH=ssh
export XENVIRONMENT=~/.Xdefaults
export HOSTNAME="$(print -P %m)"
export TIME='%es wall  %Us user  %Ss system  %P load    %C'

# --- Optional tool integrations ---
# Cargo/Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# --- Optional environment-specific configs ---
# Source Google-internal settings if present
[[ -f "${ZDOTDIR:-$HOME}/.zshenv.google" ]] && source "${ZDOTDIR:-$HOME}/.zshenv.google"
