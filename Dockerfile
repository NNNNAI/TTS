# base image
FROM nvcr.io/nvidia/pytorch:22.02-py3 as base


ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



RUN echo "Acquire::http::Proxy \"http://devops.io:3142\";" > /etc/apt/apt.conf.d/00aptproxy

RUN apt-get update && apt-get install -y libglib2.0-0 libgl1-mesa-glx sudo  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# RUN pip install -r requirements.txt -i http://devops.io:3141/root/pypi/+simple --trusted-host devops.io
RUN pip install torchaudio --extra-index-url https://download.pytorch.org/whl/cu116 -i http://devops.io:3141/root/pypi/+simple --trusted-host devops.io

WORKDIR /TTS

# Platform debug
FROM base as platform-debug

RUN apt update --allow-insecure-repositories \
    && apt install -y \
    openssh-server
