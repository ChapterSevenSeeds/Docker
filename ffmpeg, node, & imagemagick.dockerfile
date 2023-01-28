FROM ubuntu

RUN apt-get update
RUN apt-get install ffmpeg imagemagick sudo -y
RUN sudo apt install curl 
RUN https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
RUN source ~/.bashrc   
RUN nvm install node 
RUN nvm use node

CMD ["echo", "Hello?"]