# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "n_rows_max" -parent ${Page_0}
  ipgui::add_param $IPINST -name "n_cols_max" -parent ${Page_0}
  ipgui::add_param $IPINST -name "bitdepth_max" -parent ${Page_0}
  ipgui::add_param $IPINST -name "lsb_blank_length_max" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}


}

proc update_PARAM_VALUE.bitdepth_max { PARAM_VALUE.bitdepth_max } {
	# Procedure called to update bitdepth_max when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.bitdepth_max { PARAM_VALUE.bitdepth_max } {
	# Procedure called to validate bitdepth_max
	return true
}

proc update_PARAM_VALUE.lsb_blank_length_max { PARAM_VALUE.lsb_blank_length_max } {
	# Procedure called to update lsb_blank_length_max when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.lsb_blank_length_max { PARAM_VALUE.lsb_blank_length_max } {
	# Procedure called to validate lsb_blank_length_max
	return true
}

proc update_PARAM_VALUE.n_cols_max { PARAM_VALUE.n_cols_max } {
	# Procedure called to update n_cols_max when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.n_cols_max { PARAM_VALUE.n_cols_max } {
	# Procedure called to validate n_cols_max
	return true
}

proc update_PARAM_VALUE.n_rows_max { PARAM_VALUE.n_rows_max } {
	# Procedure called to update n_rows_max when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.n_rows_max { PARAM_VALUE.n_rows_max } {
	# Procedure called to validate n_rows_max
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.n_rows_max { MODELPARAM_VALUE.n_rows_max PARAM_VALUE.n_rows_max } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.n_rows_max}] ${MODELPARAM_VALUE.n_rows_max}
}

proc update_MODELPARAM_VALUE.n_cols_max { MODELPARAM_VALUE.n_cols_max PARAM_VALUE.n_cols_max } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.n_cols_max}] ${MODELPARAM_VALUE.n_cols_max}
}

proc update_MODELPARAM_VALUE.bitdepth_max { MODELPARAM_VALUE.bitdepth_max PARAM_VALUE.bitdepth_max } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.bitdepth_max}] ${MODELPARAM_VALUE.bitdepth_max}
}

proc update_MODELPARAM_VALUE.lsb_blank_length_max { MODELPARAM_VALUE.lsb_blank_length_max PARAM_VALUE.lsb_blank_length_max } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.lsb_blank_length_max}] ${MODELPARAM_VALUE.lsb_blank_length_max}
}

