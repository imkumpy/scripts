#!/bin/bash

# Script to restart docker containers

SRCDIR=/home/lab/docker
cd $SRCDIR

# Loop through every dir in SRCDIR (live docker containers)
for dir in */; do
    dir=${dir%*/}

    # Restart the containers
    # Down/up is used to push any possible changes to compose files that may have occurred in last 24hr, restart does not provide this functionality
    cd $dir
    docker-compose down && docker-compose up -d
    cd $SRCDIR
done
