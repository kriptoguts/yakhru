#!/bin/bash

# Meminta input dari pengguna
read -p "Masukkan nama hotkey: " HOTKEY_NAME

# Ambil IP publik server menggunakan curl
SERVER_IP=$(curl -s ifconfig.me)

echo "Menggunakan IP server publik: $SERVER_IP"

# Path lokal dan remote
LOCAL_WALLET_PATH="$HOME/.bittensor/wallets/default"
REMOTE_WALLET_PATH="~/.bittensor/wallets/default"

# Menyalin hotkey
echo "Mengirim hotkey ke server..."
scp "$LOCAL_WALLET_PATH/hotkeys/$HOTKEY_NAME" "root@$SERVER_IP:$REMOTE_WALLET_PATH/hotkeys/$HOTKEY_NAME"

# Menyalin coldkeypub
echo "Mengirim coldkeypub.txt ke server..."
scp "$LOCAL_WALLET_PATH/coldkeypub.txt" "root@$SERVER_IP:$REMOTE_WALLET_PATH/coldkeypub.txt"

echo "Sinkronisasi selesai!"
