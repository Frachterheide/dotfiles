# Arch (btw) Installation & Setup 

## 1 Features
- encrypted boot-partition
- encrypted "(single device) lvm on luks" system-partitions (root,home,swap)
- single password -> autodecryption & mounting
- hibernate & restore from swap partition

## 2 Requirements
- booted Linux USB-Stick assumed (needs arch-install-scripts installed)
- all following commands have to be run as root
- substitute `__someText__` with proper value (e.g.: /dev/`__deviceName__` -> /dev/sda; /dev/`__efiDevice__` -> /dev/sda1)

## 3 Partitions
- preferred tool: cfdisk /dev/`__deviceName__`
- find device names and identifiers using lsblk
- find UUID using lsblk
- preferred partitions: EFI-Partition 500MB; LUKS 1GB; LUKS 120GB+
- **note partition identifiers**

### 3.1 EFI
- min 500MB
- separate partition: enabling boot partition encryption
- mkfs.fat -F 32 -n EFI /dev/`__efiDevice__` (e.g.:/dev/sda1)

### 3.2 BOOT
- min 1GB
- choose (and rememeber a ) strong password for it is the one securing the whole system

#### 3.2.1 LUKS
- cryptsetup luksFormat -v --type=luks1 /dev/`__bootDevice__`
- cryptsetup open /dev/`__bootDevice__` boot_crypt

#### 3.2.2 Format
- mkfs.ext4 /dev/mapper/boot_crypt -L BOOT

### 3.3 ROOT
- SWAP=RAM; ROOT=50GB+; HOME=50GB+ per user (e.g.: 16+50+50=~120GB)

#### 3.3.1 LVM on LUKS
- cryptsetup luksFormat -v /dev/`__rootDevice__` 
- cryptsetup open /dev/`__rootDevice__` root_crypt
- pvcreate /dev/mapper/root_crypt
- vgcreate LINUX_LVM /dev/mapper/root_crypt
- lvcreate -L 16G -n L_SWAP LINUX_LVM
- (single user) lvcreate -l 100%FREE L_SYSTEM LINUX_LVM 
- (multi user) lvcreate -L 50G -n L_ROOT LINUX_LVM
- (multi user) lvcreate -L 50G -n L_HOME_1 LINUX_LVM

#### 3.3.2 Format
- mkswap -L SWAP /dev/mapper/LINUX_LVM-L_SWAP
- (single-user) mkfs.ext4 -L SYSTEM /dev/mapper/LINUX_LVM-L_SYSTEM
- (multi-user) mkfs.ext4 -L ROOT /dev/mapper/LINUX_LVM-L_ROOT
- (multi-user) mkfs.ext4 -L HOME_1 /dev/mapper/LINUX_LVM-L_HOME_1

### 3.4 LUKS keyfiles
- 2048 byte-size key for each luks encrypted partition
- use random characters
- separate file per partition
- keyfiles are saved to /etc/cryptsetup-keys.d/ for systemd's sd-encrypt hook to find and decrypt during boot

#### 3.4.1 Create Keyfiles
- dd bs=512 count=4 if=/dev/urandom iflag=fullblock | install -m 0600 /dev/stdin /etc/cryptsetup-keys.d/boot.key
- dd bs=512 count=4 if=/dev/urandom iflag=fullblock | install -m 0600 /dev/stdin /etc/cryptsetup-keys.d/system.key

#### 3.4.2 Add Keyfiles 
- cryptsetup -v luksKeyAdd /dev/`__bootDevice__` /etc/cryptsetup-keys.d/boot.key
- cryptsetup -v luksKeyAdd /dev/`__rootDevice__` /etc/cryptsetup-keys.d/system.key

#### 3.4.3 Test Keyfiles
- cryptsetup --test-passphrase /dev/`__bootDevice__` --key-file /etc/cryptsetup-keys.d/boot.key && echo "boot keyfile setup"
- cryptsetup --test-passphrase /dev/`__systemDevice__` --key-file /etc/cryptsetup-keys.d/system.key && echo "system keyfile setup"

#### 3.4.4 Add LUKS devices to crypttab
- touch /etc/crypttab
- echo "boot_crypt UUID=$(lsblk -dno UUID `__bootDevice__`) /etc/cryptsetup-keys.d/boot.key luks,discard,key-slot=1" >> /etc/crypttab
- echo "root_crypt UUID=$(lsblk -dno UUID `__rootDevice__`) /etc/cryptsetup-keys.d/system.key luks,discard,key-slot=1" >> /etc/crypttab

### 3.5 Mount Partitions
- (single-user) mount dev/mapper/LINUX_LVM-L_SYSTEM /mnt
- (multi-user) mount /dev/mapper/LINUX_LVM-L_ROOT /mnt
- (multi-user) mount /dev/mapper/LINUX_LVM-L_HOME_1 /mnt/home
- mount /dev/mapper/boot_crypt /mnt/boot
- mount /dev/`__efiDevice__` /mnt/efi
- swapon /dev/mapper/LINUX_LVM-L_SWAP

## 4 Installation: Arch System & Essentials
- choose and add to pacstrap below: intel-ucode OR amd-ucode **depending on CPU manufacturer**
- choose and add to pacstrap below: amdvlk amdgpu OR nvidia-dkms **depending on non-internal GPU manufacturer**
- pacstrap -K /mnt base base-devel linux-lts linux-lts-headers linux-firmware\
grub efibootmgr dosfstools ntfs-3g os-prober cryptsetup lvm2 man-db\
man-pages texinfo sudo networkmanager dbus xdg-desktop-portal\
xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-user-dirs xdg-utils\
xorg-auth pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumper\
noise-suppression-for-voice ttf-robot ttf-roboto-mono ttf-roboto-mono-nerd woff2-font-awesome\
ttf-liberation ttf-jetbrains-mono ttf-jetbrains-mono-nerd openssh bluez\
bluez-utils veracrypt wayland sway swaybg swaylock swayidle brightnessctl\
dmenu fuzzel wl-clipboard waybar neovim wezterm tmux firefox qtpass\
pavucontrol nvm npm ninja meson jq tokei htop git rsync ripgrep qmk\
postrgresql{-docs,-libs} vlc gnome-themes-extra
- (optional) energy management: tlp (enable tlp.service)
- (optional) gpu monitor: nvtop
- (optional) documents: okular libreoffice-still
- (optional) c/cpp/rust compiler & debugger: llvm lld lldb threadweaver
- (optional) java: jdk`__version__`-openjdk openjdk`__version__`-{src,doc}
- (optional) typing trainer: ktouch
- (optional) media codecs: gstreamer flac ffmpeg ffmpeg4 webrtc-audio-processing openal mpg123
- (optional) webserver: nginx
- (optional) security tools: wireshark nmap
- (optional) dynamic module update: dkms
- (optional) graphic editor: gimp
- (optional) gaming: vkbasalt vkd3d steam wine wine-gecko wine-mono hid-tmff2 (thrustmaster;AUR) winetricks (AUR)

## 5 Configuration
- genfstab -U /mnt | tee /mnt/etc/fstab
- arch-chroot /mnt

### 5.1 Localization
- ln -sf /usr/share/zoneinfo/`__region__`/`__city__` /etc/localtime
- hwclock --systohc
- echo "en_US.UTF-8" | tee --append /etc/locale.gen
- echo "de_DE.UTF-8" | tee --append /etc/locale.gen
- locale-gen
- echo "LANG=en_US.UTF-8" | tee --append /etc/locale.conf
- echo "KEYMAP=de-latin1" | tee --append /etc/vconsole.conf
- echo "host-01" | tee --append /etc/hostname

### 5.2 Change root password
- passwd

### 5.3 Prepare Initramfs
- edit /etc/mkinitcpio.conf
- preload non-internal gpu driver e.g.: MODULES=(amdgpu) 
- FILES=(/etc/cryptsetup-keys.d/boot.key /etc/cryptsetup-keys.d/system.key) 
- HOOKS=(base systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt lvm2 filesystems fsck)

### 5.4 Prepare GRUB
- note UUIDS for `__bootDevice__` and `__rootDevice__` (use: echo $(lsblk -dno UUID `__device__`))
- edit /etc/default/grub
- GRUB_CMDLINE_LINUX="rd.luks.name=`__bootUUID__`=boot_crypt rd.luks.name=`__rootUUID__`=root_crypt resume=/dev/mapper/LINUX_LVM-L_SWAP"
- GRUB_ENABLE_CRYPTODISK=y

### 5.5 Install GRUB
- grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck

### 5.6 Create sudo-User
- useradd `__username__` -G wheel audio -p `__password__`
- edit /etc/sudoers
- remove # infront of %wheel ALL=(ALL:ALL) ALL

## 6 REBOOT
- Enter password chosen for BOOT partition
- login using username and password of sudo-User

## 7 Download AUR/GIT Essentials
- adwaita qt themes for uniform presentation of applications (QT\~GTK2\~GTK3)
- libreoffice browser for private searching
- dotfiles
- mkdir -p ~/Downloads/GIT_BUILD

### 7.1 adwaita-qt5 and adwaita-qt6
- cd ~/Downloads/GIT_BUILD; git clone --recurse-submodules https://aur.archlinux.org/adwaita-qt-git.git
- cd adwaita-qt-git; makepkg; sudo pacman -U adwaita-qt{5,6}-git*x86_64.pkg.tar.zst

### 7.2 librewolf
- cd ~/Downloads/GIT_BUILD; git clone --recurse-submodules https://aur.archlinux.org/librewolf-bin.git
- cd librewolf-bin; makepkg
- gpg --receive-keys `__fingerprint__`
- makepkg; sudo pacman -U librewolf-[1-9]*.tar.zst

### 7.3 dotfiles
- cd ~/.config/; git clone --recurse-submodules https://github.com/frachterheide/dotfiles.git ./

## 8 Configure UX

### 8.1 Bash 
- follow instructions at top of ~/.config/bash/bashrc
- sudo pacman -S bash-completion
- run `make install` inside ~/.config/bash/plugins/.bashmarks

### 8.2 Environment 
- follow instructions at top of ~/.config/user-profile
- sudo edit: content of add xdg_setup_etc_security_pam_env.conf to end of /etc/security/pam_env.conf
- relog after saving file (loginctl terminate-user `__username__`)

### 8.3 Neovim 
- open Neovim
- run `:Lazy sync`
- run `:MasonUpdate`

### 8.4 Sway 

#### 8.4.1 Monitor Setup 
- run `swaymsg -t get_outputs`
- note monitor connection id (e.g.: HDMI-A-1 / DP-0) and preferred resolution/refresh rate
- edit sway/config file; search for line starting with `output`; change/add monitor id and refresh rate/resolution

#### 8.4.2 Keyboard Layout 
- run `swaymsg -t get_inputs`
- note input Identifier
- edit sway/config; add `input "__Identifier__" { xkb_layout "__layout__" }`

### 8.5 Pipewire 
- use pipewire 
