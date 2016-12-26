#! /bin/bash

#should be executed every day (crontab -e) 
datum=$(date -d "1 day ago" '+%Y%m%d')
#switch to the default firefox folder with sqlite databases
cd ~/.mozilla/firefox/*default*
#firefox manages bookmarks in a database. Firefox  bookmarks needs a folder auto-yt.
#save  playlists in this directory
dbarray=( $(sqlite3 -list places.sqlite 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title  == "auto-yt"))'; ))
#switch  home
cd
#let youtube-dl do the work  and download brandnew videos
for i in ${dbarray[@]}; do
youtube-dl --dateafter $datum --playlist-end 4 --max-downloads 2 $i
done
