#!/bin/bash

## This Shellscript downloads all fresh videos from array or firefox bookmark folder with youtube playlists. ##

## Update your youtube-dl ! ##
# "youtube-dl -U" 
## or 
# pip install --upgrade youtube-dl
# sleep 3

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
ffprofile=$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=//)
## Date= yesterday ##
datum=$(date -d "1 day ago" '+%Y%m%d')
## Max. videos download in each playlist ##
perday=4
## if aria2 downloader is installed and you want to use it, change from 0 to 1  ##
aria=0
## load from "database" or "array". database == firefox SQLITE 
loadfrom=database
## firefox database
sqltdata=places.sqlite

## Start ##

##  Use array, edit dbarray for your needs else this is ignored. ##
if [ $loadfrom == array ]
then
 dbarray=(
 "https://www.youtube.com/user/GalileoOffiziell/videos"
 "https://www.youtube.com/user/BibisBeautyPalace/videos?sort=dd&shelf_id=1&view=0"
 "https://www.youtube.com/channel/UC53bIpnef1pwAx69ERmmOLA"
)
 ##-----carefully edit below this line ! ---------
 else
 # cd ~/.mozilla/firefox/*default* || exit
 cd "$HOME/.mozilla/firefox/$ffprofile" || exit
 ## If Firefox is running, db is locked. need a copy ##
 if [ $ffon == 1 ] && [ $loadfrom == database ]
  then
  cp $sqltdata places2.sqlite
  sqltdata=places2.sqlite
 fi
 ## This line puts FF bookmarks from sqlite3 to an array ##
 readarray -t dbarray < "$(sqlite3 -list $sqltdata 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; )"
fi

## Let youtube-dl do the work  and download brandnew videos ##
cd $dl_folder || exit
if [ $aria == 1 ]
then
 for i in "${dbarray[@]}"; do
youtube-dl --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" --external-downloader aria2c --external-downloader-args '-c -j 3 -x 3 -s 3 -k 1M' "$i"
 done
 else
 for i in "${dbarray[@]}"; do
youtube-dl --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"
 done
fi

## optional show downloadfolder ##
#dolphin $dl_folder
