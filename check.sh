#!/bin/bash
if which firefox >/dev/null; then
    firefox=1
else
    firefox=0
fi


if which youtube-dl >/dev/null; then
    youtube_dl=1
else
    youtube_dl=0
fi


if which sqlite3 >/dev/null; then
    sqlite3=1
else
    sqlite3=0
fi


if [ $youtube_dl == 1 ]
then
echo 'youtube-dl is installed'
echo '# Array function is available'

else
echo '# this script needs youtube-dl'
echo 'sudo apt-get install youtube-dl'
exit
fi

if [ $firefox == 0 ]
then
echo '# Database function is not available'
echo 'sudo apt-get install firefox'
else
echo 'firefox is installed'
fi
if [ $sqlite3 == 0 ]
then
echo '# Database function is not available'
echo 'sudo apt-get install sqlite3'
else
echo 'sqlite3 is installed'
fi

if [ $youtube_dl == 1 ] && [ $firefox == 1 ] && [ $sqlite3 == 1 ]
then
echo '# database function is availabe'
echo '# Youtube Channels,Playlists Links must be stored in a bookmark folder. Variable is fav_dir'
else
echo '# database function needs youtube-dl + firefox + sqlite3'
fi
echo '# make download folder' 
echo 'mkdir ~/Downloads/youtube-dl'
echo '# Open youtube-dl.sh with texteditor and config !'





