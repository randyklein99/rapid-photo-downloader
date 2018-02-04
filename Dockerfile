# Run Rapid Photo Downloader in a container on windows
#
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

FROM python:3-alpine3.6

RUN apk add --update \
  wget \
  bash



RUN adduser -D -h /home/rpd rpd
#RUN groupadd -r rpd && useradd -m -g rpd rpd

#VOLUME [ "/data/source/" ]
#VOLUME [ "/data/target/" ]

# create a volume to persist configuration
# location will change with 0.9 version in ubuntu 18.04
#VOLUME [ "/home/rpd/" ]
#VOLUME [ "/home/rpd/.local/share/" ] 


WORKDIR /home/rpd
USER rpd

RUN wget https://launchpad.net/rapid/pyqt/0.9.7/+download/install.py

#RUN python3 install.py

#CMD [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
