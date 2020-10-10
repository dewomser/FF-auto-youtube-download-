#!/bin/bash

#This schows new Viedoclips. Script is tested with Kubuntu 19.10 and uses notify-send Popup-Window
#dl_folder should be the same as in youtube-dl.sh
#if you use the default,you need not edit this script.
#if nothing pops up thre is propably no new Video in th e last 4 hours.
#If you want to be remembered regulary there is a line for your user crontab

#0 *  * * *  XDG_RUNTIME_DIR=/run/user/$(id -u) /home/foo/bin/yt-dl-send-notify.sh

dl_folder=~/Downloads/youtube-dl/
f=$(find $dl_folder -newermt '4 hours ago' -type f -regex '.*\.\(mkv\|mp4\|wmv\|flv\|webm\|mov\)')
if [ -z "$f" ]
then exit
else
folder1="$(echo $dl_folder|sed "s/\//\\\\\//g")"
sedarg="sed s/$folder1/\n/g"
f1=$(echo "$f"|$sedarg)

notify-send --icon=video-x-generic "$f1": "Open folder: <a href='$dl_folder'>clips</a>"

fi
