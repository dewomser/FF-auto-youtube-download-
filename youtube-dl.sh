#!/bin/bash
## This Shellscript downloads all fresh videos from afirefox favorite folder. ##

## Config ##

## update youtube-dl ##
## "youtube-dl -U" or "pip youtube-dl install" ##
# pip install --upgrade youtube-dl
# sleep 3

## If Firefox is already running AND Sqlite bookmarks are used, this script will not do without action: ##
## Firefox manages bookmarks from a locked database.

## 1.) All Firefox instances must be killed. Manualy or uncomment next Line
# killall -9 firefox; sleep 3
## OR
## 2.) copy database and query there. Uncomment line 22 ; read line 60  

## from Firefox bookmarks ##
## change *default* if you have other profiles than default. ##
cd ~/.mozilla/firefox/*default* || exit
# cp places.sqlite places2.sqlite

## Variables ##

## save all your Youtube playlists in $favdir ##
favdir="bestof"
## Download folder ##
dl_folder="/home/foo/Downloads/youtube-dl/"
## Date= yesterday ##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Videos per day in each playlist##
perday=4
## if aria2 is installed example : ##
# aria2='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
aria2=''
## load from database or array
loadfrom=database

## Start ##

# echo $favdir
# echo  $dl_folder

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
 ## this line puts FF favourites from sqlite3 to an array ##
 ## edit "places" to "places2 in next line"
 dbarray=( $(sqlite3 -list places.sqlite 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))
fi
cd  $dl_folder || exit
## let youtube-dl do the work  and download brandnew videos##
# 
for i in "${dbarray[@]}"; do
youtube-dl $aria2 --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
# echo $i
done

## optional ##
#dolphin $dl_folder
