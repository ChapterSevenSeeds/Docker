FROM ubuntu

RUN apt-get update
RUN apt-get install ffmpeg build-essential imagemagick libssl-dev sudo git -y

CMD ["echo", "Hello?"]