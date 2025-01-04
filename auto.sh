# Menampilkan ASCII art di awal skrip
echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               SUBSCRIBE MY CHANNEL                     "
# Menunggu selama 60 detik sebelum menjalankan curl

sleep 5

#!/bin/bash

# Meminta pengguna untuk memasukkan nama screen
read -p "Masukkan nama screen: " screen_name

# Mengecek apakah nama screen sudah diisi
if [[ -z "$screen_name" ]]; then
    echo "Nama screen tidak boleh kosong."
    exit 1
fi

# 1. Membuat sesi screen dengan nama "$screen_name"
echo "Membuat sesi screen dengan nama '$screen_name'..."
screen -S "$screen_name" -dm

# 2. Menjalankan perintah 'aios-cli start' di dalam sesi screen "$screen_name"
echo "Menjalankan perintah 'aios-cli start' di dalam sesi screen '$screen_name'..."
screen -S "$screen_name" -X stuff "aios-cli start\n"

# Memberikan waktu untuk aios-cli start berjalan
sleep 5

# 3. Keluar dari sesi screen "$screen_name" setelah menjalankan perintah
echo "Keluar dari sesi screen '$screen_name'..."
screen -S "$screen_name" -X detach
sleep 5

# Memastikan screen berhasil dibuat
if [[ $? -eq 0 ]]; then
    echo "Screen dengan nama '$screen_name' berhasil dibuat dan menjalankan perintah aios-cli start."
else
    echo "Gagal membuat screen."
    exit 1
fi

# Menunggu beberapa detik untuk memberi waktu screen memulai proses
sleep 2

# Masukkan private key
echo "Masukkan private key Anda (akhiri dengan CTRL+D):"
cat > .pem

# Menjalankan perintah import-keys dengan file.pem
echo "Menjalankan perintah import-keys dengan file.pem..."
aios-cli hive import-keys ./.pem

# Menunggu 5 detik sebelum menjalankan perintah model add...
sleep 5
echo "Menambahkan model dengan perintah aios-cli models add..."
model="hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf"

# Mengulang jika terjadi kesalahan
until aios-cli models add "$model"; do
    echo "Terjadi kesalahan saat menambahkan model. Mengulang..."
    sleep 3  # Tunggu 3 detik sebelum mencoba lagi
done

echo "Model berhasil ditambahkan dan proses download selesai!"

# Menjalankan inferensi menggunakan model yang telah ditambahkan
echo "Menjalankan inferensi menggunakan model yang telah ditambahkan..."
infer_prompt="Hello, can you explain about the YouTube channel Share It Hub?"

# Mengulang jika terjadi kesalahan
until aios-cli infer --model "$model" --prompt "$infer_prompt"; do
    echo "Terjadi kesalahan saat menjalankan inferensi. Mengulang..."
    sleep 3  # Tunggu 3 detik sebelum mencoba lagi
done

echo "Inferensi selesai dan berhasil dijalankan!"

# Menjalankan login dan select-tier sebelum menghentikan proses 'aios-cli start'
echo "Menjalankan login dan select-tier..."
aios-cli hive login
aios-cli hive select-tier 5
aios-cli hive connect
# Menghentikan proses 'aios-cli start' dan menjalankan perintah 'aios-cli kill'
echo "Menghentikan proses 'aios-cli start' dengan 'aios-cli kill'..."
aios-cli kill

# Masuk kembali ke dalam screen dan menjalankan perintah aios-cli start --connect menggunakan nohup
echo "Masuk kembali ke screen '$screen_name' untuk menjalankan aios-cli start --connect..."

# Menggunakan screen -r untuk merujuk ke sesi yang sudah ada
screen -S "$screen_name" -X stuff "echo 'Menunggu 5 detik sebelum menjalankan perintah...'; aios-cli start --connect\n"

echo "Proses selesai. aios-cli start --connect telah dijalankan di dalam screen dan sistem telah kembali ke latar belakang."
