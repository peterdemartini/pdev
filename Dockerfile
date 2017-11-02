FROM alpine

MAINTAINER Peter DeMartini (https://github.com/peterdemartini)

ENV XDG_CONFIG_HOME=/root
ENV XDG_DATA_HOME=/data
ENV XDG_CACHE_HOME=/tmp

RUN apk update \
  && apk add --no-cache \
  fish bash git \
  alpine-sdk build-base\
  libtool automake m4 \
  autoconf linux-headers unzip \
  ncurses ncurses-dev ncurses-libs ncurses-terminfo \
  python3 python3-dev \
  clang go nodejs \
  xz curl make openssh-client \
  cmake jq coreutils

RUN python3 -m ensurepip \
  && rm -r /usr/lib/python*/ensurepip \
  && pip3 install --upgrade pip setuptools \
  && rm -rf $XDG_CACHE_HOME

RUN sed -i -e "s/bin\/ash/usr\/bin\/fish/" /etc/passwd

ENV SHELL /usr/bin/fish
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM xterm-256color-italic

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

RUN curl -L https://github.com/neovim/neovim/archive/nightly.tar.gz | tar xz && \
  cd neovim-nightly && \
  make && \
  make install && \
  cd ../ && rm -rf neovim-nightly

RUN pip3 install neovim

RUN curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY nvim /root/.config/nvim
COPY fish /root/.config/fish

RUN curl --silent -L http://get.oh-my.fish > /tmp/omf-install \
  && fish /tmp/omf-install --noninteractive --path=/usr/local/bin/omf --config=/root/.config/omf \
  && rm /tmp/omf-install

COPY omf /root/.config/omf
RUN fish -c "omf install"

RUN nvim +PlugInstall +UpdateRemotePlugins +qa > /dev/null

WORKDIR /data

CMD [ "/usr/bin/fish" ]
