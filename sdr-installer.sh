#! /bin/sh

# Copyright (c) 2022 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# This script compiles and installs SDR drivers from source.
# To disable a specific installer, comment its reference in
# the function list near the bottom of this script.

# get the latest release from git repos
download_last(){
    cd $3
    wget "$(lastversion --pre $1 --format assets --filter $2)"
}
export -f download_last

get_sdrplay_api() {
#get the sdrplay linux api installer manually
#from https://www.sdrplay.com/dlfinishs/p
#then enable and run it:
printf "\n\n...SDRplay MiricsAPI..."
target_file="SDRplay_RSP_API-Linux-3.07.1.run"
#printf "\nGet it manually from https://www.sdrplay.com/dlfinishs/"
#printf "\nRobots are people too."
cd /usr/local/src
[[ -f "/usr/local/src/$target_file" ]] \
    && chmod 755 "$target_file" \
    && ./"$target_file"
}

get_libmirisdr_4() {
printf "\n\n...LibMiriSDR-4..."
cd /usr/local/src
[[ -f "/usr/local/src/libmirisdr-4" ]] \
    || git clone https://github.com/f4exb/libmirisdr-4 \
    && mkdir -p /usr/local/src/libmirisdr-4/build
cd /usr/local/src/libmirisdr-4/build
cmake ..
make -j4
make install
}

get_SoapySDR_core() {
printf "\n\n...SoapySDR..."
cd /usr/local/src
[[ -f "/usr/local/src/SoapySDR" ]] \
    || git clone https://github.com/pothosware/SoapySDR \
    && mkdir -p /usr/local/src/SoapySDR/build
cd /usr/local/src/SoapySDR/build
cmake ..
make -j4
make install
}

get_rtl_sdr_drivers() {
printf "\n\n...rtl-sdr firmware..."
cd /usr/local/src
[[ -f "/usr/local/src/librtlsdr" ]] \
    || git clone https://github.com/steve-m/librtlsdr \
    && mkdir -p /usr/local/src/librtlsdr/build
cd /usr/local/src/librtlsdr/build
cmake ../ -DINSTALL_UDEV_RULES=ON
make -j4
make install
}

get_gr_osmosdr() {
printf "\n\n...gr-osmosdr..."
cd /usr/local/src
[[ -f "/usr/local/src/gr-osmosdr" ]] \
    || git clone git://git.osmocom.org/gr-osmosdr \
    && mkdir -p /usr/local/src/gr-osmosdr/build
cd /usr/local/src/gr-osmosdr/build
cmake ..
make -j4
make install
}

get_SoapyRTLSDR() {
printf "\n\n...SoapyRTLSDR..."
cd /usr/local/src
[[ -f "/usr/local/src/SoapyRTLSDR" ]] \
    || git clone https://github.com/pothosware/SoapyRTLSDR \
    && mkdir -p /usr/local/src/SoapyRTLSDR/build
cd /usr/local/src/SoapyRTLSDR/build
cmake ..
make -j4
make install
}

get_SoapyPlutoSDR() {
printf "\n\n...ADALM-PlutoSDR"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyPlutoSDR" ]] \
    || git clone https://github.com/pothosware/SoapyPlutoSDR \
    && mkdir -p /usr/local/src/SoapyPlutoSDR/build
cd /usr/local/src/SoapyPlutoSDR/build
cmake ..
make -j4
make install
}

get_SoapyRedPitaya() {
printf "\n\n...SoapyRedPitaya"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyRedPitaya" ]] \
    || git clone https://github.com/pothosware/SoapyRedPitaya \
    && mkdir -p /usr/local/src/SoapyRedPitaya/build
cd /usr/local/src/SoapyRedPitaya/build
cmake ..
make -j4
make install
}

get_SoapySDRPlay3() {
printf "\n\n...SoapySDRPlay3..."
cd /usr/local/src
[[ -f "/usr/local/src/SoapySDRPlay3" ]] \
    || git clone https://github.com/pothosware/SoapySDRPlay3 \
    && mkdir -p /usr/local/src/SoapySDRPlay3/build
cd /usr/local/src/SoapySDRPlay3/build
cmake ..
make -j4
make install
}

get_Airspy() {
printf "\n\n...LibAirspy..."
cd /usr/local/src
[[ -f "/usr/local/src/airspyone_host-master" ]] \
    || mkdir -p /usr/local/src/airspyone_host-master/build
# get the archived source for linux
target_file="master.zip"
cd "/usr/local/src/airspyone_host-master"
wget https://github.com/airspy/airspyone_host/archive/master.zip
unzip master.zip
rm master.zip
cd "/usr/local/src/airspyone_host-master/build"
cmake ../ -DINSTALL_UDEV_RULES=ON
make -j4
make install
}

get_SoapyAirspy() {
printf "\n\n...SoapyAirspy..."
cd /usr/local/src
[[ -f "/usr/local/src/SoapyAirspy" ]] \
    || git clone https://github.com/pothosware/SoapyAirspy \
    && mkdir -p /usr/local/src/SoapyAirspy/build
cd /usr/local/src/SoapyAirspy/build
cmake ..
make -j4
make install
}

get_SoapyAirspyHF() {
printf "\n\n...SoapyAirspyHF..."
cd /usr/local/src
[[ -f "/usr/local/src/SoapyAirspyHF" ]] \
    || git clone https://github.com/pothosware/SoapyAirspyHF \
    && mkdir -p /usr/local/src/SoapyAirspyHF/build
cd /usr/local/src/SoapyAirspyHF/build
cmake ..
make -j4
make install
}

get_SoapyAudio() {
printf "\n\n...soapy audio"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyAudio" ]] \
    || git clone https://github.com/pothosware/SoapyAudio \
    && mkdir -p /usr/local/src/SoapyAudio/build
cd /usr/local/src/SoapyAudio/build
cmake ..
make -j4
make install
}

get_SoapyBladeRF() {
printf "\n\n...SoapyBladeRF"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyBladeRF" ]] \
    || git clone https://github.com/pothosware/SoapyBladeRF \
    && mkdir -p /usr/local/src/SoapyBladeRF/build
cd /usr/local/src/SoapyBladeRF/build
cmake ..
make -j4
make install
}

get_SoapyFCDPP() {
printf "\n\n...SoapyFCDPP"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyFCDPP" ]] \
    || git clone https://github.com/pothosware/SoapyFCDPP \
    && mkdir -p /usr/local/src/SoapyFCDPP/build
cd /usr/local/src/SoapyFCDPP/build
cmake ../
make -j4
make install
}

get_SoapyHackRF() {
printf "\n\n...SoapyHackRF"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyHackRF" ]] \
    || git clone https://github.com/pothosware/SoapyHackRF \
    && mkdir -p /usr/local/src/SoapyHackRF/build
cd /usr/local/src/SoapyHackRF/build
cmake ..
make -j4
make install
}

get_SoapyLMS7() {
printf "\n\n...SoapyLMS7"
cd /usr/local/src
[[ -f "/usr/local/src/LimeSuite" ]] \
    || git clone https://github.com/myriadrf/LimeSuite \
    && mkdir -p /usr/local/src/LimeSuite/build
cd /usr/local/src/LimeSuite/build
cmake ..
make -j4
make install
}

get_SoapyRadioberrySDR() {
printf "\n\n...SoapyRadioberrySDR"
cd /usr/local/src
[[ -f "/usr/local/src/SBC/rpi-4/SoapyRadioberrySDR" ]] \
    || git clone https://github.com/pa3gsb/Radioberry-2.x \
    && mkdir -p /usr/local/src/Radioberry-2.x/SBC/rpi-4/SoapyRadioberrySDR/build
cd /usr/local/src/Radioberry-2.x/SBC/rpi-4/SoapyRadioberrySDR/build
cmake ..
make -j4
make install
}

get_SoapyUHD() {
printf "\n\n...SoapyUHD"
cd /usr/local/src
[[ -f "/usr/local/src/SoapyUHD" ]] \
    || git clone https://github.com/pothosware/SoapyUHD \
    && mkdir -p /usr/local/src/SoapyUHD/build
cd /usr/local/src/SoapyUHD/build
cmake ..
make -j4
make install
}

get_gqrx() {
printf "\n\n...Gqrx"
cd /usr/local/src
[[ -f "/usr/local/src/gqrx" ]] \
    || git clone https://github.com/csete/gqrx \
    && mkdir -p /usr/local/src/gqrx/build
cd /usr/local/src/gqrx/build
cd build
cmake ..
make -j4
make install

#create the launcher file
printf "\n\n creating the .desktop file..."
printf '[Desktop Entry]
Type=Application
Name=Gqrx
GenericName=Software Defined Radio
Comment=Software defined radio receiver implemented using GNU Radio and the Qt GUI toolkit
# FIXME add comments in other languages
GenericName[ru]=Программно-определённое радио
Comment[ru]=Приемник для программно-определенного радио (SDR) использующий GNU Radio и библиотеку Qt.
GenericName[nl]=Software Defined Radio
Comment[nl]=Software defined radio ontvanger geïmplementeerd met GNU Radio en de Qt GUI toolkit
Comment[de]=Software defined Radio auf Basis von GNU Radio und dem Qt GUI Toolkit
Exec=gqrx
Terminal=false
Icon=gqrx
Categories=HamRadio;
Keywords=SDR;Radio;HAM;
' > $HOME/.local/share/applications/gqrx.desktop
}

get_SDRpp() {
printf "\n\n...SDRplusplus"
cd /usr/local/src
[[ -f "/usr/local/src/SDRPlusPlus" ]] \
    && mkdir -p /usr/local/src/SDRPlusPlus
# download from github
target_file="sdrpp_ubuntu_focal_amd64.deb"
git_repo="AlexandreRouma/SDRPlusPlus"
dl_dir="/usr/local/src/SDRPlusPlus"
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
dpkg -i $target_file

# clean up
rm $target_file
}

get_CubicSDR() {
apt install cubicsdr
}

# Install gnuradio dependencies
apt update
apt install libgnuradio-analog3.8.1 libgnuradio-audio3.8.1 \
libgnuradio-blocks3.8.1 libgnuradio-digital3.8.1 libgnuradio-fft3.8.1 \
libgnuradio-filter3.8.1 libgnuradio-iqbalance3.8.0 libgnuradio-pmt3.8.1 \
libgnuradio-runtime3.8.1 libgnuradio-uhd3.8.1 libgnuradio-fcdproplus3.8.0 \
libfftw3-dev libglfw3-dev libglew-dev libvolk2-dev libiio-dev libad9361-dev \
librtaudio-dev

# check git repos for updates
find . -name .git -type d \
| xargs -n1 -P4 -I% git --git-dir=% --work-tree=%/.. pull origin master

# compile the software as separate processes
list="\
get_sdrplay_api \
get_libmirisdr_4 \
get_SoapySDR_core \
get_rtl_sdr_drivers \
get_gr_osmosdr \
get_SoapyRTLSDR \
get_SoapyPlutoSDR \
get_SoapyRedPitaya \
get_SoapySDRPlay3 \
get_Airspy \
get_SoapyAirspy \
get_SoapyAirspyHF \
get_SoapyAudio \
get_SoapyBladeRF \
get_SoapyHackRF \
get_SoapyLMS7 \
get_SoapyRadioberrySDR \
get_SoapyUHD \
get_gqrx \
get_SDRpp \
get_CubicSDR"

for job in $list;do
    export -f "$job"
    sem -j+0 "$job"
done

printf "\n\nWorking... Please stand by.\n\n"
printf "\n\nPlease be patient... Downloading and compiling may be slow.\n\n"
sem --wait

# update the links for shared libraries
ldconfig

printf "\n\nEnd of script.  Good luck / have fun.\n"
