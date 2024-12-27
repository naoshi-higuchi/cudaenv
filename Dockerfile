FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04

RUN apt-get update
RUN apt-get install -y sudo wget vim

ARG USERNAME ENVNAME PYTHON_VERSION MINIFORGE_INSTALLER MINIFORGE_URL

RUN useradd -m $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

RUN wget $MINIFORGE_URL
RUN bash $MINIFORGE_INSTALLER -b -u
RUN rm $MINIFORGE_INSTALLER

ENV PATH /home/$USERNAME/miniforge3/bin:$PATH

RUN mamba init
RUN mamba create -y -n $ENVNAME python==$PYTHON_VERSION
RUN echo "mamba activate $ENVNAME" >> ~/.bashrc

#RUN mamba install -y -n $ENVNAME numpy
RUN mamba install -y -n $ENVNAME pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
