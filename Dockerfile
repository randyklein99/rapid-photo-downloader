# Run Rapid Photo Downloader in a container
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

ENTRYPOINT [ "/usr/bin/rapid-photo-downloader" ]
#CMD [ "" ]
