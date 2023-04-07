FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://hostapd.conf"

do_install:append() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${B}/hostapd.conf ${D}${sysconfdir}
}