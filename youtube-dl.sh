#!/bin/bash
#
# This Shellscript downloads all fresh videos from afirefox favorite folder.
# sqlite3 and youtube-dl must  be installed
# 
#update youtube-dl
# "youtube-dl -U" or "pip youtube-dl install"
# pip install --upgrade youtube-dl
# sleep 5

# Variables #
##firefox manages bookmarks from database. ##
##save all your Youtube playlists in $favdir##
favdir="bestof"
echo $favdir
##Download folder##
dl_folder="/home/foo/Downloads/youtube-dl/"
echo  $dl_folder
##Date= yesterday##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Videos per day in each playlist##
perday=4
##if aria2 is installed example :##
#aria2='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
aria2=''

## from Firefox bookmarks##
## switch to the default firefox folder with sqlite databases.##
## change *default* if you have other profiles than default.##
cd ~/.mozilla/firefox/*default* || exit

##uncomment if you  load from an array##
##No Firefox no variables needed##
#dl_folder="~/Downloads"
#perday=4
#dbarray=(
#"https://www.youtube.com/user/example-foo"
#"https://www.youtube.com/channel/example-bar/videos?sort=dd&shelf_id=0&view=0"
#)

##comment this if you load from array##
##firefox manages bookmarks from database.## 
##Firefox  bookmarks needs a folder $favdir.##
##save all your Youtube playlists in $favdir##
dbarray=( $(sqlite3 -list places.sqlite 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))

##this  must not be commented##
cd  $dl_folder || exit
## let youtube-dl do the work  and download brandnew videos##
# 
for i in "${dbarray[@]}"; do
youtube-dl "$aria2" --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
# echo $i
done

#dolphin $dl_folder
