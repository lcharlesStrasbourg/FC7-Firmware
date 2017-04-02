--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			CLK GEN
--                          clk_40 (from fabric or ext_clk)
--                          ref_clk (200M)	                                                                    
-- History:        			Date         Version   	Author            Changes
--                          2017/03/01   1.0       	lcharles          Initial file 
--                                                                                                                                                   
--=================================================================================================--
--=================================================================================================--


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

--! user packages
use work.user_package.all;

entity clock_generator_core is
generic
(
	SLOWCTRL_MODE				: integer := 1 
);
port 
(
	--=======================================--
	-- FABRIC CLOCK (lvds_in from backplane) --
	--=======================================--
    fabric_clk_p_i              : in std_logic;  
    fabric_clk_n_i              : in std_logic;    
	--=================================--
    -- external clk (eg. from fmcdio5) --
    --=================================--
    ext_clk_i              		: in std_logic;  
	--============--
    -- REF_CLK_IN --
    --============--
    ref_clkin_i					: in std_logic;
    ref_clk_200M_o				: out std_logic; 
    --======================--
    -- IPBUS / SLOW CONTROL --
    --======================--
    --# version1
    clk_40_reset_i             	: in std_logic; --active high
    clk_40_mux_sel_i			: in std_logic; --external if '1'
    ref_clk_reset_i				: in std_logic; --active high
    --# version2
    ipb_clk_i					: in std_logic;	 
    --stat
    stat_global_clk_gen_o		: out stat_global_clk_gen_type;
    --ctrl
    ctrl_global_clk_gen_i		: in ctrl_global_clk_gen_type;    
	--=======--
    -- FLAGS --
    --=======--
    clk_40_locked_o            	: out std_logic; --'1': locked
    ref_clk_locked_o			: out std_logic; 
    --============--
    -- CLOCKS OUT --
    --============--
    fabric_clk_o				: out std_logic;      
    clk_40_0_o                  : out std_logic;
    clk_80_0_o                  : out std_logic;      
    clk_160_0_o                 : out std_logic; 
    clk_320_0_o                 : out std_logic           	
);


end clock_generator_core;

architecture rtl of clock_generator_core is

signal fabric_clk_pre_buf       : std_logic := '0';
signal fabric_clk               : std_logic := '0';


signal clk_40_0               	: std_logic := '0';
signal clk_80_0               	: std_logic := '0';
signal clk_160_0               	: std_logic := '0';
signal clk_320_0               	: std_logic := '0';

signal clk_after_mux            : std_logic := '0';
signal clk_gen_in              	: std_logic := '0';

signal clk_40_locked           	: std_logic := '0';
signal ref_clk_locked           : std_logic := '0';

--slow ctrl
signal clk_40_mux_sel 			: std_logic := '0';
signal clk_40_reset 			: std_logic := '0';
signal ref_clk_reset 			: std_logic := '0';


begin



stat_global_clk_gen_o.clk_40_locked 	<= clk_40_locked;
stat_global_clk_gen_o.ref_clk_locked 	<= ref_clk_locked;



fabric_clk_o		<= fabric_clk;
clk_40_0_o      	<= clk_40_0;
clk_80_0_o      	<= clk_80_0;
clk_160_0_o     	<= clk_160_0;               
clk_320_0_o     	<= clk_320_0;
--
clk_40_locked_o 	<= clk_40_locked;
ref_clk_locked_o 	<= ref_clk_locked;


--===========--
-- SLOW CTRL --
--===========--
slow_ctrl_gen0: if SLOWCTRL_MODE = 0 generate
	clk_40_mux_sel	<= clk_40_mux_sel_i;
	clk_40_reset 	<= clk_40_reset_i;
	ref_clk_reset 	<= ref_clk_reset_i;
end generate;

slow_ctrl_gen1: if SLOWCTRL_MODE = 1 generate
	clk_40_mux_sel	<= ctrl_global_clk_gen_i.clk_40_mux_sel;
	clk_40_reset 	<= ctrl_global_clk_gen_i.clk_40_reset;
	ref_clk_reset 	<= ctrl_global_clk_gen_i.ref_clk_reset;
end generate;



--===============--
-- CLOCK BUFFERS --
--===============--
--> fabric clock => TTC_clk or BX_clk (40-MHz)
fclk_ibuf: ibufgds     port map (i => fabric_clk_p_i, ib => fabric_clk_n_i, o => fabric_clk_pre_buf);
fclk_bufg: bufg        port map (i => fabric_clk_pre_buf,                   o => fabric_clk);

--> mux	
clk40_mux_inst: bufgmux
port map 
(
	O 	=> clk_after_mux,   					
	--when clk_mux_sel = '0' : fabric clock  
	I0 	=> fabric_clk_pre_buf,  
--	I0 	=> fabric_clk, 
	--when clk_mux_sel = '1' : ext_clk_i (eg. from fmcdio5) 
	I1 	=> ext_clk_i, 
	--Sel
	S 	=> clk_40_mux_sel    								
);

--clk_gen_in <= fabric_clk;
clk_gen_in <= clk_after_mux;

--===============--
-- CLK GENERATOR --
--===============--
--> BX_CLK OR CLK_40
clocks_gen_ip_inst: entity work.clock_gen_ip --clock daq
port map
(		
    -- Clock in ports
     CLK_IN1 		=> clk_gen_in, --fabric_clk, --fabric_clk_pre_buf
     -- Clock out ports
     CLK_OUT1 		=> clk_40_0, --40M - 0°
     CLK_OUT2 		=> clk_80_0, --80M - 0°
     CLK_OUT3 		=> clk_160_0,--160M - 0°
     CLK_OUT4 		=> clk_320_0,--320M - 0°		 
     -- Status and control signals
     RESET  		=> clk_40_reset,
     LOCKED 		=> clk_40_locked
);

--> REF_CLK
clock_ref_gen_ip_inst: entity work.clock_ref_gen_ip
port map
(		
    -- Clock in ports
     CLK_IN1 		=> ref_clkin_i, --125M + bufg ext
     -- Clock out ports
     CLK_OUT1 		=> ref_clk_200M_o,
     -- Status and control signals
     RESET  		=> ref_clk_reset,
     LOCKED 		=> ref_clk_locked
);



end rtl;
