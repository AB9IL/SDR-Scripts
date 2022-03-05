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
export working_dir="/usr/local/src"

# get the latest release from git repos
download_last(){
    wget -P "$3/" "$(lastversion --pre $1 --format assets --filter $2)"
}
export -f download_last

update_glrpt() {
printf "\n\n...glrpt..."
cd "$working_dir"
apt -o DPkg::Lock::Timeout=-1 install -y libturbojpeg libturbojpeg0-dev
[[ -d "$working_dir/glrpt" ]] \
    || git clone "https://github.com/dvdesolve/glrpt" --depth 1 \
    && mkdir -p "$working_dir/glrpt/build"
cd "$working_dir/glrpt/build"
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j4
make install
}

update_audioprism() {
printf "\n\n...audioprism..."
cd "$working_dir"
apt -o DPkg::Lock::Timeout=-1 install -y libpulse-dev libfftw3-dev \
    libsdl2-dev libsdl2-ttf-dev libsndfile1-dev libgraphicsmagick++1-dev
[[ -d "$working_dir/audioprism" ]] \
    || git clone "https://github.com/vsergeev/audioprism" --depth 1
cd "$working_dir/audioprism"
make -j4
make install
}

update_kalibrate-rtl() {
printf "\n\n...kalibrate-rtl..."
cd "$working_dir"
[[ -d "$working_dir/kalibrate-rtl" ]] \
    || git clone "https://github.com/steve-m/kalibrate-rtl" --depth 1
cd "$working_dir/kalibrate-rtl"
./bootstrap && CXXFLAGS='-W Wall -03'
./configure
make -j4
make install
}

update_dump1090() {
printf "\n\n...dump1090..."
cd "$working_dir"
[[ -d "$working_dir/dump1090-fa" ]] \
    || git clone "https://github.com/adsbxchange/dump1090-fa" --depth 1
cd "$working_dir/dumpdump1090-fa"
make -j4 -f Makefile BLADERF=no
# uncomment the symlinker below if needed
#ln -sf "$working_dir/dump1090-fa/dump1090" "/usr/local/bin/dump1090"
#ln -sf "$working_dir/dump1090-fa/view1090" "/usr/local/bin/view1090"
}

update_dump1090_ol3map() {
printf "\n\n...dump1090_ol3map..."
cd "$working_dir"
[[ -d "$working_dir/Dump1090-OpenLayers3-html" ]] \
    || git clone "https://github.com/alkissack/Dump1090-OpenLayers3-html" --depth 1
chmod 4775 "$working_dir/Dump1090-OpenLayers3-html"
chmod 4777 "$working_dir/Dump1090-OpenLayers3-html/public_html"
cd "$working_dir/Dump1090-OpenLayers3-html/public_html"
cp config.js config.js.orig
chmod 666 config.js

# set up the directory used by Dump1090
mkdir -p "/usr/local/share/dump1090"
ln -sf "$working_dir/Dump1090-OpenLayers3-html/public_html" "/usr/local/share/dump1090/html"
}

update_RTLSDR-Airband() {
printf "\n\n...RTLSDR-Airband..."
cd "$working_dir"
[[ -d "$working_dir/RTLSDR-Airband" ]] \
    || git clone "https://github.com/szpajder/RTLSDR-Airband" --depth 1 \
    && mkdir -p "$working_dir/RTLSDR-Airband/build"
cd "$working_dir/RTLSDR-Airband/build"
cmake -NFM=ON -DMIRISDR=OFF ../
make -j4
make install
}

update_libacars() {
printf "\n\n...libacars..."
cd "$working_dir"
[[ -d "$working_dir/libacars" ]] \
    || git clone "https://github.com/szpajder/libacars" --depth 1 \
    && mkdir -p "$working_dir/libacars/build"
cd "$working_dir/libacars/build"
cmake ../
make -j4
make install
}

update_acarsdec() {
printf "\n\n...acarsdec..."
cd "$working_dir"
[[ -d "$working_dir/acarsdec" ]] \
    || git clone "https://github.com/szpajder/acarsdec" --depth 1 \
    && mkdir -p "$working_dir/acarsdec/build"
cd "$working_dir/acarsdec/build"
cmake ../ -Drtl=ON
make -j4
make install
}

update_vdlm2dec() {
printf "\n\n...vdlm2dec..."
cd "$working_dir"
[[ -d "$working_dir/vdlm2dec" ]] \
    || git clone "https://github.com/TLeconte/vdlm2dec" --depth 1 \
    && mkdir -p "$working_dir/vdlm2dec/build"
cd "$working_dir/vdlm2dec/build"
cmake .. -Drtl=ON
make -j4
make install
}

update_acarsserv() {
printf "\n\n...acarsserv..."
cd "$working_dir"
[[ -d "$working_dir/acarsserv" ]] \
    || git clone "https://github.com/TLeconte/acarsserv" --depth 1
cd "$working_dir/acarsserv"
make -j4 -f Makefile
# uncomment the symlinker below if needed
#ln -sf "$working_dir/acarsserv/acarsserv" "/usr/local/sbin/acarsserv"
}

update_dumpvdl2() {
printf "\n\n...dumpvdl2..."
cd "$working_dir"
[[ -d "$working_dir/dumpvdl2" ]] \
    || git clone "https://github.com/szpajder/dumpvdl2" --depth 1 \
    && mkdir -p "$working_dir/dumpvdl2/build"
cd "usr/local/src/dumpvdl2/build"
cmake ../
make -j4
make install
}

update_rtl-ais() {
printf "\n\n...rtl-ais..."
cd "$working_dir"
[[ -d "$working_dir/rtl-ais" ]] \
    || git clone "https://github.com/dgiardini/rtl-ais" --depth 1
cd "$working_dir/rtl-ais"
make -j4
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
deb_file="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
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
extracted_dir="$(find . -maxdepth 1 -name "$(echo "$target_file" | sed 's|\.||')")"
unzip *${target_file}.zip
[[ -d "$extracted_dir" ]] \
    && rm -rf "/usr/local/sbin/sdrtrunk" \
    && mv "$extracted_dir" "/usr/local/sbin/sdrtrunk"
# clean up
rm ./*.zip
}

# update apt repo data
apt -o DPkg::Lock::Timeout=-1 update

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

# compile decoders and tools as separate processes
list="update_glrpt \
update_audioprism \
update_kalibrate-rtl \
update_dump1090 \
update_dump1090_ol3map \
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
