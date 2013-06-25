#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
export LANG=en_US.UTF-8
export PATH=${HOME}:${HOME}/.xmonad:/home/dave/.cabal/bin:${PATH}
export EDITOR=vim
export TERMCMD=urxvtc
