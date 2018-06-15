# Run Rapid Photo Downloader in a container on windows
#
# vcxsrv
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

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
  python3 

RUN apt-get update &&  apt-get install -y \
  python3-pip \
  wget \
  sudo

RUN pip3 install \
  PyQt5


# needs home directory with -m
#RUN groupadd -r rpd && useradd -m -g rpd rpd
#RUN useradd -m rpd && echo "rpd:rpd" | chpasswd && adduser rpd sudo

RUN groupadd -r rpd
RUN useradd -m -g rpd rpd && echo "rpd:rpd" | chpasswd
RUN cp /etc/sudoers /etc/sudoers.old
RUN chmod 777 /etc/sudoers
RUN echo "rpd ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 440 /etc/sudoers
RUN mkdir -p /home/rpd && chown -R rpd:rpd /home/rpd

VOLUME [ "/data/source/" ]
VOLUME [ "/data/target/" ]
#VOLUME ["/usr/local/share/man/man1"]
#RUN chmod 777 /usr/local/share/man/man1

# create a volume to persist configuration
# location will change with 0.9 version in ubuntu 18.04
#VOLUME [ "/home/rpd/" ]
#VOLUME [ "/home/rpd/.local/share/" ] 

RUN apt-get update &&  apt-get install -y \
  python3-pyqt5 \
  exiv2 \
  libgphoto2-dev \
  python3-dev \
  libzmq3-dev \
  qt5-image-formats-plugins \
  python-gobject \
  qt5-default \
  udisks2 \
  gir1.2-gudev-1.0 \
  libglib2.0-bin \
  libgexiv2-2 \
  gstreamer1.0-libav \
  libnotify-bin

#ENV XDG_RUNTIME_DIR /home/rpd

USER rpd
WORKDIR /home/rpd

RUN wget https://launchpad.net/rapid/pyqt/0.9.9/+download/install.py
RUN python3 install.py

USER root
RUN cp /etc/sudoers.old /etc/sudoers




#USER rpd
#CMD [ "/home/rpd/bin/rapid-photo-downloader" ]


# Still getting following error:
#Traceback (most recent call last):
#  File "/usr/bin/rapid-photo-downloader", line 6, in <module>
#    from pkg_resources import load_entry_point
#ModuleNotFoundError: No module named 'pkg_resources'

# apt-get install python3-pip gets past this error
# but now: ModuleNotFoundError: No module named 'requests'

# pip3 install requests gets past this error
# but now a gui pops up with Program aborting
# and complaint about using root user

# solved with: groupadd -r rpd && useradd -m -g rpd rpd 
# and: su rpd
# and now there is a segmentation fault



# python-pyqt5
# qt5-default