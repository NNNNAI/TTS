# # base image
# FROM nvcr.io/nvidia/pytorch:22.02-py3 as base


# ENV TZ=Asia/Shanghai
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



# RUN echo "Acquire::http::Proxy \"http://devops.io:3142\";" > /etc/apt/apt.conf.d/00aptproxy

# RUN apt-get update && apt-get install -y libglib2.0-0 libgl1-mesa-glx sudo  \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*


# # RUN pip install -r requirements.txt -i http://devops.io:3141/root/pypi/+simple --trusted-host devops.io
# RUN pip install torchaudio --extra-index-url https://download.pytorch.org/whl/cu116 -i http://devops.io:3141/root/pypi/+simple --trusted-host devops.io

# WORKDIR /TTS

# # Platform debug
# FROM base as platform-debug

# RUN apt update --allow-insecure-repositories \
#     && apt install -y \
#     openssh-server


ARG BASE=nvidia/cuda:11.8.0-base-ubuntu22.04
FROM ${BASE} as base

RUN echo "Acquire::http::Proxy \"http://devops.io:3142\";" > /etc/apt/apt.conf.d/00aptproxy

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends gcc g++ make python3 python3-dev python3-pip python3-venv python3-wheel espeak-ng libsndfile1-dev sudo git openssh-server && rm -rf /var/lib/apt/lists/*
RUN pip3 install -U pip
# RUN pip3 config set global.index-url https://pypi.mirrors.ustc.edu.cn/simple
# RUN pip3 config set install.trusted-host mirrors.ustc.edu.cn
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 config set install.trusted-host tuna.tsinghua.edu.cn
RUN pip3 install llvmlite --ignore-installed

COPY . /workspace/TTS
WORKDIR /workspace/TTS
RUN pip3 install torch torchaudio --extra-index-url https://download.pytorch.org/whl/cu118  -i https://pypi.mirrors.ustc.edu.cn/simple/
# RUN rm -rf /root/.cache/pip
RUN make install
# ENTRYPOINT ["tts"]
# CMD ["--help"]


# Development image
FROM base as development



# COPY . /gddi_facerecognition_final
# WORKDIR /gddi_facerecognition_final

# # download weights
# RUN wget http://cacher.devops.io/api/cacher/files/8e1f75a6fe9ec8cd4ebdea3166dafbfce696d7596eb11e8c1990d2348c8776e6 -O /gddi_facerecognition_final/gddi_facerecognition_withaug_model_zoo.tar
# RUN tar xvf gddi_facerecognition_withaug_model_zoo.tar
# RUN rm -rf gddi_facerecognition_withaug_model_zoo.tar

# # download ptqdata
# RUN wget http://cacher.devops.io/api/cacher/files/e491fb00b51ad508818792a195fca66fee3c7ba6ec8acf60e90d952ee805bb9e -O /gddi_facerecognition_final/gddi_facerecognition_ptqdata.tar
# RUN tar xvf gddi_facerecognition_ptqdata.tar
# RUN rm -rf gddi_facerecognition_ptqdata.tar

RUN groupadd -g 1000 mygroup
RUN useradd -u 1000 -g 1000 -m myuser

# Add myuser to the sudo group
RUN usermod -aG sudo myuser

# Set a password for myuser (optional)
# RUN echo 'myuser:password' | chpasswd

# Allow myuser to use sudo without a password
RUN echo 'myuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/myuser && \
    chmod 0440 /etc/sudoers.d/myuser

# Switch to the new user
USER myuser