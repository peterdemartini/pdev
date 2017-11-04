FROM alpine:edge
MAINTAINER Peter DeMartini (https://github.com/peterdemartini)

ENV HOME /root
ENV XDG_CONFIG_HOME=/usr/local/etc
ENV XDG_DATA_HOME=/usr/local/share
ENV XDG_CACHE_HOME=/usr/local/cache

RUN apk add --update-cache --virtual build-deps --no-cache \
    curl autoconf automake cmake \
    g++ libtool libuv upower \
    ncurses ncurses-dev ncurses-libs ncurses-terminfo \
    linux-headers lua5.3-dev lua-sec \
    m4 make unzip ctags \
    alpine-sdk build-base \
    unibilium openssh-client

RUN apk add --update-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    git fish bash less \
    clang go \
    nodejs tmux yarn \
    docker

RUN apk add --update-cache \
    python \
    py-pip \
    python-dev \
    python3-dev \
    python3 &&\
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    rm -r $XDG_CACHE_HOME

RUN apk add --update-cache \
    ruby ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    libstdc++ tzdata bash ca-certificates \
    &&  echo 'gem: --no-document' > /etc/gemrc

ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

WORKDIR /tmp

RUN mkdir -p $HOME/.local/share/fonts \
  && cd $HOME/.local/share/fonts \
  && curl --silent -fLo "Fura Code Regular Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete.otf

RUN git clone https://github.com/neovim/libtermkey.git && \
  cd libtermkey && \
  make && \
  make install && \
  cd ../ && rm -rf libtermkey

RUN git clone https://github.com/neovim/libvterm.git && \
  cd libvterm && \
  make && \
  make install && \
  cd ../ && rm -rf libvterm

RUN git clone https://github.com/neovim/unibilium.git && \
  cd unibilium && \
  make && \
  make install && \
  cd ../ && rm -rf unibilium

RUN curl --silent -L https://github.com/neovim/neovim/archive/nightly.tar.gz | tar xz && \
  cd neovim-nightly && \
  make && \
  make install && \
  cd ../ && rm -rf neovim-nightly

RUN pip3 install neovim

RUN git clone https://github.com/github/hub.git && \
  cd hub && \
  make install prefix=/usr/local && \
  cd ../ && rm -rf hub

COPY config/fish $XDG_CONFIG_HOME/fish
COPY config/nvim $XDG_CONFIG_HOME/nvim
COPY config/omf $XDG_CONFIG_HOME/omf
COPY ssh $HOME/.ssh
COPY gitconfig $HOME/.gitconfig
COPY gitignore_global $HOME/.gitignore_global
COPY xterm-256color-italic.terminfo $XDG_CONFIG_HOME/xterm-256color-italic.terminfo
COPY tmux-theme.conf $HOME/.tmux-theme.conf
COPY tmux.conf $HOME/.tmux.conf
COPY ctags $HOME/.ctags
COPY bin /usr/local/bin

ENV SHELL /usr/bin/fish
ENV TERM xterm-256color-italic
ENV DEBIAN_FRONTEND noninteractive
ENV NPM_CONFIG_LOGLEVEL error
ENV GOPATH $XDG_DATA_HOME/go
ENV GOBIN $XDG_DATA_HOME/go/bin
ENV PATH "$PATH:$GOBIN"

RUN ssh-keyscan github.com > $HOME/.ssh/known_hosts
RUN tic $XDG_CONFIG_HOME/xterm-256color-italic.terminfo

RUN git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm \
  && $HOME/.tmux/plugins/tpm/bin/install_plugins

RUN nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1
RUN nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1

RUN yarn global add eslint prettier && yarn cache clean

RUN curl --silent -L http://get.oh-my.fish > /tmp/omf-install \
  && fish /tmp/omf-install --noninteractive --path=/usr/local/bin/omf --config=$XDG_CONFIG_HOME/omf \
  && rm /tmp/omf-install

RUN fish -c "omf install"

RUN chmod -R 777 /usr/local

WORKDIR /workdir

CMD [ "/usr/bin/fish" ]
