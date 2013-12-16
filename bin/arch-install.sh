#!/bin/bash

PACKAGES="acpi alsa-plugins alsa-utils apr asciidoc aspell-de aspell-en autofs awesome base-devel bash-completion bc boost brasero ca-certificates chromium chromium-pepper-flash-stable cmake cups cups-filters cups-pdf cvsps dex dhclient dnsutils dosfstools doxygen eclipse eclipse-cdt evince exiv2 ffmpeg file-roller firefox flac flashplugin fltk freeglut fuse gconf gdb gedit gedit-plugins gimp glances glu gnome-keyring gnome-themes-standard gnupg gnuplot gtest gtk-engine-murrine gtk-engine-unico gtk2 gtk2-perl gtk3 gvfs-afc gvfs-afp gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb hddtemp hdf5 htop imagemagick inkscape iotop ipython2 jack jdk lame lftp libcanberra-gstreamer libcanberra-pulse libgit2-glib libgnome libgnome-keyring libjpeg-turbo libreoffice libva-vdpau-driver lm_sensors lsb-release lsof meld mendeleydesktop mount-tray mpg123 mplayer musicbrainz nano ninja nss-mdns ntfs-3g odt2txt opencl-headers opencv openmpi openssh openssl openvpn p7zip paprefs pavucontrol pdftk-bin perl-authen-sasl perl-file-mimeinfo perl-libwww perl-mime-tools perl-net-smtp-ssl perl-term-readkey phatch pidgin pidgin-otr pmount powertop pulseaudio pygtk python2-matplotlib python2-nose python2-numpy python2-pyqt4 python2-pytest python2-scipy python2-sensors qtcreator rlwrap rsync rxvt-unicode rxvt-unicode-terminfo samba sh skype slim smbclient source-highlight strace subversion swig sxiv teamviewer thunar thunderbird thunderbird-i18n-de thunderbird-i18n-en-us tightvnc tk ttf-dejavu ttf-ms-fonts unrar unzip urxvt-perls valgrind vicious vlc vte3 wget wxgtk xclip xorg-xev xorg-xkill xorg-xrandr xorg-xrdb"
NOTEBOOK_PACKAGES="bluez bluez-libs bluez-utils gnome-bluetooth network-manager-applet networkmanager nvidia opencl-nvidia samsung-tools xf86-input-synaptics"
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

    # TODO enable_services
}

main
