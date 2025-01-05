echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               SUBSCRIBE MY CHANNEL                     "

sleep 5

#!/bin/bash

read -p "Masukkan nama screen: " screen_name

if [[ -z "$screen_name" ]]; then
    echo "Nama screen tidak boleh kosong."
    exit 1
fi

echo "Membuat sesi screen dengan nama '$screen_name'..."
screen -S "$screen_name" -dm

echo "Menjalankan perintah 'aios-cli start' di dalam sesi screen '$screen_name'..."
screen -S "$screen_name" -X stuff "aios-cli start\n"

sleep 5

echo "Keluar dari sesi screen '$screen_name'..."
screen -S "$screen_name" -X detach
sleep 5

if [[ $? -eq 0 ]]; then
    echo "Screen dengan nama '$screen_name' berhasil dibuat dan menjalankan perintah aios-cli start."
else
    echo "Gagal membuat screen."
    exit 1
fi

sleep 2

echo "Masukkan private key Anda (akhiri dengan CTRL+D):"
cat > .pem

echo "Menjalankan perintah import-keys dengan file.pem..."
aios-cli hive import-keys ./.pem

sleep 5
echo "Menambahkan model dengan perintah aios-cli models add..."
model="hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf"

while true; do
    if aios-cli models add "$model"; then
        echo "Model berhasil ditambahkan dan proses download selesai!"
        break
    else
        echo "Terjadi kesalahan saat menambahkan model. Mengulang..."
        sleep 3  
    fi
done

echo "Menjalankan inferensi menggunakan model yang telah ditambahkan..."
infer_prompt="Hello, can you explain about the YouTube channel Share It Hub?"

while true; do
    if aios-cli infer --model "$model" --prompt "$infer_prompt"; then
        echo "Inferensi berhasil."
        break
    else
        echo "Terjadi kesalahan saat menjalankan inferensi. Mengulang..."
        sleep 3
    fi
done

echo "Menjalankan login dan select-tier..."
aios-cli hive login
aios-cli hive select-tier 5
aios-cli hive connect

sleep 5

echo "Menjalankan Hive inferensi menggunakan model yang telah ditambahkan..."
infer_prompt="Hello, can you explain about the YouTube channel Share It Hub?"

while true; do
    if aios-cli hive infer --model "$model" --prompt "$infer_prompt"; then
        echo "Hive Inferensi berhasil."
        break
    else
        echo "Terjadi kesalahan saat menjalankan inferensi. Mengulang..."
        sleep 3
    fi
done
echo "Menghentikan proses 'aios-cli start' dengan 'aios-cli kill'..."
aios-cli kill

echo "Masuk kembali ke screen '$screen_name' untuk menjalankan aios-cli start --connect..."

screen -S "$screen_name" -X stuff "echo 'Menunggu 5 detik sebelum menjalankan perintah...'; aios-cli start --connect\n"

echo "Proses selesai. aios-cli start --connect telah dijalankan di dalam screen dan sistem telah kembali ke latar belakang."
