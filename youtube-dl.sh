#!/bin/bash
## This Shellscript downloads all fresh videos from a firefox bookmark folder. ##

### Variables to edit from the user###

## path to youtube-dl. If you dont know, use shell command:"which youtube-dl" ##
# example1 declare -r yot_dl_p=$(which youtube-dl)
# example2 declare -r yot_dl_p="youtube-dl"
declare -r yot_dl_p="$HOME/bin/youtube-dl"
#Test
test="Program youtube-dl not found" ; find "$yot_dl_p"  >/dev/null 2>&1  && test="youtube-dl found at: $yot_dl_p"
echo "$test"

# folder for the downloaded Videos mkdir "thefolder"and"thefolder/profile" by hand. #
declare -r dl_folder="$HOME/Downloads/youtube-dl"
#Test
test="No Download folder defined" ; find "$dl_folder"  >/dev/null 2>&1  && test="Found Downlad folder at: $dl_folder"
echo "$test"

# load from "database" or "array".#
declare -r loadfrom=database

declare -a dbarray
# If Loadfrom=database, save all your Youtube playlists in favdir example (amp3) #
declare -r favdir="amp3"

## Variables to edit carefully ##
declare -i ffdefault
declare -i ffon

sleep 1

# Test if Firefox is running ? 
ffon=0; pgrep -f firefox >/dev/null 2>&1  && ffon=1

## youtube-dl Parameter to edit from the user ##

# Date= yesterday #
datum=$(date -d "1 day ago" '+%Y%m%d')
# Max. videos / datum to each playlist #
declare -i perday=4
# if aria2 is installed example : #
# aria2='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
declare -r aria2=''
# firefox database#
sqltdata=places.sqlite


## Update your youtube-dl ! ##
$yot_dl_p -U 
## or 
# pip install --upgrade youtube-dl
# sudo apt-get install youtube-dl

## Nothing  to do here. Find default profile.##

if [ $loadfrom == database ]
then
# Test Firefox profile ?
cd ~/.mozilla/firefox || exit
ffdefault=$(find ./ -maxdepth 1 -name "*default*" -type d | wc -l)
if [ "$ffdefault" -gt 1 ]
then
echo "There is more then 1 default Firefox profile ! You have to choose one at ~/.mozilla/firefox and edit this script for your need"
find ./ -maxdepth 1 -name "*default*" -type d 
exit
elif [ "$ffdefault" == 0 ]
then
echo "There is no Firefox profile in your $HOME/.mozilla/firefox but it should. Script can't continue !"
exit
fi

# If more then 1 FF profile  or no default is found , edit the path here by hand ! 
# example: change next line to: cd /home/foo/.mozilla/firefox/fdgsfdgfs43543.mything.fdsgf 
cd ./*default* || exit

# Nothing to do here. youtube-dl cannot read from a running sqlite, but to copy is allowed #
if [ $ffon == 1 ]
then
cp $sqltdata places2.sqlite
sqltdata=places2.sqlite
fi
fi
## only edit dbarray test-content if you want to use it ##

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
readarray -t dbarray < <(sqlite3 -list $sqltdata 'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))')
fi
cd  "$dl_folder" || exit

## Let youtube-dl do the work  and download brandnew videos ##

# Get out of here with 2X CTRL+C
trap "echo Exited!; exit;" SIGINT SIGTERM

for i in "${dbarray[@]}"
do

iurl=$(echo -n "$i" | sed -E "s/\//%/g")
$yot_dl_p $aria2 --download-archive "$dl_folder"/archive/"$iurl" --dateafter "$datum" --playlist-end "$perday" --max-downloads "$perday" "$i"

done
exit
