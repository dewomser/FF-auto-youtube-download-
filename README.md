

# FF-auto-youtube-download-TEST-
## Get all Videos from Firefox bookmarks




No Youtube login needed !

youtube-dl.sh downloads automatic newest Videos into local download folder.


To use this script you need: Shell, [yt-dlp](https://github.com/yt-dlp/yt-dlp) fallback is now  [youtube-dl](https://youtube-dl.org/), Firefox (tested with 66 - 101), [sqlite3](https://www.sqlite.org/index.html) . //aria2 (fast download as an option)


No firefox, no problem , write your playlists to an array.

## Useful things
* There is a checker for dependencies: check.sh
* There is a notifier script for the Kubuntu desktop: yt-dl-send-notify.sh
## Crontab these scripts  !
1. 0 */2 * * * /home/foo/bin/youtube-dl.sh > /dev/null 2>&1

2. 0 *  * * *  XDG_RUNTIME_DIR=/run/user/$(id -u) /home/foo/bin/yt-dl-send-notify.sh

3. update youtube-dl, may be useful (0 12 * * * youtube-dl -U)

------------
There is script for the Chromium Browser . It's pre-alpha but works for me. Support needed !
------------
