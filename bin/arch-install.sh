#!/bin/bash

PACKAGES="ttf-dejavu opencl-headers gtk2 gtk3 freeglut glu slim awesome vicious rlwrap dex hddtemp alsa-utils tk perl-libwww perl-term-readkey perl-mime-tools perl-net-smtp-ssl perl-authen-sasl subversion cvsps gnome-keyring libgnome-keyring bash-completion rxvt-unicode rxvt-unicode-terminfo urxvt-perls gtk2-perl alsa-utils base-devel wget rsync chromium libgnome perl-file-mimeinfo alsa-plugins pulseaudio bluez bluez-libs gconf jack python2-pyqt4 ntfs-3g dosfstools gvfs-afc gvfs-smb gvfs-gphoto2 gvfs-afp gvfs-mtp gvfs-goa libcanberra-pulse libcanberra-gstreamer ffmpeg libva-vdpau-driver sh xorg-xrdb cmake asciidoc gtest opencv python2-numpy libjpeg-turbo swig fltk boost apr openmpi valgrind gdb glances python2-sensors nss-mdns dhclient xclip hdf5 python2-nose gedit gedit-plugins vte3 libgit2-glib gtk-engine-unico htop lsof strace autofs sxiv python2-matplotlib pygtk python2-scipy python2-pytest xorg-xrandr acpi bc file-roller p7zip eclipse eclipse-cdt gtk-engine-murrine gnome-themes-standard wxgtk powertop paprefs pavucontrol xorg-xev aspell-en aspell-de ninja jdk chromium-pepper-flash-stable gimp iotop ipython2 lsb-release odt2txt pidgin pidgin-otr xclip ca-certificates gnupg nano openssh openssl openvpn brasero cups cups-filters cups-pdf doxygen evince sxiv exiv2 firefox flac flashplugin freeglut fuse gnuplot imagemagick inkscape lame lftp libreoffice lm_sensors lsof meld mpg123 mplayer musicbrainz samba smbclient thunar unzip unrar vlc xorg-xkill phatch mendeleydesktop pdftk-bin pmount teamviewer tightvnc ttf-ms-fonts skype mount-tray"

NOTEBOOK_PACKAGES="nvidia opencl-nvidia networkmanager network-manager-applet samsung-tools xf86-input-synaptics"
DESKTOP_PACKAGES="xf86-video-ati"

install_base_devel()
{
    sudo -n pacman -Syu base-devel wget --noconfirm --needed
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

install_packages()
{
    yaourt --noconfirm --needed -S "$@"
}

main()
{
    # update credentials
    sudo -v

    # install yaourt, if not yet installed
    if ! hash yaourt 2> /dev/null; then
        install_base_devel
        install_yaourt
    fi

    # update package list
    sudo -n yaourt -Sy

    # install packages
    install_packages $PACKAGES

    # TODO enable_services
}

main
