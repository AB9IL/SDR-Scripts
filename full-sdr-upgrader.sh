#! /bin/sh

# full-sdr-upgrader for Skywave Linux, version 0.9
# Copyright (c) 2018 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
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
#cd /usr/local/src
#chmod 755 SDRplay_RSP_API-Linux-2.13.1.run
#./SDRplay_RSP_API-Linux-2.13.1.run
#rm -f SDRplay_RSP_API-Linux-2.13.1.run

#open source sdrplay driver from f4exb
#cd /usr/local/src
#git clone https://github.com/f4exb/libmirisdr-4
#mkdir libmirisdr-4/build
#cd libmirisdr-4/build
#cmake ../
#make
#make install
#ldconfig
#cd /usr/local/src 
#rm -rf libmirisdr-4

#SDRplay support in OpenWebRX
echo "\n\n...openwebrx dependencies for sdrplay (SDRPlayPorts)"
cd /usr/local/src
git clone https://github.com/krippendorf/SDRPlayPorts
mkdir SDRPlayPorts/build
cd SDRPlayPorts/build
cmake ..
make
make install
ldconfig
cd /usr/local/src
rm -rf SDRPlayPorts
}

getrtlsdr(){
#install rtl-sdr drivers
echo "\n\n...rtl-sdr firmware..."
cd /usr/local/src
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
}

getsoapy(){
#get the SoapyAudio support module
echo "\n\n...soapy audio"
cd /usr/local/src
git clone https://github.com/pothosware/SoapyAudio
mkdir SoapyAudio/build
cd SoapyAudio/build
cmake ..
make
make install
ldconfig
cd /usr/local/src
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
cd /usr/local/src
git clone https://github.com/pothosware/SoapySDRPlay
mkdir SoapySDRPlay/build
cd SoapySDRPlay/build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
make install
ldconfig
cd /usr/local/src
rm -rf SoapySDRPlay

#install rx_tools
echo "\n\n...rx_tools..."
cd /usr/local/src
git clone https://github.com/rxseger/rx_tools
#git clone https://github.com/darkstar007/rx_tools
mkdir rx_tools/build
cd rx_tools/build
cmake ..
make
make install
ldconfig
}

#getqtradio(){
#get qtradio
#echo "\n\n...QtRadio..."
#cd /usr/local/src
#git clone https://github.com/alexlee188/ghpsdr3-alex
#cd ghpsdr3-alex
#sh cleanup.sh
#git checkout master
#autoreconf -i
#./configure
#make -j4 all
#make install
#cd /usr/local/src
#rm -rf ghpsdr3-alex

#Create a better launcher
#echo '[Desktop Entry]
#Type=Application
#Name=QtRadio
#Name[xx]=QtRadio
#Generic Name=SDR GUI
#Exec=QtRadio
#Icon=QtRadio
#Terminal=False
#Categories=;HamRadio;' > /usr/local/share/applications/QtRadio.desktop
#}

#getopenwebrx(){
#install OpenwebRX and dependencies
#echo "\n\nGetting the csdr dsp library..."
# get the csdr dsp library
#cd /usr/local/src
#git clone https://github.com/simonyiszk/csdr
#cd csdr
#make
#make install
#ldconfig
#cd /usr/local/src
#rm -rf csdr

#echo "\n\n\nGetting Openwebrx..."
# get openwebrx
#cd /usr/local/src
#git clone https://github.com/simonyiszk/openwebrx
#git clone https://github.com/jketterl/openwebrx
# nothing to make
# move the files
#cp -ar /usr/local/src/openwebrx /usr/local/sbin/openwebrx

# get openwebrx connectors
#cd /usr/local/src
#git clone https://github.com/jketterl/owrx_connector
#mkdir owrx_connector/build
#cd owrx_connector/build
#cmake ..
#make
#make install
#}

getcubicsdr(){
#install CubicSDR and dependencies
cd /usr/local/src 
wget "https://github.com/cjcliffe/CubicSDR/releases/download/0.2.3/CubicSDR-0.2.3-x86_64.AppImage"
chmod +x CubicSDR-0.2.3-x86_64.AppImage
mv /usr/local/src/CubicSDR-0.2.3-x86_64.AppImage /usr/local/sbin/CubicSDR/CubicSDR.AppImage
}

getlinhpsdr(){
# get linhpsdr
echo "\n\n...linhpsdr..."
#install dependencies
cd /usr/local/src
#apt update
apt install libfftw3-dev libpulse-dev libsoundio-dev libgtk-3-dev libsoapysdr-dev libfftw3-3

#get wdsp
git clone https://github.com/g0orx/wdsp
cd wdsp
make
make install
cd /usr/local/src

#get linhpsdr
echo "\n\n...linhpsdr..."
cd /usr/local/src
git clone https://github.com/g0orx/linhpsdr
cd linhpsdr
sed -i "s/#SOAPYSDR_INCLUDE=SOAPYSDR/SOAPYSDR_INCLUDE=SOAPYSDR/g" Makefile
make
# to directly install the compiled version:
make install
# to install the deb:
#cd pkg
#dpkg -i linhpsdr.deb

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
cd /usr/local/src
rm -rf linhpsdr
}

getremotesdrclient(){
#get RemoteSdrClient-NS (for RFSpace hardware)
cd /usr/local/src
git clone https://github.com/csete/remotesdrclient-ns
cd remotesdrclient-ns
make
#manually copy the binary to /usr/local/bin
cp /usr/local/src/remotesdrclient-ns/remotesdrclient-ns /usr/local/bin/remotesdrclient-ns
#manually copy the icon to /usr/share/pixmaps
cp /usr/local/src/remotesdrclient-ns/RemoteSdrClient.png /usr/share/pixmaps/RemoteSdrClient.png
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
cd /usr/local/src
git clone https://github.com/szpajder/RTLSDR-Airband
cd RTLSDR-Airband
git checkout master
make PLATFORM=x86 PULSE=1 NFM=1 WITH_SOAPYSDR=1
make install

#get libacars
cd /usr/local/src
git clone https://github.com/szpajder/libacars
mkdir libacars/build
cd libacars/build
cmake ../
make
make install
ldconfig

#get acarsdec
cd /usr/local/src
#git clone https://github.com/AB9IL/acarsdec
git clone https://github.com/szpajder/acarsdec
mkdir acarsdec/build
cd acarsdec/build
cmake ../ -Drtl=ON
make make install

#get vdlm2dec
cd /usr/local/src
git clone https://github.com/TLeconte/vdlm2dec
mkdir vdlm2dec/build
cd vdlm2dec/build
cmake .. -Drtl=ON
make
make install

#get acarsserv
cd /usr/local/src
git clone https://github.com/TLeconte/acarsserv
cd acarsserv
make -f makefile
cp acarsserv /usr/local/sbin/acarsserv

#get dumpvdl2
cd /usr/local/src
#git clone https://github.com/szpajder/dumpvdl2
#mkdir dumpvdl2/build
#cd dumpvdl2/build
#cmake ../
#make
#make install
#ldconfig
}

getdump1090(){
echo "\n\n...dump1090 for rtl-sdr devices..."
cd /usr/local/src
#git clone https://github.com/mutability/dump1090
#git clone https://github.com/MalcolmRobb/dump1090
git clone https://github.com/Mictronics/dump1090
cd dump1090
make
cp dump1090 /usr/local/bin/dump1090
cp view1090 /usr/local/bin/view1090

#create dump1090 menu entry via .desktop file
echo '[Desktop Entry]
Name=Dump1090
GenericName=Dump1090
Comment=Mode S SDR (software defined radio).
Exec=/usr/local/sbin/dump1090.sh
Icon=/usr/share/pixmaps/dump1090.png
Terminal=false
Type=Application
Categories=Network;HamRadio;ADSB;Radio;' > /usr/share/applications/dump1090.desktop
echo "\n\n...completed update for dump1090 for rtl-sdr devices..."
}

#getr820tweak(){
#echo "\n\n...getting r820tweak..."
#cd /usr/local/src
#git clone https://github.com/gat3way/r820tweak
#cd r820tweak
#make
#make install
#cd ~
#rm -rf r820tweak
#ldconfig
}

getwx_sats(){
# Install noaa-apt v 1.2.0
# https://github.com/martinber/noaa-apt
# Go get it and manually install it.

# For Meteor satellite lrpt signals, install glrpt
apt install libturbojpeg libturbojpeg0-dev
git clone https://github.com/dvdesolve/glrpt
mkdir glrpt/build
cd glrpt/build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
make install
}

getsdrtrunk(){
#sdrtrunk
echo "\n\n...SDRTrunk..."
cd /usr/local/src
wget "https://github.com/DSheirer/sdrtrunk/releases/download/v0.4.0-alpha.9/sdr-trunk-0.4.0-alpha.9-linux-x64.zip"
mv sdr-trunk-all-0.3.3-beta.3.jar /usr/local/sbin/sdrtrunk.jar
}

getwsjtx(){
#get WSJT-X
echo "\n\n...WSJT-X..."
cd /usr/local/src
wget "http://physics.princeton.edu/pulsar/k1jt/wsjtx_1.8.0_amd64.deb"
dpkg -i wsjtx_1.8.0_amd64.deb
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
cd /usr/local/src
rm -rf rtaudio
}

getcrypto(){
#lantern
echo "\n\n...getting Lantern..."
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

echo "\n\n...cleaning up a bit..."

# get psiphon
#get the crude but fast Psiphon client
echo "\n\nNext, Psiphon (PyClient)"
cd ~
git clone  https://github.com/Psiphon-Labs/psiphon-tunnel-core-binaries 
cp ~/psiphon-tunnel-core-binaries/linux/psiphon-tunnel-core-x86_64 /usr/local/sbin/psiphon/psiphon-tunnel-core-x86_64
echo '{
"LocalHttpProxyPort":8118,
"LocalSocksProxyPort":1081,
"PropagationChannelId":"FFFFFFFFFFFFFFFF",
"ClientPlatform":"Linux",
"EgressRegion":"SG",
"RemoteServerListDownloadFilename":"remote_server_list",
"RemoteServerListSignaturePublicKey":"MIICIDANBgkqhkiG9w0BAQEFAAOCAg0AMIICCAKCAgEAt7Ls+/39r+T6zNW7GiVpJfzq/xvL9SBH5rIFnk0RXYEYavax3WS6HOD35eTAqn8AniOwiH+DOkvgSKF2caqk/y1dfq47Pdymtwzp9ikpB1C5OfAysXzBiwVJlCdajBKvBZDerV1cMvRzCKvKwRmvDmHgphQQ7WfXIGbRbmmk6opMBh3roE42KcotLFtqp0RRwLtcBRNtCdsrVsjiI1Lqz/lH+T61sGjSjQ3CHMuZYSQJZo/KrvzgQXpkaCTdbObxHqb6/+i1qaVOfEsvjoiyzTxJADvSytVtcTjijhPEV6XskJVHE1Zgl+7rATr/pDQkw6DPCNBS1+Y6fy7GstZALQXwEDN/qhQI9kWkHijT8ns+i1vGg00Mk/6J75arLhqcodWsdeG/M/moWgqQAnlZAGVtJI1OgeF5fsPpXu4kctOfuZlGjVZXQNW34aOzm8r8S0eVZitPlbhcPiR4gT/aSMz/wd8lZlzZYsje/Jr8u/YtlwjjreZrGRmG8KMOzukV3lLmMppXFMvl4bxv6YFEmIuTsOhbLTwFgh7KYNjodLj/LsqRVfwz31PgWQFTEPICV7GCvgVlPRxnofqKSjgTWI4mxDhBpVcATvaoBl1L/6WLbFvBsoAUBItWwctO2xalKxF5szhGm8lccoc5MZr8kfE0uxMgsxz4er68iCID+rsCAQM=",
"RemoteServerListUrl":"https://s3.amazonaws.com//psiphon/web/mjr4-p23r-puwl/server_list_compressed",
"SponsorId":"FFFFFFFFFFFFFFFF",
"UseIndistinguishableTLS":true
}
' > /usr/local/sbin/psiphon/psiphon.config

#create the launcher file
echo "\n\nCreating the launcher..."
echo '[Desktop Entry]
Comment=Psiphon Circumvention (vpn / proxy) controller for uncensored internet.
Exec=gnome-terminal -e "/usr/local/sbin/psiphon-controller.sh"
Name=Psiphon Controller
GenericName[en_US]=Psiphon censorship circumvention controller.
Categories=Network;Internet;Networking;Privacy;psiphon;VPN;proxy;
Icon=/usr/share/pixmaps/psiphon.png
NoDisplay=false
StartupNotify=false
Terminal=0
TerminalOptions=
Type=Application
GenericName[en_US.UTF-8]=Privacy, Cryptography, Circumvention Tools, Psiphon;' > /usr/share/applications/psiphon-controller.desktop
}

#run volk_profile to optimise for certain sdr apps
echo "\n\nRunning volk_profile to optimise certain SDR applications"
volk_profile

#blacklist certain kernel drivers
echo "blacklist dvb_usb_rtl28xxu
blacklist e4000
blacklist rtl2832
blacklist rtl2830
blacklist rtl2838
blacklist msi001
blacklist msi2500
blacklist sdr_msi3101" > /etc/modprobe.d/rtl-sdr-blacklist.conf

echo "\n\n BEGINNING FULL SDR UPDATE"
# Apt update, upgrade, drivers, user interfaces.
aptupgrade
getsdrplay
getrtlsdr
getsoapy
getr820tweak
rtlsdrairband
getdump1090
getwx_sats
getsdrtrunk
getwsjtx
getcrypto
getrtaudio
getremotesdrclient
getopenwebrx
getcubicsdr
getlinhpsdr

echo "\n\nScript Execution Completed!"
