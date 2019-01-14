#!/bin/sh

###################################################################################
# Based on the standard Subsonic startup script by Sindre Mehus
###################################################################################

SUBSONIC_HOST=${SUBSONIC_HOST:-0.0.0.0}
SUBSONIC_HTTPS_PORT=${SUBSONIC_HTTPS_PORT:-0}
SUBSONIC_CONTEXT_PATH=${SUBSONIC_CONTEXT_PATH:-/}
SUBSONIC_MAX_MEMORY=${SUBSONIC_MAX_MEMORY:-150}


usage() {
    echo "Usage: subsonic.sh [options]"
    echo "  --help               This small usage guide."
    echo "  --home=DIR           The directory where Subsonic will create files."
    echo "                       Make sure it is writable. Default: ${SUBSONIC_HOME}"
    echo "  --host=HOST          The host name or IP address on which to bind Subsonic."
    echo "                       Only relevant if you have multiple network interfaces and want"
    echo "                       to make Subsonic available on only one of them. The default value"
    echo "                       will bind Subsonic to all available network interfaces. Default: ${SUBSONIC_HOST}"
    echo "  --port=PORT          The port on which Subsonic will listen for"
    echo "                       incoming HTTP traffic. Default: ${SUBSONIC_PORT}"
    echo "  --https-port=PORT    The port on which Subsonic will listen for"
    echo "                       incoming HTTPS traffic. Default: ${SUBSONIC_HTTPS_PORT} (0 - disabled)"
    echo "  --context-path=PATH  The context path, i.e., the last part of the Subsonic"
    echo "                       URL. Typically '/' or '/subsonic'. Default ${SUBSONIC_CONTEXT_PATH}"
    echo "  --max-memory=MB      The memory limit (max Java heap size) in megabytes."
    echo "                       Default: ${SUBSONIC_MAX_MEMORY}"
    echo "  --default-music-folder=DIR    Configure Subsonic to use this folder for music.  This option "
    echo "                                only has effect the first time Subsonic is started. Default ${SUBSONIC_MUSIC_FOLDER}"
    echo "  --default-podcast-folder=DIR  Configure Subsonic to use this folder for Podcasts.  This option "
    echo "                                only has effect the first time Subsonic is started. Default ${SUBSONIC_PODCAST_FOLDER}"
    echo "  --default-playlist-folder=DIR Configure Subsonic to use this folder for playlists.  This option "
    echo "                                only has effect the first time Subsonic is started. Default ${SUBSONIC_PLAYLIST_FOLDER}"
    exit 1
}

# Parse arguments.
while [ $# -ge 1 ]; do
    case $1 in
        --help)
            usage
            ;;
        --home=?*)
            SUBSONIC_HOME=${1#--home=}
            ;;
        --host=?*)
            SUBSONIC_HOST=${1#--host=}
            ;;
        --port=?*)
            SUBSONIC_PORT=${1#--port=}
            ;;
        --https-port=?*)
            SUBSONIC_HTTPS_PORT=${1#--https-port=}
            ;;
        --context-path=?*)
            SUBSONIC_CONTEXT_PATH=${1#--context-path=}
            ;;
        --max-memory=?*)
            SUBSONIC_MAX_MEMORY=${1#--max-memory=}
            ;;
        --pidfile=?*)
            SUBSONIC_PIDFILE=${1#--pidfile=}
            ;;
        --default-music-folder=?*)
            SUBSONIC_MUSIC_FOLDER=${1#--default-music-folder=}
            ;;
        --default-podcast-folder=?*)
            SUBSONIC_PODCAST_FOLDER=${1#--default-podcast-folder=}
            ;;
        --default-playlist-folder=?*)
            SUBSONIC_PLAYLIST_FOLDER=${1#--default-playlist-folder=}
            ;;
        *)
            usage
            ;;
    esac
    shift
done

if [ $(stat -c %u "${SUBSONIC_HOME}") != ${SUBSONIC_USERID} ]; then
    echo "Fixing ${SUBSONIC_HOME} permissions"
    chown -R ${SUBSONIC_USERID} "${SUBSONIC_HOME}"
fi

cd $(dirname $0)

exec /bin/gosu ${SUBSONIC_USERID} java -Xmx${SUBSONIC_MAX_MEMORY}m \
  -Dsubsonic.home=${SUBSONIC_HOME} \
  -Dsubsonic.host=${SUBSONIC_HOST} \
  -Dsubsonic.port=${SUBSONIC_PORT} \
  -Dsubsonic.httpsPort=${SUBSONIC_HTTPS_PORT} \
  -Dsubsonic.contextPath=${SUBSONIC_CONTEXT_PATH} \
  -Dsubsonic.defaultMusicFolder=${SUBSONIC_MUSIC_FOLDER} \
  -Dsubsonic.defaultPodcastFolder=${SUBSONIC_PODCAST_FOLDER} \
  -Dsubsonic.defaultPlaylistFolder=${SUBSONIC_PLAYLIST_FOLDER} \
  -Djava.awt.headless=true \
  -verbose:gc \
  -jar subsonic-booter-jar-with-dependencies.jar
