#!/bin/bash

# Copyright (c) 2022 by Philip Collier, radio AB9IL <webmaster@ab9il.net>
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version. There is NO warranty; not even for
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# update SDR decoder software and other tools
# To disable a specific updater, comment its reference in
# the function list near the bottom of this script.

# define working directory
working_dir="/usr/local/src"

# get the latest release from git repos
download_last(){
    cd $3
    wget "$(lastversion --pre $1 --format assets --filter $2)"
}
export -f download_last

update_glrpt() {
printf "\n\n...glrpt..."
cd "$working_dir"
apt install libturbojpeg libturbojpeg0-dev
[[ -f "$working_dir/glrpt" ]] \
    || git clone "https://github.com/dvdesolve/glrpt" \
    && mkdir -p "$working_dir/glrpt/build"
cd "$working_dir/glrpt/build"
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
make install
}

update_audioprism() {
printf "\n\n...audioprism..."
cd "$working_dir"
apt install libpulse-dev libfftw3-dev libsdl2-dev libsdl2-ttf-dev \
    libsndfile1-dev libgraphicsmagick++1-dev
[[ -f "$working_dir/audioprism" ]] \
    || git clone "https://github.com/vsergeev/audioprism"
cd $working_dir/audioprism
make
make install
}

update_kalibrate-rtl() {
printf "\n\n...kalibrate-rtl..."
cd "$working_dir"
[[ -f "$working_dir/kalibrate-rtl" ]] \
    || git clone "https://github.com/steve-m/kalibrate-rtl"
cd "$working_dir/kalibrate-rtl"
./bootstrap && CXXFLAGS='-W Wall -03'
./configure
make
make install
}

update_dump1090() {
printf "\n\n...dump1090..."
cd "$working_dir"
[[ -f "$working_dir/dump1090-fa" ]] \
    || git clone "https://github.com/adsbxchange/dump1090-fa"
cd "$working_dir/dumpdump1090-fa"
make
cp dump1090 /usr/local/bin/dump1090
cp view1090 /usr/local/bin/view1090
}

update_RTLSDR-Airband() {
printf "\n\n...RTLSDR-Airband..."
cd "$working_dir"
[[ -f "$working_dir/RTLSDR-Airband" ]] \
    || git clone "https://github.com/szpajder/RTLSDR-Airband" \
    && mkdir -p "$working_dir/RTLSDR-Airband/build"
cd "$working_dir/RTLSDR-Airband/build"
cmake -NFM=ON -DMIRISDR=OFF ../
make
make install
}

update_libacars() {
printf "\n\n...libacars..."
cd "$working_dir"
[[ -f "$working_dir/libacars" ]] \
    || git clone "https://github.com/szpajder/libacars" \
    && mkdir -p "$working_dir/libacars/build"
cd "$working_dir/libacars/build"
cmake ../
make
make install
}

update_acarsdec() {
printf "\n\n...acarsdec..."
cd "$working_dir"
[[ -f "$working_dir/acarsdec" ]] \
    || git clone "https://github.com/szpajder/acarsdec" \
    && mkdir -p $working_dir/acarsdec/build
cd "$working_dir/acarsdec/build"
cmake ../ -Drtl=ON
make
make install
}

update_vdlm2dec() {
printf "\n\n...vdlm2dec..."
cd "$working_dir"
[[ -f "$working_dir/vdlm2dec" ]] \
    || git clone "https://github.com/TLeconte/vdlm2dec" \
    && mkdir -p "$working_dir/vdlm2dec/build"
cd "$working_dir/vdlm2dec/build"
cmake .. -Drtl=ON
make
make install
}

update_acarsserv() {
printf "\n\n...acarsserv..."
cd "$working_dir"
[[ -f "$working_dir/acarsserv" ]] \
    || git clone "https://github.com/TLeconte/acarsserv"
cd "$working_dir/acarsserv"
make -f makefile
cp acarsserv "/usr/local/sbin/acarsserv"
}

update_dumpvdl2() {
printf "\n\n...dumpvdl2..."
cd "$working_dir"
[[ -f "$working_dir/dumpvdl2" ]] \
    || git clone "https://github.com/szpajder/dumpvdl2" \
    && mkdir -p "$working_dir/dumpvdl2/build"
cd "usr/local/src/dumpvdl2/build"
cmake ../
make
make install
}

update_rtl-ais() {
printf "\n\n...rtl-ais..."
cd "$working_dir"
[[ -f "$working_dir/rtl-ais" ]] \
    || git clone "https://github.com/dgiardini/rtl-ais"
cd "$working_dir/rtl-ais"
make
make install
}

update_noaa-apt() {
printf "\n\n...noaa-apt..."
cd "$working_dir"
git_repo="martinber/noaa-apt"
target_file="amd64.deb"
dl_dir="$working_dir/noaa-apt"
cd "$dl_dir"
download_last $git_repo $target_file $dl_dir
deb_file="$(ls | grep "$target_file")"
dpkg -i $deb_file
# clean up
rm ./*.deb
}

update_sdrtrunk() {
printf "\n\n...SDRTrunk..."
cd "$working_dir"
git_repo="DSheirer/sdrtrunk"
target_file="linux-x86_64"
dl_dir="$working_dir"
cd "$dl_dir"
## currently - download manually
download_last $git_repo $target_file $dl_dir
extracted_dir="$(ls | grep "$target_file")"
unzip *${target_file}.zip
[[ -d "$extracted_dir" ]] \
    && rm -rf "/usr/local/sbin/sdrtrunk" \
    && mv "$extracted_dir" "/usr/local/sbin/sdrtrunk"
# clean up
rm ./*.zip
}

# update apt repo data
apt update

# check git repos for updates
find . -name .git -type d \
| xargs -n1 -P4 -I% git --git-dir=% --work-tree=%/.. pull origin master

# compile decoders and tools as separate processes
list="\
update_glrpt \
update_audioprism \
update_kalibrate-rtl \
update_dump1090 \
update_RTLSDR-Airband \
update_libacars \
update_acarsdec \
update_vdlm2dec \
update_acarsserv \
update_rtl-ais \
update_noaa-apt \
update_sdrtrunk"

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
