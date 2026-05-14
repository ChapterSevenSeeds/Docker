FROM ubuntu

SHELL ["/bin/bash", "-c"]
RUN apt-get update
RUN apt-get install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update
RUN apt-get install ffmpeg bc imagemagick sudo git tmux curl dos2unix wget jq build-essential libssl-dev nano yt-dlp unzip python3.14 python3.14-venv conntrack -y

RUN wget https://gist.githubusercontent.com/davideuler/469a41b79aa7484de0c36c9f6cb780f8/raw/f1f991c15039831f429225983b113a35a4d66f25/xps2pdf.bash
RUN chmod +x xps2pdf.bash
RUN mv xps2pdf.bash /usr/local/bin/xps2pdf

RUN wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
RUN sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
RUN rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb

# install gh cli
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

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
