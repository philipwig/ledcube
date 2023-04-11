DESCRIPTION = "Lists available userspace I/O (UIO) devices"
HOMEPAGE = "https://www.osadl.org/UIO-Archives.uio-archives.0.html"
SECTION = "PETALINUX/apps"
LICENSE = "LGPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

SRCREV = "ba46808da148552462e50ba66d8d15cc5b9a3a00"
SRC_URI = "git://github.com/DigitalBrains1/lsuio.git;branch=master;protocol=https"

S = "${WORKDIR}/git"

inherit autotools

PACKAGES = "lsuio lsuio-dbg2"

FILES:${PN}-dbg2 += " \
    ${prefix}/share/* \
    ${bindir}/.debug/* \
    ${prefix}/src/debug/* \
"

do_install:append() {
    rm -f ${bindir}/.debug/lsuio
}