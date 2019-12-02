#!/bin/bash
# ##############################
# CONFIGURE AS PER YOUR SYSTEM
WIFI_DEVICE=wlp2s0

MONITORED_SSID=(
    "TestNet"
    "TestNet_5G"
    "testnetg"
)

#filtering by channels makes it more snappy, othewise goes roundrobin in all the unwanted frequencies
#Check your router for the channel, or run airodump manually to see the wanted channels
#Coma separated list
CHANNELS="8,36"
# END OF CONFIG
################################



#1. put the wifi device into monitor mode first
airmon-ng start $WIFI_DEVICE

WIFI_DEVICE_MON="${WIFI_DEVICE}mon"
NETWORK_FILTER=""
for i in "${MONITORED_SSID[@]}"; do
    NETWORK_FILTER+="-N $i "
done
CHANNELS_FILTER=""
if [ ! -z "$CHANNELS" ]
then
    CHANNELS_FILTER="--channel ${CHANNELS}"
fi

#2. run the airodump-ng process and clean up before so it will create /tmp/airodump-01.csv !!
rm -f /tmp/airodump*
airodump-ng $NETWORK_FILTER $CHANNELS_FILTER -a -w /tmp/airodump --output-format csv -K 1 $WIFI_DEVICE_MON



