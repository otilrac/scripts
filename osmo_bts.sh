#!/bin/bash
# Without echo configs files
# vano@51.ru
#
#   if not find soapysdr when build SoapyUHD 
#   sudo add-apt-repository -y ppa:myriadrf/drivers
#   sudo apt-get install libsoapysdr-dev
#   sudo apt-get update
# who am i?
id=`id -u`
if [ $id -ne 0 ]; then
   echo it is more convenient to install all this as root
   echo either run this script as sudo ./scriptname or
   echo become root and run it.
   echo press control-c to abort, or press enter to continue
   echo if you continue, expect to enter your password a bunch
   echo of times
fi

read -p "Installing dependencies"
sudo apt-get install -y git g++ cmake libsqlite3-dev  libi2c-dev libusb-1.0-0-dev libwxgtk3.0-dev freeglut3-dev libboost-all-dev swig liblog4cpp5-dev build-essential libtool libtalloc-dev shtool autoconf automake git-core pkg-config make gcc libpcsclite-dev gnutls-bin gnutls-dev python

read -p "Installing LimeSuite"
echo Installing LimeSuite
rm -r LimeSuite
git clone https://github.com/myriadrf/LimeSuite.git
cd LimeSuite
mkdir builddir && cd builddir
cmake ../
make -j4
sudo make install
sudo ldconfig
cd ~
cd LimeSuite/udev-rules
chmod 777 ./install.sh
sudo ./install.sh

read -p "Installing libosmocore"
cd ~
rm -r libosmocore
git clone git://git.osmocom.org/libosmocore
cd libosmocore
autoreconf -fi
./configure
make
sudo make install
sudo ldconfig
cd ../

read -p "Installing osmo-trx"
cd ~
rm -r osmo-trx
git clone git://git.osmocom.org/osmo-trx
cd osmo-trx
autoreconf -fi
./configure --without-uhd --with-lms
make
sudo make install
sudo ldconfig

read -p "Connect Limesdr within 20 seconds and press Enter"
#leep 20

#now run LimeUtil with --find to locate devices on the system
LimeUtil --find

read -p "Installing osmocom-nitb osmo-bts-trx"
cd ~
wget http://download.opensuse.org/repositories/network:/osmocom:/latest/Debian_9.0/Release.key 
sha256sum Release.key
apt-key add Release.key
rm Release.key
chmod 777 /etc/apt/sources.list.d/osmocom-latest.list
echo "deb http://download.opensuse.org/repositories/network:/osmocom:/latest/Debian_9.0/ ./" > /etc/apt/sources.list.d/osmocom-latest.list
apt-get update

apt-get install osmocom-nitb osmo-bts-trx

chmod +x start_bts.sh
