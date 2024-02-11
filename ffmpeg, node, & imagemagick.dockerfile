FROM ubuntu

SHELL ["/bin/bash", "-c"]
RUN apt-get update
RUN apt-get install ffmpeg bc imagemagick sudo git tmux curl -y
RUN apt-get install libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev -y

# nvm environment variables
RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 21.6.1
# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm i -g pnpm
RUN npm i -g puppeteer
RUN echo yes | puppeteer browsers clear
RUN puppeteer browsers install chrome

CMD ["echo", "Hello?"]