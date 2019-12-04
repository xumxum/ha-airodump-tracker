## Home Assistant Airodump Tracker


Home Assistant custom device tracker using airodump-ng.

#### Description
If you are running Home Assistant on a Linux device that is connected via Ethernet LAN cable and the WIFI network card is available, it can be used to track the devices on your network (or even neighbour's network) via the airocrack tools by putting WIFI card to monitor mode and parsing the output from airodump-ng.

After testing it against the ping device tracker, which is extremely unreliable for me because the WIFI goes to standby and ping just fails, this tracker performs much better with far less false indications!

Another nice feature is it does some basic distance estimation based on the received power level from the device. This could be used to do some basic zone estimations on where the device is located. 

#### Advantages: 
- Get device power level and distance estimation
- Passive, does not cause any extra transmission from the device thus saving device power


---------------------
#### Installation

1. Clone this repository to your working directory(/work, or /usr/local/lib etc)
> cd /work<br>
> git clone https://github.com/xumxum/ha-airodump-tracker.git

2. Install **airocrack-ng** package. Check airocrack-ng documentation for more information
> (Fedora: sudo dnf install airocrack-ng)<br>
> (Ubuntu: sudo apt-get install airocrack-ng)

3. Configure airodump-ng to start as a systemd service. I tried only as root
> cp /work/ha-airodump-tracker/airodump-systemd/airodump.service /etc/systemd/system/airodump.service

4. Edit **/work/ha-airodump-tracker/airodump-systemd/run_airodump.sh** and configure **WIFI_DEVICE**, **MONITORED_SSID** and **CHANNELS** variables.
If you need to get these values for your system, you can run for ex:
    - WIFI_DEVICE:
    > ip addr

    - MONITORED_SSID, CHANNELS:
    > airodump-ng wifi_device

5. Edit **/etc/systemd/system/airodump.service** and make sure run_airodump.sh path is configured to your location (in this case /work/ha-airodump-tracker/airodump-systemd/run_airodump.sh)

6. Reload systemd and start service
> systemctl daemon-reload<br>
> systemctl start airodump.service<br>

    If everything is ok, you should have a file /tmp/airodump-01.csv
> ls /tmp/airodump*

7. Copy(or link) the airodump custom component to your Home Assistant installation folder
> ln -s /var/lib/homeassistant/custom_components/airodump_tracker work/test/ha-airodump-tracker/custom_components/airodump_tracker

7. Edit Home Assistant **configuration.yaml** and add: 

> device_tracker:
>   - platform: airodump_tracker

8. Restart home assistant and you should start seeing the devices found in home assistant. 
