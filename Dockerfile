# Run Rapid Photo Downloader in a container on windows
#
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

FROM ubuntu:17.10

### install locales and set
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8 && \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

### Env vars for locales
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

RUN apt-get install -y \
  python3 \
  python3-apt \
  python3-dev \
  python3-pkg-resources \
  python3-pip \
  python3-pyqt5 \
  qt5-default \
  sudo \
  wget

RUN pip3 install --upgrade pip setuptools wheel

RUN groupadd -r rpd && useradd -g rpd rpd && usermod -aG sudo rpd
RUN mkdir /home/rpd/.local && chown -R rpd:rpd /home/rpd

RUN sed -i.bkp -e \
    's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
    /etc/sudoers


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

CMD [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
