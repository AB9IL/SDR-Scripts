#! /bin/sh

# sdr-updater for Skywave Linux, version 0.4
# Copyright (c) 2017 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# SDR Updater is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Encoding=UTF-8

getqtradio(){
#get qtradio
echo "\n\n...QtRadio..."
cd ~
git clone https://github.com/alexlee188/ghpsdr3-alex
cd ghpsdr3-alex
sh cleanup.sh
git checkout master
autoreconf -i
./configure
make -j4 all
make install
cd ~
rm -rf ghpsdr3-alex
}

getopenwebrx(){
echo "\n\n...csdr dsp library..."
# get the csdr dsp library
cd ~
git clone https://github.com/simonyiszk/csdr
cd csdr
make
make install
ldconfig
cd ~
rm -rf csdr
echo "\n\n\n...Openwebrx..."
# get openwebrx
cd ~
git clone https://github.com/simonyiszk/openwebrx
# nothing to make
# move the files
cp -ar ~/openwebrx /usr/local/sbin/openwebrx

# get the device support
getairspy
gethackrf
getrtlsdr
getsdrplay
}

getairspy(){
echo "\n\n...airspy host..."
#install airspy support
cd ~
git clone git://github.com/airspy/host/
mkdir host/build
cd host/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig
cd ~
rm -rf host
}

gethackrf(){
#install hackrf support
echo "\n\n...Mossmann's driver for hackrf"
cd ~
git clone https://github.com/mossmann/hackrf
mkdir hackrf/host/build
cd hackrf/host/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#get the SoapyHackRF support module
echo "\n\n...soapy hackrf"
cd ~
git clone https://github.com/pothosware/SoapyHackRF
mkdir SoapyHackRF/build
cd SoapyHackRF/build
cmake ..
make
make install
ldconfig
cd ~
rm -rf hackrf
rm -rf SoapyHackRF
}

getsdrplay(){
#get the sdrplay linux api installer manually
#from http://sdrplay.com/linuxdl.php
#then enable and run it:
echo "\n\n...SDRplay MiricsAPI..."
echo "\nGet it manually from http://sdrplay.com/"
echo "\nRobots are people too."
cd ~
chmod 755 SDRplay_RSP_API-Linux-2.09.1.run
./SDRplay_RSP_API-Linux-2.09.1.run
rm -f SDRplay_RSP_API-Linux-2.09.1.run

#get the SoapySDRPlay support module for CubicSDR
echo "\n...SoapySDRPlay..."
cd ~
git clone https://github.com/pothosware/SoapySDRPlay
mkdir SoapySDRPlay/build
cd SoapySDRPlay/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig
cd ~
rm -rf SoapySDRPlay

#get sdrplay support from osmocom
echo "\n\n...gr-osmosdr (gnuradio dependencies for sdrplay forked by hb9fxq)"
cd ~
#use the hb9fxq fork with better sdrplay support
git clone https://github.com/krippendorf/gr-osmosdr-fork-sdrplay
mkdir gr-osmosdr-fork-sdrplay/build
cd gr-osmosdr-fork-sdrplay/build
cmake -DENABLE_NONFREE=TRUE ../
make
make install
ldconfig
cd ~
rm -rf gr-osmosdr-fork-sdrplay

echo "\n\n...openwebrx dependencies for sdrplay (SDRPlayPorts)"
#SDRplay support in OpenWebRX
cd ~
git clone https://github.com/krippendorf/SDRPlayPorts
mkdir SDRPlayPorts/build
cd SDRPlayPorts/build
cmake ..
make
make install
ldconfig
cd ~
rm -rf SDRPlayPorts
}

getrtlsdr(){
#install rtl-sdr drivers
echo "\n\n...rtl-sdr firmware..."
cd ~
git clone https://git.osmocom.org/rtl-sdr
mkdir rtl-sdr/build
cd rtl-sdr/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#get the SoapyRTLSDR support module
echo "\n\n...SoapyRTLSDR..."
cd ~
git clone https://github.com/pothosware/SoapyRTLSDR
mkdir SoapyRTLSDR/build
cd SoapyRTLSDR/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#install rtl_hpsdr
#build librtlsdr, but only keep rtl_hpsdr
echo "\n\n...rtl_hpsdr..."
cd ~
git clone https://github.com/n1gp/librtlsdr
mkdir librtlsdr/build
cd librtlsdr/build
cmake ..
make
cp ~/librtlsdr/build/src/rtl_hpsdr /usr/local/bin/rtl_hpsdr
cd ~
rm -rf rtl-sdr
rm -rf librtlsdr
rm -rf SoapyRTLSDR
}

getcubicsdr(){
#install CubicSDR and dependencies
echo "\n\n...Getting CubicSDR and dependencies"
#get liquid-dsp
echo "\n...liquid-dsp..."
cd ~
git clone https://github.com/jgaeddert/liquid-dsp
cd liquid-dsp
./bootstrap.sh
./configure
make
make install
ldconfig

#get SoapySDR
echo "\n\n...SoapySDR..."
cd ~
git clone https://github.com/pothosware/SoapySDR
mkdir SoapySDR/build
cd SoapySDR/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get basic rtlsdr firmware and soapy module
getrtlsdr

#get CubicSDR
echo "\n\n...CubicSDR..."
cd ~
git clone https://github.com/cjcliffe/CubicSDR
mkdir CubicSDR/build
cd CubicSDR/build
cmake ../
make

#move it to /opt
#mkdir /opt/CubicSDR
cp -ar ~/CubicSDR/build/x64/* /opt/CubicSDR
cd ~
rm -rf liquid-dsp
rm -rf SoapySDR
rm -rf CubicSDR
}

getcudasdr(){
echo "\n\n...cudaSDR..."
cd ~
git clone https://github.com/n1gp/cudaSDR
cd cudaSDR/Source
qmake cudaSDR.pro
make
cp ~/cudaSDR/Source/bin/cudaSDR /usr/local/bin/cudaSDR
cp ~/cudaSDR/Source/bin/settings.ini /usr/local/bin/settings.ini
cd ~
rm -rf cudaSDR
}

getdump1090(){
echo "\n\n...dump1090 for rtl-sdr devices..."
cd ~
#git clone https://github.com/mutability/dump1090
git clone https://github.com/MalcolmRobb/dump1090
cd dump1090
make
mkdir /usr/local/sbin/dump1090
cp -ar ~/dump1090/public_html /usr/local/sbin/dump1090/public_html
cp ~/dump1090/testfiles /usr/local/sbin/dump1090/testfiles
cp ~/dump1090/tools /usr/local/sbin/dump1090/tools
cp ~/dump1090/dump1090 /usr/local/sbin/dump1090/dump1090
cp ~/dump1090/view1090 /usr/local/sbin/dump1090/view1090
cp ~/dump1090/LICENSE /usr/local/sbin/dump1090/LICENSE
cp ~/dump1090/README.md /usr/local/sbin/dump1090/README.md
cp ~/dump1090/README-dump1090.md /usr/local/sbin/dump1090/README-dump1090.md
cp ~/dump1090/README-json.md /usr/local/sbin/dump1090/README-json.md
rm -rf dump1090

#get dump1090 with advanced device support
echo "\n\n...dump1090 for advanced devices..."
cd ~
git clone https://github.com/itemir/dump1090_sdrplus
cd dump1090_sdrplus
make
mkdir /usr/local/sbin/dump1090_sdrplus
cp -ar ~/dump1090_sdrplus/public_html /usr/local/sbin/dump1090_sdrplus/public_html
cp ~/dump1090_sdrplus/testfiles /usr/local/sbin/dump1090_sdrplus/testfiles
cp ~/dump1090_sdrplus/tools /usr/local/sbin/dump1090_sdrplus/tools
cp ~/dump1090_sdrplus/dump1090 /usr/local/sbin/dump1090_sdrplus/dump1090
cp ~/dump1090_sdrplus/view1090 /usr/local/sbin/dump1090_sdrplus/view1090
cp ~/dump1090_sdrplus/LICENSE /usr/local/sbin/dump1090_sdrplus/LICENSE
cp ~/dump1090_sdrplus/README.md /usr/local/sbin/dump1090_sdrplus/README.md
cp ~/dump1090_sdrplus/README-dump1090.md /usr/local/sbin/dump1090_sdrplus/README-dump1090.md
cp ~/dump1090_sdrplus/README-json.md /usr/local/sbin/dump1090_sdrplus/README-json.md
rm -rf dump1090_sdrplus
}

getsdrangel(){
#install sdrangel
cd ~
#prerequisite packages: libboost-all-dev liblz4-dev libnanomsg.dev
git clone https://github.com/f4exb/sdrangel
mkdir sdrangel/build
cd sdrangel/build
cmake ../
make
make install
ldconfig
}

getcrypto(){
#lantern
echo "\n\n...getting Lantern..."
wget "https://s3.amazonaws.com/lantern/lantern-installer-beta-64-bit.deb"
dpkg -i lantern-installer-beta-64-bit.deb

#replace the .desktop file
echo "\n creating the desktop file..."
echo '[Desktop Entry]
Type=Application
Name=Lantern
Exec=sh -c "lantern -addr 127.0.0.1:8080"
Icon=lantern
Comment=Censorship circumvention application for unblocked web browsing.
Categories=Network;Internet;Networking;Privacy;Proxy;' > /usr/share/applications/lantern.desktop

echo "\n\n...cleaning up a bit..."

#update cjdns
echo "\n\...updating cjdns..."
sh -c "/etc/init.d/cjdns update"
}

ans=$(zenity  --list --height 270 --width 420 --text "SDR Software Updater" --radiolist  --column "Pick" --column "Action" \
TRUE "Exit (Do Nothing)" FALSE "Update QtRadio" FALSE "Update CubicSDR" FALSE "Update CudaSDR"  FALSE "Update OpenwebRX" \
FALSE "Update SDRangel" FALSE "Update Dump1090" FALSE "Update HackRF Drivers" FALSE "Update SDRPlay Drivers" \
FALSE "Update RTL-SDR Drivers" FALSE "Update Mesh Networking & Crypto");

	if [  "$ans" = "Exit (Do Nothing)" ]; then
		exit

	elif [  "$ans" = "Update QtRadio" ]; then
		getqtradio

	elif [  "$ans" = "Update CubicSDR" ]; then
		getcubicsdr

	elif [  "$ans" = "Update CudaSDR" ]; then
		getcudasdr

	elif [  "$ans" = "Update Dump1090" ]; then
		getdump1090

	elif [  "$ans" = "Update OpenwebRX" ]; then
		getopenwebrx

	elif [  "$ans" = "Update SDRangel" ]; then
		getsdrangel

	elif [  "$ans" = "Update HackRF Drivers" ]; then
		gethackrf

	elif [  "$ans" = "Update SDRPlay Drivers" ]; then
		getsdrplay

	elif [  "$ans" = "Update RTL-SDR Drivers" ]; then
		getrtlsdr

	elif [  "$ans" = "Update Mesh Networking & Crypto" ]; then
		getcrypto

	fi

echo "\n\nScript Execution Completed!"
