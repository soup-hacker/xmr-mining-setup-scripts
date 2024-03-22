#!/usr/bin/env bash

read -p "Enter Mullvad account number (leave black to ignore): " mullvad_account

read -p "Enter XMR wallet address: " xmr_address


# SETTING UP THE VPN
if[$mullvad_account!=$null]; then
    sudo curl -fsSLo /usr/share/keyrings/mullvad-keyring.asc https://repository.mullvad.net/deb/mullvad-keyring.asc

    echo "deb [signed-by=/usr/share/keyrings/mullvad-keyring.asc arch=$( dpkg --print-architecture )] https://repository.mullvad.net/deb/stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mullvad.list

    sudo apt update

    sudo apt install mullvad-vpn -y

    mullvad account login $mullvad_account

    mullvad relay set location us

    mullvad lan set allow

    mullvad connect
fi

# SETTING UP THE MINER

git clone https://github.com/xmrig/xmrig.git

mkdir xmrig/build && cd xmrig/build

cmake ..

mkdir xmrig/build && cd xmrig/build

make -j$(nproc)

sudo apt-get install software-properties-common -y 

sudo apt-get -y install cuda

cd ~

git clone https://github.com/xmrig/xmrig-cuda.git

mkdir xmrig-cuda/build && cd xmrig-cuda/build

cmake .. -DCUDA_LIB=/usr/local/cuda/lib64/stubs/libcuda.so -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda

make -j$(nproc)

echo -e "\nEverything is set up, please run the following command to start mining:\n\n${HOME}/xmrig/build/xmrig --cpu-affinity 0xFF --randomx-1gb-pages -o gulf.moneroocean.stream:10128 -u $xmr_address --cuda --cuda-loader=${HOME}/xmrig-cuda/build/xmrig/build/libxmrig-cuda.so"

# ${HOME}/xmrig/build/xmrig --cpu-affinity 0xFF --randomx-1gb-pages -o gulf.moneroocean.stream:10128 -u $xmr_address --cuda --cuda-loader=${HOME}/xmrig-cuda/build/xmrig/build/libxmrig-cuda.so
