#!/bin/bash

PACKAGES_SAME_AS_ARCH="acpi alsa-utils asciidoc aspell-de aspell-en autofs awesome bash-completion bc brasero ca-certificates cmake cups cups-filters cups-pdf cvsps dnsutils dosfstools doxygen evince exiv2 fetchmail file-roller firefox flac freeglut3-dev fuse gdb gedit gedit-plugins gimp gksu glances gnome-control-center gnome-keyring gnome-themes-standard gnupg gnuplot hddtemp htop imagemagick inkscape iotop jack lame lftp libcanberra-gstreamer libcanberra-pulse libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libpopt-dev libreoffice lsb-release lsof mdadm meld mpg123 nano ninja numlockx ntfs-3g nvidia-cuda-toolkit odt2txt opencl-headers openssl openvpn p7zip paprefs pavucontrol phatch pidgin pidgin-otr pmount powertop procmail pulseaudio python-pip qtcreator rlwrap rsync rxvt-unicode samba smartmontools smbclient source-highlight sshfs strace subversion swig sxiv sysstat texlive-publishers texlive-science thunderbird tk tmux ttf-dejavu unagi unrar unzip valgrind vlc wget xcalib xclip xscreensaver"

PACKAGES_NOTFOUND="ack alsa-plugins android-sdk-platform-tools android-udev apr aptitude base-devel boost browser-plugin-freshplayer-pepperflash chromium chromium-pepper-flash dex dhclient ffmpeg flashplugin fltk freeglut gconf gedit-latex glu gtest gtk-engine-murrine gtk-engine-unico gtk2 gtk2-perl gtk3 gvfs-afc gvfs-afp gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb hdf5 ipython2 jdk libgit2-glib libgnome libgnome-keyring libjpeg-turbo libreoffice-de libva-vdpau-driver libyaml mendeleydesktop mount-tray musicbrainz nss-mdns opencv openmpi openssh pdftk-bin perl-authen-sasl perl-file-mimeinfo perl-libwww perl-mime-tools perl-net-smtp-ssl perl-term-readkey protobuf pygtk python2-matplotlib python2-nose python2-numpyy python2-pip python2-pyqt4 python2-pytest python2-scipy python2-sensors rxvt-unicode-terminfo sh skype teamviewer texlive-core texlive-fontsextra texlive-latexextra thunderbird-i18n-de thunderbird-i18n-en-us tightvnc ttf-ms-fonts tuxboot urxvt-perls vicious vte3 wxgtk xorg-xev xorg-xkill xorg-xprop xorg-xrandr xorg-xrdb youtube-viewer"

PACKAGES_MANUAL="ack-grep flashplugin-installer android-tools-adb android-tools-adbd android-tools-fastboot chromium-browser cryptsetup-bin gconf2 ipython ipython-notebook libopencv-dev lm-sensors mplayer2 openssh-server pdftk git-gui silversearcher-ag lm-sensors gparted"

PACKAGES="$PACKAGES_SAME_AS_ARCH $PACKAGES_MANUAL"

refresh_packages()
{
    echo "Refreshing packages..."
    sudo apt-get -y update
    sudo apt-get dist-upgrade
}

install_common()
{
    sudo apt-get install $PACKAGES
}


refresh_packages
install_common
