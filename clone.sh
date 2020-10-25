#!/bin/sh

echo "Making Project Directories..."

mkdir -p $HOME/Projects/{Forks,College,Playground,Repos,Personal,Tutorials}

echo "Cloning repositories..."


PROJECTS=$HOME/Projects

FORKS=$PROJECTS/Forks
COLLEGE=$PROJECTS/College
PLAYGROUND=$PROJECTS/Playground
REPOS=$PROJECTS/Repos
PERSONAL=$PROJECTS/Personal
TUTORIALS=$PROJECTS/Tutorials

# Personal

# Repos
git clone git@github.com:Mugilan-Codes/my-family-budget.git $REPOS/my-family-budget