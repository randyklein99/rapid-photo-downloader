# Run Rapid Photo Downloader in a container on windows
#
# docker run -it \
#	--net host \ 
#	--cpuset-cpus 0 \ 
#	--memory 512mb \ 
#	-v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
#	-e DISPLAY=unix$DISPLAY \
#	-v $HOME/Downloads:/home/chrome/Downloads \
#	-v $HOME/.config/google-chrome/:/data \ # if you want to save state
#	#	--device /dev/snd \ # so we have sound
#   --device /dev/dri \
#	-v /dev/shm:/dev/shm \
#	--name chrome \
#	randyklein99/rapid-photo-downloader

FROM ubuntu:17.10

RUN apt-get update && apt-get install -y \
  rapid-photo-downloader

RUN useradd -m -U rpd

USER rpd

VOLUME [ "/data/source/" ]
VOLUME [ "/data/target/" ]

# create a volume to persist configuration
# location will change with 0.9 version in ubuntu 18.04
VOLUME [ "/home/rpd/.local/share/" ] 

ENTRYPOINT [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
