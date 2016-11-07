library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.ipbus_trans_decl.all;
use work.emac_hostbus_decl.all;
use work.system_package.all;
--use work.wb_package.all;
--! user packages
use work.user_package.all;

library unisim;
use unisim.vcomponents.all;

entity system_core is 
port
(
	
    sw3                           : in    std_logic;
--  header                        : inout std_logic_vector(10 downto 3); -- fmc_l12_spare[5:0]
--  dipsw                         : in    std_logic_vector( 7 downto 0); -- fmc_l12_spare[21:14]

    --# ethernet
    osc125_a_p                    : in    std_logic;
    osc125_a_n                    : in    std_logic;
    osc125_b_p                    : in    std_logic;
    osc125_b_n                    : in    std_logic;
    amc_tx_p0                     : out   std_logic;
    amc_tx_n0                     : out   std_logic;
    amc_rx_p0                     : in    std_logic;
    amc_rx_n0                     : in    std_logic;
    
    --# xpoint control
    k7_master_xpoint_ctrl         : out   std_logic_vector(0 to 9);
    k7_pcie_clk_ctrl              : out   std_logic_vector(0 to 3);
    k7_tclkb_en                   : out   std_logic;
    k7_tclkd_en                   : out   std_logic;
    cdce_xpoint                   : out   std_logic_vector(1 to 4); 
    osc_coax_sel                  : out   std_logic;
    osc_xpoint_ctrl               : out   std_logic_vector(0 to 7);
   
    --# fmc control        
    fmc_l12_pg_m2c                : in    std_logic;        
    fmc_l12_prsnt_l               : in    std_logic;
    fmc_l12_pwr_en                : out   std_logic;    
    fmc_l8_pg_m2c                 : in    std_logic;         
    fmc_l8_prsnt_l                : in    std_logic;        
    fmc_l8_pwr_en                 : out   std_logic;        
    fmc_pg_c2m                    : out   std_logic;    
    fmc_i2c_scl                   : inout std_logic;
    fmc_i2c_sda                   : inout std_logic;    

    --# system led
    sysled1_r                     : out   std_logic;
    sysled1_g                     : out   std_logic;
    sysled1_b                     : out   std_logic;
    sysled2_r                     : out   std_logic;
    sysled2_g                     : out   std_logic;
    sysled2_b                     : out   std_logic;
    
    --# uc interface 
    uc_pipe_nrd                   : in    std_logic;
    uc_pipe_nwe                   : in    std_logic;
    uc_pipe                       : inout std_logic_vector(15 downto 0);
    uc_spi_miso                   : out   std_logic;
    uc_spi_mosi                   : in    std_logic;
    uc_spi_sck                    : in    std_logic;
    uc_spi_cs_b                   : in    std_logic;
    
    --# fpga spi master
    spi_miso                      : in    std_logic;
    spi_mosi                      : out   std_logic;
    spi_clk                       : out   std_logic;
    spi_le                        : out   std_logic;
    
    --# fpga i2c master
    pca8574_int                   : in    std_logic;  
    local_i2c_scl                 : inout std_logic;
    local_i2c_sda                 : inout std_logic;   
    
    --# clock forwarding to usr   
    clk_31_250_bufg_o             : out   std_logic; ----------+     
    osc125_a_bufg_o               : out   std_logic; --        |
    osc125_a_mgtrefclk_o          : out   std_logic; --        |
    osc125_b_bufg_o               : out   std_logic; --        |
    osc125_b_mgtrefclk_o          : out   std_logic; --        |
                                                     --        |
    --# ipbus                                        --        | 
    ipb_clk_i                     : in    std_logic; -- <------+
    ipb_rst_o                     : out   std_logic;
    ipb_miso_i                    : in    ipb_rbus_array(0 to nbr_usr_slaves-1);
    ipb_mosi_o                    : out   ipb_wbus_array(0 to nbr_usr_slaves-1);
    ip_addr_i                     : in    std_logic_vector(31 downto 0);
    mac_addr_i                    : in    std_logic_vector(47 downto 0);
    rarp_en_i                     : in    std_logic;
    use_i2c_eeprom_i              : in    std_logic
);
end system_core;

architecture wrapper of system_core is

signal mac_tx_valid: std_logic;
signal mac_tx_last                : std_logic;
signal mac_tx_error               : std_logic;
signal mac_tx_ready               : std_logic;
signal mac_rx_valid               : std_logic;
signal mac_rx_last                : std_logic;
signal mac_rx_error               : std_logic;

signal mac_clk                    : std_logic;
signal clk_31_250_bufg            : std_logic; --signal ipb_clk : std_logic;
signal locked                     : std_logic;
signal eth_locked                 : std_logic;
signal ttc_clk, osc1, osc2        : std_logic;
signal reset_powerup_b            : std_logic;
signal reset_powerup              : std_logic;
signal rst, rst_125mhz, ipb_rst   : std_logic;
signal mac_tx_data, mac_rx_data   : std_logic_vector(7 downto 0);
signal rst_b_125mhz               : std_logic;
signal ipb_from_master, ipbw_ext  : ipb_wbus;
signal ipb_to_master, ipbr_ext    : ipb_rbus;
signal ipbus_config               : std_logic_vector(31 downto 0);
signal osc1_pre_buf, osc2_pre_buf : std_logic;
signal onehz                      : std_logic; --  signal onehz_short, onehz_long: std_logic;  
signal pkt_rx_led, pkt_tx_led     : std_logic;
signal rst_eth                    : std_logic;


    --==========================-- 
    --##########################--
    --## signal and constant ###--
    --#### declarations ########--
    --##########################--
    --==========================-- 

constant led_off                  : std_logic := '1';
constant led_on                   : std_logic := '0';

constant red                      : integer :=  2 ;
constant green                    : integer :=  1 ;
constant blue                     : integer :=  0 ;

constant sysled_off               : std_logic_vector(2 downto 0):= led_off & led_off & led_off ;     
constant sysled_blue              : std_logic_vector(2 downto 0):= led_off & led_off & led_on  ;     
constant sysled_green             : std_logic_vector(2 downto 0):= led_off & led_on  & led_off ;     
constant sysled_yellow            : std_logic_vector(2 downto 0):= led_off & led_on  & led_on  ;     
constant sysled_red               : std_logic_vector(2 downto 0):= led_on  & led_off & led_off ;     
constant sysled_purple            : std_logic_vector(2 downto 0):= led_on  & led_off & led_on  ;     
constant sysled_orange            : std_logic_vector(2 downto 0):= led_on  & led_on  & led_off ;     
constant sysled_white             : std_logic_vector(2 downto 0):= led_on  & led_on  & led_on  ;     

signal sysled1                    : std_logic_vector(2 downto 0);     
signal sysled2                    : std_logic_vector(2 downto 0);     

signal ipb_to_slaves              : ipb_wbus_array(0 to nbr_sys_slaves+nbr_usr_slaves-1);
signal ipb_from_slaves            : ipb_rbus_array(0 to nbr_sys_slaves+nbr_usr_slaves-1);

signal regs_to_ipbus              : array_32x32bit;            
signal regs_from_ipbus            : array_32x32bit;            

signal reg_ctrl                   : std_logic_vector(31 downto 0); --  4
signal reg_ctrl_2                 : std_logic_vector(31 downto 0); --  5
signal reg_status                 : std_logic_vector(31 downto 0); --  7
signal reg_status_2               : std_logic_vector(31 downto 0); --  8
signal reg_ctrl_sram              : std_logic_vector(31 downto 0); --  6
signal reg_status_sram            : std_logic_vector(31 downto 0); --  9
signal reg_spi_command            : std_logic_vector(31 downto 0); -- 10
signal reg_spi_txdata             : std_logic_vector(31 downto 0); -- 11
signal reg_spi_rxdata             : std_logic_vector(31 downto 0); -- 12
signal reg_i2c_settings           : std_logic_vector(31 downto 0); -- 13
signal reg_i2c_command            : std_logic_vector(31 downto 0); -- 14
signal reg_i2c_reply              : std_logic_vector(31 downto 0); -- 15

signal ip_addr                    : std_logic_vector(31 downto 0);
signal mac_addr                   : std_logic_vector(47 downto 0);

signal mac_from_eep               : std_logic;
signal mac_from_usr               : std_logic;
signal ip_from_eep                : std_logic;
signal ip_from_usr                : std_logic;   
               
signal i2c_eep_mac_ip_regs        : array_16x8bit;
signal i2c_eep_eui48_regs         : array_6x8bit;
signal i2c_eep_settings           : std_logic_vector(23 downto 0);
signal i2c_eep_command            : std_logic_vector(31 downto 0);
signal i2c_eep_reply              : std_logic_vector(31 downto 0);
signal i2c_eep_bypass             : std_logic;
signal i2c_eep_done               : std_logic;

signal oob_in                     : ipbus_trans_in;
signal oob_out                    : ipbus_trans_out;

signal rarp_select                : std_logic;
signal eui48                      : std_logic_vector(47 downto 0);

signal osc125_a_bufg              : std_logic;
signal osc125_a_mgtrefclk         : std_logic;
signal osc125_b_bufg              : std_logic;
signal osc125_b_mgtrefclk         : std_logic;

attribute keep                    : boolean;
attribute keep of ipb_clk_i       : signal is true;
attribute keep of ipb_mosi_o      : signal is true;
attribute keep of ipb_miso_i      : signal is true;
begin


--===================================--
-- clock inputs
--===================================--
osc125a_gtebuf: ibufds_gte2 port map (i => osc125_a_p, ib => osc125_a_n,     o => osc125_a_mgtrefclk, ceb => '0');
osc125a_clkbuf: bufg        port map (i => osc125_a_mgtrefclk,               o => osc125_a_bufg);
osc125b_gtebuf: ibufds_gte2 port map (i => osc125_b_p, ib => osc125_b_n,     o => osc125_b_mgtrefclk, ceb => '0');
osc125b_clkbuf: bufg        port map (i => osc125_b_mgtrefclk,               o => osc125_b_bufg);
--===================================--



--===================================--
-- resets
--===================================--
reset_gen:srl16   port map (clk=> ipb_clk_i, q=>reset_powerup_b, a0=>'1',a1=>'1',a2 =>'1',a3 => '1',d=>'1');
reset_powerup     <= (not reset_powerup_b) or (not sw3);
--===================================--



--===================================--
clocks: entity work.clocks_7s_serdes 
--===================================--
port map
(
    clki_fr           => osc125_b_bufg, -- independent free running clock
    clki_125          => mac_clk,
    eth_locked        => eth_locked,
    nuke              => reset_powerup,
    ------------------
    clko_ipb          => clk_31_250_bufg,
    locked            => locked,
    rsto_125          => rst_125mhz,
    rsto_ipb          => ipb_rst,
    rsto_eth          => rst_eth,
    onehz             => onehz
);
--===================================--



--===================================--
-- leds
--===================================--

    ------------------
    -- sysled1 (top)
    ------------------
    sysled1_r         <= eth_locked; -- led_off;         -- negative logic leds
    sysled1_g         <= led_off;    -- negative logic leds
    sysled1_b         <= onehz;      -- negative logic leds
    
    ------------------
    --  sysled2 (bottom)
    ------------------
    sysled2           <=   sysled_blue    when rarp_select='1' and use_i2c_eeprom_i='1' and (i2c_eep_done='1' and mac_from_eep='1') -- rarp,    eeprom ok
                      else sysled_purple  when rarp_select='1' and use_i2c_eeprom_i='1' and (i2c_eep_done='0' or  mac_from_eep='0') -- rarp,    eeprom failure
                      else sysled_red     when rarp_select='1' and use_i2c_eeprom_i='0'                                             -- rarp,    no eeprom (not allowed)
                      else sysled_green   when rarp_select='0' and use_i2c_eeprom_i='1' and (i2c_eep_done='1' and mac_from_eep='1') -- no rarp, eeprom ok
                      else sysled_orange  when rarp_select='0' and use_i2c_eeprom_i='1' and (i2c_eep_done='0' or  mac_from_eep='0') -- no rarp, eeprom failure
                      else sysled_white   when rarp_select='0' and use_i2c_eeprom_i='0'                                             -- no rarp, no eeprom   
                      else sysled_off;                                                                                              -- other  
    --
    sysled2_r         <= sysled2(red);
    sysled2_g         <= sysled2(green);
    sysled2_b         <= sysled2(blue);
--===================================--



--===================================--
eth: entity work.eth_7s_1000basex 
--===================================--
port map
(
    clk_fr_i          => osc125_b_bufg, -- independent free running clock
    rst_i             => rst_eth, 
    locked_o          => eth_locked,
    mac_clk_o         => mac_clk,
    --
    gtx_refclk        => osc125_a_mgtrefclk,
    gtx_txp           => amc_tx_p0,
    gtx_txn           => amc_tx_n0,
    gtx_rxp           => amc_rx_p0,
    gtx_rxn           => amc_rx_n0,
    --
    tx_data           => mac_tx_data,
    tx_valid          => mac_tx_valid,
    tx_last           => mac_tx_last,
    tx_error          => mac_tx_error,
    tx_ready          => mac_tx_ready,
    rx_data           => mac_rx_data,
    rx_valid          => mac_rx_valid,
    rx_last           => mac_rx_last,
    rx_error          => mac_rx_error
);
--===================================--



--===================================--
ipb: entity work.ipbus_ctrl
--===================================--
generic map (mac_cfg => external, ip_cfg  => external, n_oob => 1)
port map
(    
     mac_clk           => mac_clk,
     rst_macclk        => rst_125mhz,
     ipb_clk           => ipb_clk_i,
     rst_ipb           => ipb_rst,
    ------------------
     mac_rx_data       => mac_rx_data,
     mac_rx_valid      => mac_rx_valid,
     mac_rx_last       => mac_rx_last,
     mac_rx_error      => mac_rx_error,
    ------------------
     mac_tx_data       => mac_tx_data,
     mac_tx_valid      => mac_tx_valid,
     mac_tx_last       => mac_tx_last,
     mac_tx_error      => mac_tx_error,
     mac_tx_ready      => mac_tx_ready,
    ------------------
     ipb_out           => ipb_from_master,
     ipb_in            => ipb_to_master,
     mac_addr          => mac_addr,
     ip_addr           => ip_addr,
     rarp_select       => rarp_select,
     pkt_rx_led        => pkt_rx_led,
     pkt_tx_led        => pkt_tx_led,
     oob_in(0)         => oob_in,
     oob_out(0)        => oob_out    
);
--===================================--



--===================================--
uc_if: entity work.uc_if
--===================================--
port map(
    clk125            => osc125_b_bufg,
    rst125            => rst_125mhz,
    ------------------
    uc_pipe_nrd       => uc_pipe_nrd,
    uc_pipe_nwe       => uc_pipe_nwe,
    uc_pipe           => uc_pipe,
    uc_spi_miso       => uc_spi_miso,
    uc_spi_mosi       => uc_spi_mosi,
    uc_spi_sck        => uc_spi_sck,
    uc_spi_cs_b       => uc_spi_cs_b,
    clk_ipb           => ipb_clk_i,
    rst_ipb           => ipb_rst,
    ipb_in            => ipb_to_slaves(uc),
    ipb_out           => ipb_from_slaves(uc),
    oob_in            => oob_out,
    oob_out           => oob_in
);
--===================================--



--===================================--
ip_mac: entity work.ip_mac_select
--===================================--
port map 
(
    clk_i             => ipb_clk_i,
    reset_i           => ipb_rst,
    --# source 1: usr
    ------------------
    user_mac_addr_i   => mac_addr_i,
    user_ip_addr_i    => ip_addr_i,
    --# source 2: i2c
    regs_eeprom_i     => i2c_eep_mac_ip_regs,
    regs_slave_i      => (others => (others =>'0')),
    regs_enable       => use_i2c_eeprom_i, --dipsw(4),     -- 0: ignore ip/mac coming from i2c sources
    --# other settings
    ext_rarp_select   => rarp_en_i, --dipsw(6),        -- 0: no rarp
    --# rarp status
    rarp_select_o     => rarp_select,
    --# selected ip/mac
    ip_addr_o         => ip_addr,
    mac_addr_o        => mac_addr,
    --                        
    mac_from_eep_o    => mac_from_eep,
    mac_from_usr_o    => mac_from_usr,
    ip_from_eep_o     => ip_from_eep,    
    ip_from_usr_o     => ip_from_usr    
);
--===================================--



--===================================--
ipb_fabric: entity work.ipbus_sys_fabric
--===================================--
generic map   
(
    n_sys_slv         => nbr_sys_slaves,
    n_usr_slv         => nbr_usr_slaves,
    usr_base_addr     => x"4000_0000",
    strobe_gap        => false
)
port map
(
    ipb_clk           => ipb_clk_i,
    rst               => ipb_rst,
    ------------------
    ipb_in            => ipb_from_master,
    ipb_out           => ipb_to_master,
    ------------------
    ipb_to_slaves     => ipb_to_slaves,
    ipb_from_slaves   => ipb_from_slaves
);
--===================================--



--===================================--
--###################################--
--###################################--
--##### bus slaves ##################--
--###################################--
--###################################--
--===================================--



--===================================--
ipb_sys_regs: entity work.system_regs
--===================================--
port map
(
    clk               => ipb_clk_i,
    reset             => ipb_rst,
    ------------------
    ipbus_in          => ipb_to_slaves(sys_regs),
    ipbus_out         => ipb_from_slaves(sys_regs),
    ------------------
    regs_o            => regs_from_ipbus,
    regs_i            => regs_to_ipbus                
);
--===================================--



--===================================--
icap_if: entity work.icap_interface_wrapper
--===================================--
port map
(    
    ipbus_clk_i       => ipb_clk_i,
    reset_i           => ipb_rst,                
    conf_trigg_i      => reg_ctrl_2(4), 
    fsm_conf_page_i   => reg_ctrl_2(1 downto 0), 
    ipbus_i           => ipb_to_slaves(icap),    
    ipbus_o           => ipb_from_slaves(icap)
);
--===================================--



--===================================--
i2c_m: entity work.i2c_master_top
--===================================--
generic map (nbr_of_busses => 1)
port map
(
    clk               => ipb_clk_i,
    reset             => ipb_rst,
    ------------------
    id_o              => reg_i2c_settings(31 downto 24), -- read only
    id_i              => i2c_eep_settings(23 downto 16),
    enable            => i2c_eep_settings(15),
    bus_select        => i2c_eep_settings(12 downto 10),
    prescaler         => i2c_eep_settings( 9 downto  0),
    command           => i2c_eep_command,
    reply             => i2c_eep_reply,
    ------------------
    scl_io(0)         => local_i2c_scl,            
    sda_io(0)         => local_i2c_sda
);             
--===================================--



--===================================--
i2c_eep: entity work.i2c_eep_autoread
--===================================--
port map
(
    reset             => ipb_rst,
    clk               => ipb_clk_i,
    ------------------       
    bypass_i          => i2c_eep_bypass,
    settings_o        => i2c_eep_settings, -- to   i2c master
    command_o         => i2c_eep_command,    -- to   i2c master
    reply_i           => i2c_eep_reply,     -- from i2c master
    done_i            => i2c_eep_reply(26),-- from i2c master
    done_o            => i2c_eep_done,        
    ------------------       
    settings_i        => reg_i2c_settings(23 downto 0), -- from ipbus
    command_i         => reg_i2c_command,  -- from ipbus
    reply_o           => reg_i2c_reply,        -- to   ipbus
    ------------------       
    mac_ip_regs_o     => i2c_eep_mac_ip_regs,
    eui48_regs_o      => i2c_eep_eui48_regs        
);
    eui48             <= i2c_eep_eui48_regs(0) 
                       & i2c_eep_eui48_regs(1) 
                       & i2c_eep_eui48_regs(2) 
                       & i2c_eep_eui48_regs(3) 
                       & i2c_eep_eui48_regs(4) 
                       & i2c_eep_eui48_regs(5);
--===================================--



--===================================--
spi: entity work.spi_master
--===================================--
port map
(
    clk_i             => ipb_clk_i,
    reset_i           => ipb_rst,  
    ------------------
    data_i            => reg_spi_txdata,
    enable_i          => reg_spi_command(31),    
    ssdelay_i         => reg_spi_command(27 downto 18),
    hold_i            => reg_spi_command(17 downto 15),
    msbfirst_i        => reg_spi_command(14),
    cpha_i            => reg_spi_command(13),
    cpol_i            => reg_spi_command(12),
    prescaler_i       => reg_spi_command(11 downto 0),
    data_o            => reg_spi_rxdata,
    ------------------
    ss_b_o            => spi_le,   -- cdce_spi_le,
    sck_o             => spi_clk,  -- cdce_spi_clk,
    mosi_o            => spi_mosi, -- cdce_spi_mosi,
    miso_i            => spi_miso  -- cdce_spi_miso
);
--===================================--



--===================================--
-- io/reg mapping
--===================================--
                                          reg_ctrl           <= regs_from_ipbus(4);
                                          reg_ctrl_2         <= regs_from_ipbus(5);
    regs_to_ipbus(6)                   <= reg_status;
    regs_to_ipbus(7)                   <= reg_status_2;
                                          reg_ctrl_sram      <= regs_from_ipbus(8);
    regs_to_ipbus(9)                   <= reg_status_sram;
                                          reg_spi_txdata     <= regs_from_ipbus(10);
                                          reg_spi_command    <= regs_from_ipbus(11);
    regs_to_ipbus(12)                  <= reg_spi_rxdata;
                                          reg_i2c_settings(23 downto  0)    <= regs_from_ipbus(13)(23 downto 0);     -- reg13[23:00] is read-write    
    regs_to_ipbus(13)(31 downto 24)    <= reg_i2c_settings(31 downto 24);                                                        -- reg13[31:24] is read-only    
                                          reg_i2c_command    <= regs_from_ipbus(14);
    regs_to_ipbus(15)                  <= reg_i2c_reply;    

    regs_to_ipbus(28)                  <= "000" & i2c_eep_done
                                        & "00" 
                                        & ip_from_eep & mac_from_eep
                                        & "00" 
                                        & "00" --ip_from_slv & mac_from_slv
                                        & "00" 
                                        & ip_from_usr & mac_from_usr
                                        &    mac_addr(47 downto 32);
                                               
    regs_to_ipbus(29)                  <= mac_addr(31 downto  0);
--  regs_to_ipbus(30)                  <= dipsw & header & eui48(47 downto 32); --ip_addr;
    regs_to_ipbus(30)                  <= x"0000" & eui48(47 downto 32); --ip_addr;
    regs_to_ipbus(31)                  <=           eui48(31 downto  0); --(others => '0'); 
    --===================================--



    --===================================--
    -- reg ctrl_1 bit mapping    
    --===================================--
    k7_pcie_clk_ctrl(0)                <= reg_ctrl( 0);        -- default: 0 (pll_sel -> 0, default setting)
    k7_pcie_clk_ctrl(1)                <= reg_ctrl( 1);        -- default: 0 (mr -> 0, normal operation)
    k7_pcie_clk_ctrl(2)                <= reg_ctrl( 2);        -- default: 0 (fsel1) 125MHz
    k7_pcie_clk_ctrl(3)                <= reg_ctrl( 3);        -- default: 1 (fsel0)
--  cdce_pwrdown_from_ipb              <= reg_ctrl( 4);        -- default: 1 (powered up)
--  cdce_sel_from_ipb                  <= reg_ctrl( 5);        -- default: 0 (select secondary clock)
--  cdce_sync_from_ipb                 <= reg_ctrl( 6);        -- default: 1 (disable sync mode), rising edge needed
--  cdce_ctrl_from_ipb                 <= reg_ctrl( 7);        -- default: 1 (ipb controlled)
    cdce_xpoint(1)                     <= reg_ctrl(22);        -- default: 1 (u42 out_1 driven by in_4 = CDCE u1) -- fc7_r1 only
    cdce_xpoint(2)                     <= reg_ctrl( 8);        -- default: 1 (u42 out_2 driven by in_4 = CDCE u1)
    cdce_xpoint(3)                     <= reg_ctrl( 9);        -- default: 1 (u42 out_3 driven by in_4 = CDCE u1)    
    cdce_xpoint(4)                     <= reg_ctrl(10);        -- default: 1 (u42 out_4 driven by in_4 = CDCE u1) 
    osc_coax_sel                       <= reg_ctrl(11);        -- default: 1 (select osc)
    k7_master_xpoint_ctrl(0)           <= reg_ctrl(12);        -- default: 1 (u7 out_1 driven by in_4)    
    k7_master_xpoint_ctrl(1)           <= reg_ctrl(13);        -- default: 1 (u7 out_1 driven by in_4)
    k7_master_xpoint_ctrl(2)           <= reg_ctrl(14);        -- default: 1 (u7 out_2 driven by in_4)
    k7_master_xpoint_ctrl(3)           <= reg_ctrl(15);        -- default: 1 (u7 out_2 driven by in_4)
    k7_master_xpoint_ctrl(4)           <= reg_ctrl(16);        -- default: 1 (u7 out_3 driven by in_4) 
    k7_master_xpoint_ctrl(5)           <= reg_ctrl(17);        -- default: 1 (u7 out_3 driven by in_4) 
    k7_master_xpoint_ctrl(6)           <= reg_ctrl(18);        -- default: 1 (u7 out_4 driven by in_4) 
    k7_master_xpoint_ctrl(7)           <= reg_ctrl(19);        -- default: 1 (u7 out_4 driven by in_4) 
    k7_master_xpoint_ctrl(8)           <= reg_ctrl(20);        -- default: 1 (u8 out_1 driven by in_4) 
    k7_master_xpoint_ctrl(9)           <= reg_ctrl(21);        -- default: 1 (u8 out_1 driven by in_4) 
    k7_tclkb_en                        <= reg_ctrl(23);        -- default: 0 (disabled)  
    k7_tclkd_en                        <= reg_ctrl(23);        -- default: 0 (disabled) 
    osc_xpoint_ctrl(0)                 <= reg_ctrl(24);        -- default: 1 (u3 out_1 driven by in_4) 
    osc_xpoint_ctrl(1)                 <= reg_ctrl(25);        -- default: 1 (u3 out_1 driven by in_4) 
    osc_xpoint_ctrl(2)                 <= reg_ctrl(26);        -- default: 1 (u3 out_2 driven by in_4)
    osc_xpoint_ctrl(3)                 <= reg_ctrl(27);        -- default: 1 (u3 out_2 driven by in_4)
    osc_xpoint_ctrl(4)                 <= reg_ctrl(28);        -- default: 1 (u3 out_3 driven by in_4)
    osc_xpoint_ctrl(5)                 <= reg_ctrl(29);        -- default: 1 (u3 out_3 driven by in_4)
    osc_xpoint_ctrl(6)                 <= reg_ctrl(30);        -- default: 1 (u3 out_4 driven by in_4)
    osc_xpoint_ctrl(7)                 <= reg_ctrl(31);        -- default: 1 (u3 out_4 driven by in_4)
    --===================================--
 
    
    
    --===================================--
    -- reg ctrl_2 bit mapping    
    --===================================--
--  phase_mon_lower                    <= reg_ctrl_2(15 downto  8); -- default: xED(for 160MHz, VADJ = 2.5V)
--  phase_mon_upper                    <= reg_ctrl_2(23 downto 16); -- default: xFD(for 160MHz, VADJ = 2.5V)
--  phase_mon_strobe                   <= reg_ctrl_2(24);           -- default: 0
--  phase_mon_refclk_sel               <= reg_ctrl_2(25);           -- default: 0     (0-> 160MHz, 1-> 240MHz)
--  monitoring_refclk_polarity         <= reg_ctrl_2(26);           -- default: 0     (0-> 0deg, 1-> 180deg)
    fmc_l12_pwr_en                     <= reg_ctrl_2(28);           -- default: 0  
    fmc_l8_pwr_en                      <= reg_ctrl_2(29);           -- default: 0    
    fmc_pg_c2m                         <= reg_ctrl_2(30);           -- default: 0            
    i2c_eep_bypass                     <= reg_ctrl_2(31);           -- default: 0    
    --===================================--
 
 
     
    --===================================--
    -- reg_status bit mapping
    --===================================--
    reg_status( 0)                     <= '0';
    reg_status( 1)                     <= '0';
    reg_status( 2)                     <= '0';
    reg_status( 3)                     <= '0';
    reg_status( 4)                     <= not pca8574_int; 
    reg_status( 5)                     <= '0';
    reg_status( 6)                     <= '0';
    reg_status( 7)                     <= '0';
    reg_status( 8)                     <= '0'; --phase_mon_count(8);    
    reg_status( 9)                     <= '0'; --phase_mon_count(9);        
    reg_status(10)                     <= '0'; --phase_mon_count(10);        
    reg_status(11)                     <= '0'; --phase_mon_count(11);        
    reg_status(12)                     <= '0'; --phase_mon_count(12);    
    reg_status(13)                     <= '0'; --phase_mon_count(13);    
    reg_status(14)                     <= '0'; --phase_mon_count(14);    
    reg_status(15)                     <= '0'; --phase_mon_count(15);    
    reg_status(16)                     <= '1'; --phase_mon_done;
    reg_status(17)                     <= '1'; --phase_mon_ok;    
    reg_status(18)                     <= '0';        
    reg_status(19)                     <= '0';             
    reg_status(20)                     <= '0';
    reg_status(21)                     <= '0';
    reg_status(22)                     <= '0';
    reg_status(23)                     <= '0';
    reg_status(24)                     <= '0'; --cdce_sync_busy;
    reg_status(25)                     <= '1'; --cdce_sync_done;
    reg_status(26)                     <= '1'; --cdce_pll_lock;    
    reg_status(27)                     <= '0';
    reg_status(28)                     <=     fmc_l12_pg_m2c;
    reg_status(29)                     <= not fmc_l12_prsnt_l;    
    reg_status(30)                     <=     fmc_l8_pg_m2c;    
    reg_status(31)                     <= not fmc_l8_prsnt_l;    
     --===================================--
 
    
    
    --===================================--
    -- user logic interface
    --===================================--    
    
    osc125_a_bufg_o                    <= osc125_a_bufg;
    osc125_a_mgtrefclk_o               <= osc125_a_mgtrefclk;
    osc125_b_bufg_o                    <= osc125_b_bufg;
    osc125_b_mgtrefclk_o               <= osc125_b_mgtrefclk;
    clk_31_250_bufg_o                  <= clk_31_250_bufg;
    
    ipb_rst_o                          <= ipb_rst;
    ipb_mosi_o                         <= ipb_to_slaves   (nbr_sys_slaves to nbr_usr_slaves+nbr_sys_slaves - 1) ;
                                          ipb_from_slaves (nbr_sys_slaves to nbr_usr_slaves+nbr_sys_slaves - 1) <= ipb_miso_i; 




end wrapper;