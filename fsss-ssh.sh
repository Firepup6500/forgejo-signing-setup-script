echo '[INFO] Make sure to run this script as the user that forejo runs as, over ssh, or with manual ownership grants to your current tty!'
echo '[INFO] Now creating a gpg key, please fill out the inforemation with what you want for forejo to use.'
echo '[INFO] Since the creator is uncertain if it is supported, this script recommends having no passphrase on this key.'
echo '$ gpg --default-new-key-algo rsa4096 --gen-key'
gpg --default-new-key-algo rsa4096 --gen-key
echo '[INFO] Listing keys'
echo '$ gpg --list-secret-keys --keyid-format=long'
gpg --list-secret-keys --keyid-format=long
key_id=$(gpg --list-secret-keys --keyid-format=long|grep sec|sed -E 's_.+   .+/([^ ]+) .+_\1_g')
echo "[INFO] Detected key: $key_id"
echo '[INFO] Having git recognize this as the default signing key for this user...'
echo "$ git config --global user.signingkey $key_id"
git config --global user.signingkey $key_id
