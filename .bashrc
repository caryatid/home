#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
set -o vi

alias ls='ls --color=auto'
alias xargs="xargs -I '{}' "
PS1='[\u@\h \W]\$ '
export LANG=en_US.UTF-8
export PATH=${HOME}/prog/bin/sublime_text_3:${HOME}:${HOME}/prog/bin:${HOME}/.xmonad:/home/dave/.cabal/bin:${PATH}
export EDITOR=yi
export TERMCMD=urxvtc
