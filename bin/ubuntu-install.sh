#!/bin/bash

PACKAGES_SAME_AS_ARCH="acpi alsa-utils asciidoc aspell-de aspell-en autofs awesome bash-completion bc brasero ca-certificates cmake cups cups-filters cups-pdf cvsps dex dnsutils dosfstools doxygen evince exiv2 fetchmail ffmpeg file-roller firefox flac fuse gdb gedit gedit-plugins gimp glances gnome-keyring gnome-themes-standard gnupg gnuplot hddtemp htop imagemagick inkscape iotop jack lame lftp libcanberra-gstreamer libcanberra-pulse libreoffice lsb-release lsof meld mpg123 mplayer nano ninja ntfs-3g odt2txt opencl-headers openssl openvpn p7zip paprefs pavucontrol phatch pidgin pidgin-otr pmount powertop procmail pulseaudio qtcreator rlwrap rsync rxvt-unicode samba slim smartmontools smbclient source-highlight sshfs strace subversion swig sxiv texlive-publishers texlive-science thunderbird tk tmux ttf-dejavu unrar unzip valgrind vlc wget xcalib xclip"

PACKAGES_NOTFOUND="ack alsa-plugins android-sdk-platform-tools android-udev apr base-devel boost chromium chromium-pepper-flash dhclient flashplugin fltk freeglut gconf gedit-latex glu gtest gtk-engine-murrine gtk-engine-unico gtk2 gtk2-perl gtk3 gvfs-afc gvfs-afp gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-smb hdf5 ipython2 jdk libgit2-glib libgnome libgnome-keyring libjpeg-turbo libreoffice-de libva-vdpau-driver libyaml lm_sensors mendeleydesktop mount-tray musicbrainz nss-mdns opencv openmpi openssh pdftk-bin perl-authen-sasl perl-file-mimeinfo perl-libwww perl-mime-tools perl-net-smtp-ssl perl-term-readkey protobuf pygtk python2-matplotlib python2-nose python2-numpy python2-pip python2-pyqt4 python2-pytest python2-scipy python2-sensors rxvt-unicode-terminfo sh skype teamviewer texlive-core texlive-fontsextra texlive-latexextra thunderbird-i18n-de thunderbird-i18n-en-us tightvnc ttf-ms-fonts tuxboot urxvt-perls vicious vte3 wxgtk xorg-xev xorg-xkill xorg-xprop xorg-xrandr xorg-xrdb youtube-viewer"

PACKAGES_MANUAL="ack-grep adobe-flashplugin android-tools-adb android-tools-adbd android-tools-fastboot browser-plugin-freshplayer-pepperflash chromium-browser cryptsetup-bin gconf2 ipython ipython-notebook libopencv-dev lm-sensors openssh-server pdftk skype git-gui"

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
