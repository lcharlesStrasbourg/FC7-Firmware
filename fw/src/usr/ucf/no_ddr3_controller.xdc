################################
### IOSTANDARD
################################

set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_dq}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_addr}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_ba}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_ras_n}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_cas_n}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_we_n}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_reset_n}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_cke}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_odt}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_cs_n}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_dm}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_dqs_p}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_dqs_n}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_ck_p}]
set_property IOSTANDARD LVCMOS25 [get_ports {ddr3_ck_n}]

set_property IOSTANDARD LVCMOS25 	[get_ports {ddr3_sys_clk_p}]


################################
### PIN MAP
################################

# clock
set_property PACKAGE_PIN H27        [get_ports ddr3_sys_clk_p]

# PadFunction: IO_L13P_T2_MRCC_18 
set_property PACKAGE_PIN E19 [get_ports {ddr3_dq[0]}]

# PadFunction: IO_L14P_T2_SRCC_18 
set_property PACKAGE_PIN C18 [get_ports {ddr3_dq[1]}]

# PadFunction: IO_L13N_T2_MRCC_18 
set_property PACKAGE_PIN D19 [get_ports {ddr3_dq[2]}]

# PadFunction: IO_L16P_T2_18 
set_property PACKAGE_PIN C17 [get_ports {ddr3_dq[3]}]

# PadFunction: IO_L17N_T2_18 
set_property PACKAGE_PIN A16 [get_ports {ddr3_dq[4]}]

# PadFunction: IO_L18P_T2_18 
set_property PACKAGE_PIN B18 [get_ports {ddr3_dq[5]}]

# PadFunction: IO_L16N_T2_18 
set_property PACKAGE_PIN B17 [get_ports {ddr3_dq[6]}]

# PadFunction: IO_L17P_T2_18 
set_property PACKAGE_PIN B16 [get_ports {ddr3_dq[7]}]

# PadFunction: IO_L1N_T0_18 
set_property PACKAGE_PIN H20 [get_ports {ddr3_dq[8]}]

# PadFunction: IO_L2N_T0_18 
set_property PACKAGE_PIN H18 [get_ports {ddr3_dq[9]}]

# PadFunction: IO_L1P_T0_18 
set_property PACKAGE_PIN H19 [get_ports {ddr3_dq[10]}]

# PadFunction: IO_L4N_T0_18 
set_property PACKAGE_PIN E16 [get_ports {ddr3_dq[11]}]

# PadFunction: IO_L5P_T0_18 
set_property PACKAGE_PIN E17 [get_ports {ddr3_dq[12]}]

# PadFunction: IO_L4P_T0_18 
set_property PACKAGE_PIN F16 [get_ports {ddr3_dq[13]}]

# PadFunction: IO_L6P_T0_18 
set_property PACKAGE_PIN F18 [get_ports {ddr3_dq[14]}]

# PadFunction: IO_L2P_T0_18 
set_property PACKAGE_PIN H17 [get_ports {ddr3_dq[15]}]

# PadFunction: IO_L22N_T3_18 
set_property PACKAGE_PIN A21 [get_ports {ddr3_dq[16]}]

# PadFunction: IO_L23N_T3_18 
set_property PACKAGE_PIN A23 [get_ports {ddr3_dq[17]}]

# PadFunction: IO_L22P_T3_18 
set_property PACKAGE_PIN B21 [get_ports {ddr3_dq[18]}]

# PadFunction: IO_L24N_T3_18 
set_property PACKAGE_PIN B23 [get_ports {ddr3_dq[19]}]

# PadFunction: IO_L20P_T3_18 
set_property PACKAGE_PIN C20 [get_ports {ddr3_dq[20]}]

# PadFunction: IO_L19P_T3_18 
set_property PACKAGE_PIN D22 [get_ports {ddr3_dq[21]}]

# PadFunction: IO_L20N_T3_18 
set_property PACKAGE_PIN B20 [get_ports {ddr3_dq[22]}]

# PadFunction: IO_L23P_T3_18 
set_property PACKAGE_PIN B22 [get_ports {ddr3_dq[23]}]

# PadFunction: IO_L10N_T1_18 
set_property PACKAGE_PIN E23 [get_ports {ddr3_dq[24]}]

# PadFunction: IO_L8P_T1_18 
set_property PACKAGE_PIN F20 [get_ports {ddr3_dq[25]}]

# PadFunction: IO_L8N_T1_18 
set_property PACKAGE_PIN F21 [get_ports {ddr3_dq[26]}]

# PadFunction: IO_L11N_T1_SRCC_18 
set_property PACKAGE_PIN D21 [get_ports {ddr3_dq[27]}]

# PadFunction: IO_L10P_T1_18 
set_property PACKAGE_PIN F23 [get_ports {ddr3_dq[28]}]

# PadFunction: IO_L11P_T1_SRCC_18 
set_property PACKAGE_PIN D20 [get_ports {ddr3_dq[29]}]

# PadFunction: IO_L7N_T1_18 
set_property PACKAGE_PIN G21 [get_ports {ddr3_dq[30]}]

# PadFunction: IO_L12P_T1_MRCC_18 
set_property PACKAGE_PIN E21 [get_ports {ddr3_dq[31]}]

# PadFunction: IO_L5N_T0_17 
set_property PACKAGE_PIN A28 [get_ports {ddr3_addr[13]}]

# PadFunction: IO_L1N_T0_17 
set_property PACKAGE_PIN C25 [get_ports {ddr3_addr[12]}]

# PadFunction: IO_L8N_T1_17 
set_property PACKAGE_PIN D27 [get_ports {ddr3_addr[11]}]

# PadFunction: IO_L11P_T1_SRCC_17 
set_property PACKAGE_PIN F25 [get_ports {ddr3_addr[10]}]

# PadFunction: IO_L5P_T0_17 
set_property PACKAGE_PIN B28 [get_ports {ddr3_addr[9]}]

# PadFunction: IO_L10P_T1_17 
set_property PACKAGE_PIN F28 [get_ports {ddr3_addr[8]}]

# PadFunction: IO_L12N_T1_MRCC_17 
set_property PACKAGE_PIN E27 [get_ports {ddr3_addr[7]}]

# PadFunction: IO_L10N_T1_17 
set_property PACKAGE_PIN E28 [get_ports {ddr3_addr[6]}]

# PadFunction: IO_L17N_T2_17 
set_property PACKAGE_PIN G28 [get_ports {ddr3_addr[5]}]

# PadFunction: IO_L17P_T2_17 
set_property PACKAGE_PIN H28 [get_ports {ddr3_addr[4]}]

# PadFunction: IO_L12P_T1_MRCC_17 
set_property PACKAGE_PIN E26 [get_ports {ddr3_addr[3]}]

# PadFunction: IO_L6P_T0_17 
set_property PACKAGE_PIN C27 [get_ports {ddr3_addr[2]}]

# PadFunction: IO_L8P_T1_17 
set_property PACKAGE_PIN D26 [get_ports {ddr3_addr[1]}]

# PadFunction: IO_L4N_T0_17 
set_property PACKAGE_PIN B27 [get_ports {ddr3_addr[0]}]

# PadFunction: IO_L3N_T0_DQS_17 
set_property PACKAGE_PIN A26 [get_ports {ddr3_ba[2]}]

# PadFunction: IO_L11N_T1_SRCC_17 
set_property PACKAGE_PIN F26 [get_ports {ddr3_ba[1]}]

# PadFunction: IO_L4P_T0_17 
set_property PACKAGE_PIN B26 [get_ports {ddr3_ba[0]}]

# PadFunction: IO_L2P_T0_17 
set_property PACKAGE_PIN A24 [get_ports {ddr3_ras_n}]

# PadFunction: IO_L2N_T0_17 
set_property PACKAGE_PIN A25 [get_ports {ddr3_cas_n}]

# PadFunction: IO_L3P_T0_DQS_17 
set_property PACKAGE_PIN B25 [get_ports {ddr3_we_n}]

# PadFunction: IO_L12N_T1_MRCC_18 
set_property PACKAGE_PIN E22 [get_ports {ddr3_reset_n}]

# PadFunction: IO_L7N_T1_17 
set_property PACKAGE_PIN E24 [get_ports {ddr3_cke[0]}]

# PadFunction: IO_L1P_T0_17 
set_property PACKAGE_PIN C24 [get_ports {ddr3_odt[0]}]

# PadFunction: IO_L7P_T1_17 
set_property PACKAGE_PIN F24 [get_ports {ddr3_cs_n[0]}]

# PadFunction: IO_L14N_T2_SRCC_18 
set_property PACKAGE_PIN C19 [get_ports {ddr3_dm[0]}]

# PadFunction: IO_L5N_T0_18 
set_property PACKAGE_PIN E18 [get_ports {ddr3_dm[1]}]

# PadFunction: IO_L24P_T3_18 
set_property PACKAGE_PIN C23 [get_ports {ddr3_dm[2]}]

# PadFunction: IO_L7P_T1_18 
set_property PACKAGE_PIN G20 [get_ports {ddr3_dm[3]}]

# PadFunction: IO_L15P_T2_DQS_18 
set_property PACKAGE_PIN D16 [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L15N_T2_DQS_18 
set_property PACKAGE_PIN D17 [get_ports {ddr3_dqs_n[0]}]

# PadFunction: IO_L3P_T0_DQS_18 
set_property PACKAGE_PIN G17 [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L3N_T0_DQS_18 
set_property PACKAGE_PIN G18 [get_ports {ddr3_dqs_n[1]}]

# PadFunction: IO_L21P_T3_DQS_18 
set_property PACKAGE_PIN A19 [get_ports {ddr3_dqs_p[2]}]

# PadFunction: IO_L21N_T3_DQS_18 
set_property PACKAGE_PIN A20 [get_ports {ddr3_dqs_n[2]}]

# PadFunction: IO_L9P_T1_DQS_18 
set_property PACKAGE_PIN G22 [get_ports {ddr3_dqs_p[3]}]

# PadFunction: IO_L9N_T1_DQS_18 
set_property PACKAGE_PIN G23 [get_ports {ddr3_dqs_n[3]}]

# PadFunction: IO_L9P_T1_DQS_17 
set_property PACKAGE_PIN D24 [get_ports {ddr3_ck_p[0]}]

# PadFunction: IO_L9N_T1_DQS_17 
set_property PACKAGE_PIN D25 [get_ports {ddr3_ck_n[0]}]






