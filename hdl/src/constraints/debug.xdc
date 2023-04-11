create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/cnt_bit[0]} {design_1_i/led_driver_top_0/inst/driver/cnt_bit[1]} {design_1_i/led_driver_top_0/inst/driver/cnt_bit[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 14 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/bright_counter[0]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[1]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[2]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[3]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[4]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[5]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[6]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[7]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[8]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[9]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[10]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[11]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[12]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 14 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/blank_counter[0]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[1]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[2]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[3]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[4]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[5]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[6]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[7]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[8]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[9]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[10]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[11]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[12]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[13]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/blank_bit[0]} {design_1_i/led_driver_top_0/inst/driver/blank_bit[1]} {design_1_i/led_driver_top_0/inst/driver/blank_bit[2]} {design_1_i/led_driver_top_0/inst/driver/blank_bit[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_buffer[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[0]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[1]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[2]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[3]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[4]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[5]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[6]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[7]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[8]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[9]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[10]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[11]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[12]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[13]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[14]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[15]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[16]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[17]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[18]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[19]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[20]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[21]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[22]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[23]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[24]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[25]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[26]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[27]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[28]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[29]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[30]} {design_1_i/led_driver_top_0/inst/frames/r_lower_dout[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_1_i/led_driver_top_0/inst/frames/w_addr[0]} {design_1_i/led_driver_top_0/inst/frames/w_addr[1]} {design_1_i/led_driver_top_0/inst/frames/w_addr[2]} {design_1_i/led_driver_top_0/inst/frames/w_addr[3]} {design_1_i/led_driver_top_0/inst/frames/w_addr[4]} {design_1_i/led_driver_top_0/inst/frames/w_addr[5]} {design_1_i/led_driver_top_0/inst/frames/w_addr[6]} {design_1_i/led_driver_top_0/inst/frames/w_addr[7]} {design_1_i/led_driver_top_0/inst/frames/w_addr[8]} {design_1_i/led_driver_top_0/inst/frames/w_addr[9]} {design_1_i/led_driver_top_0/inst/frames/w_addr[10]} {design_1_i/led_driver_top_0/inst/frames/w_addr[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 2 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/main_state[0]} {design_1_i/led_driver_top_0/inst/driver/main_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[0]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[1]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[2]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[3]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[4]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[5]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[6]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[7]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[8]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[9]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[10]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[11]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[12]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[13]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[14]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[15]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[16]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[17]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[18]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[19]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[20]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[21]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[22]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[23]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[24]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[25]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[26]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[27]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[28]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[29]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[30]} {design_1_i/led_driver_top_0/inst/frames/r_upper_dout[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 6 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/disp_row[0]} {design_1_i/led_driver_top_0/inst/driver/disp_row[1]} {design_1_i/led_driver_top_0/inst/driver/disp_row[2]} {design_1_i/led_driver_top_0/inst/driver/disp_row[3]} {design_1_i/led_driver_top_0/inst/driver/disp_row[4]} {design_1_i/led_driver_top_0/inst/driver/disp_row[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 5 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/disp_addr[0]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[1]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[2]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[3]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 13 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/mem_addr[0]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[1]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[2]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[3]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[4]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[5]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[6]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[7]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[8]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[9]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[10]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[11]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 6 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/mem_din[0]} {design_1_i/led_driver_top_0/inst/driver/mem_din[1]} {design_1_i/led_driver_top_0/inst/driver/mem_din[2]} {design_1_i/led_driver_top_0/inst/driver/mem_din[3]} {design_1_i/led_driver_top_0/inst/driver/mem_din[4]} {design_1_i/led_driver_top_0/inst/driver/mem_din[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 3 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/mem_bit[0]} {design_1_i/led_driver_top_0/inst/driver/mem_bit[1]} {design_1_i/led_driver_top_0/inst/driver/mem_bit[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {design_1_i/led_driver_top_0/inst/frames/w_dout[0]} {design_1_i/led_driver_top_0/inst/frames/w_dout[1]} {design_1_i/led_driver_top_0/inst/frames/w_dout[2]} {design_1_i/led_driver_top_0/inst/frames/w_dout[3]} {design_1_i/led_driver_top_0/inst/frames/w_dout[4]} {design_1_i/led_driver_top_0/inst/frames/w_dout[5]} {design_1_i/led_driver_top_0/inst/frames/w_dout[6]} {design_1_i/led_driver_top_0/inst/frames/w_dout[7]} {design_1_i/led_driver_top_0/inst/frames/w_dout[8]} {design_1_i/led_driver_top_0/inst/frames/w_dout[9]} {design_1_i/led_driver_top_0/inst/frames/w_dout[10]} {design_1_i/led_driver_top_0/inst/frames/w_dout[11]} {design_1_i/led_driver_top_0/inst/frames/w_dout[12]} {design_1_i/led_driver_top_0/inst/frames/w_dout[13]} {design_1_i/led_driver_top_0/inst/frames/w_dout[14]} {design_1_i/led_driver_top_0/inst/frames/w_dout[15]} {design_1_i/led_driver_top_0/inst/frames/w_dout[16]} {design_1_i/led_driver_top_0/inst/frames/w_dout[17]} {design_1_i/led_driver_top_0/inst/frames/w_dout[18]} {design_1_i/led_driver_top_0/inst/frames/w_dout[19]} {design_1_i/led_driver_top_0/inst/frames/w_dout[20]} {design_1_i/led_driver_top_0/inst/frames/w_dout[21]} {design_1_i/led_driver_top_0/inst/frames/w_dout[22]} {design_1_i/led_driver_top_0/inst/frames/w_dout[23]} {design_1_i/led_driver_top_0/inst/frames/w_dout[24]} {design_1_i/led_driver_top_0/inst/frames/w_dout[25]} {design_1_i/led_driver_top_0/inst/frames/w_dout[26]} {design_1_i/led_driver_top_0/inst/frames/w_dout[27]} {design_1_i/led_driver_top_0/inst/frames/w_dout[28]} {design_1_i/led_driver_top_0/inst/frames/w_dout[29]} {design_1_i/led_driver_top_0/inst/frames/w_dout[30]} {design_1_i/led_driver_top_0/inst/frames/w_dout[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 32 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {design_1_i/led_driver_top_0/inst/frames/w_din[0]} {design_1_i/led_driver_top_0/inst/frames/w_din[1]} {design_1_i/led_driver_top_0/inst/frames/w_din[2]} {design_1_i/led_driver_top_0/inst/frames/w_din[3]} {design_1_i/led_driver_top_0/inst/frames/w_din[4]} {design_1_i/led_driver_top_0/inst/frames/w_din[5]} {design_1_i/led_driver_top_0/inst/frames/w_din[6]} {design_1_i/led_driver_top_0/inst/frames/w_din[7]} {design_1_i/led_driver_top_0/inst/frames/w_din[8]} {design_1_i/led_driver_top_0/inst/frames/w_din[9]} {design_1_i/led_driver_top_0/inst/frames/w_din[10]} {design_1_i/led_driver_top_0/inst/frames/w_din[11]} {design_1_i/led_driver_top_0/inst/frames/w_din[12]} {design_1_i/led_driver_top_0/inst/frames/w_din[13]} {design_1_i/led_driver_top_0/inst/frames/w_din[14]} {design_1_i/led_driver_top_0/inst/frames/w_din[15]} {design_1_i/led_driver_top_0/inst/frames/w_din[16]} {design_1_i/led_driver_top_0/inst/frames/w_din[17]} {design_1_i/led_driver_top_0/inst/frames/w_din[18]} {design_1_i/led_driver_top_0/inst/frames/w_din[19]} {design_1_i/led_driver_top_0/inst/frames/w_din[20]} {design_1_i/led_driver_top_0/inst/frames/w_din[21]} {design_1_i/led_driver_top_0/inst/frames/w_din[22]} {design_1_i/led_driver_top_0/inst/frames/w_din[23]} {design_1_i/led_driver_top_0/inst/frames/w_din[24]} {design_1_i/led_driver_top_0/inst/frames/w_din[25]} {design_1_i/led_driver_top_0/inst/frames/w_din[26]} {design_1_i/led_driver_top_0/inst/frames/w_din[27]} {design_1_i/led_driver_top_0/inst/frames/w_din[28]} {design_1_i/led_driver_top_0/inst/frames/w_din[29]} {design_1_i/led_driver_top_0/inst/frames/w_din[30]} {design_1_i/led_driver_top_0/inst/frames/w_din[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/cnt_col[0]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[1]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[2]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[3]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[4]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[5]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[6]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 6 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/cnt_row[0]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[1]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[2]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[3]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[4]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 4 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {design_1_i/led_driver_top_0/inst/frames/w_strb[0]} {design_1_i/led_driver_top_0/inst/frames/w_strb[1]} {design_1_i/led_driver_top_0/inst/frames/w_strb[2]} {design_1_i/led_driver_top_0/inst/frames/w_strb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 2 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/bcm_state[0]} {design_1_i/led_driver_top_0/inst/driver/bcm_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list design_1_i/led_driver_top_0/inst/driver/bcm_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list design_1_i/led_driver_top_0/inst/driver/bcm_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list design_1_i/led_driver_top_0/inst/driver/blank_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list design_1_i/led_driver_top_0/inst/driver/blank_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list design_1_i/led_driver_top_0/inst/driver/cnt_buffer]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list design_1_i/led_driver_top_0/inst/driver/ctrl_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list design_1_i/led_driver_top_0/inst/driver/ctrl_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list design_1_i/led_driver_top_0/inst/driver/disp_blank]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list design_1_i/led_driver_top_0/inst/driver/disp_clk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list design_1_i/led_driver_top_0/inst/driver/disp_latch]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list design_1_i/led_driver_top_0/inst/driver/irq_disp_sync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list design_1_i/led_driver_top_0/inst/driver/mem_buffer]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list design_1_i/led_driver_top_0/inst/driver/mem_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list design_1_i/led_driver_top_0/inst/frames/mem_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list design_1_i/led_driver_top_0/inst/frames/n_0_0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list design_1_i/led_driver_top_0/inst/frames/n_0_1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list design_1_i/led_driver_top_0/inst/frames/w_buffer]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list design_1_i/led_driver_top_0/inst/frames/w_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
