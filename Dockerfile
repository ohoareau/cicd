FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y git python3-pip curl groff build-essential zip unzip && \
    apt clean && \
    apt autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install awscli --upgrade && \
    pip3 install --upgrade setuptools

# tfenv
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc

# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# pyenv
RUN curl https://pyenv.run | bash
RUN echo 'export PATH="/root/.pyenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

COPY ./scripts/aws-account-profile-add.sh /usr/local/bin/aws-account-profile-add
COPY ./scripts/aws-role-profile-add.sh /usr/local/bin/aws-role-profile-add
COPY ./scripts/terraform-cloud-api-token-set.sh /usr/local/bin/terraform-cloud-api-token-set

RUN mkdir -p /code

WORKDIR /code
