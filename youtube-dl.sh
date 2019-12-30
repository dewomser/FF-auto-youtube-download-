#!/bin/bash
## This Shellscript downloads all fresh videos from a firefox bookmark folder. ##

## Update your youtube-dl ! ##
youtube-dl -U 
## or 
# pip install --upgrade youtube-dl
sleep 1
zaehl=0
## Variables ##

## Save all your Youtube playlists in favdir (amp3) ##
favdir="amp3"
## Firefox running ?
# ffon=0; ps -ef|grep firefox|grep -v grep && ffon=1
ffon=0; pgrep firefox && ffon=1
## Download folder ##
dl_folder=~/Downloads/youtube-dl
## Date= yesterday ##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Max. videos / datum to each playlist ##
perday=4
## if aria2 is installed example : ##
# aria2='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
aria2=''
## load from "database" or "array".
loadfrom=database
## firefox database
sqltdata=places.sqlite

## Start ##

cd ~/.mozilla/firefox/*default* || exit

if [ $ffon == 1 ] && [ $loadfrom == database ]
then
cp $sqltdata places2.sqlite
sqltdata=places2.sqlite
fi

## only edit dbarray test-content if you want to use it

if [ $loadfrom == array ]
then
 dbarray=(
 "https://www.youtube.com/user/GalileoOffiziell/videos"
 "https://www.youtube.com/user/BibisBeautyPalace/videos?sort=dd&shelf_id=1&view=0"
 "https://www.youtube.com/channel/UC53bIpnef1pwAx69ERmmOLA"
 )
##
##--------------------Do not edit below this line ! -----------------------
##
 
else
 ## This line puts FF bookmarks from sqlite3 to an array ##

# dbarray=( $(sqlite3 -list $sqltdata 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))
readarray -t dbarray < "$(sqlite3 -list $sqltdata 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; )"
fi
cd  $dl_folder || exit

## Let youtube-dl do the work  and download brandnew videos ##

for i in "${dbarray[@]}"; do
((zaehl++))
youtube-dl $aria2 --download-archive $dl_folder/archive/archive-$zaehl.txt --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
# echo $i
done
##
##--------------------Do not edit above this line ! -----------------------
##

## optional after all Downloads ##

## Feedback if this script is started from crontab
#export HOME=/home/karl
#export DISPLAY=:0.0
## Open folder in dolphin KDE
#dolphin $dl_folder
## Notifier KDE
#f=$(find $dl_folder -mtime 0,2 -type f -regex '.*\.\(mkv\|mp4\|wmv\|flv\|webm\|mov\)') && notify-send "Neue Videos": "$f" --icon=video-x-generic

 ## Notifier KDE in nice
#f=$(find $dl_folder -mtime 0 -type f -regex '.*\.\(mkv\|mp4\|wmv\|flv\|webm\|mov\)')
#folder1=$(echo $dl_folder|sed "s/\//\\\\\//g")
#f1=$(echo $f|sed "s/$folder1/\n /g")
#notify-send "Neue Videos": "$f1" --icon=video-x-generic

