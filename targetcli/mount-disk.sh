#!/bin/bash

function write_log {
echo $(date +"%d.%m.%Y %H:%M") $1 >> $2
}

disk=sdb1
file=/home/golubyatnikov/projects/log
folder=/ram_disk

[ -d $folder ] || (mkdir $folder && write_log "$folder has been created" $file)


if [ "$(lsblk | grep $disk | wc -l)" != '1' ];
then
write_log "disk '$disk' not found" $file
blk=$(echo $disk | cut -c 1-3)

if [ "$(lsblk | grep $blk[^1-5] | wc -l)" == '1' ]
then
write_log "'$blk' has been partitioned" $file
printf "n\np\n\n\n\nw\n" | fdisk /dev/$blk

mkfs.ext4 -F /dev/$disk
write_log "'$blk' has been formated" $file

mount /dev/$disk $folder
write_log "'$disk' mounted to '$folder'" $file

else
write_log "block device '$blk' not found" $file
fi

else
write_log "disk '$disk' found" $file

if [ "$(mount | grep /dev/$disk | wc -l)" == '0' ]
then
mount /dev/$disk $folder
write_log "'$disk' mounted to '$folder'" $file

fi

fi
