#!/bin/bash
## This Shellscript downloads all fresh videos from afirefox favorite folder. ##

## update your youtube-dl ##
# "youtube-dl -U" 
## or 
# pip install --upgrade youtube-dl
# sleep 3

## Variables ##

## save all your Youtube playlists in $favdir ##
favdir="bestof"
## firefox running ?
ffon=0; ps -ef|grep firefox|grep -v grep && ffon=1
## Download folder ##
dl_folder="/home/foo/Downloads/youtube-dl/"
## Date= yesterday ##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Videos per day on each playlist##
perday=4
## if aria2 is installed example : ##
# aria2='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
aria2=''
## load from database or array
loadfrom=database
## firefox database
sqltdata=places.sqlite

## Start ##

cd ~/.mozilla/firefox/*default* || exit

if (( ffon == 1 && loadfrom == database ))
then
cp $sqltdata places2.sqlite
sqltdata=places2.sqlite
fi

## only edit dbarray content if you want to use it

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
 ## This line puts FF favourites from sqlite3 to an array ##
 ## Only if 2.) Next line edit "places" to "places2"
 dbarray=( $(sqlite3 -list $sqltdata 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))
fi
cd  $dl_folder || exit

## Let youtube-dl do the work  and download brandnew videos ##

for i in "${dbarray[@]}"; do
youtube-dl $aria2 --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
# echo $i
done

## optional ##
#dolphin $dl_folder
