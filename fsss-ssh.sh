echo '[INFO] Make sure to run this script as the user that forejo runs as, over ssh, or with manual ownership grants to your current tty!'
rname="NUL"
read -p '"Real Name" for gpg and git: ' rname
email="NUL"
read -p 'Email: ' email
echo '[INFO] Now creating a gpg key, please fill out the inforemation with what you want for forejo to use.'
echo "$ gpg --default-new-key-algo rsa4096 --quick-gen-key --batch --passphrase '' '$rname <$email>'"
gpg --default-new-key-algo rsa4096 --quick-gen-key --batch --passphrase '' '$rname <$email>'
echo '[INFO] Listing keys'
echo '$ gpg --list-secret-keys --keyid-format=long'
gpg --list-secret-keys --keyid-format=long
key_id=$(gpg --list-secret-keys --keyid-format=long|grep sec|sed -E 's_.+   .+/([^ ]+) .+_\1_g')
echo "[INFO] Detected key: $key_id"
echo '[INFO] Having git recognize this as the default signing key for this user...'
echo "$ git config --global user.signingkey $key_id"
git config --global user.signingkey $key_id
echo "[INFO] Having git use \"$rname\" as name and \"email\" as email..."
echo "$ git config --global user.name \"$rname\""
git config --global user.name "$rname"
echo "$ git config --global user.email \"$email\""
git config --global user.email "$email"
