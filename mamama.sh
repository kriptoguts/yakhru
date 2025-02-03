#!/bin/bash

# Fungsi untuk mendapatkan IPv4 server
get_ip() {
    curl -s http://checkip.amazonaws.com
}

IP=$(get_ip)

# Menampilkan menu pilihan
echo "Pilih opsi yang ingin dijalankan:"
echo "1) Instalasi Bittensor CLI"
echo "2) Instalasi Gaia"
echo "3) Menjalankan script"
echo "4) Cek IP server"

read -p "Masukkan pilihan (1/2/3/4): " pilihan

case $pilihan in
    1)
        echo "Mengunduh dan menjalankan Bittensor CLI..."
        wget https://raw.githubusercontent.com/rennzone/Auto-Install-Bittensor-Script/refs/heads/main/bittensor-cli.sh && bash bittensor-cli.sh
        ;;
    2)
        echo "Mengkloning dan menginstal Gaia..."
        git clone https://github.com/Nickel5-Inc/Gaia.git
        cd Gaia || exit
        sudo apt update && sudo apt install python3-venv nodejs npm postgresql -y
        python3 -m venv myenv
        source myenv/bin/activate
        pip install -r requirements.txt
        python ./scripts/setup.py
        sudo service postgresql start
        source ../.gaia/bin/activate
        pip install "git+https://github.com/rayonlabs/fiber.git@production#egg=fiber[full]"
        pip install -e .
        
        echo "Menginstal PM2..."
        sudo npm install -g pm2
        pm2 --version
        pm2 startup
        npm install pm2 -g
        pm2 install pm2-logrotate
        pm2 set pm2-logrotate:max_size 20G
        pm2 set pm2-logrotate:retain 5
        pm2 set pm2-logrotate:compress true
        pm2 set pm2-logrotate:dateFormat YYYY-MM-DD_HH-mm-ss

        echo "Membuat file .env..."
        cat <<EOL > .env
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432
WALLET_NAME=default
HOTKEY_NAME=default
NETUID=57
SUBTENSOR_NETWORK=finney
MIN_STAKE_THRESHOLD=10000
EOL

        echo "Instalasi Gaia selesai. Silakan cek dan edit file .env jika diperlukan."
        ;;
    3)
        echo "Menjalankan script dengan IP: $IP..."
        ./setup_proxy_server.sh --ip "$IP" --port 8089 --forwarding_port 9032 --server_name ProxyServer1
        fiber-post-ip --netuid 57 --external_ip "$IP" --external_port 8089 --subtensor.network finney --wallet.name default --wallet.hotkey default
        pm2 start --name subnet57 --instances 1 python -- gaia/miner/miner.py --port 9032
        ;;
    4)
        echo "IP server Anda adalah: $IP"
        ;;
    *)
        echo "Pilihan tidak valid, keluar..."
        exit 1
        ;;
esac
