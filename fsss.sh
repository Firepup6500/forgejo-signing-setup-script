#!/bin/bash
echo '[NOTICE] Make sure to run this script as the user that forejo runs as, via ssh or with manual ownership grants to your current tty!'
#echo '[NOTICE] This script modifes your default git config! If forejo runs as your user, then this will mess up your default git config!'
read -p '"Real Name" for gpg and git [Testing]: ' rname
rname=${rname:-Testing}
read -p 'Email [test@test.test]: ' email
email=${email:-test@test.test}
read -p 'Override default git config. Unless forgejo runs as you, this should be left alone! (Y|N) [Y]: ' ovrgit
ovrgit=${ovrgit:-Y}
read -p "Use default gpg directory. Unless you know exactly what you're doing, you should leave this alone! (Y|N) [Y]: " ovrgpg
ovrgpg=${ovrgpg:-Y}
temp=~/.gnupg
[[ $overgpg == n || $ovrgpg == N ]] && read -p "GPG home [$temp]: " gpghome
gpghome=${gpghome:-~/.gnupg}
echo "[INFO] Ensuring '$gpghome' exists with the correct permissions"
echo "$ mkdir -p $gpghome"
mkdir -p "$gpghome"
echo "$ chmod 700 $gpghome"
chmod 700 "$gpghome"
echo '[INFO] Now creating a gpg key using the real name and email provided'
echo "$ GPGHOME=$gpghome gpg --default-new-key-algo rsa4096 --quick-gen-key --batch --passphrase '' \"$rname <$email>\""
GNUPGHOME="$gpghome" gpg --default-new-key-algo rsa4096 --quick-gen-key --batch --passphrase '' "$rname <$email>"
echo '[INFO] Listing keys'
echo "$ GNUPGHOME=$gpghome gpg --list-secret-keys --keyid-format=long"
GNUPGHOME="$gpghome" gpg --list-secret-keys --keyid-format=long
key_id=$(GNUPGHOME="$gpghome" gpg --list-secret-keys --keyid-format=long|grep sec|sed -E 's_.+   .+/([^ ]+) .+_\1_g')
echo "[INFO] Detected key: $key_id"
if [[ "${ovrgit}" == "y" || "${ovrgit}" == "Y" ]] ; then
  echo '[NOTICE] Reconfiguring git!'
  echo '[INFO] Having git recognize this as the default signing key for this user...'
  echo "$ git config --global user.signingkey $key_id"
  git config --global user.signingkey $key_id
  echo "[INFO] Having git use \"$rname\" as name and \"$email\" as email..."
  echo "$ git config --global user.name \"$rname\""
  git config --global user.name "$rname"
  echo "$ git config --global user.email \"$email\""
  git config --global user.email "$email"
else
  echo '[NOTICE] Not Reconfiguring git!'
  echo '[INFO] If you want forgejo to use the new gpg key, you\'ll need to set a few keys in `app.ini`.'
  echo '[INFO] The keys you\'ll need to set are:'
  echo '[repository.signing]'
  echo "SIGNING_KEY = $key_id"
  echo "SIGNING_NAME = $rname"
  echo "SIGNING_EMAIL = $email"
  echo '[INFO] This script does recommend that you use the default git setup with GPG keys, however.'
  [[ $overgpg == n || $ovrgpg == N ]] && echo '[NOTICE] I notice you\'re trying to use a non-standard gpg directory'
  [[ $overgpg == n || $ovrgpg == N ]] && echo '[NOTICE] I have no idea how to make forgejo read from a non-standard gpg dirctory'
  [[ $overgpg == n || $ovrgpg == N ]] && echo '[NOTICE] So you\'re on your own from here. I hope you know what you\'re doing.'
fi
