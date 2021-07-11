#!/bin/bash
####################################
#
# Backup to NFS mount script with
# grandfather-father-son rotation.
#
####################################
SRCDIR=/home/lab/docker

cd $SRCDIR
#Loop through directories in SRCDIR
for dir in */; do\
    # What to backup.
    dir=${dir%*/}
    backup_files=${dir%*/}

    # Where to backup to.
    dest=/media/shared/mc-backups/$dir

    # If dest doesn't exist, create it.
    if [ ! -d "$dest" ]; then
      mkdir $dest
    fi

    # Setup variables for the archive filename.
    day=$(date +%A)

    # Find which week of the month 1-4 it is.
    day_num=$(date +%-d)
    if (( $day_num <= 7 )); then
            week_file="$dir-week1.tgz"
    elif (( $day_num > 7 && $day_num <= 14 )); then
            week_file="$dir-week2.tgz"
    elif (( $day_num > 14 && $day_num <= 21 )); then
            week_file="$dir-week3.tgz"
    elif (( $day_num > 21 && $day_num < 32 )); then
            week_file="$dir-week4.tgz"
    fi

    # Find if the Month is odd or even.
    month_num=$(date +%m)
    month=$(expr $month_num % 2)
    if [ $month -eq 0 ]; then
            month_file="$dir-month2.tgz"
    else
            month_file="$dir-month1.tgz"
    fi

    # Create archive filename.
    if [ $day_num == 1 ]; then
        archive_file=$month_file
    elif [ $day != "Saturday" ]; then
            archive_file="$dir-$day.tgz"
    else
        archive_file=$week_file
    fi

    # Print start status message.
    echo "Backing up $backup_files to $dest/$archive_file"
    date
    echo

    # Backup the files using tar.
    tar czf $dest/$archive_file $backup_files

    # Backup week files to S3
    if [ $archive_file == $week_file ]; then
	/usr/local/bin/aws s3 cp $dest/$archive_file s3://kumpdev-mcbackups/
	echo "Backed up files to S3"
    fi

    # Print end status message.
    echo
    echo "Backup finished"
    date

    # Long listing of files in $dest to check file sizes.
    ls -lh $dest/
done
