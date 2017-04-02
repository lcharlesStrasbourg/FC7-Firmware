--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			data processing & buffering (TRIGDATA & STUBDATA) for one chip CBC3 (chip-level)                                                                   
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file  
--                                                                                                                                                   
--=================================================================================================--
--=================================================================================================--


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--! user packages
use work.user_pkg_cfg_modules.all;
use work.user_pkg_be_proc.all;



entity cbc3_data_proc is
--generic
--(
--	stubdata_delay_value_size			: integer := 8
--);	
port 
(
	clk_i								: in std_logic;
	reset_i								: in std_logic;
	--TRIGDATA 
	cbc3_trigdata_i						: in std_logic_vector(273 downto 0); 
	cbc3_trigdata_valid_i				: in std_logic; 
	--STUBDATA
	cbc3_stubdata_i						: in  std_logic_vector(39 downto 0);	
	cbc3_stubdata_valid_i				: in std_logic;	
	cbc3_stubdata_delay_value_i			: in std_logic_vector(stubdata_delay_value_size-1 downto 0); 
	L1A_i								: in std_logic;
	--Buffering interface
	all_buf_rd_en_i						: in std_logic;
	cbc3_trigdata_buf_dout_o			: out cbc3_trigdata_chip_type;	
	cbc3_stubdata_buf_dout_o			: out cbc3_stubdata_chip_type;	
	cbc3_trig_and_stubdata_buf_dout_o	: out cbc3_trig_and_stubdata_chip_type;
	cbc3_data_buf_valid_o				: out std_logic;
	cbc3_trigdata_buf_empty_o			: out std_logic;
	cbc3_trigdata_buf_full_o			: out std_logic;
	cbc3_trigdata_buf_prog_full_o		: out std_logic;
	cbc3_stubdata_buf_empty_o			: out std_logic;
	cbc3_stubdata_buf_full_o			: out std_logic;
	cbc3_stubdata_buf_prog_full_o		: out std_logic		
);
end cbc3_data_proc;


architecture rtl of cbc3_data_proc is

signal cbc3_trigdata_buf_dout 			: cbc3_trigdata_chip_type 				:= (others=>(others=>'0'));
signal cbc3_stubdata_buf_dout 			: cbc3_stubdata_chip_type 				:= (others=>(others=>'0'));
signal cbc3_trig_and_stubdata_buf_dout 	: cbc3_trig_and_stubdata_chip_type 		:= (others=>(others=>'0'));
signal cbc3_trigdata_buf_valid 			: std_logic := '0';

signal cbc3_trigdata_buf_empty 			: std_logic := '0';
signal cbc3_trigdata_buf_full 			: std_logic := '0';
signal cbc3_trigdata_buf_prog_full		: std_logic := '0';

signal cbc3_stubdata_buf_empty 			: std_logic := '0';
signal cbc3_stubdata_buf_full 			: std_logic := '0';
signal cbc3_stubdata_buf_prog_full		: std_logic := '0';




begin

--============--
-- OUTPUTTING --
--============--
cbc3_trigdata_buf_dout_o 			<= cbc3_trigdata_buf_dout;
cbc3_stubdata_buf_dout_o			<= cbc3_stubdata_buf_dout;
cbc3_trig_and_stubdata_buf_dout_o	<= cbc3_trig_and_stubdata_buf_dout;
cbc3_data_buf_valid_o				<= cbc3_trigdata_buf_valid; 

cbc3_trigdata_buf_empty_o			<= cbc3_trigdata_buf_empty;
cbc3_trigdata_buf_full_o			<= cbc3_trigdata_buf_full;
cbc3_trigdata_buf_prog_full_o		<= cbc3_trigdata_buf_prog_full;

cbc3_stubdata_buf_empty_o			<= cbc3_stubdata_buf_empty;
cbc3_stubdata_buf_full_o			<= cbc3_stubdata_buf_full;
cbc3_stubdata_buf_prog_full_o		<= cbc3_stubdata_buf_prog_full;

--==============================--
-- TRIG_AND_STUBDATA FORMATTING --
--==============================--
gen1: for i in 1 to CBC3_TRIGDATA_SIZE generate
	cbc3_trig_and_stubdata_buf_dout(i) <= cbc3_trigdata_buf_dout(i);
end generate;

gen2: for i in 1 to CBC3_STUBDATA_SIZE generate
	cbc3_trig_and_stubdata_buf_dout(CBC3_TRIGDATA_SIZE + i) <= cbc3_stubdata_buf_dout(i);
end generate;


--====================--
-- CBC3 TRIGDATA PROC --
--====================--
cbc3_trigdata_proc_i: entity work.cbc3_trigdata_proc
port map 
(
	clk_i							=> clk_i,
	reset_i							=> reset_i,
	--Data from PHY
	cbc3_trigdata_i 				=> cbc3_trigdata_i,
	cbc3_trigdata_valid_i 			=> cbc3_trigdata_valid_i,
	--Buffer interface
	cbc3_trigdata_buf_rd_en_i		=> all_buf_rd_en_i,
	cbc3_trigdata_buf_dout_o		=> cbc3_trigdata_buf_dout,
	cbc3_trigdata_buf_valid_o		=> cbc3_trigdata_buf_valid,
	cbc3_trigdata_buf_empty_o		=> cbc3_trigdata_buf_empty,
	cbc3_trigdata_buf_full_o		=> cbc3_trigdata_buf_full,
	cbc3_trigdata_buf_prog_full_o	=> cbc3_trigdata_buf_prog_full		
);


--====================--
-- CBC3 STUBDATA PROC --
--====================--
cbc3_stubdata_proc_i: entity work.cbc3_stubdata_proc
--generic map
--(
--	stubdata_delay_value_size		=> stubdata_delay_value_size
--)
port map 
(
	clk_i							=> clk_i,
	reset_i							=> reset_i,
	--Data from PHY
	cbc3_stubdata_i 				=> cbc3_stubdata_i,
	cbc3_stubdata_valid_i 			=> cbc3_stubdata_valid_i,
	--Stubdata delaying
	cbc3_stubdata_delay_value_i		=> cbc3_stubdata_delay_value_i,
	--Local L1A
	L1A_i							=> L1A_i,		
	--Buffer interface
	cbc3_stubdata_buf_rd_en_i		=> all_buf_rd_en_i,
	cbc3_stubdata_buf_dout_o		=> cbc3_stubdata_buf_dout,
	cbc3_stubdata_buf_valid_o		=> open, --cbc3_stubdata_buf_valid
	cbc3_stubdata_buf_empty_o		=> cbc3_stubdata_buf_empty,
	cbc3_stubdata_buf_full_o		=> cbc3_stubdata_buf_full,
	cbc3_stubdata_buf_prog_full_o	=> cbc3_stubdata_buf_prog_full		
);



end rtl;
