# Menampilkan ASCII art di awal skrip
echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               SUBSCRIBE MY CHANNEL                     "
# Menunggu selama 60 detik sebelum menjalankan curl
echo "AUTO HYPERSPACE BY SHARE IT HUB"
sleep 3

# Mengunduh dan menjalankan skrip dari URL yang diberikan
echo "Mengunduh skrip pemasangan..."
curl -s https://download.hyper.space/api/install | bash

# Memuat ulang .bashrc
echo "Memuat ulang .bashrc..."
source /root/.bashrc

# 1. Membuat sesi screen dengan nama 'hyperspace'
echo "Membuat sesi screen dengan nama 'hyperspace'..."
screen -S hyperspace -dm

# 2. Menjalankan perintah 'aios-cli start' di dalam sesi screen 'hyperspace'
echo "Menjalankan perintah 'aios-cli start' di dalam sesi screen 'hyperspace'..."
screen -S hyperspace -X stuff "aios-cli start\n"

# Memberikan waktu untuk aios-cli start berjalan
sleep 5

# 3. Keluar dari sesi screen 'hyperspace' setelah menjalankan perintah
echo "Keluar dari sesi screen 'hyperspace'..."
screen -S hyperspace -X detach

# Membuat sesi screen baru dengan nama 'prompt-hyperspace' dan menjalankan perintah
echo "Membuat sesi screen baru dengan nama 'prompt-hyperspace'..."
screen -S prompt-hyperspace -dm bash -c "echo 'Sesi prompt-hyperspace siap untuk perintah selanjutnya'"

# Memuat ulang .bashrc
echo "Memuat ulang .bashrc..."
source /root/.bashrc

# Menunggu 5 detik sebelum melanjutkan
echo "Menunggu 5 detik sebelum menjalankan perintah import-keys..."
sleep 5

# Meminta pengguna untuk memasukkan private key
echo "Masukkan private key Anda (akhiri dengan CTRL+D):"
cat > .pem

# Menjalankan perintah import-keys dengan file.pem
echo "Menjalankan perintah import-keys dengan file.pem..."
aios-cli hive import-keys ./.pem

# Menunggu 5 detik sebelum menjalankan perintah
echo "Menunggu 5 detik sebelum menjalankan perintah model add..."
sleep 5

# Menambahkan model dengan perintah aios-cli models add
echo "Menambahkan model dengan perintah aios-cli models add..."
model="hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf"

# Mengulang jika terjadi kesalahan
until aios-cli models add "$model"; do
    echo "Terjadi kesalahan saat menambahkan model. Mengulang..."
    sleep 10  # Tunggu 10 detik sebelum mencoba lagi
done

echo "Model berhasil ditambahkan dan proses download selesai!"

# Menjalankan inferensi menggunakan model yang telah ditambahkan
echo "Menjalankan inferensi menggunakan model yang telah ditambahkan..."
infer_prompt="Hello, can you explain about the YouTube channel Share It Hub?"

# Mengulang jika terjadi kesalahan
until aios-cli infer --model "$model" --prompt "$infer_prompt"; do
    echo "Terjadi kesalahan saat menjalankan inferensi. Mengulang..."
    sleep 10  # Tunggu 10 detik sebelum mencoba lagi
done

echo "Inferensi selesai dan berhasil dijalankan!"

# Melakukan login dan memilih tier
echo "Menunggu 10 detik sebelum menjalankan perintah 'aios-cli hive login'..."
sleep 10
echo "Menjalankan perintah 'aios-cli hive login'..."

# Mengulang jika terjadi kesalahan saat login
until aios-cli hive login; do
    echo "Terjadi kesalahan saat login. Mengulang..."
    sleep 10
done

echo "Menunggu 10 detik sebelum menjalankan perintah 'aios-cli hive select-tier 5'..."
sleep 10
echo "Menjalankan perintah 'aios-cli hive select-tier 5'..."

# Mengulang jika terjadi kesalahan saat memilih tier
until aios-cli hive select-tier 5; do
    echo "Terjadi kesalahan saat memilih tier. Mengulang..."
    sleep 10
done

# Menghubungkan ke hive
echo "Menunggu 10 detik sebelum menjalankan perintah 'aios-cli hive connect'..."
sleep 10
echo "Menjalankan perintah 'aios-cli hive connect'..."

# Mengulang jika terjadi kesalahan saat menghubungkan ke hive
until aios-cli hive connect; do
    echo "Terjadi kesalahan saat menghubungkan ke hive. Mengulang..."
    sleep 10
done

# Menjalankan inferensi setelah menghubungkan ke hive
echo "Menjalankan inferensi setelah menghubungkan ke hive..."
while true; do
    aios-cli hive infer --model hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf --prompt "Hello, can you explain about the YouTube channel Share It Hub?"
    if [ $? -eq 0 ]; then
        echo "Inferensi selesai dan berhasil dijalankan!"
        break
    else
        echo "Terjadi kesalahan saat menjalankan inferensi. Mencoba lagi..."
        sleep 5
    fi
done

# Keluar dari sesi screen 'prompt-hyperspace' dan kembali ke hyperspace
echo "Keluar dari sesi screen 'prompt-hyperspace'..."
screen -S prompt-hyperspace -X detach
sleep 10

# Masuk kembali ke sesi screen 'hyperspace'
echo "Masuk kembali ke sesi screen 'hyperspace'..."
screen -r hyperspace

# Menghentikan proses 'aios-cli start' dan menjalankan perintah 'aios-cli kill'
echo "Menghentikan proses 'aios-cli start' dengan 'aios-cli kill'..."
aios-cli kill

# Menunggu 10 detik sebelum menjalankan 'aios-cli start --connect'
echo "Menunggu 10 detik sebelum menjalankan perintah 'aios-cli start --connect'..."
sleep 10

# Menjalankan perintah 'aios-cli start --connect'
echo "Menjalankan perintah 'aios-cli start --connect'..."

# Mengulang jika terjadi kesalahan saat menjalankan start --connect
until aios-cli start --connect; do
    echo "Terjadi kesalahan saat menjalankan 'aios-cli start --connect'. Mengulang..."
    sleep 10
done

# Keluar dari screen 'hyperspace' setelah menjalankan 'aios-cli start --connect'
echo "Keluar dari sesi screen 'hyperspace'..."
screen -S hyperspace -X detach
sleep 10

# Menjalankan perintah 'aios-cli points'
echo "Menjalankan perintah 'aios-cli points'..."
aios-cli points

echo "Proses selesai!"
