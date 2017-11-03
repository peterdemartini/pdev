FROM alpine
MAINTAINER Peter DeMartini (https://github.com/peterdemartini)

RUN mkdir -p /home/pdev/project /home/pdev/.config /home/pdev/.cache /home/pdev/.data

ENV HOME /home/pdev
ENV XDG_CONFIG_HOME=/home/pdev/.config
ENV XDG_CACHE_HOME=/home/pdev/.cache
ENV XDG_DATA_HOME=/home/pdev/.data

RUN apk add --update-cache --virtual build-deps --no-cache \
    curl autoconf automake cmake \
    g++ libtool libuv \
    ncurses ncurses-dev ncurses-libs ncurses-terminfo \
    linux-headers lua5.3-dev lua-sec \
    m4 make unzip ctags \
    alpine-sdk build-base

RUN apk add --update-cache \
    git fish bash less \
    unibilium clang \
    go nodejs tmux

RUN apk add --update-cache \
    python \
    py-pip \
    python-dev \
    python3-dev \
    python3 &&\
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    rm -r /home/pdev/.cache

RUN apk add --update-cache \
    ruby ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    libstdc++ tzdata bash ca-certificates \
    &&  echo 'gem: --no-document' > /etc/gemrc

ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF

WORKDIR /tmp

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

COPY config /home/pdev/.config
COPY gitconfig /home/pdev/.gitconfig
COPY xterm-256color-italic.terminfo /home/pdev/
COPY tmux-theme.conf /home/pdev/.tmux-theme.conf
COPY tmux.conf /home/pdev/.tmux.conf
COPY bin /home/pdev/.bin

ENV SHELL /usr/bin/fish
ENV TERM xterm-256color-italic
ENV DEBIAN_FRONTEND noninteractive
ENV NPM_CONFIG_LOGLEVEL error
ENV PATH "/home/pdev/go/bin:/home/pdev/.bin:$PATH"
ENV GOPATH /home/pdev/go

RUN tic /home/pdev/xterm-256color-italic.terminfo

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  && /home/pdev/.tmux/plugins/tpm/bin/install_plugins

RUN nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1
RUN nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1

RUN curl --silent -L http://get.oh-my.fish > /tmp/omf-install \
  && fish /tmp/omf-install --noninteractive --path=/usr/local/bin/omf --config=/home/pdev/.config/omf \
  && rm /tmp/omf-install

RUN fish -c "omf install"

RUN npm install --silent \
  --global eslint prettier \
  && npm cache clean

RUN chmod -R 777 /home/pdev
RUN chmod -R 777 /usr/local

WORKDIR /home/pdev/project

CMD [ "/usr/bin/fish" ]
