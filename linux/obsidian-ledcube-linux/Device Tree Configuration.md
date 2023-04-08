To add to petalinux device tree, add additional nodes to `project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi`

Also see info [here](https://docs.xilinx.com/r/en-US/ug1144-petalinux-tools-reference-guide/Configuring-Device-Tree) for more information.


## Notes
Add `uio_pdrv_genirq.of_id=generic-uio` to enable interrupts from generic uio driver

`wlan_en_reg` is for the wireless chip regulator?
`sdhci` is for data communication with wifi module
`spi` communication with stm controller using python spidev driver
`qspi` for booting from qspi flash
`led_driver_top` add `compatible = "generic-uio", "xlnx,led-driver-top-1.0";` to use generic-uio driver with axi interface. This will allow for easy binding in userspace of those memroy ranges