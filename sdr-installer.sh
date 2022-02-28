#!/bin/bash

# Copyright (c) 2022 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# This script compiles and installs SDR drivers from source.
# To disable a specific installer, comment its reference in
# the function list near the bottom of this script.

# define working directory
export working_dir="/usr/local/src"

# get the latest release from git repos
download_last(){
    wget -P "$3/" "$(lastversion --pre $1 --format assets --filter $2)"
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
cd "$working_dir"
[[ -f "$working_dir/$target_file" ]] \
    && chmod 755 "$target_file" \
    && ./"$target_file"
}

get_libmirisdr_4() {
printf "\n\n...LibMiriSDR-4..."
cd "$working_dir"
[[ -d "$working_dir/libmirisdr-4" ]] \
    || git clone "https://github.com/f4exb/libmirisdr-4" --depth 1 \
    && mkdir -p "$working_dir/libmirisdr-4/build"
cd "$working_dir/libmirisdr-4/build"
cmake ..
make -j4
make install
}

get_SoapySDR_core() {
printf "\n\n...SoapySDR..."
cd "$working_dir"
[[ -d "$working_dir/SoapySDR" ]] \
    || git clone "https://github.com/pothosware/SoapySDR" --depth 1 \
    && mkdir -p "$working_dir/SoapySDR/build"
cd "$working_dir/SoapySDR/build"
cmake ..
make -j4
make install
}

get_rtl_sdr_drivers() {
printf "\n\n...rtl-sdr firmware..."
cd "$working_dir"
[[ -d "$working_dir/librtlsdr" ]] \
    || git clone "https://github.com/steve-m/librtlsdr" --depth 1 \
    && mkdir -p "$working_dir/librtlsdr/build"
cd "$working_dir/librtlsdr/build"
cmake ../ -DINSTALL_UDEV_RULES=ON
make -j4
make install
}

get_gr_osmosdr() {
printf "\n\n...gr-osmosdr..."
cd "$working_dir"
[[ -d "$working_dir/gr-osmosdr" ]] \
    || git clone "git://git.osmocom.org/gr-osmosdr" --depth 1 \
    && mkdir -p "$working_dir/gr-osmosdr/build"
cd "$working_dir/gr-osmosdr/build"
cmake ..
make -j4
make install
}

get_SoapyRTLSDR() {
printf "\n\n...SoapyRTLSDR..."
cd "$working_dir"
[[ -d "$working_dir/SoapyRTLSDR" ]] \
    || git clone "https://github.com/pothosware/SoapyRTLSDR" --depth 1 \
    && mkdir -p "$working_dir/SoapyRTLSDR/build"
cd "$working_dir/SoapyRTLSDR/build"
cmake ..
make -j4
make install
}

get_SoapyPlutoSDR() {
printf "\n\n...ADALM-PlutoSDR"
cd "$working_dir"
[[ -d "$working_dir/SoapyPlutoSDR" ]] \
    || git clone "https://github.com/pothosware/SoapyPlutoSDR" --depth 1 \
    && mkdir -p "$working_dir/SoapyPlutoSDR/build"
cd "$working_dir/SoapyPlutoSDR/build"
cmake ..
make -j4
make install
}

get_SoapyRedPitaya() {
printf "\n\n...SoapyRedPitaya"
cd "$working_dir"
[[ -d "$working_dir/SoapyRedPitaya" ]] \
    || git clone "https://github.com/pothosware/SoapyRedPitaya" --depth 1 \
    && mkdir -p "$working_dir/SoapyRedPitaya/build"
cd "$working_dir/SoapyRedPitaya/build"
cmake ..
make -j4
make install
}

get_SoapySDRPlay3() {
printf "\n\n...SoapySDRPlay3..."
cd "$working_dir"
[[ -d "$working_dir/SoapySDRPlay3" ]] \
    || git clone "https://github.com/pothosware/SoapySDRPlay3" --depth 1 \
    && mkdir -p "$working_dir/SoapySDRPlay3/build"
cd "$working_dir/SoapySDRPlay3/build"
cmake ..
make -j4
make install
}

get_Airspy() {
printf "\n\n...LibAirspy..."
cd "$working_dir"
[[ -d "$working_dir/airspyone_host-master" ]] \
    || mkdir -p "$working_dir/airspyone_host-master/build"
# get the archived source for linux
target_file="master.zip"
cd "$working_dir/airspyone_host-master"
wget "https://github.com/airspy/airspyone_host/archive/master.zip"
unzip master.zip
rm master.zip
cd "$working_dir/airspyone_host-master/build"
cmake ../ -DINSTALL_UDEV_RULES=ON
make -j4
make install
}

get_SoapyAirspy() {
printf "\n\n...SoapyAirspy..."
cd "$working_dir"
[[ -d "$working_dir/SoapyAirspy" ]] \
    || git clone "https://github.com/pothosware/SoapyAirspy" --depth 1 \
    && mkdir -p "$working_dir/SoapyAirspy/build"
cd "$working_dir/SoapyAirspy/build"
cmake ..
make -j4
make install
}

get_SoapyAirspyHF() {
printf "\n\n...SoapyAirspyHF..."
cd "$working_dir"
[[ -d "$working_dir/SoapyAirspyHF" ]] \
    || git clone "https://github.com/pothosware/SoapyAirspyHF" --depth 1 \
    && mkdir -p "$working_dir/SoapyAirspyHF/build"
cd "$working_dir/SoapyAirspyHF/build"
cmake ..
make -j4
make install
}

get_SoapyAudio() {
printf "\n\n...soapy audio"
cd "$working_dir"
[[ -d "$working_dir/SoapyAudio" ]] \
    || git clone "https://github.com/pothosware/SoapyAudio" --depth 1 \
    && mkdir -p "$working_dir/SoapyAudio/build"
cd "$working_dir/SoapyAudio/build"
cmake ..
make -j4
make install
}

get_SoapyBladeRF() {
printf "\n\n...SoapyBladeRF"
cd "$working_dir"
[[ -d "$working_dir/SoapyBladeRF" ]] \
    || git clone "https://github.com/pothosware/SoapyBladeRF" --depth 1 \
    && mkdir -p "$working_dir/SoapyBladeRF/build"
cd "$working_dir/SoapyBladeRF/build"
cmake ..
make -j4
make install
}

get_SoapyFCDPP() {
printf "\n\n...SoapyFCDPP"
cd "$working_dir"
[[ -d "$working_dir/SoapyFCDPP" ]] \
    || git clone "https://github.com/pothosware/SoapyFCDPP" --depth 1 \
    && mkdir -p "$working_dir/SoapyFCDPP/build"
cd "$working_dir/SoapyFCDPP/build"
cmake ../
make -j4
make install
}

get_SoapyHackRF() {
printf "\n\n...SoapyHackRF"
cd "$working_dir"
[[ -d "$working_dir/SoapyHackRF" ]] \
    || git clone "https://github.com/pothosware/SoapyHackRF" --depth 1 \
    && mkdir -p "$working_dir/SoapyHackRF/build"
cd "$working_dir/SoapyHackRF/build"
cmake ..
make -j4
make install
}

get_SoapyLMS7() {
printf "\n\n...SoapyLMS7"
cd "$working_dir"
[[ -d "$working_dir/LimeSuite" ]] \
    || git clone "https://github.com/myriadrf/LimeSuite" --depth 1 \
    && mkdir -p "$working_dir/LimeSuite/build"
cd "$working_dir/LimeSuite/build"
cmake ..
make -j4
make install
}

get_SoapyRadioberrySDR() {
printf "\n\n...SoapyRadioberrySDR"
cd "$working_dir"
[[ -d "$working_dir/SBC/rpi-4/SoapyRadioberrySDR" ]] \
    || git clone "https://github.com/pa3gsb/Radioberry-2.x" --depth 1 \
    && mkdir -p "$working_dir/Radioberry-2.x/SBC/rpi-4/SoapyRadioberrySDR/build"
cd "$working_dir/Radioberry-2.x/SBC/rpi-4/SoapyRadioberrySDR/build"
cmake ..
make -j4
make install
}

get_SoapyUHD() {
printf "\n\n...SoapyUHD"
cd "$working_dir"
[[ -d "$working_dir/SoapyUHD" ]] \
    || git clone "https://github.com/pothosware/SoapyUHD" --depth 1 \
    && mkdir -p "$working_dir/SoapyUHD/build"
cd "$working_dir/SoapyUHD/build"
cmake ..
make -j4
make install
}

get_gqrx() {
printf "\n\n...Gqrx"
cd "$working_dir"
[[ -d "$working_dir/gqrx" ]] \
    || git clone "https://github.com/csete/gqrx" --depth 1 \
    && mkdir -p "$working_dir/gqrx/build"
cd "$working_dir/gqrx/build"
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
' > "$HOME/.local/share/applications/gqrx.desktop"
}

get_gqrx_scanner() {
printf "\n\n...Gqrx-Scanner..."
cd "$working_dir"
[[ -d "$working_dir/gqrx-scanner" ]] \
    || git clone "https://github.com/neural75/gqrx-scanner" --depth 1 \
    && mkdir -p "$working_dir/gqrx-scanner"
cd "$working_dir/gqrx-scanner"
cmake .
make -j4

#uncomment the symlinker if necessary (first install)
#ln -s "$working_dir/gqrx-scanner/bin/gqrx-scanner" "/usr/local/bin/gqrx-scanner"

#create the launcher file
printf "\n\n creating the .desktop file..."
printf '[Desktop Entry]
Type=Application
Name=Gqrx-Scanner
GenericName=SDR Scanner
Comment=Software defined radio scanner using Gqrx
Exec=sdr-scanner
Terminal=false
Icon=utilities-terminal
Categories=HamRadio;
Keywords=SDR;Radio;HAM;
' > "$HOME/.local/share/applications/gqrx-scanner.desktop"
}

get_SDRpp() {
printf "\n\n...SDRplusplus"
cd "$working_dir"
[[ -d "$working_dir/SDRPlusPlus" ]] \
    && mkdir -p "$working_dir/SDRPlusPlus"
# download from github
target_file="sdrpp_ubuntu_focal_amd64.deb"
git_repo="AlexandreRouma/SDRPlusPlus"
dl_dir="$working_dir/SDRPlusPlus"
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
dpkg -i $target_file

# clean up
rm $target_file
}

get_CubicSDR() {
apt -o DPkg::Lock::Timeout=-1 install -y cubicsdr
}

# Install gnuradio dependencies
apt -o DPkg::Lock::Timeout=-1 update
apt -o DPkg::Lock::Timeout=-1 install -y libgnuradio-analog3.8.1 \
libgnuradio-audio3.8.1 libgnuradio-blocks3.8.1 libgnuradio-digital3.8.1 \
libgnuradio-fft3.8.1 libgnuradio-filter3.8.1 libgnuradio-iqbalance3.8.0 \
libgnuradio-pmt3.8.1 libgnuradio-runtime3.8.1 libgnuradio-uhd3.8.1 \
libgnuradio-fcdproplus3.8.0 libfftw3-dev libglfw3-dev libglew-dev \
libvolk2-dev libiio-dev libad9361-dev librtaudio-dev

# use find (unless you already have fd)
find -type d -name '.git' | xargs -n1 -P4 -I {} \
    bash -c 'pushd "${0%/*}" \
    && ( git pull --depth 1; \
    git tag -d $(git tag -l); \
    git reflog expire --expire=all --all;
    git gc --prune=all ) \
    && popd' {} \;

# use fd if you have it
#fd -HIFt d '.git' | xargs -n1 -P4 -I {} \
#    bash -c 'pushd "$0" \
#    && ( git pull --depth 1; \
#    git tag -d $(git tag -l); \
#    git reflog expire --expire=all --all; \
#    git gc --prune=all ) \
#    && popd' {}

# compile the software as separate processes
list="get_sdrplay_api \
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
get_gqrx_scanner \
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
