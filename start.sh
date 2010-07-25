#!/bin/bash

cd $HOME/maxine-freenode
touch keep-running
while [ -f keep-running ]
do
  ./infobot
done
