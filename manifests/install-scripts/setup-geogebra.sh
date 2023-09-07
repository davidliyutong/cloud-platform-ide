#!/bin/bash

# DPKG way
# wget "https://www.geogebra.org/download/deb.php?arch=amd64&ver=6" -O /tmp/geogebra.deb
# apt-get update && apt-get install -y libgconf-2-4 libcanberra-gtk-module libcanberra-gtk3-module && apt-get clean && apt-get autoclean
# dpkg -i /tmp/geogebra.deb
# rm /tmp/geogebra.deb

wget https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-6-0-794-0.zip -O /tmp/geogebra.zip
unzip /tmp/geogebra.zip -d /opt
DESKTOP_FILE="#!/usr/bin/env xdg-open
[Desktop Entry]
Name=GeoGebra Classic
GenericName=Dynamic mathematics software
Comment=Create interactive mathematical constructions and applets.
TryExec=GeoGebra
Exec=GeoGebra %F
Terminal=false
Type=Application
StartupNotify=true
Categories=Education;Math;"

ln -s /opt/GeoGebra-linux-x64/GeoGebra /usr/local/bin/GeoGebra
echo "$DESKTOP_FILE" > /usr/share/applications/geogebra.desktop

rm /tmp/geogebra.zip

