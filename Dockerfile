# Run Rapid Photo Downloader in a container on windows
#
# docker run -it -e DISPLAY=<server>:0.0 -v <source>:/data/source -v <target>:/data/target/ -v <dir>\RapidPhotoDownloaderConfig\local\:/home/rpd/.local/share/ -v <dir>\RapidPhotoDownloaderConfig\home\:/home/rpd/ randyklein99/rapid-photo-downloader

FROM opensuse:tumbleweed

#to fix "package module error" 
# still not working, not sure why


RUN zypper --non-interactive install --no-recommends \
  glibc-i18ndata \
  glibc-locale

ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"
ENV PYTHONIOENCODING=UTF-8

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN zypper --non-interactive install --no-recommends \
  python3-pip \
  rapid-photo-downloader

RUN pip install requests

## Output after above command
#Output of systemd-presets-branding-CAASP-15.0-3.1.noarch.rpm %posttrans script:
#    Created symlink /etc/systemd/system/default.target.wants/issue-add-ssh-keys.service -> /usr/lib/systemd/system/issue-add-ssh-keys.service.
#    Created symlink /etc/systemd/system/multi-user.target.wants/kbdsettings.service -> /usr/lib/systemd/system/kbdsettings.service.

#Output of kmod-24-6.1.x86_64.rpm %posttrans script:
#    Please run mkinitrd as soon as your system is complete.

#Output of udev-234-12.1.x86_64.rpm %posttrans script:
#    Creating /lib/udev -> /usr/lib/udev symlink.
##


#RUN locale-gen en_US.UTF-8 && \
#  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
#  echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
#	dpkg-reconfigure --frontend=noninteractive locales && \
#	update-locale LANG=en_US.UTF-8

#Env vars for locales
#ENV LANG="en_US.UTF-8"
#ENV LANGUAGE="en_US:en"
#ENV LC_ALL="en_US.UTF-8"

#change to how suse creates users
RUN groupadd -r rpd && useradd -g rpd -m rpd 

VOLUME [ "/data/source/" ]
VOLUME [ "/data/target/" ]

# create a volume to persist configuration
# location will change with 0.9 version 
#VOLUME [ "/home/rpd/" ]
#VOLUME [ "/home/rpd/.local/share/" ] 

#
#USER rpd
#WORKDIR /home/rpd

#ENV LANG="en_US.UTF-8"
#ENV LANGUAGE="en_US:en"
#ENV LC_ALL="en_US.UTF-8"


#ENTRYPOINT [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
