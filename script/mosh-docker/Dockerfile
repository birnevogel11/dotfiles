FROM ubuntu:22.04 as builder

RUN set -ex \
    && sed -i 's/archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list \
    && apt update \
    && apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y build-essential \
       cmake pkg-config libutempter-dev zlib1g-dev libncurses5-dev \
       libssl-dev bash-completion tmux less wget openssh-client autoconf git \
       libtool libtool-bin \
       locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean all \
    && rm -rf \
         /var/cache/debconf/* \
         /var/lib/apt/lists/* \
         /var/log/* \
         /tmp/* \
         /var/tmp/*

ENV LANG en_US.UTF-8
ENV TERM=xterm-256color

RUN set -ex \
    && echo "Install protobuf 26.1" \
    && mkdir -p /build \
    && cd /build \
    && git clone https://github.com/protocolbuffers/protobuf.git \
    && cd /build/protobuf \
    && git checkout v26.1 \
    && git submodule update --init --recursive

RUN set -ex \
    && cd /build/protobuf* \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j16 \
    && make install \
    && ldconfig

RUN set -ex \
    && echo "Install mosh" \
    && mkdir -p /build \
    && cd /build \
    && git clone https://github.com/mobile-shell/mosh

RUN set -ex \
    && cd /build/mosh \
    && git checkout 1105d481bb9143dad43adf768f58da7b029fd39c \
    && ./autogen.sh \
    && ./configure \
    && make -j16 \
    && make install

RUN set -ex \
    && cd /usr/local \
    && find . -type f -name *.a | xargs -n1 rm \
    && rm -rf /usr/local/lib/libprotoc.la /usr/local/lib/libprotoc.so* \
    && rm -rf /usr/local/lib/libprotobuf-lite.la /usr/local/lib/libprotobuf-lite.so* \
    && rm -rf /usr/local/protoc

FROM ubuntu:22.04

RUN set -ex \
    && sed -i 's/archive.ubuntu.com/de.archive.ubuntu.com/g' /etc/apt/sources.list \
    && apt update \
    && apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y locales openssh-client libutempter0 \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean all \
    && rm -rf \
         /var/cache/debconf/* \
         /var/lib/apt/lists/* \
         /var/log/* \
         /tmp/* \
         /var/tmp/*

ENV LANG en_US.UTF-8
ENV TERM=xterm-256color

COPY --from=builder /usr/local/bin/mosh* /usr/local/bin

RUN ldconfig
