FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04

RUN apt-get update
RUN apt-get install -y sudo wget vim openssh-server
RUN mkdir /var/run/sshd
RUN ssh-keygen -A
EXPOSE 22

ARG USERNAME PASSWORD HOST_UID HOST_GID ENVNAME PYTHON_VERSION MINIFORGE_INSTALLER MINIFORGE_URL

COPY .scripts/adduser.sh /tmp/adduser.sh
RUN sh /tmp/adduser.sh $USERNAME $PASSWORD $HOST_UID $HOST_GID
RUN rm /tmp/adduser.sh
COPY .scripts/sshd.sh /home/$USERNAME/sshd.sh
RUN chmod +x /home/$USERNAME/sshd.sh
USER $USERNAME
WORKDIR /home/$USERNAME
RUN mkdir -p /home/$USERNAME/.ssh
COPY .ssh_local/id.pub /home/$USERNAME/.ssh/authorized_keys

RUN wget $MINIFORGE_URL
RUN bash $MINIFORGE_INSTALLER -b -u
RUN rm $MINIFORGE_INSTALLER

ENV PATH /home/$USERNAME/miniforge3/bin:$PATH

RUN mamba init
RUN mamba create -y -n $ENVNAME python==$PYTHON_VERSION
RUN echo "mamba activate $ENVNAME" >> ~/.bashrc
RUN mamba clean -i -y

#RUN mamba install -y -n $ENVNAME numpy
#RUN mamba install -y -v -n $ENVNAME pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia
