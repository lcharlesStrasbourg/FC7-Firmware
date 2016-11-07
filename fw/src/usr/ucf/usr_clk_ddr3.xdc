create_clock -name fabric_clk -period 25           [get_ports fabric_clk_p]
set_property PACKAGE_PIN AK18                      [get_ports fabric_clk_p]
set_property IOSTANDARD LVDS_25                    [get_ports fabric_clk_p]
set_property DIFF_TERM true                        [get_ports fabric_clk_p]

create_clock -name ddr3_sys_clk -period 4.158      [get_ports ddr3_sys_clk_p]
set_property PACKAGE_PIN H27                       [get_ports ddr3_sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15                [get_ports ddr3_sys_clk_p]

create_clock -name fabric_coax_or_osc -period 25   [get_ports fabric_coax_or_osc_p]
set_property PACKAGE_PIN AL18                      [get_ports fabric_coax_or_osc_p]
set_property IOSTANDARD LVDS_25                    [get_ports fabric_coax_or_osc_p]
set_property DIFF_TERM true                        [get_ports fabric_coax_or_osc_p]

set_false_path -through                            [get_nets  usr/usr_ddr3_rst]
set_false_path -through                            [get_nets  usr/ddr3_sys_rst_n]

#set_false_path -from                               [get_clocks clk_pll_i]
#set_false_path -to                                 [get_clocks clk_pll_i]

set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks eth_txoutclk] \
    -group [get_clocks -include_generated_clocks osc125_a] \
    -group [get_clocks -include_generated_clocks osc125_b] \
    -group [get_clocks -include_generated_clocks fabric_clk] \
    -group [get_clocks -include_generated_clocks fabric_coax_or_osc] \
    -group [get_clocks -include_generated_clocks ddr3_sys_clk]
    
        