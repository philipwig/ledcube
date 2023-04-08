###############################################################################
#
#   Constraints file for snickerdoodle black
#
#   Copyright (c) 2016 krtkl inc.
#
###############################################################################
#
#------------------------------------------------------------------------------
# Constraints for GPIO outputs
#------------------------------------------------------------------------------
# JA1 Connector
#------------------------------------------------------------------------------
#### JA1.4 (IO_0_35)
#set_property PACKAGE_PIN    G14         [get_ports {FCLK_CLK1_0}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {FCLK_CLK1_0}]
#set_property PULLUP         TRUE        [get_ports {FCLK_CLK1_0}]

#### JA1.5 (IO_L5P_T0_AD9P_35)
#set_property PACKAGE_PIN    E18         [get_ports {gpio_ja1[5]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[5]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[5]}]

#### JA1.6 (IO_L4N_T0_35)
#set_property PACKAGE_PIN    D20         [get_ports {gpio_ja1[6]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[6]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[6]}]

#### JA1.7 (IO_L5N_T0_AD9N_35)
#set_property PACKAGE_PIN    E19         [get_ports {gpio_ja1[7]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[7]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[7]}]

#### JA1.8 (IO_L4P_T0_35)
#set_property PACKAGE_PIN    D19         [get_ports {gpio_ja1[8]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[8]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[8]}]

### JA1.11 (IO_L6P_T0_35)
set_property PACKAGE_PIN F16 [get_ports {HUB75_0_disp_addr[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_0_disp_addr[0]}]
set_property PULLUP true [get_ports {HUB75_0_disp_addr[0]}]

### JA1.12 (IO_L1N_T0_AD0N_35)
set_property PACKAGE_PIN B20 [get_ports {HUB75_0_disp_addr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_0_disp_addr[1]}]
set_property PULLUP true [get_ports {HUB75_0_disp_addr[1]}]

### JA1.13 (IO_L6N_T0_VREF_35)
set_property PACKAGE_PIN F17 [get_ports {HUB75_0_disp_addr[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_0_disp_addr[2]}]
set_property PULLUP true [get_ports {HUB75_0_disp_addr[2]}]

### JA1.14 (IO_L1P_T0_AD0P_35)
set_property PACKAGE_PIN C20 [get_ports {HUB75_0_disp_addr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_0_disp_addr[3]}]
set_property PULLUP true [get_ports {HUB75_0_disp_addr[3]}]

### JA1.17 (IO_L3P_T0_DQS_AD1P_35)
set_property PACKAGE_PIN E17 [get_ports {HUB75_0_disp_addr[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_0_disp_addr[4]}]
set_property PULLUP true [get_ports {HUB75_0_disp_addr[4]}]

#### JA1.18 (IO_L2N_T0_AD8N_35)
#set_property PACKAGE_PIN    A20         [get_ports {gpio_ja1[18]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[18]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[18]}]

#### JA1.19 (IO_L3N_T0_DQS_AD1N_35)
#set_property PACKAGE_PIN    D18         [get_ports {gpio_ja1[19]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[19]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[19]}]

#### JA1.20 (IO_L2P_T0_AD8P_35)
#set_property PACKAGE_PIN    B19         [get_ports {gpio_ja1[20]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[20]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[20]}]

### JA1.23 (IO_L15P_T2_DQS_AD12P_35)
set_property PACKAGE_PIN F19 [get_ports HUB75_0_disp_r0]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_r0]
set_property PULLUP true [get_ports HUB75_0_disp_r0]

### JA1.24 (IO_L18N_T2_AD13N_35)
set_property PACKAGE_PIN G20 [get_ports HUB75_0_disp_g0]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_g0]
set_property PULLUP true [get_ports HUB75_0_disp_g0]

### JA1.25 (IO_L15N_T2_DQS_AD12N_35)
set_property PACKAGE_PIN F20 [get_ports HUB75_0_disp_b0]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_b0]
set_property PULLUP true [get_ports HUB75_0_disp_b0]

#### JA1.26 (IO_L18P_T2_AD13P_35)
#set_property PACKAGE_PIN    G19         [get_ports {gpio_ja1[26]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[26]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[26]}]

### JA1.29 (IO_L17P_T2_AD5P_35)
set_property PACKAGE_PIN J20 [get_ports HUB75_0_disp_r1]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_r1]
set_property PULLUP true [get_ports HUB75_0_disp_r1]

### JA1.30 (IO_L16N_T2_35)
set_property PACKAGE_PIN G18 [get_ports HUB75_0_disp_g1]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_g1]
set_property PULLUP true [get_ports HUB75_0_disp_g1]

### JA1.31 (IO_L17N_T2_AD5N_35)
set_property PACKAGE_PIN H20 [get_ports HUB75_0_disp_b1]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_b1]
set_property PULLUP true [get_ports HUB75_0_disp_b1]

#### JA1.32 (IO_L16P_T2_35)
#set_property PACKAGE_PIN    G17         [get_ports {gpio_ja1[32]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[32]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[32]}]

### JA1.35 (IO_L14P_T2_AD4P_SRCC_35)
set_property PACKAGE_PIN J18 [get_ports HUB75_0_disp_clk]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_clk]
set_property PULLUP true [get_ports HUB75_0_disp_clk]

### JA1.36 (IO_L13N_T2_MRCC_35)
set_property PACKAGE_PIN H17 [get_ports HUB75_0_disp_blank]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_blank]
set_property PULLUP true [get_ports HUB75_0_disp_blank]

### JA1.37 (IO_L14N_T2_AD4N_SRCC_35)
set_property PACKAGE_PIN H18 [get_ports HUB75_0_disp_latch]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_0_disp_latch]
set_property PULLUP true [get_ports HUB75_0_disp_latch]

#### JA1.38 (IO_L13P_T2_MRCC_35)
#set_property PACKAGE_PIN    H16         [get_ports {gpio_ja1[38]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio_ja1[38]}]
#set_property PULLUP         TRUE        [get_ports {gpio_ja1[38]}]

##------------------------------------------------------------------------------
## JA2 Connector
##------------------------------------------------------------------------------
#### JA2.4 (IO_25_35)
#set_property PACKAGE_PIN    J15         [get_ports {gpio1_tri_io[24]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[24]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[24]}]

#### JA2.5 (IO_L22P_T3_AD7P_35)
#set_property PACKAGE_PIN    L14         [get_ports {gpio1_tri_io[8]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[8]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[8]}]

#### JA2.6 (IO_L24N_T3_AD15N_35)
#set_property PACKAGE_PIN    J16         [get_ports {gpio1_tri_io[11]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[11]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[11]}]

#### JA2.7 (IO_L22N_T3_AD7N_35)
#set_property PACKAGE_PIN    L15         [get_ports {gpio1_tri_io[9]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[9]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[9]}]

#### JA2.8 (IO_L24P_T3_AD15P_35)
#set_property PACKAGE_PIN    K16         [get_ports {gpio1_tri_io[10]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[10]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[10]}]

#### JA2.11 (IO_L23P_T3_35)
#set_property PACKAGE_PIN    M14         [get_ports {gpio1_tri_io[12]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[12]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[8]}]

#### JA2.12 (IO_L19N_T3_VREF_35)
#set_property PACKAGE_PIN    G15         [get_ports {gpio1_tri_io[15]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[15]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[15]}]

#### JA2.13 (IO_L23N_T3_35)
#set_property PACKAGE_PIN    M15         [get_ports {gpio1_tri_io[13]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[13]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[13]}]

#### JA2.14 (IO_L19P_T3_35)
#set_property PACKAGE_PIN    H15         [get_ports {gpio1_tri_io[14]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[14]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[14]}]

#### JA2.17 (IO_L21P_T3_DQS_AD14P_35)
#set_property PACKAGE_PIN    N15         [get_ports {gpio1_tri_io[20]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[20]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[20]}]

#### JA2.18 (IO_L20N_T3_AD6N_35)
#set_property PACKAGE_PIN    J14         [get_ports {gpio1_tri_io[17]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[17]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[17]}]

#### JA2.19 (IO_L21N_T3_DQS_AD14N_35)
#set_property PACKAGE_PIN    N16         [get_ports {gpio1_tri_io[21]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[21]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[21]}]

#### JA2.20 (IO_L20P_T3_AD6P_35)
#set_property PACKAGE_PIN    K14         [get_ports {gpio1_tri_io[16]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[16]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[16]}]

#### JA2.23 (IO_L9P_T1_DQS_AD3P_35)
#set_property PACKAGE_PIN    L19         [get_ports {gpio1_tri_io[18]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[18]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[18]}]

#### JA2.24 (IO_L10N_T1_AD11N_35)
#set_property PACKAGE_PIN    J19         [get_ports {gpio1_tri_io[1]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[1]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[1]}]

#### JA2.25 (IO_L9N_T1_DQS_AD3N_35)
#set_property PACKAGE_PIN    L20         [get_ports {gpio1_tri_io[19]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[19]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[19]}]

#### JA2.26 (IO_L10P_T1_AD11P_35)
#set_property PACKAGE_PIN    K19         [get_ports {gpio1_tri_io[0]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[0]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[0]}]

#### JA2.29 (IO_L8P_T1_AD10P_35)
#set_property PACKAGE_PIN    M17         [get_ports {gpio1_tri_io[2]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[2]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[2]}]

#### JA2.30 (IO_L7N_T1_AD2N_35)
#set_property PACKAGE_PIN    M20         [get_ports {gpio1_tri_io[5]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[5]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[5]}]

#### JA2.31 (IO_L8N_T1_AD10N_35)
#set_property PACKAGE_PIN    M18         [get_ports {gpio1_tri_io[3]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[3]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[3]}]

#### JA2.32 (IO_L7P_T1_AD2P_35)
#set_property PACKAGE_PIN    M19         [get_ports {gpio1_tri_io[4]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[4]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[4]}]

#### JA2.35 (IO_L11P_T1_SRCC_35)
#set_property PACKAGE_PIN    L16         [get_ports {gpio1_tri_io[6]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[6]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[6]}]

#### JA2.36 (IO_L12N_T1_MRCC_35)
#set_property PACKAGE_PIN    K18         [get_ports {gpio1_tri_io[23]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[23]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[23]}]

#### JA2.37 (IO_L11N_T1_SRCC_35)
#set_property PACKAGE_PIN    L17         [get_ports {gpio1_tri_io[7]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[7]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[7]}]

#### JA2.38 (IO_L12P_T1_MRCC_35)
#set_property PACKAGE_PIN    K17         [get_ports {gpio1_tri_io[22]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio1_tri_io[22]}]
#set_property PULLUP         TRUE        [get_ports {gpio1_tri_io[22]}]

##------------------------------------------------------------------------------
## JB1 Connector
##------------------------------------------------------------------------------
#### JB1.4 (IO_25_34)
#set_property PACKAGE_PIN    T19         [get_ports {gpio2_tri_io[24]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[24]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[24]}]

#### JB1.5 (IO_L1P_T0_34)
#set_property PACKAGE_PIN    T11         [get_ports {gpio2_tri_io[8]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[8]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[8]}]

#### JB1.6 (IO_L2N_T0_34)
#set_property PACKAGE_PIN    U12         [get_ports {gpio2_tri_io[11]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[11]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[11]}]

#### JB1.7 (IO_L1N_T0_34)
#set_property PACKAGE_PIN    T10         [get_ports {gpio2_tri_io[9]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[9]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[9]}]

#### JB1.8 (IO_L2P_T0_34)
#set_property PACKAGE_PIN    T12         [get_ports {gpio2_tri_io[10]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[10]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[10]}]

### JB1.11 (IO_L6P_T0_34)
set_property PACKAGE_PIN P14 [get_ports {HUB75_1_disp_addr[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_1_disp_addr[0]}]
set_property PULLUP true [get_ports {HUB75_1_disp_addr[0]}]

### JB1.12 (IO_L4N_T0_34)
set_property PACKAGE_PIN W13 [get_ports {HUB75_1_disp_addr[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_1_disp_addr[1]}]
set_property PULLUP true [get_ports {HUB75_1_disp_addr[1]}]

### JB1.13 (IO_L6N_T0_VREF_34)
set_property PACKAGE_PIN R14 [get_ports {HUB75_1_disp_addr[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_1_disp_addr[2]}]
set_property PULLUP true [get_ports {HUB75_1_disp_addr[2]}]

#### JB1.14 (IO_L4P_T0_34)
set_property PACKAGE_PIN V12 [get_ports {HUB75_1_disp_addr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_1_disp_addr[3]}]
set_property PULLUP true [get_ports {HUB75_1_disp_addr[3]}]

### JB1.17 (IO_L3P_T0_DQS_PUDC_B_34)
set_property PACKAGE_PIN U13 [get_ports {HUB75_1_disp_addr[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HUB75_1_disp_addr[4]}]
set_property PULLUP true [get_ports {HUB75_1_disp_addr[4]}]

#### JB1.18 (IO_L5N_T0_34)
#set_property PACKAGE_PIN    T15         [get_ports {gpio2_tri_io[17]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[17]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[17]}]

#### JB1.19 (IO_L3N_T0_DQS_34)
#set_property PACKAGE_PIN    V13         [get_ports {gpio2_tri_io[21]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[21]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[21]}]

#### JB1.20 (IO_L5P_T0_34)
#set_property PACKAGE_PIN    T14         [get_ports {gpio2_tri_io[16]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[16]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[16]}]

### JB1.23 (IO_L9P_T1_DQS_34)
set_property PACKAGE_PIN T16 [get_ports HUB75_1_disp_r0]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_r0]
set_property PULLUP true [get_ports HUB75_1_disp_r0]

### JB1.24 (IO_L7N_T1_34)
set_property PACKAGE_PIN Y17 [get_ports HUB75_1_disp_g0]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_g0]
set_property PULLUP true [get_ports HUB75_1_disp_g0]

### JB1.25 (IO_L9N_T1_DQS_34)
set_property PACKAGE_PIN U17 [get_ports HUB75_1_disp_b0]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_b0]
set_property PULLUP true [get_ports HUB75_1_disp_b0]

#### JB1.26 (IO_L7P_T1_34)
#set_property PACKAGE_PIN    Y16         [get_ports {gpio2_tri_io[0]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[0]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[0]}]

### JB1.29 (IO_L8P_T1_34)
set_property PACKAGE_PIN W14 [get_ports HUB75_1_disp_r1]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_r1]
set_property PULLUP true [get_ports HUB75_1_disp_r1]

### JB1.30 (IO_L10N_T1_34)
set_property PACKAGE_PIN W15 [get_ports HUB75_1_disp_g1]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_g1]
set_property PULLUP true [get_ports HUB75_1_disp_g1]

### JB1.31 (IO_L8N_T1_34)
set_property PACKAGE_PIN Y14 [get_ports HUB75_1_disp_b1]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_b1]
set_property PULLUP true [get_ports HUB75_1_disp_b1]

#### JB1.32 (IO_L10P_T1_34)
#set_property PACKAGE_PIN    V15         [get_ports {gpio2_tri_io[4]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[4]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[4]}]

### JB1.35 (IO_L11P_T1_SRCC_34)
set_property PACKAGE_PIN U14 [get_ports HUB75_1_disp_clk]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_clk]
set_property PULLUP true [get_ports HUB75_1_disp_clk]

### JB1.36 (IO_L12N_T1_MRCC_34)
set_property PACKAGE_PIN U19 [get_ports HUB75_1_disp_blank]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_blank]
set_property PULLUP true [get_ports HUB75_1_disp_blank]

### JB1.37 (IO_L11N_T1_SRCC_34)
set_property PACKAGE_PIN U15 [get_ports HUB75_1_disp_latch]
set_property IOSTANDARD LVCMOS33 [get_ports HUB75_1_disp_latch]
set_property PULLUP true [get_ports HUB75_1_disp_latch]

#### JB1.38 (IO_L12P_T1_MRCC_34)
#set_property PACKAGE_PIN    U18         [get_ports {gpio2_tri_io[22]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio2_tri_io[22]}]
#set_property PULLUP         TRUE        [get_ports {gpio2_tri_io[22]}]

##------------------------------------------------------------------------------
## JB2 Connector
##------------------------------------------------------------------------------
#### JB2.4 (IO_0_34)
#set_property PACKAGE_PIN    R19         [get_ports {gpio3_tri_io[24]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[24]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[24]}]

#### JB2.5 (IO_L23P_T3_34)
#set_property PACKAGE_PIN    N17         [get_ports {gpio3_tri_io[8]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[8]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[8]}]

#### JB2.6 (IO_L24N_T3_34)
#set_property PACKAGE_PIN    P16         [get_ports {gpio3_tri_io[11]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[11]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[11]}]

#### JB2.7 (IO_L23N_T3_34)
#set_property PACKAGE_PIN    P18         [get_ports {gpio3_tri_io[9]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[9]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[9]}]

#### JB2.8 (IO_L24P_T3_34)
#set_property PACKAGE_PIN    P15         [get_ports {gpio3_tri_io[10]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[10]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[10]}]

#### JB2.11 (IO_L20P_T3_34)
#set_property PACKAGE_PIN    T17         [get_ports {gpio3_tri_io[12]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[12]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[12]}]

#### JB2.12 (IO_L19N_T3_VREF_34)
#set_property PACKAGE_PIN    R17         [get_ports {gpio3_tri_io[15]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[15]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[15]}]

#### JB2.13 (IO_L20N_T3_34)
#set_property PACKAGE_PIN    R18         [get_ports {gpio3_tri_io[13]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[13]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[13]}]

#### JB2.14 (IO_L19P_T3_34)
#set_property PACKAGE_PIN    R16         [get_ports {gpio3_tri_io[14]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[14]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[14]}]

#### JB2.17 (IO_L21P_T3_DQS_34)
#set_property PACKAGE_PIN    V17         [get_ports {gpio3_tri_io[20]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[20]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[20]}]

#### JB2.18 (IO_L22N_T3_34)
#set_property PACKAGE_PIN    W19         [get_ports {gpio3_tri_io[17]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[17]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[17]}]

#### JB2.19 (IO_L21N_T3_DQS_34)
#set_property PACKAGE_PIN    V18         [get_ports {gpio3_tri_io[21]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[21]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[21]}]

#### JB2.20 (IO_L22P_T3_34)
#set_property PACKAGE_PIN    W18         [get_ports {gpio3_tri_io[16]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[16]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[16]}]

#### JB2.23 (IO_L15P_T2_DQS_34)
#set_property PACKAGE_PIN    T20         [get_ports {gpio3_tri_io[18]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[18]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[18]}]

#### JB2.24 (IO_L18N_T2_34)
#set_property PACKAGE_PIN    W16         [get_ports {gpio3_tri_io[1]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[1]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[1]}]

#### JB2.25 (IO_L15N_T2_DQS_34)
#set_property PACKAGE_PIN    U20         [get_ports {gpio3_tri_io[19]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[19]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[19]}]

#### JB2.26 (IO_L18P_T2_34)
#set_property PACKAGE_PIN    V16         [get_ports {gpio3_tri_io[0]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[0]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[0]}]

#### JB2.29 (IO_L16P_T2_34)
#set_property PACKAGE_PIN    V20         [get_ports {gpio3_tri_io[2]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[2]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[2]}]

#### JB2.30 (IO_L17N_T2_34)
#set_property PACKAGE_PIN    Y19         [get_ports {gpio3_tri_io[5]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[5]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[5]}]

#### JB2.31 (IO_L16N_T2_34)
#set_property PACKAGE_PIN    W20         [get_ports {gpio3_tri_io[3]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[3]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[3]}]

#### JB2.32 (IO_L17P_T2_34)
#set_property PACKAGE_PIN    Y18         [get_ports {gpio3_tri_io[4]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[4]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[4]}]

#### JB2.35 (IO_L14P_T2_SRCC_34)
#set_property PACKAGE_PIN    N20         [get_ports {gpio3_tri_io[6]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[6]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[6]}]

#### JB2.36 (IO_L13N_T2_MRCC_34)
#set_property PACKAGE_PIN    P19         [get_ports {gpio3_tri_io[23]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[23]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[23]}]

#### JB2.37 (IO_L14N_T2_SRCC_34)
#set_property PACKAGE_PIN    P20         [get_ports {gpio3_tri_io[7]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[7]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[7]}]

#### JB2.38 (IO_L13P_T2_MRCC_34)
#set_property PACKAGE_PIN    N18         [get_ports {gpio3_tri_io[22]}]
#set_property IOSTANDARD     LVCMOS33    [get_ports {gpio3_tri_io[22]}]
#set_property PULLUP         TRUE        [get_ports {gpio3_tri_io[22]}]



set_output_delay -clock [get_clocks clk_fpga_0] 2.000 [get_ports -filter { NAME =~  "*disp*" && DIRECTION == "OUT" }]



connect_debug_port u_ila_0/probe13 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/p_0_in[0]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[1]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[2]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[3]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[4]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[5]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[6]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[7]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[8]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[9]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[10]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[11]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[12]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[13]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[14]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[15]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[16]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[17]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[18]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[19]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[20]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[21]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[22]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[23]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[24]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[25]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[26]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[27]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[28]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[29]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[30]} {design_1_i/led_driver_top_0/inst/driver/p_0_in[31]}]]
connect_debug_port u_ila_0/probe153 [get_nets [list design_1_i/led_driver_top_0/inst/driver/p_3_in]]




connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/cnt_row[0]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[1]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[2]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[3]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[4]} {design_1_i/led_driver_top_0/inst/driver/cnt_row[5]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/cnt_bit[0]} {design_1_i/led_driver_top_0/inst/driver/cnt_bit[1]} {design_1_i/led_driver_top_0/inst/driver/cnt_bit[2]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_brightness[31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/blank_counter[0]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[1]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[2]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[3]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[4]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[5]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[6]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[7]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[8]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[9]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[10]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[11]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[12]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[13]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[14]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[15]} {design_1_i/led_driver_top_0/inst/driver/blank_counter[16]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/main_state[0]} {design_1_i/led_driver_top_0/inst/driver/main_state[1]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/cnt_col[0]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[1]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[2]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[3]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[4]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[5]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[6]} {design_1_i/led_driver_top_0/inst/driver/cnt_col[7]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_bitdepth[31]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_lsb_blank[31]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/blank_bit[0]} {design_1_i/led_driver_top_0/inst/driver/blank_bit[1]} {design_1_i/led_driver_top_0/inst/driver/blank_bit[2]} {design_1_i/led_driver_top_0/inst/driver/blank_bit[3]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/bright_counter[0]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[1]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[2]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[3]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[4]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[5]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[6]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[7]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[8]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[9]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[10]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[11]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[12]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[13]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[14]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[15]} {design_1_i/led_driver_top_0/inst/driver/bright_counter[16]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/mem_addr[0]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[1]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[2]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[3]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[4]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[5]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[6]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[7]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[8]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[9]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[10]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[11]} {design_1_i/led_driver_top_0/inst/driver/mem_addr[12]}]]
connect_debug_port u_ila_0/probe11 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/mem_din[0]} {design_1_i/led_driver_top_0/inst/driver/mem_din[1]} {design_1_i/led_driver_top_0/inst/driver/mem_din[2]} {design_1_i/led_driver_top_0/inst/driver/mem_din[3]} {design_1_i/led_driver_top_0/inst/driver/mem_din[4]} {design_1_i/led_driver_top_0/inst/driver/mem_din[5]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/mem_bit[0]} {design_1_i/led_driver_top_0/inst/driver/mem_bit[1]} {design_1_i/led_driver_top_0/inst/driver/mem_bit[2]}]]
connect_debug_port u_ila_0/probe13 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_rows[31]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/disp_row[0]} {design_1_i/led_driver_top_0/inst/driver/disp_row[1]} {design_1_i/led_driver_top_0/inst/driver/disp_row[2]} {design_1_i/led_driver_top_0/inst/driver/disp_row[3]} {design_1_i/led_driver_top_0/inst/driver/disp_row[4]} {design_1_i/led_driver_top_0/inst/driver/disp_row[5]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/disp_addr[0]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[1]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[2]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[3]} {design_1_i/led_driver_top_0/inst/driver/disp_addr[4]}]]
connect_debug_port u_ila_0/probe16 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[0]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[1]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[2]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[3]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[4]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[5]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[6]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[7]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[8]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[9]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[10]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[11]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[12]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[13]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[14]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[15]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[16]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[17]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[18]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[19]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[20]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[21]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[22]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[23]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[24]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[25]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[26]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[27]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[28]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[29]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[30]} {design_1_i/led_driver_top_0/inst/driver/ctrl_n_cols[31]}]]
connect_debug_port u_ila_0/probe17 [get_nets [list {design_1_i/led_driver_top_0/inst/axi_lite/awskd_addr[0]} {design_1_i/led_driver_top_0/inst/axi_lite/awskd_addr[1]} {design_1_i/led_driver_top_0/inst/axi_lite/awskd_addr[2]}]]
connect_debug_port u_ila_0/probe18 [get_nets [list {design_1_i/led_driver_top_0/inst/driver/bcm_state[0]} {design_1_i/led_driver_top_0/inst/driver/bcm_state[1]}]]
connect_debug_port u_ila_0/probe19 [get_nets [list design_1_i/led_driver_top_0/inst/axi_lite/axil_write_ready]]
connect_debug_port u_ila_0/probe20 [get_nets [list design_1_i/led_driver_top_0/inst/driver/bcm_en]]
connect_debug_port u_ila_0/probe21 [get_nets [list design_1_i/led_driver_top_0/inst/driver/bcm_rdy]]
connect_debug_port u_ila_0/probe22 [get_nets [list design_1_i/led_driver_top_0/inst/driver/blank_en]]
connect_debug_port u_ila_0/probe23 [get_nets [list design_1_i/led_driver_top_0/inst/driver/blank_rdy]]
connect_debug_port u_ila_0/probe24 [get_nets [list design_1_i/led_driver_top_0/inst/driver/cnt_buffer]]
connect_debug_port u_ila_0/probe25 [get_nets [list design_1_i/led_driver_top_0/inst/driver/ctrl_en]]
connect_debug_port u_ila_0/probe26 [get_nets [list design_1_i/led_driver_top_0/inst/driver/ctrl_rst]]
connect_debug_port u_ila_0/probe27 [get_nets [list design_1_i/led_driver_top_0/inst/driver/disp_blank]]
connect_debug_port u_ila_0/probe28 [get_nets [list design_1_i/led_driver_top_0/inst/driver/disp_clk]]
connect_debug_port u_ila_0/probe29 [get_nets [list design_1_i/led_driver_top_0/inst/driver/disp_latch]]
connect_debug_port u_ila_0/probe30 [get_nets [list design_1_i/led_driver_top_0/inst/driver/mem_buffer]]
connect_debug_port u_ila_0/probe31 [get_nets [list design_1_i/led_driver_top_0/inst/driver/mem_en]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list design_1_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 13 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/mem_addr[0]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[1]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[2]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[3]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[4]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[5]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[6]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[7]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[8]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[9]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[10]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[11]} {design_1_i/led_driver_top_1/inst/driver/mem_addr[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 3 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/mem_bit[0]} {design_1_i/led_driver_top_1/inst/driver/mem_bit[1]} {design_1_i/led_driver_top_1/inst/driver/mem_bit[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/bcm_state[0]} {design_1_i/led_driver_top_1/inst/driver/bcm_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 6 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/mem_din[0]} {design_1_i/led_driver_top_1/inst/driver/mem_din[1]} {design_1_i/led_driver_top_1/inst/driver/mem_din[2]} {design_1_i/led_driver_top_1/inst/driver/mem_din[3]} {design_1_i/led_driver_top_1/inst/driver/mem_din[4]} {design_1_i/led_driver_top_1/inst/driver/mem_din[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 17 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/bright_counter[0]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[1]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[2]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[3]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[4]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[5]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[6]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[7]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[8]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[9]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[10]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[11]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[12]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[13]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[14]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[15]} {design_1_i/led_driver_top_1/inst/driver/bright_counter[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 3 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/cnt_bit[0]} {design_1_i/led_driver_top_1/inst/driver/cnt_bit[1]} {design_1_i/led_driver_top_1/inst/driver/cnt_bit[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[0]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[1]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[2]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[3]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[4]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[5]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[6]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[7]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[8]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[9]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[10]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[11]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[12]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[13]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[14]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[15]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[16]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[17]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[18]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[19]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[20]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[21]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[22]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[23]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[24]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[25]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[26]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[27]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[28]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[29]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[30]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_rows[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[0]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[1]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[2]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[3]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[4]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[5]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[6]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[7]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[8]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[9]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[10]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[11]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[12]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[13]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[14]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[15]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[16]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[17]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[18]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[19]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[20]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[21]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[22]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[23]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[24]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[25]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[26]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[27]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[28]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[29]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[30]} {design_1_i/led_driver_top_1/inst/driver/ctrl_bitdepth[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 6 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/disp_row[0]} {design_1_i/led_driver_top_1/inst/driver/disp_row[1]} {design_1_i/led_driver_top_1/inst/driver/disp_row[2]} {design_1_i/led_driver_top_1/inst/driver/disp_row[3]} {design_1_i/led_driver_top_1/inst/driver/disp_row[4]} {design_1_i/led_driver_top_1/inst/driver/disp_row[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/blank_bit[0]} {design_1_i/led_driver_top_1/inst/driver/blank_bit[1]} {design_1_i/led_driver_top_1/inst/driver/blank_bit[2]} {design_1_i/led_driver_top_1/inst/driver/blank_bit[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 2 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/main_state[0]} {design_1_i/led_driver_top_1/inst/driver/main_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[0]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[1]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[2]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[3]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[4]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[5]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[6]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[7]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[8]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[9]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[10]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[11]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[12]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[13]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[14]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[15]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[16]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[17]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[18]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[19]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[20]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[21]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[22]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[23]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[24]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[25]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[26]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[27]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[28]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[29]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[30]} {design_1_i/led_driver_top_1/inst/driver/ctrl_n_cols[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 5 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/disp_addr[0]} {design_1_i/led_driver_top_1/inst/driver/disp_addr[1]} {design_1_i/led_driver_top_1/inst/driver/disp_addr[2]} {design_1_i/led_driver_top_1/inst/driver/disp_addr[3]} {design_1_i/led_driver_top_1/inst/driver/disp_addr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/cnt_col[0]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[1]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[2]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[3]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[4]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[5]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[6]} {design_1_i/led_driver_top_1/inst/driver/cnt_col[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 17 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/blank_counter[0]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[1]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[2]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[3]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[4]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[5]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[6]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[7]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[8]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[9]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[10]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[11]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[12]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[13]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[14]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[15]} {design_1_i/led_driver_top_1/inst/driver/blank_counter[16]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[0]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[1]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[2]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[3]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[4]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[5]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[6]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[7]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[8]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[9]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[10]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[11]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[12]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[13]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[14]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[15]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[16]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[17]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[18]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[19]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[20]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[21]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[22]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[23]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[24]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[25]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[26]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[27]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[28]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[29]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[30]} {design_1_i/led_driver_top_1/inst/driver/ctrl_lsb_blank[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 32 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[0]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[1]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[2]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[3]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[4]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[5]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[6]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[7]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[8]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[9]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[10]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[11]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[12]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[13]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[14]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[15]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[16]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[17]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[18]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[19]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[20]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[21]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[22]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[23]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[24]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[25]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[26]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[27]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[28]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[29]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[30]} {design_1_i/led_driver_top_1/inst/driver/ctrl_brightness[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 6 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {design_1_i/led_driver_top_1/inst/driver/cnt_row[0]} {design_1_i/led_driver_top_1/inst/driver/cnt_row[1]} {design_1_i/led_driver_top_1/inst/driver/cnt_row[2]} {design_1_i/led_driver_top_1/inst/driver/cnt_row[3]} {design_1_i/led_driver_top_1/inst/driver/cnt_row[4]} {design_1_i/led_driver_top_1/inst/driver/cnt_row[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list design_1_i/led_driver_top_1/inst/driver/bcm_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list design_1_i/led_driver_top_1/inst/driver/bcm_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list design_1_i/led_driver_top_1/inst/driver/blank_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list design_1_i/led_driver_top_1/inst/driver/blank_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list design_1_i/led_driver_top_1/inst/driver/cnt_buffer]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list design_1_i/led_driver_top_1/inst/driver/ctrl_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list design_1_i/led_driver_top_1/inst/driver/ctrl_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list design_1_i/led_driver_top_1/inst/driver/disp_blank]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list design_1_i/led_driver_top_1/inst/driver/disp_clk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list design_1_i/led_driver_top_1/inst/driver/disp_latch]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list design_1_i/led_driver_top_1/inst/driver/mem_buffer]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list design_1_i/led_driver_top_1/inst/driver/mem_en]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
