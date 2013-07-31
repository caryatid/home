#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
set -o vi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
export LANG=en_US.UTF-8
export PATH=${HOME}:${HOME}/prog/bin:${HOME}/.xmonad:/home/dave/.cabal/bin:${PATH}
export EDITOR=yi
export TERMCMD=urxvtc
