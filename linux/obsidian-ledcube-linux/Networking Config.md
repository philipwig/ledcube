```
cat > $rootfs/etc/resolv.conf << "EOF"
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
```

```
cat > $rootfs/etc/wpa_supplicant.conf << "EOF"
ctrl_interface=/run/wpa_supplicant
ctrl_interface_group=0
update_config=1

EOF
```

```
chmod 0600 $rootfs/etc/wpa_supplicant.conf
```

```
# Add script to bringup the wireless access point
cat > $rootfs/etc/snickerdoodle/accesspoint/wlan.sh << "EOF"
#!/bin/sh

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# On Debian GNU/Linux systems, the text of the GPL license,
# version 2, can be found in /usr/share/common-licenses/GPL-2.

IFACE=wlan1
HOSTAPD_CONF=/etc/hostapd/hostapd.conf

init_accesspoint () {
        echo 1 > /proc/sys/net/ipv4/ip_forward

        if [ ! -d /sys/class/net/$IFACE ]; then
                iw phy `ls /sys/class/ieee80211/` interface add $IFACE type managed
        fi

        HWID=`sed '{s/://g; s/.*\([0-9a-fA-F]\{6\}$\)/\1/}' /sys/class/net/$IFACE/address`
        DEFAULT_SSID=`hostname`-$HWID

        if [ -z $(grep -e "^ssid *=.*" $HOSTAPD_CONF) ]; then
                if [ -n $(grep -e "^#ssid *=.*" $HOSTAPD_CONF) ]; then
                        sed -ie "s/^#\(ssid *= *\).*$/\1$DEFAULT_SSID/g" $HOSTAPD_CONF
                fi
        fi
}

init_accesspoint
exit 0


EOF

chmod 755 $rootfs/etc/snickerdoodle/accesspoint/wlan.sh

# Systemd service

cat > $rootfs/usr/lib/systemd/system/setup_wlan.service << "EOF"
[Unit]
Description=configure wlan1 interface
After=network.target


[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/etc/snickerdoodle/accesspoint/wlan.sh


[Install]
WantedBy=multi-user.target
EOF

chmod 644 $rootfs/usr/lib/systemd/system/setup_wlan.service

ln -s /usr/lib/systemd/system/setup_wlan.service $rootfs/etc/systemd/system/multi-user.target.wants/setup_wlan.service

```