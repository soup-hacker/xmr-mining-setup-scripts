#!/bin/bash

read -p "Enter Mullvad account number: " mullvad_account

read -p "Enter XMR wallet address: " xmr_address


# SETTING UP THE VPN
sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list

sudo apt update

sudo apt install mullvad-vpn -y

mullvad account login $mullvad_account

mullvad relay set location us

mullvad lan set allow

mullvad connect

# SETTING UP THE MINER

sudo apt update

sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

git clone https://github.com/xmrig/xmrig.git

cd xmrig/

mkdir ./build && cd ./build

echo -e "\n\nCompiling the executable, this will take some time...\n\n"

cmake ..

make

echo -e "\nEverything is ready. To start mining please run the following command:\n\n./xmrig -o gulf.moneroocean.stream:10128 -u $xmr_address\n"

# ./xmrig -o gulf.moneroocean.stream:10128 -u $xmr_address
