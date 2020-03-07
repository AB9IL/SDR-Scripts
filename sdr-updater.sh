#!/bin/bash

# sdr-updater for Skywave Linux, version 0.9
# Copyright (c) 2019 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# SDR Updater is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Encoding=UTF-8

aptupgrade(){
apt update
apt -y upgrade
echo "\n\nFinished installing software from the repositories."
}

getsdrplay(){
#get the sdrplay linux api installer manually
#from http://sdrplay.com/linuxdl.php
#then enable and run it:
#echo "\n\n...SDRplay MiricsAPI..."
#echo "\nGet it manually from http://sdrplay.com/"
#echo "\nRobots are people too."
#cd ~
#chmod 755 SDRplay_RSP_API-Linux-2.13.1.run
#./SDRplay_RSP_API-Linux-2.13.1.run
#rm -f SDRplay_RSP_API-Linux-2.13.1.run

#open source sdrplay driver from f4exb
#cd ~
#git clone https://github.com/f4exb/libmirisdr-4
#mkdir libmirisdr-4/build
#cd libmirisdr-4/build
#cmake ../
#make
#make install
#ldconfig
#cd ~
#rm -rf libmirisdr-4

#SDRplay support in OpenWebRX
echo "\n\n...openwebrx dependencies for sdrplay (SDRPlayPorts)"
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
#git clone https://git.osmocom.org/rtl-sdr
#git clone https://github.com/steve-m/librtlsdr
#git clone https://github.com/mutability/rtl-sdr
#git clone https://github.com/thaolia/librtlsdr-thaolia
#mv librtlsdr-thaolia rtl-sdr
git clone https://github.com/AB9IL/rtl-sdr
mkdir rtl-sdr/build
cd rtl-sdr/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
make install
ldconfig
rm -rf rtl-sdr
}

getsoapy(){
#get the SoapyAudio support module
echo "\n\n...soapy audio"
cd ~
git clone https://github.com/pothosware/SoapyAudio
mkdir SoapyAudio/build
cd SoapyAudio/build
cmake ..
make
make install
ldconfig
cd ~
rm -rf SoapyAudio

#get SoapyPlutoSDR support module
echo "\n\n...SoapyPlutoSDR"
cd ~
git clone https://github.com/jocover/SoapyPlutoSDR
mkdir SoapyPlutoSDR/build
cd SoapyPlutoSDR/build
cmake ..
make
sudo make install
ldconfig

#get the SoapySDRPlay support module for CubicSDR
echo "\n\n...SoapySDRPlay..."
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

#install rx_tools
echo "\n\n...rx_tools..."
cd ~
git clone https://github.com/rxseger/rx_tools
#git clone https://github.com/darkstar007/rx_tools
mkdir rx_tools/build
cd rx_tools/build
cmake ..
make
make install
ldconfig
}

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

#Create a better launcher
echo '[Desktop Entry]
Type=Application
Name=QtRadio
Name[xx]=QtRadio
Generic Name=SDR GUI
Exec=QtRadio
Icon=QtRadio
Terminal=False
Categories=Radio;HamRadio;' > /usr/local/share/applications/QtRadio.desktop
}

getlinhpsdr(){
# get linhpsdr
echo "\n\n...linhpsdr..."
cd ~
git clone https://github.com/g0orx/linhpsdr
cd linhpsdr
sed -i "s/#SOAPYSDR_INCLUDE=SOAPYSDR/SOAPYSDR_INCLUDE=SOAPYSDR/g" Makefile
make
cd pkg
dpkg -i linhpsdr.deb

#create the launcher file
echo "\n\n creating the .desktop file..."
echo '[Desktop Entry]
Version=0.1
Type=Application
Terminal=false
Name=linHPSDR
Name[eb_GB]=linHPSDR
Exec=linhpsdr
Icon=/usr/share/linhpsdr/hpsdr_small.png
Categories=Radio;HamRadio;' > /usr/share/applications/linhpsdr.desktop
cd ~
rm -rf linhpsdr
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

echo "\n\n...Openwebrx..."
# get openwebrx
cd ~
#git clone https://github.com/simonyiszk/openwebrx
git clone https://github.com/jketterl/openwebrx
# nothing to make
# move the files
cp -ar ~/openwebrx /usr/local/sbin/openwebrx

# get openwebrx connectors 
cd ~
git clone https://github.com/jketterl/owrx_connector
mkdir owrx_connector/build
cd owrx_connector/build
cmake ..
make
make install
}

getcubicsdr(){
#install CubicSDR and dependencies
cd ~
wget "https://github.com/cjcliffe/CubicSDR/releases/download/0.2.3/CubicSDR-0.2.3-x86_64.AppImage"
chmod +x CubicSDR-0.2.3-x86_64.AppImage
mv ~/CubicSDR-0.2.3-x86_64.AppImage /usr/local/sbin/CubicSDR/CubicSDR.AppImage
}

getremotesdrclient(){
#get RemoteSdrClient-NS (for RFSpace hardware)
cd ~
git clone https://github.com/csete/remotesdrclient-ns
cd remotesdrclient-ns
make
#manually copy the binary to /usr/local/bin
cp ~/remotesdrclient-ns/remotesdrclient-ns /usr/local/bin/remotesdrclient-ns
#manually copy the icon to /usr/share/pixmaps
cp ~/remotesdrclient-ns/RemoteSdrClient.png /usr/share/pixmaps/RemoteSdrClient.png
#create menu entry via .desktop file
echo '[Desktop Entry]
Name=RemoteSdrClient
GenericName=RemoteSdrClient
Comment=Remote Client for RFSpace SDRs
Exec=/usr/local/bin/remotesdrclient-ns
Icon=RemoteSdrClient.png
Terminal=false
Type=Application
Categories=Radio;HamRadio;' > /usr/share/applications/remotesdrclient.desktop
}

rtlsdrairband(){
#get rtlsdr-airband
cd ~
git clone https://github.com/szpajder/RTLSDR-Airband
cd RTLSDR-Airband
PLATFORM=x86 NFM=1 make
make install

#get libacars
cd ~
git clone https://github.com/szpajder/libacars
mkdir libacars/build
cd libacars/build
cmake ../
make
make install
ldconfig

#get acarsdec
cd ~
#git clone https://github.com/AB9IL/acarsdec
git clone https://github.com/szpajder/acarsdec
mkdir acarsdec/build
cd acarsdec/build
cmake ../ -Drtl=ON
make make install

#get acarsserv
cd ~
git clone https://github.com/TLeconte/acarsserv
cd acarsserv
make -f makefile
cp acarsserv /usr/local/sbin/acarsserv

#get dumpvdl2
cd ~
git clone https://github.com/szpajder/dumpvdl2
mkdir dumpvdl2/build
cd dumpvdl2/build
cmake ../
make
make install
ldconfig

cd ~
rm -rf acarsdec
rm -rf acarsserv
rm -rf dumpvdl2
rm -rf libacars
}

getdump1090(){
echo "\n\n...dump1090..."
cd ~
#git clone https://github.com/mutability/dump1090
#git clone https://github.com/MalcolmRobb/dump1090
git clone https://github.com/Mictronics/dump1090
cd dump1090
make
cp dump1090 /usr/local/bin/dump1090
cp view1090 /usr/local/bin/view1090
cd ~
rm -rf dump1090
echo "\n\n...completed update for dump1090..."
}

getr820tweak(){
echo "\n\n...getting r820tweak..."
cd ~
git clone https://github.com/gat3way/r820tweak
cd r820tweak
make
make install
cd ~
rm -rf r820tweak
ldconfig
}

getsdrtrunk(){
#sdrtrunk
echo "\n\n...SDRTrunk..."
cd ~
wget "https://github.com/DSheirer/sdrtrunk/releases/download/v0.3.3-beta.3/sdr-trunk-all-0.3.3-beta.3.jar"
mv sdr-trunk-all-0.3.3-beta.3.jar /usr/local/sbin/sdrtrunk.jar
}

getwsjtx(){
#get WSJT-X
echo "\n\n...WSJT-X..."
apt install --reinstall wsjtx
}

getrtaudio(){
#get rtaudio
echo "\n\n...rtaudio"
cd ~
git clone https://github.com/thestk/rtaudio
mkdir rtaudio/build
cd rtaudio/build
cmake .. -DAUDIO_LINUX_PULSE=ON
cd rtaudio
./autogen.sh --with-pulse
make
make install
ldconfig
cd ~
rm -rf rtaudio
}

getcrypto(){
#lantern
echo "\n\n...getting Lantern..."
cd ~
wget "https://s3.amazonaws.com/lantern/lantern-installer-beta-64-bit.deb"
dpkg -i lantern-installer-beta-64-bit.deb

#replace the .desktop file
echo '[Desktop Entry]
Type=Application
Name=Lantern
Exec=sh -c "lantern -addr 127.0.0.1:8118"
Icon=lantern
Comment=Censorship circumvention (proxy / vpn) application for unblocked web browsing.
Categories=Network;Internet;Networking;Privacy;Proxy;VPN;' > /usr/share/applications/lantern.desktop

#update cjdns
echo "\n\n...updating cjdns..."
sh -c "/etc/init.d/cjdns update"

# get psiphon
echo "\n\n...updating psiphon..."
cd ~
mkdir ~/go
export GOROOT=/usr/lib/go-1.11/bin # point to the directory copntaining the go binary
export GOPATH=~/go # point to where source will be compiled
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH  # allow access from within the system
cd ~/go

# download the source code
# git clone https://github.com/Psiphon-Labs/psiphon-tunnel-core

cd ~/go/psiphon-tunnel-core/ConsoleClient

sed -i "14s/.*/BUILDDATE=$(date +%Y-%m-%dT%H:%M:%S%z)/" make.bash

./make.bash linux

# Create a config file
# See config options at https://github.com/Psiphon-Labs/psiphon-tunnel-core/blob/master/psiphon/config.go

echo '{
"LocalHttpProxyPort":8118,
"LocalSocksProxyPort":1081,
"PropagationChannelId":"FFFFFFFFFFFFFFFF",
"ClientPlatform":"Linux",
"EgressRegion":"",
"RemoteServerListDownloadFilename":"remote_server_list",
"RemoteServerListSignaturePublicKey":"MIICIDANBgkqhkiG9w0BAQEFAAOCAg0AMIICCAKCAgEAt7Ls+/39r+T6zNW7GiVpJfzq/xvL9SBH5rIFnk0RXYEYavax3WS6HOD35eTAqn8AniOwiH+DOkvgSKF2caqk/y1dfq47Pdymtwzp9ikpB1C5OfAysXzBiwVJlCdajBKvBZDerV1cMvRzCKvKwRmvDmHgphQQ7WfXIGbRbmmk6opMBh3roE42KcotLFtqp0RRwLtcBRNtCdsrVsjiI1Lqz/lH+T61sGjSjQ3CHMuZYSQJZo/KrvzgQXpkaCTdbObxHqb6/+i1qaVOfEsvjoiyzTxJADvSytVtcTjijhPEV6XskJVHE1Zgl+7rATr/pDQkw6DPCNBS1+Y6fy7GstZALQXwEDN/qhQI9kWkHijT8ns+i1vGg00Mk/6J75arLhqcodWsdeG/M/moWgqQAnlZAGVtJI1OgeF5fsPpXu4kctOfuZlGjVZXQNW34aOzm8r8S0eVZitPlbhcPiR4gT/aSMz/wd8lZlzZYsje/Jr8u/YtlwjjreZrGRmG8KMOzukV3lLmMppXFMvl4bxv6YFEmIuTsOhbLTwFgh7KYNjodLj/LsqRVfwz31PgWQFTEPICV7GCvgVlPRxnofqKSjgTWI4mxDhBpVcATvaoBl1L/6WLbFvBsoAUBItWwctO2xalKxF5szhGm8lccoc5MZr8kfE0uxMgsxz4er68iCID+rsCAQM=",
"RemoteServerListUrl":"https://s3.amazonaws.com//psiphon/web/mjr4-p23r-puwl/server_list_compressed",
"SponsorId":"FFFFFFFFFFFFFFFF",
"UseIndistinguishableTLS":true
}' > psiphon.config

cp psiphon-tunnel-core-i686 /usr/local/sbin/psiphon/psiphon-tunnel-core-i686
cp psiphon.config /usr/local/sbin/psiphon/psiphon.config
}

ans=$(zenity  --list --height 470 --width 420 --text "SDR Software Updater" \
--radiolist  --column "Pick" --column "Action" \
TRUE "Upgrade Base System and Drivers with Apt" FALSE "Update QtRadio" \
FALSE "Update CubicSDR" FALSE "Update LinHPSDR" FALSE "Update RemoteSdrClient" \
FALSE "Update OpenwebRX" FALSE "Update R820tweak" FALSE "Update SoapySDR Drivers" \
FALSE "Update Dump1090" FALSE "Update SDRPlay Drivers" FALSE "Update RTL-SDR" \
FALSE "Update RTLSDR-Airband" FALSE "Update SDRTrunk" FALSE "Update WSJT-X" \
FALSE "Update Rtaudio" FALSE "Update Mesh Networking & Crypto");

	if [  "$ans" = "Upgrade Base System and Drivers with Apt" ]; then
		aptupgrade

	elif [  "$ans" = "Update QtRadio" ]; then
		getqtradio

	elif [  "$ans" = "Update CubicSDR" ]; then
		getcubicsdr

	elif [  "$ans" = "Update LinHPSDR" ]; then
		getlinhpsdr

	elif [  "$ans" = "Update RemoteSdrClient" ]; then
		getremotesdrclient

	elif [  "$ans" = "Update Dump1090" ]; then
		getdump1090

	elif [  "$ans" = "Update OpenwebRX" ]; then
		getopenwebrx

	elif [  "$ans" = "Update R820tweak" ]; then
		getr820tweak

	elif [  "$ans" = "Update SoapySDR Drivers" ]; then
		getsoapy

	elif [  "$ans" = "Update SDRPlay Drivers" ]; then
		getsdrplay

	elif [  "$ans" = "Update RTL-SDR Drivers" ]; then
		getrtlsdr

	elif [  "$ans" = "Update RTLSDR-Airband" ]; then
		rtlsdrairband

	elif [  "$ans" = "Update SDRTrunk" ]; then
		getsdrtrunk

	elif [  "$ans" = "Update WSJT-X" ]; then
		getwsjtx

	elif [  "$ans" = "Update Rtaudio" ]; then
		getrtaudio

	elif [  "$ans" = "Update Mesh Networking & Crypto" ]; then
		getcrypto

	fi

echo "\n\nScript Execution Completed!"
read -p "\n\nPress any key to continue..."
