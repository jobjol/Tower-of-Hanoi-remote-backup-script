#!/bin/bash
####################################
#
# Tower of Hanoi remote server backup script v1.1
# Fork of hanoi_backup v2.3.1 jeremdow@gmail.com
#
# This script will archive directories of a remote server on the local host.
# If run as a daily cron job, archives are rotated on a Tower of Hanoi schedule.
# Archives from 1, 2, 4, 8, 16... $max days ago are retained depending on the setting.
#
####################################

# Configuration Settings

# Remote server access info.
user="remote-user"
server="10.10.10.1"

# Where to backup to. (dont append a slash)
dest="/home/remote-user/backup"

# Backup folder at remote server (dont append a slash)
files="/home/remote-user"

# Exclude pattern(s), see man rsync --exclude
exclude="**sites/default/files**"
# Oldest backup to keep (as a power of 2 in days)
max="10"

####################################

# Create archive filename.
date=$(date +%F)
file_archive="$server-$date";

# Print start status message.
echo $(date)
echo "Backing up locations: $server:$files to $dest/$file_archive"
echo

# Backup files. Full backup. With compression
rsync -az --update --delete $user@$server:$files $dest/$file_archive --exclude $exclude 

# Print end status message.
echo "Backup $dest/$file_archive complete"
date
echo

# Calculate the previous move in the cycle
((day=$(date +%s)/86400))
for (( i=1; i<=$max/2; i=2*i ))
    do
    (( rotation=$day & i ))
    if [ "$rotation" -eq "0" ]
    then
        (( expired=$i*2 ))
        break
    else
        expired="4"
    fi
done

# Remove the expired backups

expired_file=$server-$(date -d "$expired days ago" +%F)
echo "Attempting to remove expired backup: $dest/$expired_file"
if [ -d $dest/$expired_file ]
then
    rm "$dest/$expired_file" -R
    #find $dest -name "$expired_file" -type d -delete
fi

# Finished
echo Complete!
