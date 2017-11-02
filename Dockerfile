FROM alpine

MAINTAINER Peter DeMartini (https://github.com/peterdemartini)

ENV XDG_CONFIG_HOME=/usr/local/etc
ENV XDG_DATA_HOME=/usr/local/share
ENV XDG_CACHE_HOME=/usr/local/cache

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
  cmake jq coreutils \
  ctags tmux

RUN python3 -m ensurepip \
  && rm -r /usr/lib/python*/ensurepip \
  && pip3 install --upgrade pip setuptools \
  && rm -rf $XDG_CACHE_HOME

RUN sed -i -e "s/bin\/ash/usr\/bin\/fish/" /etc/passwd

ENV SHELL /usr/bin/fish
ENV CMAKE_EXTRA_FLAGS=-DENABLE_JEMALLOC=OFF
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

COPY gitconfig $XDG_CONFIG_HOME/.gitconfig

COPY xterm-256color-italic.terminfo $XDG_CONFIG_HOME/
RUN tic $XDG_CONFIG_HOME/xterm-256color-italic.terminfo
ENV TERM xterm-256color-italic

WORKDIR /tmp

RUN git clone https://github.com/neovim/libtermkey.git && \
  cd libtermkey && \
  make && \
  make install && \
  cd ../ && rm -rf libtermkey

RUN git clone https://github.com/neovim/libvterm.git libvterm && \
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

RUN curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY config $XDG_CONFIG_HOME

ENV TMUX_PLUGIN_MANAGER_PATH $XDG_CONFIG_HOME/tmux/plugins

RUN mkdir -p $XDG_CONFIG_HOME/tmux/plugins/tpm \
  && git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm \
  && $XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins

COPY tmux-theme.conf $XDG_CONFIG_HOME/tmux-theme.conf
COPY tmux.conf $XDG_CONFIG_HOME/.tmux.conf

RUN curl --silent -L http://get.oh-my.fish > $XDG_CACHE_HOME/omf-install \
  && fish $XDG_CACHE_HOME/omf-install --noninteractive --path=/usr/local/bin/omf --config=$XDG_CONFIG_HOME/omf \
  && rm $XDG_CACHE_HOME/omf-install

RUN fish -c "omf install"

RUN nvim +PlugInstall +qa > /dev/null

RUN env NPM_CONFIG_LOGLEVEL=error npm install --silent --global eslint prettier && npm cache --force clean

WORKDIR /data

CMD [ "/usr/bin/fish" ]
