mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFb+RA+iiqCY3E77PITvYKLPZLHv0SAfp4PoemkKjMVv enzovercellotti@hotmail.com
' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo '✅ Clé SSH installée avec succès!'
echo '🧪 Test de la connexion...'
