#!/bin/bash

args=("$@")
name=${args[0]}
path=$HOME/pythonProjects/$name

if [[ -z "$name" ]]; then
  echo "createPython <nombre>"
  exit 0
fi

if [[ -e "$path" ]]; then
  echo "name already in use"
  exit
fi

logsPath=$HOME/pythonProjects/logs
log=`date +"%Y-%m-%d %T"`
log+=" user:$USER project_name:$name project_path:$path "

read -p "do you want to create a virtual environment [y/n]: " venv
read -p "do you want to create a git repository [y/n]: " gitRepo
echo

mkdir $path

if [[ ! -e "main.py" ]]; then
  touch "$path/main.py"
fi

if [[ "$venv" == "y" || "$venv" == "Y"  ]]; then
  virtualenv "$path/venv_$name"
  venv=true
  log+="virtualenv:true "
fi

if [[ "$gitRepo" == "y" || "$gitRepo" == "Y"  ]]; then
  cd $path
  git init
  log+="git_repository:true "
  if [[ "$venv" = true ]]; then
    touch .gitignore
    echo "#virtual environment" >> .gitignore
    echo "venv_$name/" >> .gitignore
  fi
fi

echo $log >> "$logsPath/log.txt"

echo
echo "project created at $path"
