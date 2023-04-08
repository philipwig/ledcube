
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/led_driver_top_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BITDEPTH_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CTRL_NUM_REG" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIL_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXIL_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIF_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIF_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXIF_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LSB_BLANK_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_COLS_MAX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_PIXELS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_ROWS_MAX" -parent ${Page_0}


}

proc update_PARAM_VALUE.N_PIXELS { PARAM_VALUE.N_PIXELS PARAM_VALUE.N_ROWS_MAX PARAM_VALUE.N_COLS_MAX } {
	# Procedure called to update N_PIXELS when any of the dependent parameters in the arguments change
	
	set N_PIXELS ${PARAM_VALUE.N_PIXELS}
	set N_ROWS_MAX ${PARAM_VALUE.N_ROWS_MAX}
	set N_COLS_MAX ${PARAM_VALUE.N_COLS_MAX}
	set values(N_ROWS_MAX) [get_property value $N_ROWS_MAX]
	set values(N_COLS_MAX) [get_property value $N_COLS_MAX]
	set_property value [gen_USERPARAMETER_N_PIXELS_VALUE $values(N_ROWS_MAX) $values(N_COLS_MAX)] $N_PIXELS
}

proc validate_PARAM_VALUE.N_PIXELS { PARAM_VALUE.N_PIXELS } {
	# Procedure called to validate N_PIXELS
	return true
}

proc update_PARAM_VALUE.BITDEPTH_MAX { PARAM_VALUE.BITDEPTH_MAX } {
	# Procedure called to update BITDEPTH_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BITDEPTH_MAX { PARAM_VALUE.BITDEPTH_MAX } {
	# Procedure called to validate BITDEPTH_MAX
	return true
}

proc update_PARAM_VALUE.CTRL_NUM_REG { PARAM_VALUE.CTRL_NUM_REG } {
	# Procedure called to update CTRL_NUM_REG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CTRL_NUM_REG { PARAM_VALUE.CTRL_NUM_REG } {
	# Procedure called to validate CTRL_NUM_REG
	return true
}

proc update_PARAM_VALUE.C_AXIL_ADDR_WIDTH { PARAM_VALUE.C_AXIL_ADDR_WIDTH } {
	# Procedure called to update C_AXIL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIL_ADDR_WIDTH { PARAM_VALUE.C_AXIL_ADDR_WIDTH } {
	# Procedure called to validate C_AXIL_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXIL_DATA_WIDTH { PARAM_VALUE.C_AXIL_DATA_WIDTH } {
	# Procedure called to update C_AXIL_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXIL_DATA_WIDTH { PARAM_VALUE.C_AXIL_DATA_WIDTH } {
	# Procedure called to validate C_AXIL_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_ADDR_WIDTH { PARAM_VALUE.C_S_AXIF_ADDR_WIDTH } {
	# Procedure called to update C_S_AXIF_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_ADDR_WIDTH { PARAM_VALUE.C_S_AXIF_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXIF_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_DATA_WIDTH { PARAM_VALUE.C_S_AXIF_DATA_WIDTH } {
	# Procedure called to update C_S_AXIF_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_DATA_WIDTH { PARAM_VALUE.C_S_AXIF_DATA_WIDTH } {
	# Procedure called to validate C_S_AXIF_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXIF_ID_WIDTH { PARAM_VALUE.C_S_AXIF_ID_WIDTH } {
	# Procedure called to update C_S_AXIF_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXIF_ID_WIDTH { PARAM_VALUE.C_S_AXIF_ID_WIDTH } {
	# Procedure called to validate C_S_AXIF_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.LSB_BLANK_MAX { PARAM_VALUE.LSB_BLANK_MAX } {
	# Procedure called to update LSB_BLANK_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LSB_BLANK_MAX { PARAM_VALUE.LSB_BLANK_MAX } {
	# Procedure called to validate LSB_BLANK_MAX
	return true
}

proc update_PARAM_VALUE.N_COLS_MAX { PARAM_VALUE.N_COLS_MAX } {
	# Procedure called to update N_COLS_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_COLS_MAX { PARAM_VALUE.N_COLS_MAX } {
	# Procedure called to validate N_COLS_MAX
	return true
}

proc update_PARAM_VALUE.N_ROWS_MAX { PARAM_VALUE.N_ROWS_MAX } {
	# Procedure called to update N_ROWS_MAX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_ROWS_MAX { PARAM_VALUE.N_ROWS_MAX } {
	# Procedure called to validate N_ROWS_MAX
	return true
}


proc update_MODELPARAM_VALUE.N_ROWS_MAX { MODELPARAM_VALUE.N_ROWS_MAX PARAM_VALUE.N_ROWS_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_ROWS_MAX}] ${MODELPARAM_VALUE.N_ROWS_MAX}
}

proc update_MODELPARAM_VALUE.N_COLS_MAX { MODELPARAM_VALUE.N_COLS_MAX PARAM_VALUE.N_COLS_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_COLS_MAX}] ${MODELPARAM_VALUE.N_COLS_MAX}
}

proc update_MODELPARAM_VALUE.BITDEPTH_MAX { MODELPARAM_VALUE.BITDEPTH_MAX PARAM_VALUE.BITDEPTH_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BITDEPTH_MAX}] ${MODELPARAM_VALUE.BITDEPTH_MAX}
}

proc update_MODELPARAM_VALUE.LSB_BLANK_MAX { MODELPARAM_VALUE.LSB_BLANK_MAX PARAM_VALUE.LSB_BLANK_MAX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LSB_BLANK_MAX}] ${MODELPARAM_VALUE.LSB_BLANK_MAX}
}

proc update_MODELPARAM_VALUE.CTRL_NUM_REG { MODELPARAM_VALUE.CTRL_NUM_REG PARAM_VALUE.CTRL_NUM_REG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CTRL_NUM_REG}] ${MODELPARAM_VALUE.CTRL_NUM_REG}
}

proc update_MODELPARAM_VALUE.N_PIXELS { MODELPARAM_VALUE.N_PIXELS PARAM_VALUE.N_PIXELS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_PIXELS}] ${MODELPARAM_VALUE.N_PIXELS}
}

proc update_MODELPARAM_VALUE.C_AXIL_ADDR_WIDTH { MODELPARAM_VALUE.C_AXIL_ADDR_WIDTH PARAM_VALUE.C_AXIL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIL_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXIL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIL_DATA_WIDTH { MODELPARAM_VALUE.C_AXIL_DATA_WIDTH PARAM_VALUE.C_AXIL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXIL_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXIL_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_ID_WIDTH { MODELPARAM_VALUE.C_S_AXIF_ID_WIDTH PARAM_VALUE.C_S_AXIF_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_ID_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXIF_DATA_WIDTH PARAM_VALUE.C_S_AXIF_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXIF_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXIF_ADDR_WIDTH PARAM_VALUE.C_S_AXIF_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXIF_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXIF_ADDR_WIDTH}
}

