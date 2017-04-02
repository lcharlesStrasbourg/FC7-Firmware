library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


use work.ipbus.all;
use work.system_package.all;
--! user packages
use work.user_package.all;
use work.user_version_package.all;

library unisim;
use unisim.vcomponents.all;


--! user packages
--use work.user_pkg_cfg_modules.all;
use work.user_pkg_be_proc.all;

entity user_core is 
port
(

	--# led
	usrled1_r						: out	std_logic; -- fmc_l12_spare[8]
	usrled1_g						: out	std_logic; -- fmc_l12_spare[9]
	usrled1_b						: out	std_logic; -- fmc_l12_spare[10]
	usrled2_r						: out	std_logic; -- fmc_l12_spare[11]
	usrled2_g						: out	std_logic; -- fmc_l12_spare[12]
	usrled2_b						: out	std_logic; -- fmc_l12_spare[13]

	--# on-board fabric clk
    fabric_clk_p                    : in    std_logic; -- new port [PV 2015.08.19]
    fabric_clk_n                    : in    std_logic; -- new port [PV 2015.08.19]
    fabric_coax_or_osc_p 			: in 	std_logic;
	fabric_coax_or_osc_n 			: in 	std_logic;

	--# on-board mgt clk
	pcie_clk_p						: in	std_logic;
    pcie_clk_n                      : in    std_logic;
	osc_xpoint_a_p					: in	std_logic;
	osc_xpoint_a_n					: in	std_logic;
	osc_xpoint_b_p					: in	std_logic;
	osc_xpoint_b_n					: in	std_logic;
	osc_xpoint_c_p					: in	std_logic;
	osc_xpoint_c_n					: in	std_logic;
	osc_xpoint_d_p					: in	std_logic;
	osc_xpoint_d_n					: in	std_logic;
	ttc_mgt_xpoint_a_p				: in	std_logic;
	ttc_mgt_xpoint_a_n				: in	std_logic;
	ttc_mgt_xpoint_b_p				: in	std_logic;
	ttc_mgt_xpoint_b_n				: in	std_logic;
	ttc_mgt_xpoint_c_p				: in	std_logic;
	ttc_mgt_xpoint_c_n				: in	std_logic;
			
	--# fmc mgt clk		
	fmc_l12_gbtclk0_a_p				: in	std_logic; 
	fmc_l12_gbtclk0_a_n				: in	std_logic; 
	fmc_l12_gbtclk1_a_p				: in	std_logic; 
	fmc_l12_gbtclk1_a_n				: in	std_logic; 
	fmc_l12_gbtclk0_b_p				: in	std_logic; 
	fmc_l12_gbtclk0_b_n				: in	std_logic; 
	fmc_l12_gbtclk1_b_p				: in	std_logic; 
	fmc_l12_gbtclk1_b_n				: in	std_logic; 
	fmc_l8_gbtclk0_p				: in	std_logic; 
	fmc_l8_gbtclk0_n				: in	std_logic; 
	fmc_l8_gbtclk1_p				: in	std_logic; 
	fmc_l8_gbtclk1_n				: in	std_logic; 

	--# fmc mgt
	fmc_l12_dp_c2m_p				: out	std_logic_vector(11 downto 0);
	fmc_l12_dp_c2m_n				: out	std_logic_vector(11 downto 0);
	fmc_l12_dp_m2c_p				: in	std_logic_vector(11 downto 0);
	fmc_l12_dp_m2c_n				: in	std_logic_vector(11 downto 0);
	fmc_l8_dp_c2m_p					: out	std_logic_vector( 7 downto 0);
	fmc_l8_dp_c2m_n					: out	std_logic_vector( 7 downto 0);
	fmc_l8_dp_m2c_p					: in	std_logic_vector( 7 downto 0);
	fmc_l8_dp_m2c_n					: in	std_logic_vector( 7 downto 0);
	
	--# fmc fabric clk	
    fmc_l8_clk0                     : in    std_logic; 
    fmc_l8_clk1                     : in    std_logic;
    fmc_l12_clk0                    : in    std_logic;
    fmc_l12_clk1                    : in    std_logic;    

	--# fmc gpio		
	fmc_l8_la_p						: inout	std_logic_vector(33 downto 0);
	fmc_l8_la_n						: inout	std_logic_vector(33 downto 0);
	fmc_l12_la_p					: inout	std_logic_vector(33 downto 0);
	fmc_l12_la_n					: inout	std_logic_vector(33 downto 0);
	
	--# amc mgt		
	k7_amc_rx_p						: inout	std_logic_vector(15 downto 1);
	k7_amc_rx_n						: inout	std_logic_vector(15 downto 1);
	amc_tx_p						: inout	std_logic_vector(15 downto 1);
	amc_tx_n						: inout	std_logic_vector(15 downto 1);
	
	--# amc fabric
	k7_fabric_amc_rx_p03			: inout	std_logic;
	k7_fabric_amc_rx_n03    		: inout	std_logic;
	k7_fabric_amc_tx_p03    		: inout	std_logic;
	k7_fabric_amc_tx_n03    		: inout	std_logic;

	--# ddr3
	ddr3_sys_clk_p 					: in	std_logic;
	ddr3_sys_clk_n 					: in	std_logic;
	ddr3_dq                 		: inout std_logic_vector( 31 downto 0);
	ddr3_dqs_p              		: inout std_logic_vector(  3 downto 0);
	ddr3_dqs_n              		: inout std_logic_vector(  3 downto 0);
	ddr3_addr               		: out   std_logic_vector( 13 downto 0);
	ddr3_ba                 		: out   std_logic_vector(  2 downto 0);
	ddr3_ras_n              		: out   std_logic;
	ddr3_cas_n              		: out   std_logic;
	ddr3_we_n               		: out   std_logic;
	ddr3_reset_n            		: out   std_logic;
	ddr3_ck_p               		: out   std_logic_vector(  0 downto 0);
	ddr3_ck_n               		: out   std_logic_vector(  0 downto 0);
	ddr3_cke                		: out   std_logic_vector(  0 downto 0);
	ddr3_cs_n               		: out   std_logic_vector(  0 downto 0);
	ddr3_dm                 		: out   std_logic_vector(  3 downto 0);
	ddr3_odt                		: out   std_logic_vector(  0 downto 0);

    --# cdce
	cdce_pll_lock_i                 : in    std_logic; -- new port [PV 2015.08.19]  
    cdce_pri_clk_bufg_o 		    : out 	std_logic; -- new port [PV 2015.08.19] 
    cdce_ref_sel_o                  : out   std_logic; -- new port [PV 2015.08.19]   
    cdce_pwrdown_o                  : out   std_logic; -- new port [PV 2015.08.19]  
    cdce_sync_o                     : out   std_logic; -- new port [PV 2015.08.19]  
    cdce_sync_clk_o                 : out   std_logic; -- new port [PV 2015.08.19]  

	--# system clk		
	osc125_a_bufg_i					: in	std_logic;
	osc125_a_mgtrefclk_i			: in	std_logic;
	osc125_b_bufg_i					: in 	std_logic;
	osc125_b_mgtrefclk_i			: in	std_logic;
    clk_31_250_bufg_i		        : in	std_logic; -- new port [PV 2015.08.19]
    
    --# ipbus comm    
	ipb_clk_o				        : out	std_logic;
	ipb_rst_i				        : in	std_logic;
	ipb_miso_o			            : out	ipb_rbus_array(0 to nbr_usr_slaves-1);
	ipb_mosi_i			            : in	ipb_wbus_array(0 to nbr_usr_slaves-1);

    --# ipbus conf
	ip_addr_o						: out	std_logic_vector(31 downto 0);
    mac_addr_o                      : out   std_logic_vector(47 downto 0);
    rarp_en_o                       : out   std_logic;
    use_i2c_eeprom_o                : out   std_logic
);
end user_core;

architecture usr of user_core is

--===================================--
-- Constant definition
--===================================--
constant NUM_HYBRIDS            : integer := 1;
--===================================--
    
--===================================--
-- Signal definition
--===================================--

--# Clocking
--
signal ipb_clk                    		: std_logic := '0';
--
signal fabric_clk_pre_buf               : std_logic := '0';                
signal fabric_clk                       : std_logic := '0';
--
signal ext_clk							: std_logic := '0';
--
signal clk_40_0                         : std_logic := '0';
signal clk_80_0                         : std_logic := '0';
signal clk_160_0                        : std_logic := '0';
signal clk_320_0                        : std_logic := '0';
--
signal ref_clk_200M						: std_logic := '0'; 
--
signal clk_readout                      : std_logic := '0';
signal BX_clk                           : std_logic := '0';
--
signal clk_40_locked                    : std_logic := '0';
signal ref_clk_locked                   : std_logic := '0';
--

--# AMC13
--amc13 dummy event
signal AMC13Link_EventData_header 		: std_logic := '0'; -- first data word
signal AMC13Link_EventData_trailer 		: std_logic := '0'; -- last data word
signal AMC13Link_EventData  			: std_logic_vector(63 downto 0) := (others => '0');
signal AMC13Link_EventData_valid 		: std_logic := '0';
--tts
signal TTS_state 						: std_logic_vector(3 downto 0) := (others => '0');

--# Counters
signal BX_cnt_int 						: integer range 0 to 2**12 - 1 := 0;
signal BX_cnt		 					: std_logic_vector(11 downto 0) := (others => '0');
signal BX_cnt_full 						: std_logic := '0';
--
signal orbit_cnt_int 					: integer range 0 to 2**16 - 1 := 0;
signal orbit_cnt		 				: std_logic_vector(15 downto 0) := (others => '0');
--
signal L1Acnt_int 						: integer range 0 to 2**24 - 1 := 0;
signal L1Acnt		 					: std_logic_vector(23 downto 0) := (others => '0');
signal L1Acnt_valid						: std_logic := '0';
--
signal evnt_cnt							: std_logic_vector(23 downto 0) := (others => '0');  --L1A_cnt24b

--# L1A
signal L1A 								: std_logic := '0'; --L1-Trigger (ORed TTC_L1A, ext_trigger,...)

--# TTC
signal ttc_rdy							: std_logic := '0';
signal ttc_L1A              			: std_logic := '0';
signal ttc_cmd_ec0    					: std_logic := '0';
signal ttc_cmd_bc0						: std_logic := '0';
signal ttc_cmd_reset					: std_logic := '0';


--# PHY / BE_PROC interface                                                    
signal cbc3_trigdata					: cbc3_trigdata_in_sys_type; 
signal cbc3_trigdata_valid				: valid_in_sys_type;   
--                                                     
signal cbc3_stubdata					: cbc3_stubdata_in_sys_type;	   



-- Global reset signal from IPBus
signal ipb_global_reset      	: std_logic;
--===================================--
-- Fast Command Block Signals
--===================================--
-- Trigger Fast Signals from Fast Command Block
signal fast_signal_to_phy       : cmd_fastbus;    
-- Stubs From Hybrids
signal hybrid_stubs             : std_logic_vector(NUM_HYBRIDS downto 1);
signal fast_block_status_fsm    : std_logic_vector(7 downto 0);
signal fast_block_error         : std_logic_vector(7 downto 0);
-- Control bus to Fast Command Block
signal ctrl_fast_block          : ctrl_fastblock_type;
signal cnfg_fast_block          : cnfg_fastblock_type;
signal stat_fast_block          : stat_fastblock_type;
--===================================--

signal test_clock_frequency     : array_4x32bit;


--===================================--
-- Command Processor Block Signals
--===================================--
signal cmd_reply : cmd_rbus;
signal stub_to_hb : stub_data_to_hb_t_array(0 to NUM_HYBRIDS-1);
signal trig_data_to_hb : triggered_data_frame_r_array(0 to NUM_HYBRIDS-1);
-- control of command processor block
signal cnfg_command_block               : cnfg_command_block_type;
signal ctrl_command_block_from_ipbus    : ctrl_command_block_from_ipbus_type;
signal ctrl_command_block_to_ipbus      : ctrl_command_block_to_ipbus_type;
signal stat_command_block               : stat_command_block_type;


--===================================--
-- Global Block Signals
--===================================--
signal stat_global_clk_gen				: stat_global_clk_gen_type;
signal stat_global_ttc					: stat_global_ttc_type;
signal ctrl_global_clk_gen 				: ctrl_global_clk_gen_type;            
signal ctrl_global_ttc					: ctrl_global_ttc_type;
signal ctrl_global_amc13				: ctrl_global_amc13_type;

--===================================--
-- Readout Block Signals
--===================================--
signal stat_readout						: stat_readout_type;
signal stat_be_proc						: stat_be_proc_type;
signal ctrl_readout_to_ipbus			: ctrl_readout_to_ipbus_type;
signal ctrl_readout_from_ipbus			: ctrl_readout_from_ipbus_type;





           
            
begin

	--===========================================--
	-- ipbus management
	--===========================================--
	ipb_clk					<= clk_31_250_bufg_i;     -- select the frequency of the ipbus clock
	ipb_clk_o				<= ipb_clk;               -- always forward the selected ipb_clk to system core
	--
	ip_addr_o				<= x"c0_a8_00_50"; --192.168.0.80
	mac_addr_o				<= x"aa_bb_cc_dd_ee_50";
	rarp_en_o				<= '1';
	use_i2c_eeprom_o 		<= '1';
	--===========================================--	
    
    --===================================--
    -- Block responsible for I2C command processing. Is connected to: fast command block, hybrids.
    --===================================--
    command_processor_block: entity work.command_processor_core;
    --===================================--
    --generic map
    --(
    --)
    --port map
    --(
    --);        
    --===================================--    
    
    --===================================--
    -- Fast commands. Connected to: physical interface, hybrids.
    --===================================--
    fast_command_block: entity work.fast_command_core;
    --===================================--
    --generic map
    --(
    --)
    --port map
    --(
    --);        
    --===================================-- 
      
    
    --===================================--
    -- Physical interface layer. Connected to: hybrids (40mhz lines + I2C lines), fast commands, FMC 1&2
    --===================================--
    phy_block: entity work.phy_core;
    --===================================--
    --generic map
    --(
    --)
    --port map
    --(
    --);        
    --===================================--
 
 
 
 
--     --===================================--
--    -- Hybrids generation
--    --===================================--   
--    HYB_GEN : FOR hybrid_i IN 1 TO NUM_HYBRIDS GENERATE
--    --===================================--
--    hybrid_block: entity work.hybrid_core;
--    --===================================--
--    --generic map
--    --(
--    --)
--    --port map
--    --(
--    --);        
--    --===================================--
--    END GENERATE HYB_GEN;
--    --===================================--  
 
 
 
    
--    --===================================--
--    -- BE Data Buffer - Contains Global Event Builder. Connected to: hybrids
--    --===================================--
--    be_data_buffer_block: entity work.be_data_buffer_core
--    --===================================--
--    --generic map
--    --(
--    --)
--    port map
--    (
--		cbc3_trigdata_sys_i					=> (others=>(others=>(others=>(others=>(others=>'0'))))),
--		cbc3_stubdata_sys_i					=> (others=>(others=>(others=>(others=>(others=>'0'))))),
--		cbc3_trigdata_and_stubdata_sys_i	=> (others=>(others=>(others=>(others=>(others=>'0')))))   
--    );        
--    --===================================--  
 

--=============================================================================================================================================--
-- START CLK_GEN -- 
--=============================================================================================================================================--  
ext_clk <= fmc_l8_la_p(16); --test

clock_generator_core_inst: entity work.clock_generator_core
port map
(
	--=======================================--
	-- FABRIC CLOCK (lvds_in from backplane) --
	--=======================================--
	fabric_clk_p_i              => fabric_clk_p, 
	fabric_clk_n_i              => fabric_clk_n,  
	--=================================--
    -- external clk (eg. from fmcdio5) --
    --=================================--
    ext_clk_i              		=> ext_clk,  
	--=======================================--
    -- REF_CLK_IN --
    --=======================================--
    ref_clkin_i					=> osc125_a_bufg_i,                 
    --======================--
    -- IPBUS / SLOW CONTROL --
    --======================--
    --# version1
	clk_40_reset_i             	=> '0',  --all the  generator (pll or mmcm)
	clk_40_mux_sel_i			=> '0', --clk_40_mux_sel,
    ref_clk_reset_i				=> '0',
    --# version2
	ipb_clk_i					=> ipb_clk,    
    stat_global_clk_gen_o		=> stat_global_clk_gen,
    ctrl_global_clk_gen_i		=> ctrl_global_clk_gen,   
	--=======--
    -- FLAGS --
    --=======--
	clk_40_locked_o            	=> clk_40_locked,  --'1': locked
    ref_clk_locked_o			=> ref_clk_locked,
	--============--
	-- CLOCKS OUT --
	--============--      
	--# 40M
	fabric_clk_o				=> fabric_clk,
	clk_40_0_o                  => clk_40_0,  
	clk_80_0_o                 	=> clk_80_0,       
	clk_160_0_o                 => clk_160_0,  
	clk_320_0_o                 => clk_320_0,
	--# ref clk
    ref_clk_200M_o				=> ref_clk_200M	
);       

--clk_40_0 <= fabric_clk;

BX_clk 			<= clk_40_0;
clk_readout 	<= clk_40_0; 
--=============================================================================================================================================--
-- END CLK_GEN -- 
--=============================================================================================================================================-- 



    
--=============================================================================================================================================--
-- START TTC DECOD -- 
--=============================================================================================================================================--    

ttc_decoder_block_inst: entity work.ttc_decoder_block   
port map
(
	--================================--
	-- FABRIC CLOCK (before mmcm/pll) --
	--================================--
	fabric_clk_i				=> fabric_clk,  
	--===============================--
	-- FABRIC CLOCK (after mmcm/pll) --
	--===============================--
	BX_clk_i   					=> clk_40_0, 
	--===============--
    -- Powerup reset --
    --===============--  
    powerup_reset_i				=> ipb_rst_i,  	                      
    --======================--
	-- IPBUS / SLOW CONTROL --
	--======================--
    --# version1
	ttc_dec_reset_i				=> '0', --sw_ttc_dec_reset,
	--iodelay
	iodelay_clk_i				=> ref_clk_200M, --ttc_dec_idel.clk,
	iodelay_load_i     			=> '0',--ttc_dec_idel.load,-- delay increment, decrement signal for bit 
    iodelay_inc_i      			=> '0',--ttc_dec_idel.inc,-- delay increment, decrement signal for bit 
    iodelay_ce_i       			=> '0',--ttc_dec_idel.ce,-- delay increment, decrement signal for bit 
    iodelay_tap_ctrl_i      	=> (others => '0'),--ttc_dec_idel.tap_ctrl,-- dynamically loadable delay tap value for bit 
    iodelay_tap_stat_o      	=> open,--ttc_dec_idel.tap_stat,-- bit  delay tap value for monitor
    --# version2
	ipb_clk_i					=> ipb_clk,
    --stat
    stat_global_ttc_o			=> stat_global_ttc, 
    --ctrl
    ctrl_global_ttc_i			=> ctrl_global_ttc,    	
	--=================--
	-- TTC DATA INPUTS -- 
	--=================--
	ttc_data_p_i 				=> k7_fabric_amc_rx_p03,
	ttc_data_n_i           		=> k7_fabric_amc_rx_n03, 
    --=================--
	-- FLAGS or STATUS --
	--=================--  
	ttc_rdy_o					=> ttc_rdy,
	ttc_dec_single_err_cnt_o	=> open,
	ttc_dec_double_err_cnt_o	=> open, 	
	--=============--
	-- TTC OUTPUTS --
	--=============--    
	ttc_l1a_o               	=> ttc_L1A,
	--B-Chan CMDs
	ttc_cmd_ec0_o				=> ttc_cmd_ec0,
	ttc_cmd_bc0_o				=> ttc_cmd_bc0,
	ttc_cmd_reset_o				=> ttc_cmd_reset
);    
--=============================================================================================================================================--
-- END TTC DECOD -- 
--=============================================================================================================================================--     




--=============================================================================================================================================--
-- START AMC13 BLOCK -- 
--=============================================================================================================================================--
amc13_block_inst: entity work.amc13_block 
port map 
( 
	--========--
	-- CLOCKS --
	--========--
	BX_clk_i				=> clk_40_0, --BX_clk, 
	--===============--
    -- Powerup reset --
    --===============--    
    powerup_reset_i			=> ipb_rst_i, --used internally for the link & the user part	
	--============================--
    -- User reset (dummy events)  --
    --============================--
	user_reset_i			=> '0',  --from be_proc
    --======================--
	-- IPBUS / SLOW CONTROL --
	--======================--
	--# version1
	amc13_link_reset_i  	=> '0', --sw_amc13_link_reset,
	sw_TTS_state_valid_i	=> '0', --sw_TTS_valid,	
	sw_TTS_state_i			=> "0000", --sw_TTS_state,	
	--# version2
	ipb_clk_i				=> ipb_clk,    
	ctrl_global_amc13_i		=> ctrl_global_amc13,  	
	--==============--	
	-- GTX INTERFACE--                       	
	--==============--	
	gtx_refclk_i			=> osc125_a_mgtrefclk_i,
	--
	gtx_rx_n_i				=> k7_amc_rx_n(1), --see usr_mgt_amc.xdc 
	gtx_rx_p_i				=> k7_amc_rx_p(1), --see usr_mgt_amc.xdc  
	gtx_tx_n_i				=> amc_tx_n(1), 
	gtx_tx_p_i				=> amc_tx_p(1), 	
	--==========--	
	-- TTS PORT --                       	
	--==========--		
	tts_port_clk_i   		=> clk_40_0, --clk_readout, --clk_40_0, --> 160M if TTS FSM in 160M or TTS_state_160M 
	tts_state_i				=> TTS_state, --from be_proc
	--===============--
	-- TTC INTERFACE --
	--===============--	
	--for dummy events	
	L1A_i					=> L1A, --L1Acnt_valid, 
	bcn_i					=> BX_cnt, --12b 	
	orn_i 					=> orbit_cnt, --16b
	evn_i 					=> evnt_cnt --L1Acnt --24b
);

--L1Acnt_valid <= ttc_L1A or int_trig;
--=============================================================================================================================================--
-- END AMC13 BLOCK -- 
--=============================================================================================================================================--


--====================--
-- CONNECTIONS TO ADD --
--====================--
--# PHY 
--cbc3_trigdata			<= ;
--cbc3_trigdata_valid	<= ;   
--cbc3_stubdata			<= ;
--# Trigger L1A
--L1A 					<= ttc_L1A; --put others choices 


--=============================================================================================================================================--
-- START BE_PROC -- 
--=============================================================================================================================================--

be_proc_inst: entity work.be_proc 
port map
(
	clk_i							=> BX_clk,                            
	reset_i							=> ipb_rst_i, --user_reset,  
    --======================--
	-- IPBUS / SLOW CONTROL --
	--======================--
	--# version1							    
	--# version2
	ipb_clk_i						=> ipb_clk, 
	--stat
	stat_readout_o					=> stat_readout,
	--
	stat_be_proc_o					=> stat_be_proc,
	--ctrl
	ctrl_readout_to_ipbus_o			=> ctrl_readout_to_ipbus, 
	ctrl_readout_from_ipbus_i		=> ctrl_readout_from_ipbus,    
	--======================--	
	ttc_cmd_ec0_i					=> ttc_cmd_ec0, --EC0 or evnt_cnt_reset
	--
	evnt_cnt_o 						=> evnt_cnt,
	--
	L1A_i							=> L1A,                 
	--from PHY                                                     
	cbc3_trigdata_i					=> cbc3_trigdata,      
	cbc3_trigdata_valid_i			=> cbc3_trigdata_valid,  
	--                                                     
	cbc3_stubdata_i					=> cbc3_stubdata
);




    --===================================--
    -- IPBus Control Decoder
    --===================================--
    ipbus_decoder_ctrl: entity work.ipbus_decoder_ctrl
    --===================================--
    port map
    (   
        clk_ipb               => ipb_clk,
        clk_40MHz             => clk_40_0, --clk_40MHz_fromBUFG,
        reset                 => ipb_global_reset,
        ipb_mosi_i            => ipb_mosi_i(ipb_daq_system_ctrl_sel),
        ipb_miso_o            => ipb_miso_o(ipb_daq_system_ctrl_sel),
        -- global commands
        ipb_global_reset      => ipb_global_reset,
        -- ctrl global clk_gen 
        ctrl_global_clk_gen_o => ctrl_global_clk_gen,  
         -- ctrl global clk_gen 
        ctrl_global_ttc_o 	  => ctrl_global_ttc,  
         -- ctrl global clk_gen         
		ctrl_global_amc13_o	  => ctrl_global_amc13,
        -- ctrl readout from ipb
		ctrl_readout_from_ipbus_o => ctrl_readout_from_ipbus, 
		-- ctrl readout to ipb
		ctrl_readout_to_ipbus_i  => ctrl_readout_to_ipbus,   		             
        -- fast commands
        ctrl_fastblock_o      => ctrl_fast_block,
        -- command processor
        ctrl_command_block_from_ipbus   => ctrl_command_block_from_ipbus,                    
        ctrl_command_block_to_ipbus     => ctrl_command_block_to_ipbus 
    );
    --===================================--
    
--    --===================================--
--    -- IPBus Config Decoder
--    --===================================--
--    ipbus_decoder_cnfg: entity work.ipbus_decoder_cnfg
--    --===================================--
--    port map
--    (   
--        clk                   => ipb_clk,
--        reset                 => ipb_global_reset,
--        ipb_mosi_i            => ipb_mosi_i(ipb_daq_system_cnfg_sel),
--        ipb_miso_o            => ipb_miso_o(ipb_daq_system_cnfg_sel),
--        -- fast block
--        cnfg_fastblock_o      => cnfg_fast_block,
--        -- command block
--        cnfg_command_block_o  => cnfg_command_block
--    );
--    --===================================--
    
    --===================================--
    -- IPBus Status Decoder
    --===================================--
    ipbus_decoder_stat: entity work.ipbus_decoder_stat
    --===================================--
    port map
    (   
        clk                   => ipb_clk,
        reset                 => ipb_global_reset,
        ipb_mosi_i            => ipb_mosi_i(ipb_daq_system_stat_sel),
        ipb_miso_o            => ipb_miso_o(ipb_daq_system_stat_sel),
        -- stat global clk_gen 
        stat_global_clk_gen_i => stat_global_clk_gen,       
        -- stat global ttc 
        stat_global_ttc_i 	  => stat_global_ttc, 
        -- stat readout block  
        stat_readout_i		  => stat_readout, 
		--
        stat_be_proc_i		  => stat_be_proc,                
        -- fast command block statuses
        stat_fast_block_i      => stat_fast_block, --:= ((others => '0'),'0','0',(others => '0'))
        -- command block statuses
        stat_command_block_i  => stat_command_block,        
        -- clock frequencies tester
        test_clock_frequency   => test_clock_frequency,
        -- temporary line while HYBRID block is not existing
        trig_data_i => trig_data_to_hb
    );
    --===================================--



end usr;
