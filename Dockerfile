FROM nvidia/cuda:13.1.1-cudnn-runtime-ubuntu24.04

RUN apt-get update
RUN apt-get install -y sudo wget vim openssh-server curl && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/run/sshd
RUN ssh-keygen -A
EXPOSE 22

ARG USERNAME PASSWORD HOST_UID HOST_GID ENVNAME PYTHON_VERSION UV_VERSION UV_INSTALL_URL

COPY .scripts/adduser.sh /tmp/adduser.sh
RUN sh /tmp/adduser.sh $USERNAME $PASSWORD $HOST_UID $HOST_GID
RUN rm /tmp/adduser.sh

USER $USERNAME
WORKDIR /home/$USERNAME
RUN mkdir -p /home/$USERNAME/.ssh
COPY .ssh_local/id.pub /home/$USERNAME/.ssh/authorized_keys

RUN wget -qO- $UV_INSTALL_URL | sh -s -- --version $UV_VERSION

ENV PATH /home/$USERNAME/.local/bin:$PATH

RUN uv python install $PYTHON_VERSION
RUN mkdir -p /home/$USERNAME/.venvs
RUN uv venv /home/$USERNAME/.venvs/$ENVNAME --python $PYTHON_VERSION
RUN echo "source /home/$USERNAME/.venvs/$ENVNAME/bin/activate" >> ~/.bashrc
RUN uv cache prune --all && rm -rf /home/$USERNAME/.cache/uv

USER root
COPY .scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
