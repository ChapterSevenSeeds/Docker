FROM ubuntu

SHELL ["/bin/bash", "-c"]
RUN apt-get update
RUN apt-get install ffmpeg bc imagemagick sudo git tmux curl dos2unix wget jq build-essential libssl-dev -y

RUN wget https://gist.githubusercontent.com/davideuler/469a41b79aa7484de0c36c9f6cb780f8/raw/f1f991c15039831f429225983b113a35a4d66f25/xps2pdf.bash
RUN chmod +x xps2pdf.bash
RUN mv xps2pdf.bash /usr/local/bin/xps2pdf

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
RUN npx -y playwright install --with-deps

CMD ["/bin/bash", "-i"]