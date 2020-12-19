#!/bin/bash
# Back up minecraft(docker) servers

TIME=`date +%b-%d-%y` #This will add the date to file name
SRCDIR=/home/lab/docker

cd $SRCDIR

#Loop through directories in SRCDIR
for dir in */; do\

    #Remove trailing / in dir
    dir=${dir%*/}
    echo "$dir"

    FILENAME=$dir-$TIME.tar.gz
    DESDIR=/media/shared/mc-backups/$dir

    #Ensure DESDIR exists
    mkdir $DESDIR

    #Backup server files
    tar -cpzf $DESDIR/$FILENAME -C $SRCDIR $dir 

    #Remove backups older than 7 days
    find $DESDIR/$dir-*.tar.gz -type f -mtime +7 -delete
done
