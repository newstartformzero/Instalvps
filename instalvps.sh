#!/bin/bash

# Daftar IP VPS
VPS_LIST=(
152.42.179.87  
139.59.243.176  
206.189.94.136  
167.172.90.148  
159.223.35.64  
104.248.154.226  
178.128.93.244  
167.71.192.145  
139.59.98.251  
159.89.206.223
)

# Password SSH
PASSWORD="KonTol707d"

# Cek apakah expect tersedia
if ! command -v expect &> /dev/null; then
    echo "🔧 Menginstal expect..."
    sudo apt update && sudo apt install -y expect
fi

# Fungsi untuk jalankan perintah di satu VPS
run_on_vps() {
    local IP="$1"
    echo "🚀 Menyambung ke $IP dan menjalankan auto reinstall..."

    expect <<EOF
log_user 1
set timeout 120
spawn ssh -o StrictHostKeyChecking=no root@$IP
expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*assword:" { send "$PASSWORD\r" }
}
expect "#" {
    send -- "wget -O reinstall.sh https://raw.githubusercontent.com/bin456789/reinstall/refs/heads/main/reinstall.sh\r"
    expect "#"
    send -- "bash reinstall.sh dd --img \"http://188.166.176.108/dotaja.gz\" --rdp-port 2003 --password \"jokoaja\"\r"
    expect "#"
    send -- "reboot\r"
}
# Menunggu koneksi terputus karena reboot
expect {
    "Connection to $IP closed" {
        puts "🔌 Koneksi ke $IP terputus (reboot)"
    }
    eof {
        puts "🔌 EOF diterima (reboot)"
    }
}
EOF
}

# Loop ke semua VPS
for IP in "${VPS_LIST[@]}"; do
    run_on_vps "$IP"
    echo "✅ Selesai untuk $IP"
    echo "----------------------------"
done

echo "🎉 SEMUA VPS SELESAI!"
