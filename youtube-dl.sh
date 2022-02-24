#!/bin/bash
## This Shellscript downloads all fresh videos from a firefox bookmark folder. ##

## Variables to edit carefully not ##
#declare -i ffdefault
#declare -i ffon=0
declare -a dbarray #videoclips
declare -a ydarray #youtube-dl parameters
###------------------------------------------------------
### Variables to edit from user --->START ###
# Firefox path profile.  I guess this is default right now. 
#Is there … /.mozilla/firefox/34567k.lolo and you use it  … /*.lolo/
fpath="$HOME/snap/firefox/common/.mozilla/firefox/*.defa/"
cd "$fpath" || exit

# IMPORTANT ! load from "database" or "array". Choose 1 ! 
declare -r loadfrom=database
# IMPORTANT ! if Loadfrom=database, save all your Youtube playlists in FF favdir example (amp3) #
declare -r favdir="amp3"

# You may edit dbarray as you want to.
# This has no effect if loadfrom=database
if [ $loadfrom == array ] ; then
    dbarray=(
    "https://www.youtube.com/user/GalileoOffiziell/videos"
    "https://www.youtube.com/user/BibisBeautyPalace/videos?sort=dd&shelf_id=1&view=0"
    "https://www.youtube.com/channel/UC53bIpnef1pwAx69ERmmOLA"
    )
fi

### Variables to edit from user --->STOP###
###--------------------------------------------------

## path to youtube-dl. If you dont know, default should work in most cases" ##
# example2 declare -r yot_dl_p="youtube-dl"
# example3 declare -r yot_dl_p="$HOME/bin/youtube-dl"
yot_dl_p=$(command -v yt-dlp) || yot_dl_p=$(command -v youtube-dl)

#Setup Test "yot_dl_p"

## [ -z "$var" ] && echo "Empty" || echo "Not empty"

 [ -z "$yot_dl_p" ] && echo "Program youtube-dl not found" || echo "youtube-dl found at: $yot_dl_p"


## Update your youtube-dl ! ##
# youtube-dl update with crontab / good choice:  as root:  pip3 install --upgrade youtube-dl
# pip install --upgrade youtube-dl / mind the install path
$yot_dl_p -U 
# sudo apt-get install youtube-dl
## or , or nothing


# folder for the downloaded videos  #
# if dl_folder is empty you where asked every time this script starts ehere to put videos
dl_folder="$HOME/Downloads/youtube-dl"
find "$dl_folder"/archive -type d >/dev/null 2>&1 || mkdir "$dl_folder"/archive

#Check for dl_folder and set variable if not exist.
test="notfound" ; find "$dl_folder" -type d >/dev/null 2>&1 \
&& test="Found Download folder at: $dl_folder"
if [ "$test" == notfound ] ;then
    echo "Hit ENTER or change and accept this folder for video storage !"
    read -r -e -i "$dl_folder" dl_folder 
    echo "Download folder is $dl_folder"
    mkdir "$dl_folder" && mkdir "$dl_folder"/archive
else
    echo "$test"
fi

## youtube-dl Parameterlist as array START ##

# Date for yesterday is "1 day ago" #
datum=$(date -d "2 days ago" '+%Y%m%d')
ydarray[0]="--dateafter $datum"
# Max. videos / datum to each playlist #
perday=4
ydarray[1]="--playlist-end $perday"
ydarray[2]="--max-downloads $perday"
# For more youtube-dl parameters
# if aria2 is installed example : #
# ydarray[3]='--external-downloader aria2c  --external-downloader-args "-j 8 -s 8 -x 8 -k 5M"'
ydarray[3]=""

## youtube-dl Paramrterlist STOP ##

if [ $loadfrom == database ] ; then
    # firefox database#
    sqltdata=places.sqlite
    # Test Setup if Firefox is running ? 
    #ffon=0; pgrep -f firefox >/dev/null 2>&1  && ffon=1
    # Test Firefox profile ?
 
        cp $sqltdata places2.sqlite
        sqltdata=places2.sqlite
    # fi

    ## This line puts FF bookmarks from sqlite3 to an array ##
    readarray -t dbarray < <(sqlite3 -list $sqltdata \
    'select url from moz_places where id in (select fk from moz_bookmarks where parent in ( select "id" from moz_bookmarks where title == "'$favdir'"))')
fi
cd  "$dl_folder" || exit

## Let youtube-dl do the work  and download brandnew videos ##

# Get out of here with 2X CTRL+C
trap "echo Exited!; exit;" SIGINT SIGTERM

for i in "${dbarray[@]}"; do
    iurl=$(echo -n "$i" | sed -E "s/\//%/g")
    $yot_dl_p  --continue --no-overwrites --ignore-errors --download-archive "$dl_folder"/archive/"$iurl"\
    ${ydarray[0]} ${ydarray[1]} ${ydarray[2]} ${ydarray[3]} "$i" ;
done
exit
# exit or not. It is your choice
