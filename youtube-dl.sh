#!/bin/bash

## This Shellscript downloads all fresh videos from array or firefox bookmark folder with youtube playlists. ##

## Update your youtube-dl ! ##
# "youtube-dl -U" 
## or 
# pip install --upgrade youtube-dl
sleep 1
#zaehl=0

## Variables ##
## ----------important-------------
## Download folder make it. mkdir ~/Downloads/youtube-dl ##
dl_folder=~/Downloads/youtube-dl
## Save all your Youtube playlists in FF bookmark (bestof) ##
favdir="bestof"
## ------------ may help----------
## Firefox running ?
ffon=0; pgrep firefox && ffon=1
## Firefox default Profil
## only if you not using the default FF-profile, this line must be edited ## 
# ffprofile=$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=//)
## Date= yesterday ##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Max. videos download in each playlist ##
perday=4
## if aria2 downloader is installed and you want to use it, change from 0 to 1  ##
aria2=''
## load from "database" or "array". database == firefox SQLITE 
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

 dbarray=( $(sqlite3 -list $sqltdata 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))
fi
cd  $dl_folder || exit

## Let youtube-dl do the work  and download brandnew videos ##
## Wenn die Variable zaehl aktiviert ist, kann der parameter eingebaut werden.
##--download-archive $dl_folder/archive/archive-$zaehl.txt

for i in "${dbarray[@]}"; do
((zaehl++))
youtube-dl $aria2 --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
# echo $i
done


## optional ##

# dolphin $dl_folder
## send-notify ##
# f=$(find $dl_folder -mtime 0,2 -type f -regex '.*\.\(mkv\|mp4\|wmv\|flv\|webm\|mov\)') && notify-send "Neue Videos": "$f" --icon=video-x-generic

