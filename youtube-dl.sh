#!/bin/bash
## This Shellscript downloads all fresh videos from afirefox favorite folder. ##

## update youtube-dl ##
## "youtube-dl -U" or "pip youtube-dl install" ##
# pip install --upgrade youtube-dl
# sleep 5

## Variables ##
## Firefox manages bookmarks from database. ##

# All firefox intances must be killed.
# Reason is: Error: database is locked

killall -9 firefox; sleep 3

# #save all your Youtube playlists in $favdir ##
favdir="bestof"
echo $favdir
## Download folder ##
dl_folder="/home/foo/Downloads/youtube-dl/"
echo  $dl_folder
## Date= yesterday ##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Videos per day in each playlist##
perday=4
## if aria2 is installed example : ##
# aria2='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
aria2=''

## from Firefox bookmarks ##
## change *default* if you have other profiles than default. ##
## comment if you load from array ##
cd ~/.mozilla/firefox/*default* || exit

## uncomment if you  load from an array ##
## No Firefox no variables needed ##
# dl_folder="~/Downloads"
# perday=4
# dbarray=(
# "https://www.youtube.com/user/example-foo"
# "https://www.youtube.com/channel/example-bar/videos?sort=dd&shelf_id=0&view=0"
# )

## comment this if you load from array ##
## this line puts FF favourites from sqlite3 to an array ##
dbarray=( $(sqlite3 -list places.sqlite 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))

## this  must not be commented ##
cd  $dl_folder || exit
## let youtube-dl do the work  and download brandnew videos##
# 
for i in "${dbarray[@]}"; do
youtube-dl $aria2 --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
# echo $i
done

## optional ###
#dolphin $dl_folder
