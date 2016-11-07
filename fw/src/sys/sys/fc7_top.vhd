library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.system_package.all;
--! user packages
use work.user_package.all;

library unisim;
use unisim.vcomponents.all;

entity fc7_top is 
port
(
	
    --====================--
    -- sys pins
    --====================--

    sw3                     : in    std_logic;
    --# ethernet
    osc125_a_p              : in    std_logic;
    osc125_a_n              : in    std_logic;
    osc125_b_p              : in    std_logic;
    osc125_b_n              : in    std_logic;
    amc_tx_p0               : out   std_logic;
    amc_tx_n0               : out   std_logic;
    amc_rx_p0               : in    std_logic;
    amc_rx_n0               : in    std_logic;
    
    --# unused    
--  phase_mon_flag_p        : in    std_logic;
--  phase_mon_flag_n        : in    std_logic;
--  monitoring_refclk_p     : out   std_logic;                
--  monitoring_refclk_n     : out   std_logic;                

    --# xpoint control
    cdce_ctrla4_r1          : out   std_logic;
    k7_master_xpoint_ctrl   : out   std_logic_vector(0 to 9);
    k7_pcie_clk_ctrl        : out   std_logic_vector(0 to 3);
    k7_tclkb_en             : out   std_logic;
    k7_tclkd_en             : out   std_logic;
    
    --# fmc control
    fmc_l12_pg_m2c          : in    std_logic;        
    fmc_l12_prsnt_l         : in    std_logic;
    fmc_l12_pwr_en          : out   std_logic;    
    fmc_l8_pg_m2c           : in    std_logic;         
    fmc_l8_prsnt_l          : in    std_logic;        
    fmc_l8_pwr_en           : out   std_logic;        
    fmc_pg_c2m              : out   std_logic;    
    fmc_i2c_scl             : inout std_logic;
    fmc_i2c_sda             : inout std_logic;
    
    --# system led
    sysled1_r               : out   std_logic;
    sysled1_g               : out   std_logic;
    sysled1_b               : out   std_logic;
    sysled2_r               : out   std_logic;
    sysled2_g               : out   std_logic;
    sysled2_b               : out   std_logic;

    cpld2fpga_gpio          : inout std_logic_vector(3 downto 0);
    cpld2fpga_ebi_nrd       : in    std_logic;
    cpld2fpga_ebi_nwe_0     : in    std_logic;
    fpga_config_data        : inout std_logic_vector(15 downto 0);    
    
    --# i2c master
    pca8574_int             : in    std_logic; 
    local_i2c_scl           : inout std_logic;
    local_i2c_sda           : inout std_logic;

    --#
    osc_sata_scl            : inout std_logic;
    osc_sata_sda            : inout std_logic;
    

    --====================--
    -- sys & usr
    --====================--
    fmc_l8_spare            : inout std_logic_vector(0 to 19); -- 
    fmc_l12_spare           : inout std_logic_vector(13 downto 8);

    --====================--
    -- usr
    --====================--
    
    --# on-board fabric clk
    fabric_clk_p            : in    std_logic;
    fabric_clk_n            : in    std_logic;
    fabric_coax_or_osc_p    : in    std_logic;
    fabric_coax_or_osc_n    : in    std_logic;
    
    --# on-board mgt clk
    pcie_clk_p              : in    std_logic;
    pcie_clk_n              : in    std_logic;
    osc_xpoint_a_p          : in    std_logic;
    osc_xpoint_a_n          : in    std_logic;
    osc_xpoint_b_p          : in    std_logic;
    osc_xpoint_b_n          : in    std_logic;
    osc_xpoint_c_p          : in    std_logic;
    osc_xpoint_c_n          : in    std_logic;
    osc_xpoint_d_p          : in    std_logic;
    osc_xpoint_d_n          : in    std_logic;
    ttc_mgt_xpoint_a_p      : in    std_logic;
    ttc_mgt_xpoint_a_n      : in    std_logic;
    ttc_mgt_xpoint_b_p      : in    std_logic;
    ttc_mgt_xpoint_b_n      : in    std_logic;
    ttc_mgt_xpoint_c_p      : in    std_logic;
    ttc_mgt_xpoint_c_n      : in    std_logic;
    
    --# fmc mgt clk
    fmc_l12_gbtclk0_a_p     : in    std_logic; 
    fmc_l12_gbtclk0_a_n     : in    std_logic; 
    fmc_l12_gbtclk1_a_p     : in    std_logic; 
    fmc_l12_gbtclk1_a_n     : in    std_logic; 
    fmc_l12_gbtclk0_b_p     : in    std_logic; 
    fmc_l12_gbtclk0_b_n     : in    std_logic; 
    fmc_l12_gbtclk1_b_p     : in    std_logic; 
    fmc_l12_gbtclk1_b_n     : in    std_logic; 
    fmc_l8_gbtclk0_p        : in    std_logic; 
    fmc_l8_gbtclk0_n        : in    std_logic; 
    fmc_l8_gbtclk1_p        : in    std_logic; 
    fmc_l8_gbtclk1_n        : in    std_logic; 

    --# fmc mgt
    fmc_l8_dp_c2m_p         : out   std_logic_vector( 7 downto 0);
    fmc_l8_dp_c2m_n         : out   std_logic_vector( 7 downto 0);
    fmc_l8_dp_m2c_p         : in    std_logic_vector( 7 downto 0);
    fmc_l8_dp_m2c_n         : in    std_logic_vector( 7 downto 0);
    fmc_l12_dp_c2m_p        : out   std_logic_vector(11 downto 0);
    fmc_l12_dp_c2m_n        : out   std_logic_vector(11 downto 0);
    fmc_l12_dp_m2c_p        : in    std_logic_vector(11 downto 0);
    fmc_l12_dp_m2c_n        : in    std_logic_vector(11 downto 0);
    
    --# fmc fabric clk
    fmc_l8_clk0             : in    std_logic; 
    fmc_l8_clk1             : in    std_logic;
    fmc_l12_clk0            : in    std_logic;
    fmc_l12_clk1            : in    std_logic;
    
    --# fmc io 
    fmc_l8_la_p             : inout std_logic_vector(33 downto 0);
    fmc_l8_la_n             : inout std_logic_vector(33 downto 0);
    fmc_l12_la_p            : inout std_logic_vector(33 downto 0);
    fmc_l12_la_n            : inout std_logic_vector(33 downto 0);
    
    --# amc mgt
    k7_amc_rx_p             : inout std_logic_vector(15 downto 1);
    k7_amc_rx_n             : inout std_logic_vector(15 downto 1);
    amc_tx_p                : inout std_logic_vector(15 downto 1);
    amc_tx_n                : inout std_logic_vector(15 downto 1);
    
    --# amc fabric
    k7_fabric_amc_rx_p03    : inout std_logic;
    k7_fabric_amc_rx_n03    : inout std_logic;
    k7_fabric_amc_tx_p03    : inout std_logic;
    k7_fabric_amc_tx_n03    : inout std_logic;
    
    --# cdce     
    fpga_refclkout_p        : out   std_logic;
    fpga_refclkout_n        : out   std_logic;
    cdce_sync_r1            : out   std_logic;
    
    --# ddr3
    ddr3_sys_clk_p          : in    std_logic;
    ddr3_sys_clk_n          : in    std_logic;
    ddr3_dq                 : inout std_logic_vector( 31 downto 0);
    ddr3_dqs_p              : inout std_logic_vector(  3 downto 0);
    ddr3_dqs_n              : inout std_logic_vector(  3 downto 0);
    ddr3_addr               : out   std_logic_vector( 13 downto 0);
    ddr3_ba                 : out   std_logic_vector(  2 downto 0);
    ddr3_ras_n              : out   std_logic;
    ddr3_cas_n              : out   std_logic;
    ddr3_we_n               : out   std_logic;
    ddr3_reset_n            : out   std_logic;
    ddr3_ck_p               : out   std_logic_vector(  0 downto 0);
    ddr3_ck_n               : out   std_logic_vector(  0 downto 0);
    ddr3_cke                : out   std_logic_vector(  0 downto 0);
    ddr3_cs_n               : out   std_logic_vector(  0 downto 0);
    ddr3_dm                 : out   std_logic_vector(  3 downto 0);
    ddr3_odt                : out   std_logic_vector(  0 downto 0)
    
);
end fc7_top;

architecture top of fc7_top is

signal ip_addr                    : std_logic_vector(31 downto 0);                    
signal mac_addr                   : std_logic_vector(47 downto 0);                    
signal use_i2c_eeprom             : std_logic;                    
signal rarp_en                    : std_logic;
                           
signal clk_31_250_bufg            : std_logic;
signal osc125_a_bufg              : std_logic;    
signal osc125_a_mgtrefclk         : std_logic;
signal osc125_b_bufg              : std_logic;    
signal osc125_b_mgtrefclk         : std_logic;
 
signal ipb_rst                    : std_logic;
signal ipb_clk_from_usr           : std_logic;
signal ipb_miso                   : ipb_rbus_array(0 to nbr_usr_slaves-1);
signal ipb_mosi                   : ipb_wbus_array(0 to nbr_usr_slaves-1);
 
signal cdce_sync_clk              : std_logic;
signal cdce_sync                  : std_logic;

signal cdce_pri_clk_bufg          : std_logic;
signal cdce_pri_clk_oddr          : std_logic;
signal d1, d2                     : std_logic;

attribute dont_touch              : boolean;
    
begin



--==============================--
cdce_clk: for i in 0 to 0 generate
--==============================--
    attribute dont_touch of clk_oddr : label is true; 
    attribute dont_touch of clk_obuf : label is true; 
begin 

    d2 <= '0';
    d1 <= '1';

    clk_oddr: oddr   
    port map (c => cdce_pri_clk_bufg, q => cdce_pri_clk_oddr, d1 => d1, d2 => d2, ce => '1'); -- d1 d2 to be confirmed
      
    clk_obuf: obufds 
    port map (i => cdce_pri_clk_oddr, o => fpga_refclkout_p,       ob => fpga_refclkout_n);  

end generate;
--==============================--



--==============================--
sync_r1: for i in 0 to 0 generate
--==============================--
    attribute dont_touch of cdce_sync_r1_fdre : label is true; 
begin 
    cdce_sync_r1_fdre : fdre   
    port map (d => cdce_sync, q => cdce_sync_r1,    c  => cdce_sync_clk, ce => '1', r => '0');
end generate;
--==============================--


    
--==============================--
sync_r0: for i in 0 to 0 generate
--==============================--
    attribute dont_touch of cdce_sync_r0_fdre : label is true; 
begin 
    cdce_sync_r0_fdre : fdre   
    port map (d => cdce_sync, q => fmc_l8_spare(4), c  => cdce_sync_clk, ce => '1', r => '0');
end generate;
--==============================--



--==============================--
sys: entity work.system_core
--==============================--
port map
(
    
    sw3                           => sw3,
--    header                      => fmc_l12_spare (7 downto 0),
--    dipsw                       => fmc_l12_spare(21 downto 14),
                                 
    --# ethernet
    osc125_a_p                    => osc125_a_p,                    
    osc125_a_n                    => osc125_a_n,                    
    osc125_b_p                    => osc125_b_p,                    
    osc125_b_n                    => osc125_b_n,    
    amc_tx_p0                     => amc_tx_p0,                    
    amc_tx_n0                     => amc_tx_n0,                    
    amc_rx_p0                     => amc_rx_p0,                    
    amc_rx_n0                     => amc_rx_n0,     

    --# xpoint control
    k7_master_xpoint_ctrl         => k7_master_xpoint_ctrl,    
    k7_pcie_clk_ctrl              => k7_pcie_clk_ctrl,            
    k7_tclkb_en                   => k7_tclkb_en,                    
    k7_tclkd_en                   => k7_tclkd_en,                    
    cdce_xpoint(1)                => cdce_ctrla4_r1,
    cdce_xpoint(2)                => fmc_l8_spare(6),
    cdce_xpoint(3)                => fmc_l8_spare(7),
    cdce_xpoint(4)                => fmc_l8_spare(8),
    osc_coax_sel                  => fmc_l8_spare(9),
    osc_xpoint_ctrl               => fmc_l8_spare(12 to 19),
                    
    --# fmc control        
    fmc_l12_pg_m2c                => fmc_l12_pg_m2c,             
    fmc_l12_prsnt_l               => fmc_l12_prsnt_l,             
    fmc_l12_pwr_en                => fmc_l12_pwr_en,             
    fmc_l8_pg_m2c                 => fmc_l8_pg_m2c,                
    fmc_l8_prsnt_l                => fmc_l8_prsnt_l,             
    fmc_l8_pwr_en                 => fmc_l8_pwr_en,                 
    fmc_pg_c2m                    => fmc_pg_c2m,                     
    fmc_i2c_scl                   => fmc_i2c_scl,                    
    fmc_i2c_sda                   => fmc_i2c_sda, 
                                     
    --# system led
    sysled1_r                     => sysled1_r,                    
    sysled1_g                     => sysled1_g,                    
    sysled1_b                     => sysled1_b,                    
    sysled2_r                     => sysled2_r,                    
    sysled2_g                     => sysled2_g,                    
    sysled2_b                     => sysled2_b,                    
                                 
    --# uc interface 
    uc_pipe_nrd                   => cpld2fpga_ebi_nrd,
    uc_pipe_nwe                   => cpld2fpga_ebi_nwe_0,
    uc_pipe                       => fpga_config_data,
    uc_spi_sck                    => cpld2fpga_gpio(0),
    uc_spi_mosi                   => cpld2fpga_gpio(1),
    uc_spi_miso                   => cpld2fpga_gpio(2),
    uc_spi_cs_b                   => cpld2fpga_gpio(3),

    --# fpga spi master
    spi_le                        => fmc_l8_spare(1),
    spi_clk                       => fmc_l8_spare(2),
    spi_mosi                      => fmc_l8_spare(3),
    spi_miso                      => fmc_l8_spare(11),
    
    --# fpga i2c master
    pca8574_int                   => pca8574_int,                    
    local_i2c_scl                 => local_i2c_scl,                
    local_i2c_sda                 => local_i2c_sda,
                   
    --# clock forwarding to usr   
    osc125_a_bufg_o               => osc125_a_bufg,                    
    osc125_a_mgtrefclk_o          => osc125_a_mgtrefclk,
    osc125_b_bufg_o               => osc125_b_bufg,                    
    osc125_b_mgtrefclk_o          => osc125_b_mgtrefclk,
    clk_31_250_bufg_o             => clk_31_250_bufg,                    
        
    --# ipbus comm with usr                                 
    ipb_clk_i                     => ipb_clk_from_usr,
    ipb_rst_o                     => ipb_rst, 
    ipb_mosi_o                    => ipb_mosi,
    ipb_miso_i                    => ipb_miso,

    --# ipbus conf by usr
    ip_addr_i                     => ip_addr,                            
    mac_addr_i                    => mac_addr,                            
    rarp_en_i                     => rarp_en,           
    use_i2c_eeprom_i              => use_i2c_eeprom    
);
--==============================--



--==============================--
usr: entity work.user_logic
--==============================--
port map
(
    --# led 
    usrled1_r                     => fmc_l12_spare(8),
    usrled1_g                     => fmc_l12_spare(9),
    usrled1_b                     => fmc_l12_spare(10),
    usrled2_r                     => fmc_l12_spare(11),
    usrled2_g                     => fmc_l12_spare(12),
    usrled2_b                     => fmc_l12_spare(13),

	--# on-board fabric clk
    fabric_clk_p                  => fabric_clk_p,                 
    fabric_clk_n                  => fabric_clk_n,   
    fabric_coax_or_osc_p          => fabric_coax_or_osc_p,     
    fabric_coax_or_osc_n          => fabric_coax_or_osc_n,     

	--# on-board mgt clk
    pcie_clk_p                    => pcie_clk_p,            
    pcie_clk_n                    => pcie_clk_n,
    osc_xpoint_a_p                => osc_xpoint_a_p,                
    osc_xpoint_a_n                => osc_xpoint_a_n,                
    osc_xpoint_b_p                => osc_xpoint_b_p,                
    osc_xpoint_b_n                => osc_xpoint_b_n,                
    osc_xpoint_c_p                => osc_xpoint_c_p,                
    osc_xpoint_c_n                => osc_xpoint_c_n,                
    osc_xpoint_d_p                => osc_xpoint_d_p,                
    osc_xpoint_d_n                => osc_xpoint_d_n,                
    ttc_mgt_xpoint_a_p            => ttc_mgt_xpoint_a_p,        
    ttc_mgt_xpoint_a_n            => ttc_mgt_xpoint_a_n,        
    ttc_mgt_xpoint_b_p            => ttc_mgt_xpoint_b_p,        
    ttc_mgt_xpoint_b_n            => ttc_mgt_xpoint_b_n,        
    ttc_mgt_xpoint_c_p            => ttc_mgt_xpoint_c_p,        
    ttc_mgt_xpoint_c_n            => ttc_mgt_xpoint_c_n,        
                                  
    --# fmc mgt clk               
    fmc_l12_gbtclk0_a_p           => fmc_l12_gbtclk0_a_p,        
    fmc_l12_gbtclk0_a_n           => fmc_l12_gbtclk0_a_n,    
    fmc_l12_gbtclk1_a_p           => fmc_l12_gbtclk1_a_p,        
    fmc_l12_gbtclk1_a_n           => fmc_l12_gbtclk1_a_n,        
    fmc_l12_gbtclk0_b_p           => fmc_l12_gbtclk0_b_p,        
    fmc_l12_gbtclk0_b_n           => fmc_l12_gbtclk0_b_n,        
    fmc_l12_gbtclk1_b_p           => fmc_l12_gbtclk1_b_p,        
    fmc_l12_gbtclk1_b_n           => fmc_l12_gbtclk1_b_n,        
    fmc_l8_gbtclk0_p              => fmc_l8_gbtclk0_p,            
    fmc_l8_gbtclk0_n              => fmc_l8_gbtclk0_n,            
    fmc_l8_gbtclk1_p              => fmc_l8_gbtclk1_p,            
    fmc_l8_gbtclk1_n              => fmc_l8_gbtclk1_n,            
                                  
    --# fmc mgt
    fmc_l12_dp_c2m_p              => fmc_l12_dp_c2m_p,
    fmc_l12_dp_c2m_n              => fmc_l12_dp_c2m_n,
    fmc_l12_dp_m2c_p              => fmc_l12_dp_m2c_p,
    fmc_l12_dp_m2c_n              => fmc_l12_dp_m2c_n,
    fmc_l8_dp_c2m_p               => fmc_l8_dp_c2m_p,
    fmc_l8_dp_c2m_n               => fmc_l8_dp_c2m_n,
    fmc_l8_dp_m2c_p               => fmc_l8_dp_m2c_p,
    fmc_l8_dp_m2c_n               => fmc_l8_dp_m2c_n,

    -- fmc fabric clk
    fmc_l8_clk0                   => fmc_l8_clk0,    
    fmc_l8_clk1                   => fmc_l8_clk1,  
    fmc_l12_clk0                  => fmc_l12_clk0, 
    fmc_l12_clk1                  => fmc_l12_clk1, 
    
    -- fmc gpio
    fmc_l12_la_p                  => fmc_l12_la_p,     
    fmc_l12_la_n                  => fmc_l12_la_n,
    fmc_l8_la_p                   => fmc_l8_la_p,
    fmc_l8_la_n                   => fmc_l8_la_n,   
    
    --# amc mgt                                
    k7_amc_rx_p                   => k7_amc_rx_p,
    k7_amc_rx_n                   => k7_amc_rx_n,    
    amc_tx_p                      => amc_tx_p,
    amc_tx_n                      => amc_tx_n,
           
    --# amc fabric                         
    k7_fabric_amc_rx_p03          => k7_fabric_amc_rx_p03,
    k7_fabric_amc_rx_n03          => k7_fabric_amc_rx_n03,
    k7_fabric_amc_tx_p03          => k7_fabric_amc_tx_p03,
    k7_fabric_amc_tx_n03          => k7_fabric_amc_tx_n03,
    
    --# ddr3
    ddr3_sys_clk_p                => ddr3_sys_clk_p ,
    ddr3_sys_clk_n                => ddr3_sys_clk_n ,
    ddr3_dq                       => ddr3_dq,
    ddr3_dqs_p                    => ddr3_dqs_p,
    ddr3_dqs_n                    => ddr3_dqs_n,
    ddr3_addr                     => ddr3_addr,
    ddr3_ba                       => ddr3_ba,
    ddr3_ras_n                    => ddr3_ras_n,
    ddr3_cas_n                    => ddr3_cas_n,
    ddr3_we_n                     => ddr3_we_n,
    ddr3_reset_n                  => ddr3_reset_n,
    ddr3_ck_p                     => ddr3_ck_p,
    ddr3_ck_n                     => ddr3_ck_n,
    ddr3_cke                      => ddr3_cke,
    ddr3_cs_n                     => ddr3_cs_n,
    ddr3_dm                       => ddr3_dm,
    ddr3_odt                      => ddr3_odt,
    
	--# cdce
    cdce_pll_lock_i               => fmc_l8_spare(10),
    cdce_ref_sel_o                => fmc_l8_spare(0), 
    cdce_pwrdown_o                => fmc_l8_spare(5),
    cdce_pri_clk_bufg_o           => cdce_pri_clk_bufg,
    cdce_sync_o                   => cdce_sync,
    cdce_sync_clk_o               => cdce_sync_clk,
    
    --# system clk		
    osc125_a_bufg_i               => osc125_a_bufg,                    
    osc125_a_mgtrefclk_i          => osc125_a_mgtrefclk,
    osc125_b_bufg_i               => osc125_b_bufg,                    
    osc125_b_mgtrefclk_i          => osc125_b_mgtrefclk,
    clk_31_250_bufg_i             => clk_31_250_bufg,                    
                                                        
    --# ipbus comm    
    ipb_clk_o                     => ipb_clk_from_usr,
    ipb_rst_i                     => ipb_rst, 
    ipb_mosi_i                    => ipb_mosi,
    ipb_miso_o                    => ipb_miso,

    --# ipbus conf
    ip_addr_o                     => ip_addr,                            
    mac_addr_o                    => mac_addr,                            
    use_i2c_eeprom_o              => use_i2c_eeprom,
    rarp_en_o                     => rarp_en    
    
);    
--==============================--


    
end top;