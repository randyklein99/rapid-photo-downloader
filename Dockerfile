# Run Rapid Photo Downloader in a container on windows
#
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

FROM ubuntu:18.04

ENV  DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  locales \
  python3 \
  python3-pip \
  rapid-photo-downloader
  
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && dpkg-reconfigure --frontend=noninteractive tzdata

#RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8 && \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

### Env vars for locales
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

RUN groupadd -r rpd && useradd -g rpd rpd

#VOLUME [ "/data/source/" ]
#VOLUME [ "/data/target/" ]

# create a volume to persist configuration
# location will change with 0.9 version in ubuntu 18.04
#VOLUME [ "/home/rpd/" ]
#VOLUME [ "/home/rpd/.local/share/" ] 

#USER rpd
WORKDIR /home/rpd

#ENTRYPOINT [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]


