#!/bin/bash

# Pastikan script berjalan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Jalankan skrip ini sebagai root: sudo bash install_subtensor.sh" 
   exit 1
fi

echo "🔄 Memperbarui sistem..."
sudo apt update -y

echo "📦 Menginstal dependensi Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "📦 Menginstal dependensi sistem..."
sudo apt install --assume-yes make build-essential git clang curl libssl-dev llvm libudev-dev protobuf-compiler

echo "🔄 Mengkloning repository Subtensor..."
git clone https://github.com/opentensor/subtensor.git
cd subtensor

echo "🚀 Menjalankan skrip init.sh..."
./scripts/init.sh

echo "🔨 Membangun Subtensor..."
cargo build -p node-subtensor --profile production

echo "🌐 Menjalankan localnet dengan binary build..."
BUILD_BINARY=1 ./scripts/localnet.sh False
BUILD_BINARY=0 ./scripts/localnet.sh False --no-purge

echo "✅ Instalasi selesai!"

# Memberikan opsi untuk menjalankan wallet overview setelah install
echo "🔍 Menampilkan wallet overview..."
btcli wallet overview --wallet.name default --subtensor.chain_endpoint ws://127.0.0.1:9946
