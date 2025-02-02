#!/bin/bash

# Fungsi untuk install mulai dari Bittensor
install_full() {
    echo "Memulai instalasi lengkap..."
    
    # Unduh dan jalankan skrip Bittensor
    wget https://raw.githubusercontent.com/rennzone/Auto-Install-Bittensor-Script/refs/heads/main/bittensor-cli.sh && bash bittensor-cli.sh
    
    # Lanjut ke instalasi DistributedAutoML
    install_subnet49
}

# Fungsi untuk install mulai dari DistributedAutoML (Subnet 49)
install_subnet49() {
    echo "Memulai instalasi DistributedAutoML (Subnet 49)..."
    
    # Clone repo DistributedAutoML
    git clone https://github.com/Hivetrain/DistributedAutoML
    cd DistributedAutoML

    # Install pm2 dan konfigurasi log rotation
    npm install pm2 -g
    pm2 install pm2-logrotate
    pm2 set pm2-logrotate:max_size 100G
    pm2 set pm2-logrotate:retain 5
    pm2 set pm2-logrotate:compress true
    pm2 set pm2-logrotate:dateFormat YYYY-MM-DD_HH-mm-ss

    # Install git-lfs dan dependencies Python
    sudo apt install git-lfs -y
    git lfs install
    pip install -r requirements.txt
    pip install -e .

    # Masuk ke direktori konfigurasi
    cd dml/configs

    # Modifikasi bittensor_config.py
    cat > bittensor_config.py <<EOL
import bittensor as bt

class BittensorConfig:
    netuid = 49
    wallet_name = "default"
    wallet_hotkey = "default"
    path = "~/.bittensor/wallets/"
    network = "finney"
    epoch_length = 100

    @classmethod
    def get_bittensor_config(cls):
        bt_config = bt.config()
        bt_config.wallet = bt.config()
        bt_config.subtensor = bt.config()
        bt_config.netuid = cls.netuid
        bt_config.wallet.name = cls.wallet_name
        bt_config.wallet.hotkey = cls.wallet_hotkey
        bt_config.subtensor.network = cls.network
        bt_config.epoch_length = cls.epoch_length
        return bt_config
EOL

    # Meminta input pengguna untuk hf_token dan gene_repo
    echo "Masukkan HF Token Anda:"
    read hf_token
    echo "Masukkan HF Repository Anda:"
    read gene_repo

    # Modifikasi general_config.py
    cat > general_config.py <<EOL
class GeneralConfig:
    device = "cpu"
    hf_token = "$hf_token"
    gene_repo = "$gene_repo"
    metrics_file = "metrics.csv"
    seed = 42
EOL

    # Modifikasi miner_config.py
    cat > miner_config.py <<EOL
import time 

class MinerConfig:
    device = "cpu"
    batch_size = 4
    checkpoint_save_dir = "checkpoints"
    check_registration_interval = 500
    evaluation_iterations = 30
    gp_tree_height = 60
    generations = 1000000
    migration_interval = 1000
    miner_type = "loss"
    num_processes = 3
    pool_url = None
    population_size = 40
    push_platform = "hf"
    save_temp_only = True
    seed = int(time.time())
    tournament_size = 2
    training_iterations = 100
    architectures = {
        "cifar10": ["mlp"],
        "imagenette": ["resnet", "mobilenet_v3"],
        "flowers102": ["resnet", "mobilenet_v3"]
    }
    architectures_weights = {
        "mlp": 0.4,
        "resnet": 0.3,
        "mobilenet_v3": 0.3
    }
EOL

    echo "Konfigurasi selesai!"
}

# Menampilkan menu pilihan
echo "Pilih opsi instalasi:"
echo "1) Instalasi lengkap (Bittensor + DistributedAutoML)"
echo "2) Instalasi hanya DistributedAutoML (Subnet 49)"
read -p "Masukkan pilihan Anda (1 atau 2): " pilihan

case $pilihan in
    1) install_full ;;
    2) install_subnet49 ;;
    *) echo "Pilihan tidak valid, keluar dari script." ;;
esac
