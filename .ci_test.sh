#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install required packages
apt-get update
apt-get install -y tzdata sudo apt-utils build-essential python3 git locales sudo

# Change timezon
ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# Change LC_locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8
apt-get install -y console-data

# Setting personal account
useradd yen3
echo 'yen3 ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
mkdir -p /home/yen3
mkdir -p /home/yen3/usr/rc

# Copy dotfiles
cp -rv ./* /home/yen3/usr/rc/

# Correct the permission
chown -R yen3:yen3 /home/yen3

# Start to install as a normal user
# shellcheck disable=SC2117
su yen3
# shellcheck disable=SC2164
cd /home/yen3/usr/rc
export HOME=/home/yen3
export USER=yen3
./install.sh
