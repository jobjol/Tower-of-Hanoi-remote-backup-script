# Tower of Hanoi remote backup script
Linux bash script

Author: jobjol jobjoling[at]gmail.com

Fork of hanoi_backup v2.3.1 Author: jeremdow[at]gmail.com

##Purpose
Generate full backups from remote server locations with rsync.

##Desciption
This script will archive specified files and folders on the remote host.
If run as a daily cron job, archives are rotated on a Tower of Hanoi schedule.
Archives from 1, 2, 4, 8, 16... $max days ago are retained depending on the setting.

##prerequisites
copy your SSH key to the remote host, to allow access without a password.

##settings
user = username to login with at the remote server
server = IP address remote server
dest = local backup destination (make sure this directory exists and the script has write permissions to it. Don't append a slash)
files = remote backup directory (don't append a slash)
exclude = Exclude pattern(s), see man rsync --exclude
max = Oldest backup to keep (as a power of 2 in days)
