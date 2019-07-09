#!/bin/bash

printf "\nINFO: Setting up bash ...\n\n"

apt-get -qq update > /dev/null
apt-get -qq -y upgrade > /dev/null
apt-get -qq -y dist-upgrade > /dev/null
apt-get -qq -y install wget apt-transport-https > /dev/null

cd /tmp/
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
chown root:root /etc/apt/sources.list.d/microsoft-prod.list

printf "Package: *\nPin: release a=unstable\nPin-Priority: 400" > /etc/apt/preferences.d/unstable
printf "deb http://deb.debian.org/debian unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list

apt-get -qq update > /dev/null
apt-get -qq -y install aspnetcore-runtime-2.2 > /dev/null
apt-get -qq -yt unstable install gcc-8 libstdc++-8-dev > /dev/null
