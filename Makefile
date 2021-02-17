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
