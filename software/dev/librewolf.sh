# Desinstala
sudo apt purge librewolf -y
sudo extrepo disable librewolf
sudo apt purge extrepo -y
sudo apt autoremove --purge -y
rm -rf ~/.librewolf ~/.cache/librewolf
sudo rm -rf /var/lib/extrepo

# Instala
sudo apt install extrepo -y
sudo extrepo enable librewolf
sudo extrepo update librewolf
sudo apt install librewolf -y
