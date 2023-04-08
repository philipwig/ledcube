
```
sudo iw wlan0 scan | grep SSID
wpa_passphrase PHILIP-DESKTOP uptownsucks | sudo tee wpa_supplicant.conf
sudo wpa_supplicant -B -Dnl80211 -iwlan0 -c wpa_supplicant.conf
sudo udhcpc -i wlan0
```

Check if interface is up
`ifconfig wlan0`

Set interface up
`ifconfig wlan0 up`

Configure WiFi module on first boot
`cd /usr/sbin/wlconf`
`sudo ./configure-device.sh` 

Scan for avaliable networks
`sudo iw wlan0 scan | grep SSID`

Create wpa_supplicant for network to connect to
`wpa_passphrase PHILIP-DESKTOP uptownsucks | sudo tee wpa_supplicant.conf`

Start wpa_supplicant in background and connect to network in wpa_supplicant.conf (run twice??)
`sudo wpa_supplicant -B -Dnl80211 -iwlan0 -c wpa_supplicant.conf`

Get ip address from router
`sudo udhcpc -i wlan0`



`ip` for all network interfaces, including setting up and down:
```
ip link set wlan0 up
ip link set wlan0 down
ip help
ip link help
ip addr help
```

`iw` for wireless extensions (needs to be called as root):
```
iw dev
iw phy
iw wlan0 scan
iw wlan0 station dump
iw help
```

```
program     obsoleted by
arp         ip neigh
ifconfig    ip addr
ipmaddr     ip maddr
iptunnel    ip tunnel
route       ip route
nameif      ifrename
mii-tool    ethtool
```