# Run Rapid Photo Downloader in a container on windows
#
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
  python3 \
  python3-dev \
  python3-pyqt5 \
  qt5-default \
  wget

RUN groupadd -r rpd && useradd -g rpd rpd

#VOLUME [ "/data/source/" ]
#VOLUME [ "/data/target/" ]

# create a volume to persist configuration
# location will change with 0.9 version in ubuntu 18.04
#VOLUME [ "/home/rpd/" ]
#VOLUME [ "/home/rpd/.local/share/" ] 

#USER rpd
WORKDIR /home/rpd

RUN wget https://launchpad.net/rapid/pyqt/0.9.7/+download/install.py

# manually execute install.py with rpd user by
# running container in -it and executing script
# commit changes to a new image

#ENTRYPOINT [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
