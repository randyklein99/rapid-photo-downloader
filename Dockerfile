# Run Rapid Photo Downloader in a container on windows
#
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

FROM ubuntu:17.10

#RUN apt update && apt install -y \
#  sudo \
#  wget \
#  python3 \
#  python3-dev \
#  python3-pip \
#  python3-pyqt5 \
#  python3-apt \
#  libimage-exiftool-perl \
#  exiv2 \
#  libgphoto2-dev \
#  gphoto2 \
#  libmediainfo0v5 \
#  libzmq3-dev \
#  qt5-style-plugins \
#  libraw16 \
#  python3-tk \
#  locales \
#  gstreamer1.0-libav \
#  gstreamer1.0-plugins-good \
#  intltool \
#  gir1.2-gexiv2-0.10 \
#  gir1.2-gudev-1.0 \
#  gir1.2-udisks-2.0 \
#  gir1.2-notify-0.7 \
#  gir1.2-gstreamer-1.0 \
#  python3-arrow \
 # python3-psutil \
 # python3-zmq \
 # python3-colorlog \
 # libraw-bin \
 # python3-easygui \
 # python3-sortedcontainers \

### install locales and set
RUN apt update && apt install -y locales
RUN locale-gen en_US.UTF-8 && \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

### Env vars for locales
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

# packages id'd in install.py
 RUN apt install -y \
   python3-apt \
   python3-pip \
   gstreamer1.0-libav gstreamer1.0-plugins-good \
   libimage-exiftool-perl python3-dev \
   intltool gir1.2-gexiv2-0.10 python3-gi gir1.2-gudev-1.0 \
   gir1.2-udisks-2.0 \
   gir1.2-notify-0.7 \
   gir1.2-glib-2.0 \
   gir1.2-gstreamer-1.0 \
   libgphoto2-dev \
   python3-arrow \
   python3-psutil \
   g++ \
   libmediainfo0v5 \
   python3-zmq \
   exiv2 \
   python3-colorlog \
   libraw-bin \
   python3-easygui \
   python3-sortedcontainers \
   qt5-image-formats-plugins \
   python3-pyqt5 \
   python3-requests

#ensure pyqt5 >= 5.9.2, else sip version is impacted   

RUN groupadd -r rpd && useradd -g rpd -m rpd
USER rpd
WORKDIR /home/rpd
  
### pip packages, might have to do it as non-root user if this doesn't work
#setuptools
#wheel
RUN pip install --user wheel setuptools pyprind dnf

# couldn't I just use wget instead?
RUN python3 requests.get("https://launchpad.net/rapid/pyqt/0.9.7/+download/rapid-photo-downloader-0.9.7.tar.gz")

# might need --user
# from this line: install --user --disable-pip-version-check --no-deps {}'.format(installer)
RUN pip install --user --disable-pip-version-check --no-deps rapid-photo-downloader-0.9.7.tar.gz

### install.py step
# set locale

#RUN echo "deb-src http://archive.ubuntu.com/ubuntu bionic main restricted universe multiverse" | tee -a /etc/apt/sources.list

#RUN echo "Package: * \
#Pin: release n=artful \
#Pin-Priority: -10 \
#\
#Package: rapid-photo-downloader \ 
#Pin: release n=bionic \
#Pin-Priority: 500" >> /etc/apt/preferences.d/somename.pref

#RUN apt-get update && apt-get install -y \
#  rapid-photo-downloader

#RUN python3 -m pip install upgrade


VOLUME [ "/data/source/" ]
VOLUME [ "/data/target/" ]

# create a volume to persist configuration
# location will change with 0.9 version in ubuntu 18.04
#VOLUME [ "/home/rpd/" ]
#VOLUME [ "/home/rpd/.local/share/" ] 

#RUN mkdir -p /usr/local/share/man/man1

#RUN sed -i.bkp -e \
#    's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
#    /etc/sudoers

#USER rpd
#WORKDIR /home/rpd

#ENV LANG="en_US.UTF-8"
#ENV LANGUAGE="en_US:en"
#ENV LC_ALL="en_US.UTF-8"

#
#python3-colour \
#  python3-gphoto2 \
#  python3-pymediainfo \
#  python3-pyprind \
#  python3-rawkit \
#  python3-exif \
#  python3-gphoto2cffi \
#  qt5-image-formats-plugins
#
#RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/r/rapid-photo-downloader/rapid-photo-downloader_0.9.7-1_all.deb

#RUN wget https://launchpad.net/rapid/pyqt/0.9.7/+download/install.py

#RUN python3 -m pip install --user --upgrade setuptools wheel

# need to figure out the sudo password work around
#RUN python3 install.py

#RUN sudo deluser rpd sudo

#ENTRYPOINT [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
