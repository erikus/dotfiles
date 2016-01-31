setopt append_history auto_param_keys auto_param_slash auto_remove_slash bad_pattern bang_hist brace_ccl chase_links clobber complete_aliases complete_in_word csh_junkie_history equals exec extended_glob function_argzero glob glob_dots glob_subst hash_cmds hash_dirs hist_ignore_dups hist_ignore_space hist_no_store hup interactive_comments list_ambiguous list_packed list_types long_list_jobs mark_dirs multios nomatch notify prompt_cr prompt_subst pushd_ignore_dups pushd_to_home rc_expand_param rc_quotes rcs rm_star_silent short_loops sh_word_split hist_ignore_all_dups unset auto_list typeset_silent extended_history
unsetopt always_to_end auto_menu rec_exact print_exit_value
setopt zle 2> /dev/null
unsetopt all_export always_last_prompt auto_cd auto_name_dirs auto_pushd auto_resume beep bg_nice bsd_echo cdable_vars correct correct_all csh_junkie_loops csh_junkie_quotes csh_null_glob err_exit flow_control global_rcs glob_assign glob_complete hash_list_all hist_allow_clobber hist_beep hist_verify ignore_braces ksh_arrays ksh_option_print list_beep local_options mail_warning magic_equal_subst menu_complete null_glob numeric_glob_sort overstrike path_dirs posix_builtins pushd_minus pushd_silent sh_file_expansion sh_glob sh_option_letters single_line_zle sun_keyboard_hack
setopt ignore_eof
#interactive login monitor privileged shin_stdin single_command verbose xtrace

ulimit -SHc unlimited -SHt unlimited -SHf unlimited -SHd unlimited -SHv unlimited -Ss 256000 -Sn unlimited 2> /dev/null
ulimit -Sc 0
umask 027

IFS="$(print -n ' \t\n\r')"
NULLCMD=:
READNULLCMD=:
SAVEHIST=1000000

export TERM=xterm-256color
export EDITOR=vim
export GREP_OPTIONS='--color=auto'
export LC_ALL=C
export LESS='-cfiQMwx -h20 -j10 -y20 -z-3 -#8'
export LESSCHARSET=latin1
export LISTER='ls -LF'
#export PAGER='less -e'
export PARINIT='rTbgqR B=.,?_A_a Q=_s>|:'
export RSYNC_RSH=ssh
export VISUAL=vim
export XENVIRONMENT=~/.Xdefaults

export ENFORCE_TOOLS_COMPATIBILITY=0
export HOSTNAME="$(print -P %m)"
export P4CONFIG=.p4config
export P4EDITOR="$EDITOR"
export TIME='%es wall  %Us user  %Ss system  %P load    %C'

export GOPATH='/usr/local/google/home/estaab/go'

export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
