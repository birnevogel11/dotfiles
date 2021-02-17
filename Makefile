SHELL := /bin/bash

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

UBUNTU_VERSION?=18.04

.PHONY: install
install:
	./install.sh

.PHONY: build-image
build-image:
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} -t yen3/dotfiles:latest .

.PHONY: build-arch-image
build-arch-image:
	docker build -t yen3/dotfiles:arch -f Dockerfile.archlinux .

.PHONY: push-image
push-image:
	docker push yen3/dotfiles:latest

.PHONY: ci-test
ci-test:
	apt-get update
	apt-get install -y tzdata sudo apt-utils build-essential python3 git locales sudo
	ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
	locale-gen
	update-locale LANG=en_US.UTF-8
	apt-get install -y console-data
	Setting personal account
	useradd yen3
	echo 'yen3 ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
	mkdir -p /home/yen3
	mkdir -p /home/yen3/usr/rc
	cp -rv ./* /home/yen3/usr/rc/
	chown -R yen3:yen3 /home/yen3
	# Start to install
	su yen3 && cd /home/yen3/usr/rc && HOME=/home/yen3 USER=yen3 ./install.sh
