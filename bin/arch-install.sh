#!/bin/bash

PACKAGES="ack acpi alsa-plugins alsa-utils android-sdk-platform-tools android-udev apr asciidoc aspell-de aspell-en autofs awesome base-devel bash-completion bc boost brasero ca-certificates chromium chromium-pepper-flash cmake cups cups-filters cups-pdf cvsps dex dhclient dnsutils dosfstools doxygen evince exiv2 fetchmail ffmpeg file-roller firefox flac flashplugin fltk freeglut fuse gconf gdb gedit gedit-plugins gedit-latex gimp glances glu gnome-keyring gnome-themes-standard gnupg gnuplot gtest gtk-engine-murrine gtk-engine-unico gtk2 gtk2-perl gtk3 gvfs-afc gvfs-afp gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb hddtemp hdf5 htop imagemagick inkscape iotop ipython2 jack jdk lame lftp libcanberra-gstreamer libcanberra-pulse libgit2-glib libgnome libgnome-keyring libjpeg-turbo libreoffice libreoffice-de libva-vdpau-driver libyaml lm_sensors lsb-release lsof meld mendeleydesktop mount-tray mpg123 mplayer musicbrainz nano ninja nss-mdns ntfs-3g odt2txt opencl-headers opencv openmpi openssh openssl openvpn p7zip paprefs pavucontrol pdftk-bin perl-authen-sasl perl-file-mimeinfo perl-libwww perl-mime-tools perl-net-smtp-ssl perl-term-readkey phatch pidgin pidgin-otr pmount powertop procmail protobuf pulseaudio pygtk python2-matplotlib python2-nose python2-numpy python2-pip python2-pyqt4 python2-pytest python2-scipy python2-sensors qtcreator rlwrap rsync rxvt-unicode rxvt-unicode-terminfo samba sh skype slim smartmontools smbclient source-highlight sshfs strace subversion swig sxiv teamviewer texlive-core texlive-fontsextra texlive-latexextra texlive-publishers texlive-science thunderbird thunderbird-i18n-de thunderbird-i18n-en-us tightvnc tk tmux ttf-dejavu ttf-ms-fonts tuxboot unrar unzip urxvt-perls valgrind vicious vlc vte3 wget wxgtk xcalib xclip xorg-xev xorg-xkill xorg-xprop xorg-xrandr xorg-xrdb youtube-viewer"

NOTEBOOK_PACKAGES="bluez bluez-libs bluez-utils gnome-bluetooth nemo network-manager-applet networkmanager nvidia opencl-nvidia samsung-tools xf86-input-synaptics"
DESKTOP_PACKAGES="xf86-video-ati"

install_base_devel()
{
    sudo -n pacman -Syu base-devel patch wget --noconfirm --needed
}

install_yaourt()
{
    pushd $(mktemp -d) > /dev/null
    wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
    tar -xvzf package-query.tar.gz
    cd package-query
    makepkg -si --noconfirm
    cd ..
    
    wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
    tar -xvzf yaourt.tar.gz
    cd yaourt
    makepkg -si --noconfirm
    cd ..
    
    popd > /dev/null
}

enable_multiarch()
{

    # multilib already enabled
    grep -q '^\[multilib\]' /etc/pacman.conf && echo "Multilib already enabled" && return

    # apply patch    
    echo "Enabling multilib in /etc/pacman.conf"
    cat << EOF | sudo patch -N -p0 /etc/pacman.conf
@@ -92,2 +92,2 @@ Include = /etc/pacman.d/mirrorlist
-#[multilib]
-#Include = /etc/pacman.d/mirrorlist
+[multilib]
+Include = /etc/pacman.d/mirrorlist
EOF

}

install_packages()
{
    yaourt --noconfirm --needed -S "$@"
}

enable_sysrq()
{
    echo 'kernel.sysrq = 1' | sudo tee /etc/sysctl.d/99-sysrq.conf
}

main()
{
    # update credentials
    sudo -v
    
    # keep-alive: update existing sudo time stamp if set, otherwise do nothing
    # https://gist.github.com/cowboy/3118588
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # install yaourt, if not yet installed
    if ! hash yaourt 2> /dev/null; then
        install_base_devel
        install_yaourt
    fi
    
    # enable x86
    enable_multiarch

    # update package list
    sudo -n yaourt -Sy

    # install packages
    install_packages $PACKAGES

    # enable sysrq
    enable_sysrq

    # TODO enable_services
    sudo systemctl enable NetworkManager
    sudo systemctl start  NetworkManager
    sudo systemctl enable smartd
    sudo systemctl start  smartd

}

main
