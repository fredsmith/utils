#! /usr/bin/env bash

. ~/dotfiles/bash/todotxt

args=($1)
if [[ ${args[0]} =~ ^-?[0-9]+$ ]]; then
  todo.sh do ${args[0]};
  todo.sh;
else
  if [[ -z "${args[0]}" ]]; then
    todo.sh;
  else
    todo.sh $@;
    todo.sh;
  fi
fi
