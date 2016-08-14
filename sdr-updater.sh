#! /bin/sh

# sdr-updater (SDR Updater), version 0.1
# Copyright (c) 2016 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# SDR Updater is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Encoding=UTF-8

getqtradio(){
#get qtradio
echo "\nGetting code for QtRadio..."
cd ~
git clone git://github.com/alexlee188/ghpsdr3-alex.git
cd ghpsdr3-alex
make distclean
sh cleanup.sh
git checkout master
autoreconf -i
./configure
make -j4 all
make install
cd ~
rm -rfv ghpsdr3-alex
getrtlsdr
}

getopenwebrx(){
echo "\nGetting the csdr dsp library..."
# get the csdr dsp library
cd ~
git clone https://github.com/simonyiszk/csdr
cd csdr
make
make install
ldconfig
cd ~
rm -rfv csdr
echo "\nGetting Openwebrx..."
# get openwebrx
cd ~
git clone https://github.com/simonyiszk/openwebrx
# nothing to make
# move the files
mv -ar ~/openwebrx /usr/local/sbin/openwebrx

gethackrf
getairspy
getsdrplay
getrtlsdr
}

getairspy(){
echo "\nGetting support for airspy..."
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
rm -rfv host
}

getsdrplay(){
#get the sdrplay linux api installer manually
#from http://sdrplay.com/linuxdl.php
#then enable and run it:
echo "\nnext, SDRplay MiricsAPI"
echo "\nGet it manually from http://sdrplay.com/linuxdl.php"
cd ~
chmod 755 SDRplay_RSP_MiricsAPI-Linux-1.95.3.run
./SDRplay_RSP_MiricsAPI-Linux-1.95.3.run
rm -f SDRplay_RSP_MiricsAPI-Linux-1.95.3.run

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
echo "\nnext, gr-osmosdr (gnuradio dependencies for sdrplay forked by hb9fxq)"
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

echo "\nGetting openwebrx dependencies for sdrplay (SDRPlayPorts)"
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

gethackrf(){
#install hackrf support
echo "\nnext, mossmann's driver for hackrf"
cd ~
git clone https://github.com/mossmann/hackrf
mkdir hackrf/host/build
cd hackrf/host/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig
cd ~
rm -rf hackrf
}

getrtlsdr(){
#install rtl-sdr drivers
echo "\nnext, rtl-sdr firmware..."
cd ~
git clone git://git.osmocom.org/rtl-sdr.git
cd rtl-sdr
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig

#install rtl_hpsdr
#build librtlsdr, but only keep rtl_hpsdr
echo "\nnext, rtl_hpsdr..."
cd ~
git clone git://github.com/n1gp/librtlsdr
cd librtlsdr
mkdir build
cd build
cmake ..
make
cp ~/librtlsdr/build/src/rtl_hpsdr /usr/local/bin/rtl_hpsdr
cd ~
rm -rf rtl-sdr
rm -rf librtlsdr
}

getcubicsdr(){
#install CubicSDR and dependencies
echo "\n\nGetting CubicSDR and dependencies"
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
echo "\n...SoapySDR..."
cd ~
git clone https://github.com/pothosware/SoapySDR
mkdir SoapySDR/build
cd SoapySDR/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get basic rtlsdr firmware
getrtlsdr

#get the SoapyRTLSDR support module
echo "\n...SoapyRTLSDR..."
cd ~
git clone https://github.com/pothosware/SoapyRTLSDR
mkdir SoapyRTLSDR/build
cd SoapyRTLSDR/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig

#get CubicSDR
echo "\nLast, but not least, CubicSDR..."
cd ~
git clone https://github.com/cjcliffe/CubicSDR
mkdir CubicSDR/build
cd CubicSDR/build
cmake ../
make

#move it to /opt
#mkdir /opt/CubicSDR
cp -ar ~/CubicSDR/build/x64 /opt/CubicSDR
cd ~
rm -rf liquid-dsp
rm -rf SoapySDR
rm -rf SoapyRTLSDR
rm -rf CubicSDR
}


ans=$(zenity  --list --height 270 --width 420 --text "SDR Software Updater" --radiolist  --column "Pick" --column "Action" \
TRUE "Exit (Do Nothing)" FALSE "Update QtRadio" FALSE "Update CubicSDR" FALSE "Update OpenwebRX" \
FALSE "Update HackRF Drivers" FALSE "Update SDRPlay Drivers" FALSE "Update RTL-SDR Drivers");

	if [  "$ans" = "Exit (Do Nothing)" ]; then
		exit

	elif [  "$ans" = "Update QtRadio" ]; then
		getqtradio

	elif [  "$ans" = "Update CubicSDR" ]; then
		getcubicsdr

	elif [  "$ans" = "Update OpenwebRX" ]; then
		getopenwebrx

	elif [  "$ans" = "Update HackRF Drivers" ]; then
		gethackrf

	elif [  "$ans" = "Update SDRPlay Drivers" ]; then
		getsdrplay

	elif [  "$ans" = "Update RTL-SDR Drivers" ]; then
		getrtlsdr

	fi

echo "\nnext, Script Execution Completed!"
