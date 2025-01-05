echo "   ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo "               SUBSCRIBE MY CHANNEL                     "

sleep 5

echo "Menghapus model yang ada sebelumnya..."
rm -rf /root/.cache/hyperspace/models/*
sleep 5

#!/bin/bash
echo "Masukkan private key Anda (akhiri dengan CTRL+D):"
cat > .pem

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

echo "Menambahkan model dengan perintah aios-cli models add..."

echo "Menambahkan model dengan perintah aios-cli models add..."

# URL untuk mengunduh model
url="https://huggingface.com/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q4_K_M.gguf"

# Path folder dan model yang akan disimpan
model_folder="/root/.cache/hyperspace/models/hf__TheBloke___phi-2-GGUF__phi-2.Q4_K_M.gguf"
model_path="$model_folder/phi-2.Q4_K_M.gguf"

# Membuat folder jika belum ada
if [[ ! -d "$model_folder" ]]; then
    echo "Folder tidak ditemukan, membuat folder $model_folder..."
    mkdir -p "$model_folder"
else
    echo "Folder sudah ada, melanjutkan..."
fi

# Mengunduh model jika file belum ada
if [[ ! -f "$model_path" ]]; then
    echo "Mengunduh model dari $url..."
    while true; do
        if wget -q "$url" -O "$model_path"; then
            echo "Model berhasil diunduh dan disimpan di $model_path!"
            break
        else
            echo "Terjadi kesalahan saat mengunduh model. Mengulang..."
            sleep 3  
        fi
    done
else
    echo "Model sudah ada di $model_path, melewati proses pengunduhan."
fi

echo "Model berhasil ditambahkan!"

# Menjalankan inferensi menggunakan model yang telah diunduh
echo "Menjalankan inferensi menggunakan model yang telah ditambahkan..."

# Prompt untuk inferensi
infer_prompt="Can you explain how to write an HTTP server in Rust?"

# Menjalankan inferensi dengan model yang sudah diunduh
while true; do
    if aios-cli infer --model hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf --prompt "$infer_prompt"; then
        echo "Inferensi berhasil."
        break
    else
        echo "Terjadi kesalahan saat menjalankan inferensi. Mengulang..."
        sleep 3
    fi
done

echo "Menjalankan perintah import-keys dengan file.pem..."
aios-cli hive import-keys ./.pem

sleep 5

echo "Menjalankan login dan select-tier..."
aios-cli hive login
aios-cli hive select-tier 5
sleep 5

echo "Menjalankan Hive inferensi menggunakan model yang telah ditambahkan..."
infer_prompt="Can you explain how to write an HTTP server in Rust?"

while true; do
    if aios-cli hive infer --model "$model" --prompt "$infer_prompt"; then
        echo "Hive Inferensi berhasil."
        break
    else
        echo "Terjadi kesalahan saat menjalankan inferensi. Mengulang..."
        sleep 3
    fi
done

sleep 5

echo "Menghentikan proses 'aios-cli start' dengan 'aios-cli kill'..."
aios-cli hive login
sleep 5

aios-cli hive connect
sleep 5

echo "DONE. JIKA KALIAN INGIN CHECK GUNAKAN PERINTAH : sceen -r ""nama screen yang dibuat tanpa tanda " """ !"
