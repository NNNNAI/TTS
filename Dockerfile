


FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime as base

RUN echo "Acquire::http::Proxy \"http://devops.io:3142\";" > /etc/apt/apt.conf.d/00aptproxy

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND noninteractive 

RUN apt update --allow-insecure-repositories \
    && apt install -y \
    git cmake curl wget g++ \
    openssh-server \
    libgl1-mesa-glx \
    sudo \
    zlib1g-dev \
    vim \
    && $sudo apt clean \
    && $sudo rm -rf /var/lib/apt/lists/*

RUN pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/web/simple

# COPY . /TTS
# WORKDIR /TTS
# RUN make install

# FROM base as development
# # User Dev
# RUN useradd -ms /bin/bash myuser && usermod -aG sudo myuser
# # New added for disable sudo password
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# # Set as default user
# USER myuser

