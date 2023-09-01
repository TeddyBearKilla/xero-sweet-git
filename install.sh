#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
sleep 3
echo
echo "Backing up current XeroASCII      "
echo "##################################"
# Check if pacman.conf.old file exists in /etc/
if [ -f "$HOME/.config/neofetch/XeroAscii.old" ]; then
    echo "Deleting existing XeroAscii.old file..."
    rm $HOME/.config/neofetch/XeroAscii.old
fi
# Rename XeroAscii toXero Ascii.old
if [ -f "$HOME/.config/neofetch/XeroAscii" ]; then
    echo "Renaming XeroAscii to XeroAscii.old..."
    mv $HOME/.config/neofetch/XeroAscii $HOME/.config/neofetch/XeroAscii.old
fi
echo
echo "Removing No longer needed Packages"
echo "##################################"
sudo pacman -Rns --noconfirm lightly-git &>/dev/null; sudo pacman -Rns --noconfirm latte-dock &>/dev/null; sudo pacman -Rns --noconfirm qt5-virtualkeyboard &>/dev/null; sudo pacman -Rns --noconfirm qt6-virtualkeyboard &>/dev/null
sleep 2
echo
echo "Installing Sweet Theme & Needed Packages"
echo "########################################"
# Check if any of the specified packages are installed and install them if not present
packages="sweet-kde-git sweet-kvantum-theme-git sweet-cursors-theme-git beautyline oxygen xero-fonts-git ttf-hack-nerd ttf-fira-code ttf-meslo-nerd-font-powerlevel10k ttf-terminus-nerd noto-fonts-emoji otf-hasklig-nerd"

for package in $packages; do
    pacman -Qi "$package" > /dev/null 2>&1 || sudo pacman -Syy --noconfirm --needed "$package" > /dev/null 2>&1
done
sleep 2
echo
echo "Creating Backup & Applying new Rice, hold on..."
echo "###############################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~
sudo cp -Rf Configs/System/. / && sudo cp -Rf Configs/Home/. /root/
sudo sed -i "s/Current=.*/Current=Shiny-SDDM/" /etc/sddm.conf.d/kde_settings.conf
sleep 2
echo
echo "Applying Flatpak GTK Overrides"
echo "##############################"
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
echo
sleep 2
echo
echo "##########################################"
echo "      Applying LibAdwaita GTK4 Patch      "
echo "    Please Select Sweet-Dark from list    "
echo "##########################################"
./libadwaita-tc.py
sleep 2
ln -sf "$HOME/.themes/Sweet-Dark/gtk-4.0/assets" "${HOME}/.config/gtk-4.0/assets"
sleep 1.5
ln -sf "$HOME/.themes/Sweet-Dark/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk-dark.css"
sleep 1.5
ln -sf "$HOME/.themes/Sweet-Dark/gtk-4.0/gtk-dark.css" "${HOME}/.config/gtk-4.0/gtk.css"
sleep 2
echo
echo "Applying Grub Theme...."
echo "#################################"
chmod +x Grub.sh
sudo ./Grub.sh
sudo sed -i "s/GRUB_GFXMODE=*.*/GRUB_GFXMODE=1920x1080x32/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo
cd ~ && rm -rf xero-sweet-git/
echo "Applying New XeroASCII...."
echo "#################################"
cd ~/.config/neofetch/ && wget -O XeroAscii https://raw.githubusercontent.com/xerolinux/xero-fixes/main/conf/XeroAsciiSweet
echo
rm -rf ~/.cache/
echo "Plz Reboot To Apply Settings..."
echo "#################################"
