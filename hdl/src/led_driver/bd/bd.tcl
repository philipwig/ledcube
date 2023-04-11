proc init { cellpath otherInfo } {

    set ip [get_bd_cells $cellpath]

    ::bd::send_dbg_msg -of $cellpath  -text  " init Running my init\n"

	set_property CONFIG.FREQ_HZ.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIL_ACLK]
	set_property CONFIG.CLK_DOMAIN.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIL_ACLK]
	set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIL_ACLK]
	set_property CONFIG.PHASE.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIL_ACLK]        

	set_property CONFIG.FREQ_HZ.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIF_ACLK]
	set_property CONFIG.CLK_DOMAIN.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIF_ACLK]
	set_property CONFIG.FREQ_TOLERANCE_HZ.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIF_ACLK]
	set_property CONFIG.PHASE.VALUE_SRC PROPAGATED [get_bd_pins $cellpath/S_AXIF_ACLK]        


    bd::mark_propagate_overrideable $ip {C_S_AXIF_ADDR_WIDTH C_S_AXIF_DATA_WIDTH C_S_AXIF_ID_WIDTH}
    bd::mark_propagate_overrideable $ip {C_AXIL_ADDR_WIDTH C_AXIL_DATA_WIDTH}


}

proc pre_propagate {cellpath otherInfo } {
    # Vivado runs this at the begining of validation
	# set buildtime [clock seconds]
	# set_property CONFIG.BUILD_TIME $buildtime [get_bd_cells $cellpath]
	# puts [concat $cellpath build time has been updated to: [clock format $buildtime]] 
    puts "Test pre_propogate"
}

# Parameters
# N_ROWS_MAX = 64, // Total num rows on panel (64 for 64x64 panel)
# N_COLS_MAX = 64*4, // Number of panels * number of cols per panel
# BITDEPTH_MAX = 8, // Bits per color (bpc), 8 gives 24 bits per pixel, max 10
# LSB_BLANK_MAX = 200,

# CTRL_NUM_REG = 7,

# // ********** Calculated parameters **********
# N_PIXELS = N_ROWS_MAX * N_COLS_MAX,

# // AXI Lite Parameters
# C_AXIL_ADDR_WIDTH = $clog2(CTRL_NUM_REG) + 2, // plus two for byte addressed
# C_AXIL_DATA_WIDTH = 32,

# // AXI Full Parameters
# C_S_AXIF_ID_WIDTH = 2,
# C_S_AXIF_DATA_WIDTH = 32, // Can do max of 10 bpc
# C_S_AXIF_ADDR_WIDTH = $clog2(N_ROWS_MAX * N_COLS_MAX) + 2 // plus two for byte addressed



proc propagate {cellpath otherInfo } {
    # Vivado runs this at the end of validation
    set ip [get_bd_cells $cellpath] 


    # ***********************
    # * Set axil addr width *
    # ***********************
    set axil_addr_width [get_property CONFIG.ADDR_WIDTH [find_bd_objs -relation connected_to [get_bd_intf_pins $ip/S_AXIL]]]
    if { $axil_addr_width == "" } {
        set_property MSG.ERROR "AXIL ADDR_WIDTH not propagated from AXI Interface"
    } else {
        puts "Set C_AXIL_ADDR_WIDTH to $axil_addr_width"
        set_property CONFIG.C_AXIL_ADDR_WIDTH [expr int($axil_addr_width)] $ip
    }

    # ***********************
    # * Set axil data width *
    # ***********************
    set axil_data_width [get_property CONFIG.DATA_WIDTH [find_bd_objs -relation connected_to [get_bd_intf_pins $ip/S_AXIL]]]
    if { $axil_data_width == "" } {
        set_property MSG.ERROR "AXIF DATA_WIDTH not propagated from AXI Interface"
    } else {
        puts "Set C_AXIL_DATA_WIDTH to $axil_data_width"
        set_property CONFIG.C_AXIL_DATA_WIDTH [expr int($axil_data_width)] $ip
    }







    # *********************
    # * Set axif id width *
    # *********************
    set axif_id_width [get_property CONFIG.ID_WIDTH [find_bd_objs -relation connected_to [get_bd_intf_pins $ip/S_AXIF]]]
    if { $axif_id_width == "" } {
        set_property MSG.ERROR "AXIF ID_WIDTH not propagated from AXI Interface"
    } else {
        puts "Set C_S_AXIF_ID_WIDTH to $axif_id_width"
        set_property CONFIG.C_S_AXIF_ID_WIDTH [expr int($axif_id_width)] $ip
    }

    # ***********************
    # * Set axif data width *
    # ***********************
    set axif_data_width [get_property CONFIG.DATA_WIDTH [find_bd_objs -relation connected_to [get_bd_intf_pins $ip/S_AXIF]]]
    if { $axif_data_width == "" } {
        set_property MSG.ERROR "AXIF DATA_WIDTH not propagated from AXI Interface"
    } else {
        puts "Set C_S_AXIF_DATA_WIDTH to $axif_data_width"
        set_property CONFIG.C_S_AXIF_DATA_WIDTH [expr int($axif_data_width)] $ip
    }


    # ***********************
    # * Set axif data width *
    # ***********************
    set axif_addr_width [get_property config.ADDR_WIDTH [find_bd_objs -relation connected_to [get_bd_intf_pins $ip/S_AXIF]]]
    if { $axif_addr_width == "" } {
        set_property MSG.ERROR "AXIF ADDR_WIDTH not propagated from AXI Interface"
    } else {
        puts "Set C_S_AXIF_ADDR_WIDTH to $axif_addr_width"
        set_property CONFIG.C_S_AXIF_ADDR_WIDTH [expr int($axif_addr_width)] $ip
    }



    # set clk_pin_handle [get_bd_pins $cellpath/s_axi_aclk]
    # set freq [get_property CONFIG.FREQ_HZ $clk_pin_handle]
 
    # if { $freq == "" } {
    #   set_property MSG.ERROR "The FEC CTRL AXI CLOCK Frequency is not propagated from AXI Interface" $ip
    # } else {
    #   set freq_Hz [expr int($freq)] 
    #   set_property CONFIG.S_AXI_ACLK_FREQ_HZ $freq_Hz $ip
    # }
}