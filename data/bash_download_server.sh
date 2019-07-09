#!/bin/bash

printf "INFO: Downloading needed files ...\n\n"

user="$(whoami)"

wget --no-check-certificate -q -O /tmp/altv-server https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_linux/altv-server
wget --no-check-certificate -q -O /tmp/libnode.so.64  https://alt-cdn.s3.nl-ams.scw.cloud/alt-node/libnode.so.64
wget --no-check-certificate -q -O /tmp/vehmodels.bin https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_win32/data/vehmodels.bin
wget --no-check-certificate -q -O /tmp/vehmods.bin https://alt-cdn.s3.nl-ams.scw.cloud/server/master/x64_win32/data/vehmods.bin
wget --no-check-certificate -q -O /tmp/libnode-module.so https://alt-cdn.s3.nl-ams.scw.cloud/alt-node/x64_linux/libnode-module.so
wget --no-check-certificate -q -O /tmp/libcsharp-module.so https://alt-cdn.s3.nl-ams.scw.cloud/coreclr-module/stable/x64_linux/libcsharp-module.so

rm -rf /mnt/c/altv-server
mkdir -p /mnt/c/altv-server
mkdir -p /mnt/c/altv-server/data
mkdir -p /mnt/c/altv-server/modules

sudo cp -f data/start_server.sh /mnt/c/altv-server/start_server.sh

cd /tmp/

sudo mv -f altv-server /mnt/c/altv-server/
sudo mv -f libnode.so.64 /mnt/c/altv-server/
sudo mv -f vehmodels.bin /mnt/c/altv-server/data/
sudo mv -f vehmods.bin /mnt/c/altv-server/data/
sudo mv -f libnode-module.so /mnt/c/altv-server/modules/
sudo mv -f libcsharp-module.so /mnt/c/altv-server/modules/

sudo chown -R $user /mnt/c/altv-server

sudo chmod +x /mnt/c/altv-server/start_server.sh
sudo chmod +x /mnt/c/altv-server/altv-server

ln -s /mnt/c/altv-server ~

