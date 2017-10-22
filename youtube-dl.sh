#! /bin/bash
#This Bash-script should be executed every day (crontab -e) 

update youtube-dl
youtube-dl -U
sleep 5
# fav dir
# put in your favorite path
favdir="auto-yt"
#echo $favdir
#Date= yesterday
datum=$(date -d "1 day ago" '+%Y%m%d')

# from array. No Firefox needed
#dbarray=(
#"https://www.youtube.com/user/example-foo"
#"https://www.youtube.com/channel/example-bar/videos?sort=dd&shelf_id=0&view=0"
#)

# from Firefox bookmarks
#switch to the default firefox folder with sqlite databases.
#change *default* if you have other profiles than default.
cd ~/.mozilla/firefox/*default*

#firefox manages bookmarks from database. 
#Firefox  bookmarks needs a folder auto-yt.
#save all your Youtube playlists in auto-yt
dbarray=( $(sqlite3 -list places.sqlite 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))'; ))
#switch  to your youtube download folder
cd ~/Downloads
#let youtube-dl do the work  and download brandnew videos
for i in ${dbarray[@]}; do
youtube-dl --dateafter $datum --playlist-end 4 --max-downloads 2 $i
done
