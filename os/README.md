# ARCH

## installing arch on usb drive

> https://archlinux.org/download/#http-downloads

### check if usb drive is mounted

If so, unmount all partitions.

### Download and verify the ISO

Get the latest ISO from [archlinux](https://archlinux.org/download/)
(pick a mirror close to you, e.g. a Belgian or Dutch one),
then check it against the SHA256 shown on that page:

```bash
cd downloads
ls -l . | grep "archlinux-*-x86_64.iso"
ls -l . | grep "checksum.txt"
sha256sum -c checksum.txt --ignore-missing
```

### Write to stick

```bash
sudo dd if=archlinux-x86_64.iso of=/dev/sda bs=4M conv=fsync oflag=direct status=progress
sync
```

Use the whole disk (/dev/sda), not a partition (/dev/sda1). This overwrites the partition table,
you don't need to empty it first.

## Boot it

Plug the usb into the target machine,
open the boot menu, and pick the USB
in UEFI mode. If Secure Boot blocks it,
disable Secure Boot for the install.

## Installation

follow Arch's [wiki](https://wiki.archlinux.org/title/Installation_guide).


```bash
localectl set-keymap be-latin1
setfont ter-132b

ip link
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect X

timedateclt
timedatectl set-timezone Europe/Brussels

fdisk -l
g          new empty GPT partition table
n          new partition (ESP)
1          partition number
<Enter>    first sector (default, 2048)
+1G        last sector
t          change type
uefi       "EFI System"

n          new partition (LUKS)
2          partition number
<Enter>    first sector (default)
<Enter>    last sector (default, uses the rest of the disk)
t          change type
2          select partition 2
L          list types, find "Linux LUKS" (or just use "Linux filesystem")
p          print and check the layout
w          write and exit

cryptsetup luksFormat ${DISK}p2
cryptsetup open ${DISK}p2 athena

pvcreate /dev/mapper/athena
vgcreate athena /dev/mapper/athena
lvcreate -L 32G athena -n swap
lvcreate -L 32G athena -n root
lvcreate -l 100%FREE athena -n home

mkfs.fat -F32 ${DISK}p1
mkfs.ext4 /dev/athena/root
mkfs.ext4 /dev/athena/home
mkswap /dev/athena/swap

mount /dev/athena/root /mnt
mount --mkdir /dev/athena/home /mnt/home
mount --mkdir ${DISK}p1 /mnt/boot
swapon /dev/athena/swap

pacstrap -K /mnt base linux linux-firmware lvm2 intel-ucode \
  networkmanager vim sudo man-db

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc

locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo myhostname > /etc/hostname

passwd
useradd -mG wheel ibrahim && passwd ibrahim

EDITOR=vim visudo # uncomment the %wheel line
systemctl enable NetworkManager

# Edit /etc/mkinitcpio.conf and set the HOOKS line.
# sd-encrypt and lvm2 must come after block and before filesystems:
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)

echo "KEYMAP=be-latin1" > /etc/vconsole.conf

bootctl install
blkid -s UUID -o value /dev/nvme0n1p2

touch /boot/loader/entries/arch.conf
vim /boot/loader/entries/arch.conf
# title Arch Linux
# linux /vmlinuz-linux
# initrd /initramfs-linux.img
# 
# options root=/dev/athena/root rw

touch /etc/crypttab.initramfs
vim /etc/crypttab.initramfs
# athena    UUID=X  none    luks

vim /boot/loader/loader.conf
# default arch.conf
# timeout 3

mkinitcpio -P

exit
umount -R /mnt
reboot
```

## chrooting

```bash
cryptsetup open /dev/nvme0n1p2 athena
vgchange -ay
mount /dev/athena/root /mnt
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/athena/home /mnt/home
arch-chroot /mnt
```

## desktop environment

After login in tty1:

```bash
nmcli dev wifi connect X --ask

pacman -S git
pacman -S pipewire wireplumber
pacman -S ttf-jetbrains-mono-nerd ttf-jetbrains-mono
pacman -S sddm


systemctl enable sddm.service
pacman -S kitty

pacman -S hyprland
pacman -S xdg-desktop-portal-hyprland
pacman -S polkit-kde-agent

pacman -S qt5-wayland qt6-wayland
pacman -S dunst
pacman -S brightnessctl
pacman -S pamixer
pacman -S waybar
pacman -S wofi
pacman -S cliphist
pacman -S wl-clipboard
pacman -S awww
pacman -S hyprlock
pacman -S hypridle
pacman -S grimblast
pacman -S nwg-look
pacman -S qt5ct qt6ct kvantum
```


### Theming

```bash
pacman -S stow
git clone https://github.com/ibrahimElk/dotfiles ~/dotfiles
cd ~/dotfiles
touch ~/.gtkrc-2.0.mine
stow --no-folding -t ~ hypr waybar kitty dunst nvim tmux zsh lazygit assets gtk qt theme
```

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font Mono 11'
```

```bash
sudo pacman -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
sudo git clone --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git \
  /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
sudo tee /etc/sddm.conf > /dev/null <<'EOF'
[Theme]
Current=sddm-astronaut-theme
EOF

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null <<'EOF'
[General]
InputMethod=qtvirtualkeyboard
EOF
```
