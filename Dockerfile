# Run Rapid Photo Downloader in a container on windows
#
# vcxsrv
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v "<dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/.config/Rapid Photo Downloader" randyklein99/rapid-photo-downloader:script2

FROM ubuntu:18.04

## from https://hub.docker.com/r/library/ubuntu/
#RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#ENV LANG en_US.utf8


# need to run this command to get past the interactive "geographic area"
# request
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales tzdata

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 



RUN apt-get update &&  apt-get install -y \
  exiv2 \
  gir1.2-gudev-1.0 \
  gstreamer1.0-libav \
  libgexiv2-2 \
  libglib2.0-bin \
  libgphoto2-dev \
  libnotify-bin \
  libzmq3-dev \
  python3 \
  python3-dev \
  python-gobject \
  python3-pip \
  python3-pyqt5 \
  qt5-default \
  qt5-image-formats-plugins \
  udisks2 \
  sudo \
  wget
  
RUN pip3 install \
  PyQt5


# establish rpd user
# temporarily elevate sudo - remove privs after script executes
RUN groupadd -r rpd
RUN useradd -m -g rpd rpd && echo "rpd:rpd" | chpasswd
RUN cp /etc/sudoers /etc/sudoers.old
RUN chmod 777 /etc/sudoers
RUN echo "rpd ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 440 /etc/sudoers
RUN mkdir -p /home/rpd && chown -R rpd:rpd /home/rpd


#When the program is installed using the install.py script from the download page of this site, the program's directories are:
#Executable: ~/bin
#Configuration: ~/.config/Rapid Photo Downloader
#Cache: ~/.local/cache/rapid-photo-downloader
#Data: ~/.local/share/rapid-photo-downloader

# folders for source and target directories
VOLUME [ "/data/source/" ]
VOLUME [ "/data/target/" ]

USER rpd
WORKDIR /home/rpd

RUN wget https://launchpad.net/rapid/pyqt/0.9.9/+download/install.py
RUN python3 install.py

# remove sudo no passwd privileges
USER root
RUN cp /etc/sudoers.old /etc/sudoers

#USER rpd
#CMD [ "/home/rpd/bin/rapid-photo-downloader" ]

