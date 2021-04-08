# OV_MLAT_Tool - GB3OV Mulilateration Tool
This project is an experiment to see whether we can use multi-lateration to identify the source of RF signals
using a network of Raspberry Pis with RTL-SDR dongles.
The project was inspired by the work of [Stefan Scholl - DC9ST][DC9ST] and presented by him at the [Software Defined Radio Forum 2017][SDRF] at Frederickshafen.

[DC9ST]: http://www.panoradio-sdr.de/
[SDRF]: http://www.panoradio-sdr.de/tdoa-transmitter-localization-with-rtl-sdrs/

# Background
Our local 70cms repeater, [GB3OV], is located in Graveley, Cambridgeshire.
In the UK, the 70cms band is shared and the Radio Amateur Service is only a secondary user.
Thus we need to be prepared for co-channel interference - and we do experience this.
The main source of intereference is low-power locator beacons that are used by cranes to locate their jibs.
Locating these devices and then negotiating with the operator to - hopefully - change the frequency
can be quite time-consuming. 
Hence this project to "automate" the positioning task.

Any additional use might be to locate deliberate interference by other licensed amateurs; 
however this is more difficult because they often transmit over an existing transmission.

# Proposed Method
The general idea is to produce a small number (probably 3) of self-contained units that can be installed at known locations around the repeater. 
These units will use the techniques described in [Stefan's paper][SDRF] to capture and send an IQ data stream to a fourth computer running the analysis software.
The results of the analysis will be displayed on a website.

# Architecture
## Linux Master Station
### Hardware
The Master Station will probably be a Linux VM running on a publicaly accessible host somewhere.

### Software
Installed on the Master Station will be the [Analysis Software][Analysis].

[Analysis]: https://github.com/garethhowell
## Raspberry Pi Minion
### Hardware
The minion comprises a [Raspberry Pi 3B][Pi3b] microcomputer with a cheap plugin [RTL-SDR Dongle][RTL-SDR] and simple antenna.
The total cost should be under £50.00

[Pi3b]: https://www.raspberrypi.org/products/raspberry-pi-3-model-b/
[RTL-SDR]: https://www.rtl-sdr.com/about-rtl-sdr/

### Software
The Pi will be running [Balena OS][BalenaOS] and a Balena IOT project built from the [OV_MLAT_TOOL Github repository][MLAT_TOOL].
This comprises a number of [Docker] containers running on Balena OS and controlled from a single point.

[MLAT_TOOL]: https://github.com/garethhowell
[Docker]: https://docker/com

## Docker Containers
The following containers run on the Minion.

### wifi-connect
This is a pre-defined Balena container that detects if the Pi is connected to a local network.
If not, then it presents a wifi hotspot that can be used to configure the Pi's wireless networking settings.

Typically, this is done just the once when the Pi is installed at a new location.
If the Pi is connected to the local network using an Ethernet cable, this container is redundant.

### resilio-sync
This container implements a customised version of the [Resilio Sync][Resilio] Peer-2-Peer file transfer node that is used to synchronise the locally captured IQ data stream with the Master Station.

[Resilio]: https://www.resilio.com/

### mlat
This container implements the custom multilateration code.

# To Do
Currently, the system requires a master station to connect to.
A future modification would be to move the Master into something like [Amazon Web Services][AWS]

[AWS]: https://aws.amazon.com/
