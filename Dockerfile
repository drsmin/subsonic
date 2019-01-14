FROM alpine:3.5
MAINTAINER drs <drs@drs.pe.kr>

ENV SUBSONIC_VERSION=6.0.beta1 \
    SUBSONIC_USERID=0 \
    SUBSONIC_PORT=4040 \
    SUBSONIC_HOME=/subsonic/home \
    SUBSONIC_MUSIC_FOLDER=/subsonic/music \
    SUBSONIC_PODCAST_FOLDER=/subsonic/podcasts \
    SUBSONIC_PLAYLIST_FOLDER=/subsonic/playlists

# Install gosu
COPY bin/gosu /bin/

# Install required packages
RUN apk add --no-cache openjdk8-jre-base ffmpeg openssl

# Install Subsonic
COPY subsonic /subsonic
RUN install -d -D -o ${SUBSONIC_USERID} -m 0750 /subsonic ${SUBSONIC_HOME}/transcode ${SUBSONIC_MUSIC_FOLDER} ${SUBSONIC_PODCAST_FOLDER} ${SUBSONIC_PLAYLIST_FOLDER} && \
    ln -s /usr/bin/ffmpeg ${SUBSONIC_HOME}/transcode/

VOLUME ["${SUBSONIC_HOME}", "${SUBSONIC_MUSIC_FOLDER}", "${SUBSONIC_PODCAST_FOLDER}", "${SUBSONIC_PLAYLIST_FOLDER}"]

# RUN chmod 755 /subsonic/start.sh
EXPOSE $SUBSONIC_PORT
ENTRYPOINT ["/subsonic/start.sh"]
