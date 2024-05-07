echo '[INFO] Make sure to run this script as the user that forejo runs as, over ssh, or with manual ownership grants to your current tty!'
echo '[INFO] Now creating a gpg key, please fill out the inforemation with what you want for forejo to use.'
echo '$ gpg --default-new-key-algo rsa4096 --gen-key'
gpg --default-new-key-algo rsa4096 --gen-key
echo '[INFO] Listing keys'
echo '$ gpg --list-secret-keys --keyid-format=long'
gpg --list-secret-keys --keyid-format=long
key_id=$(gpg --list-secret-keys --keyid-format=long|grep sec|sed -E 's_.+   .+/([^ ]+) .+_\1_g')
echo "[INFO] Detected key: $key_id"
