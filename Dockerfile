FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y git python3-pip curl groff build-essential zip unzip && \
    apt clean && \
    apt autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# tfenv
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_custom

ARG NVM_VERSION=0.35.3

# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bash_custom && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bash_custom && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bash_custom

# pyenv
RUN curl https://pyenv.run | bash
RUN echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.bash_custom && \
    echo 'eval "$(pyenv init -)"' >> ~/.bash_custom && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_custom

RUN echo '. ~/.bash_custom' >> ~/.bashrc

COPY ./scripts/aws-account-set.sh /usr/local/bin/aws-account-set
COPY ./scripts/aws-account-profile-add.sh /usr/local/bin/aws-account-profile-add
COPY ./scripts/aws-role-profile-add.sh /usr/local/bin/aws-role-profile-add
COPY ./scripts/terraform-cloud-api-token-set.sh /usr/local/bin/terraform-cloud-api-token-set
COPY ./scripts/shell-wrapper.sh /usr/local/bin/shell-wrapper
COPY ./scripts/npm-registry-scope.sh /usr/local/bin/npm-registry-scope
COPY ./scripts/npm-registry-identity.sh /usr/local/bin/npm-registry-identity

ARG NODE_VERSION=14.4.0
ARG TERRAFORM_VERSION=0.12.28

RUN cp /bin/sh /bin/sh.old && cp /bin/bash /bin/sh
RUN source ~/.bash_custom && tfenv install $TERRAFORM_VERSION && tfenv use $TERRAFORM_VERSION
RUN source ~/.bash_custom && nvm install $NODE_VERSION

RUN pip3 install awscli --upgrade && \
    pip3 install --upgrade setuptools

RUN source ~/.bash_custom && npm -g install yarn

RUN cp /bin/sh.old /bin/sh
RUN cat ~/.bash_custom >> /usr/local/bin/shell-wrapper
RUN echo 'exec bash "$@"' >> /usr/local/bin/shell-wrapper
RUN mkdir -p /code

WORKDIR /code