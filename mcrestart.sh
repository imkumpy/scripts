#!/bin/bash

# Script to restart docker containers

SRCDIR=/home/lab/docker
cd $SRCDIR

# Loop through every dir in SRCDIR (live docker containers)
for dir in */; do
    dir=${dir%*/}

    #restart the containers
    cd $dir
    docker-compose down && docker-compose up -d
    cd $SRCDIR
done
