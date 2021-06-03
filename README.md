

# FF-auto-youtube-download-TEST-
## Get all Videos from Firefox bookmarks
[![Build Status](https://travis-ci.org/dewomser/FF-auto-youtube-download-.svg?branch=master)](https://travis-ci.org/dewomser/FF-auto-youtube-download-) Travis CI / Shellcheck approved.

[![Trigger: Push action](https://github.com/dewomser/FF-auto-youtube-download-/actions/workflows/blank.yml/badge.svg?branch=master)](https://github.com/dewomser/FF-auto-youtube-download-/actions/workflows/blank.yml)


No Youtube login needed !

youtube-dl.sh downloads automatic newest Videos into local download folder.

To use this script you need: Shell, [youtube-dl](https://youtube-dl.org/), Firefox (tested with 66 - 89), [sqlite3](https://www.sqlite.org/index.html) . //aria2 (fast download as an option)

No firefox, no problem , write your playlists to an array.
## Useful things
* There is a checker for dependencies: check.sh
* There is a notifier script for the Kubuntu desktop: yt-dl-send-notify.sh
## Crontab these scripts  !
1. 0 */2 * * * /home/foo/bin/youtube-dl.sh > /dev/null 2>&1

2. 0 *  * * *  XDG_RUNTIME_DIR=/run/user/$(id -u) /home/foo/bin/yt-dl-send-notify.sh

3. update youtube-dl, may be useful (0 12 * * * youtube-dl -U)
