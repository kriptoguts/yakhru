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
    
esac
