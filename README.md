

# FF-auto-youtube-download-
## Download  Video folders and playlists from links stored in an (1)array or (2)Firefox-bookmarks-folder.
[![Build Status](https://travis-ci.org/dewomser/FF-auto-youtube-download-.svg?branch=master)](https://travis-ci.org/dewomser/FF-auto-youtube-download-) Travis CI / Shellcheck approved.

No need to login at Youtube !

youtube-dl.sh downloads only newest Videos into local download folder. Modus is 1 or 2

1. array : only shell and [youtube-dl](https://github.com/rg3/youtube-dl) is needed

2. firefox-bookmark-folder : shell, [youtube-dl](https://github.com/rg3/youtube-dl), Firefox (tested with 66 - 81), sqlite3 . //aria2 (fast download as an option)

## Useful things
There is a checker for dependencies: check.sh

There is a notifier script for the Kubuntu desktop: yt-dl-send-notify.sh


## Crontab these scripts  !
1. 0 */2 * * * /home/foo/bin/youtube-dl.sh > /dev/null 2>&1

2. 0 *  * * *  XDG_RUNTIME_DIR=/run/user/$(id -u) /home/foo/bin/yt-dl-send-notify.sh

3. update youtube-dl, may be useful (0 12 * * * youtube-dl -U)
