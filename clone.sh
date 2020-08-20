#!/bin/sh

echo "Making Project Directories..."

mkdir -p $HOME/Projects/{Forks,College,Playground,Repos,Personal}

echo "Cloning repositories..."

PROJECTS=$HOME/Projects

PERSONAL=$PROJECTS/Personal
REPOS=$PROJECTS/Repos

# Personal
git clone git@github.com:Mugilan-Codes/100-days-of-code.git $PERSONAL/100-days-of-code
git clone git@github.com:Mugilan-Codes/workout-tracker.git $PERSONAL/workout-tracker

# Repos
git clone git@github.com:Mugilan-Codes/my-family-budget.git $REPOS/my-family-budget