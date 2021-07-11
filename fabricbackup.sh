#!/bin/bash
# Back up minecraft(docker) servers

TIME=`date +%b-%d-%y-%H` #This will add the date to file name
#SRCDIR=/home/lab/docker/

cd /home/lab/docker/bungee/data

#Loop through directories in SRCDIR
#for dir in */; do\

    #Remove trailing / in dir
    #dir=${dir%*/}
    #echo "$dir"

    FILENAME=fabric-$TIME-H.tar.gz
    DESDIR=/media/shared/mc-backups/fabric-fastbackups/

    #Ensure DESDIR exists
    mkdir $DESDIR

    #Backup server files
    tar -cpzf $DESDIR/$FILENAME fabric/ 

    #Remove backups older than 3 days
    find $DESDIR/fabric-*.tar.gz -type f -mtime +3 -delete
#done
