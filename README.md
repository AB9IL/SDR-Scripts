# SDR-Scripts

### Tools to Concurrently Download and Update Software Defined Radio Apps
These run in Bash, downloading and compiling concurrenty, four jobs at once.

Download, install, or update SoapySDR drivers and associated hardware: rtl-sdr, hackrf, sdrplay, etc.
The decoder script supports decoders and demod tools for ADS-B, ACARS, and VDL mode 2, etc.

These scripts use "Lastversion" (Python) and GNU Parallel. Get them with:
```
sudo apt install parallel
python3 -m pip install lastversion
```

#### Supported Apps:
| Decoders | SDR Hardware & GUIs |
| --- | --- |
| glrpt | sdrplay api (must manually download first)
| audioprism | libmirisdr-4
| kalibrate-rtl | SoapySDR (core functionality)
| dump1090 | rtl-sdr
| RTLSDR-Airband | gr-osmosdr
| libacars | SoapyRTLSDR
| acarsdec | SoapyPlutoSDR
| vdlm2dec | SoapyRedPitaya
| acarsserv | SoapySDRPlay3
| rtl-ais | Airspy
| noaa-apt | SoapyAirspy
| sdrtrunk | SoapyAirspyHF
| | SoapyAudio
| | SoapyBladeRF
| | SoapyHackRF
| | SoapyLMS7
| | SoapyRadioberrySDR
| | SoapyUHD
| |  Gqrx
| |  SDRplusplus
| | CubicSDR


#### Usage:
Copy the scripts to /usr/local/src.  Execute them there as root.
```
sudo sdr-installer.sh
sudo decoders.sh
```
Note, these scripts will find any git repos cloned in the working directory, do a "git pull" for them, but only compile the packages supported in the scripts. To add a new package, you must:

- write in a function (similar to the others) to support the software
- add the function to the list at the bottom of the script

Supported software does not need to be exclusively hosted on github; any git repo works. Also, any web resource hosting deb packages, zip, or tar archives available to wget can work. FTW, you could even set these up to use Aria2 or another download tool...
