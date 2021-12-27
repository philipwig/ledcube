

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "led_driver_test" "NUM_INSTANCES" "DEVICE_ID"  "C_axi_control_BASEADDR" "C_axi_control_HIGHADDR"
}
