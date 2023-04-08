FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://wl18xx-conf.bin"

do_install:append() {
    install -d ${D}${nonarch_base_libdir}/firmware/ti-connectivity
    install -m 0755 ${WORKDIR}/wl18xx-conf.bin ${D}${nonarch_base_libdir}/firmware/ti-connectivity/wl18xx-conf.bin
}
