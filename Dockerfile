FROM ubuntu:17.04
MAINTAINER Peter DeMartini <thepeterdemartini@gmail.com>

ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8

RUN apt-get update && \
  apt-get install -y \
  build-essential software-properties-common \
  wget curl git unzip \
  netcat-openbsd openssh-client \
  iputils-ping jq libncurses5-dev \
  libevent-dev net-tools \
  libtool libtool-bin \
  groff util-linux bc coreutils \
  g++ pkg-config cmake automake autoconf

RUN apt-get update && apt-get install -y \
      rubygems ruby-dev \
      silversearcher-ag socat tmux \
      fish bash neovim \
      python3 python3-pip

RUN chsh -s /usr/bin/fish
RUN curl --silent -L http://get.oh-my.fish > /tmp/install \
  && fish /tmp/install --noninteractive \
  && rm /tmp/install
COPY omf "$HOME/.config/omf"
RUN fish -c "omf install"

COPY nvim "$HOME/.config/nvim"

COPY tmux .
RUN git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

ENV DOCKER_VERSION 17.09.0-ce
ENV DOCKER_MACHINE_VERSION 0.12.2

RUN curl -fsSLO "https://github.com/docker/machine/releases/download/v$DOCKER_MACHINE_VERSION/docker-machine-Linux-x86_64" \
  && mv docker-machine-Linux-x86_64 /usr/local/bin/docker-machine \
  && chmod +x /usr/local/bin/docker-machine

RUN curl -fsSLO "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz" \
  && tar --strip-components=1 -xvzf "docker-$DOCKER_VERSION.tgz" -C /usr/local/bin \
  && chmod +x /usr/local/bin/docker \
  && rm "docker-$DOCKER_VERSION.tgz"
