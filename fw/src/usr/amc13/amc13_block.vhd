--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			AMC13 Link	                                                                    
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file 
--                                                                                                                                                   
--=================================================================================================--
--=================================================================================================--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.all;

--! user packages
use work.user_package.all;



--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity amc13_block is
generic
(
	SLOWCTRL_MODE				: integer := 1 
);
port 
(
	--========--
	-- CLOCKS --
	--========--
	BX_clk_i					: in std_logic; 
	--===============--
    -- Powerup reset --
    --===============--     
    powerup_reset_i				: in std_logic; 	 
	--============================--
	-- User reset (dummy events)  --
	--============================--
	user_reset_i				: in std_logic; --just the dummy events
    --======================--
	-- IPBUS / SLOW CONTROL --
	--======================--	
    --# version1	
	amc13_link_reset_i  		: in std_logic; 
	sw_TTS_state_valid_i		: in std_logic;
	sw_TTS_state_i				: in std_logic_vector(3 downto 0);
    --# version2	
    --ctrl
    ipb_clk_i					: in std_logic;
    ctrl_global_amc13_i			: in ctrl_global_amc13_type;    		
	--==============--	
	-- GTX INTERFACE--                       	
	--==============--	
	gtx_refclk_i				: in std_logic;
	--
	gtx_rx_n_i					: in std_logic; 
	gtx_rx_p_i					: in std_logic; 
	gtx_tx_n_i					: out std_logic; 
	gtx_tx_p_i					: out std_logic; 	
	--==========--	
	-- TTS PORT --                       	
	--==========--		
	tts_port_clk_i   			: in std_logic;
	tts_state_i					: in std_logic_vector(3 downto 0);
	--===============--
	-- TTC INTERFACE --
	--===============--	
	--for dummy events	
	L1A_i						: in std_logic;
	bcn_i						: in std_logic_vector(11 downto 0); 	
	orn_i 						: in std_logic_vector(15 downto 0);
	evn_i 						: in std_logic_vector(23 downto 0)		
);
	
end amc13_block;



architecture archi of amc13_block is


--amc13 dummy event
signal EventData_header 			: std_logic := '0'; -- first data word
signal EventData_trailer 			: std_logic := '0'; -- last data word
signal EventData  					: std_logic_vector(63 downto 0) := (others => '0');
signal EventData_valid 				: std_logic := '0';


signal amc13_link_reset 			: std_logic := '0';
signal sw_TTS_state  				: std_logic_vector(3 downto 0) := (others => '0');
signal sw_TTS_state_valid 			: std_logic := '0';

signal tts_state  					: std_logic_vector(3 downto 0) := (others => '0');


begin


--===========--
-- SLOW CTRL --
--===========--
slow_ctrl_gen0: if SLOWCTRL_MODE = 0 generate
	amc13_link_reset <= amc13_link_reset_i or powerup_reset_i;
	resync_proc: process
	begin
	wait until rising_edge(tts_port_clk_i); --if resync no made on top
		sw_TTS_state_valid	<= sw_TTS_state_valid_i;		
		sw_TTS_state		<= sw_TTS_state_i;
	end process;
end generate;

slow_ctrl_gen1: if SLOWCTRL_MODE = 1 generate
	amc13_link_reset <= ctrl_global_amc13_i.amc13_link_reset or powerup_reset_i;
	resync_proc: process
	begin
	wait until rising_edge(tts_port_clk_i);	
		sw_TTS_state_valid 	<= ctrl_global_amc13_i.sw_TTS_state_valid;	
		sw_TTS_state 		<= ctrl_global_amc13_i.sw_TTS_state;
	end process;		
end generate;


--> mux
TTS_state_mux: process
begin
wait until rising_edge(tts_port_clk_i);
	if sw_TTS_state_valid = '1' then
		tts_state <= sw_TTS_state;
	else
		tts_state <= tts_state_i; --from be_proc
	end if;
end process;	


--> resync made in DAQ_Link_7S -> 40M ok if EventDataClk = 40M in AMC13Link
AMC13Link_EmptyEvent_inst: entity work.EmptyEvent 
port map 
( 
	clk 				=> BX_clk_i, 
	L1A 				=> L1A_i,
	reset 				=> user_reset_i or powerup_reset_i,
	bcnt	 			=> bcn_i, --12b
	orn 				=> orn_i, --16b
	evn 				=> evn_i, --24b
	EventData_header 	=> EventData_header,
	EventData_trailer 	=> EventData_trailer,
	EventData 			=> EventData,
	EventData_valid		=> EventData_valid
);



amc13_link_inst: entity work.DAQ_LINK_Kintex 
generic map 
(
--	REFCLK frequency, select one among 100, 125, 200 and 250
--	If your REFCLK frequency is not in the list, please contact wusx@bu.edu
	F_REFCLK					=> 125,
	SYSCLK_IN_period			=> 24, -- unit is ns
--	If you do not use the trigger port, set it to false
	USE_TRIGGER_PORT			=> false,
	simulation                 	=> false
)
port map
(
	reset						=> amc13_link_reset, -- asynchronous reset, assert reset until GTX REFCLK stable 
	GTX_REFCLK 					=> gtx_refclk_i, 
	GTX_RXN  					=> gtx_rx_n_i,
	GTX_RXP               		=> gtx_rx_p_i,
	GTX_TXN            			=> gtx_tx_n_i,
	GTX_TXP             		=> gtx_tx_p_i,
--	TRIGGER port - ignored!!!
	TTCclk    					=> '0',
	BcntRes   					=> '0',
	trig          				=> (others => '0'),
	-- TTS port
	TTSclk   					=> tts_port_clk_i,
	TTS             			=> tts_state, --TTS
--	SYSCLK_IN is required by the GTX ip core, you can connect any clock source(e.g. TTSclk, TTCclk or EventDataClk) as long as its period is in the range of 8-250ns
--	do not forget to specify its period in the generic port
	SYSCLK_IN           		=> BX_clk_i,
	ReSyncAndEmpty    			=> '0',
	EventDataClk 				=> BX_clk_i,
	EventData_valid       		=> EventData_valid,
	EventData_header        	=> EventData_header,
	EventData_trailer    		=> EventData_trailer,
	EventData                 	=> EventData,
	AlmostFull                  => open,
	Ready                     	=> open 
);

end archi;


