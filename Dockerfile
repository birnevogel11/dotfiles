ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei

# Install all packages
RUN set -eux \
    && apt-get update \
    && apt-get install -y tzdata sudo apt-utils build-essential python3 git locales \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get install -y console-data \
    && apt-get clean all \
    && rm -rf \
           /var/cache/debconf/* \
           /var/lib/apt/lists/* \
           /var/log/* \
           /tmp/* \
           /var/tmp/*

ENV LANG=en_US.UTF-8

# Setting personal account
RUN set -eux \
    && useradd yen3 \
    && echo 'yen3 ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && mkdir -p /home/yen3 \
    && chown -R yen3:yen3 /home/yen3

USER yen3

WORKDIR /home/yen3

# Install personal environment
RUN set -eux \
    && mkdir -p /home/yen3/usr \
    && cd /home/yen3/usr \
    && git clone --recursive https://gitlab.com/yen3/dotfiles.git rc \
    && cd /home/yen3/usr/rc \
    && ./install.sh \
    && sudo apt-get clean all \
    && sudo rm -rf \
           /var/cache/debconf/* \
           /var/lib/apt/lists/* \
           /var/log/* \
           /tmp/* \
           /var/tmp/*

ENTRYPOINT ["/bin/zsh"]
