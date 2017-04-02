--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			data processing & buffering (TRIGDATA) for one chip CBC3 (chip-level)                                                                   
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



entity cbc3_trigdata_proc is
port 
(
	clk_i							: in std_logic;
	reset_i							: in std_logic;
	--from PHY
	cbc3_trigdata_i 				: in std_logic_vector(273 downto 0); --274b
	cbc3_trigdata_valid_i 			: in std_logic;	
	--Buffer interface
	cbc3_trigdata_buf_rd_en_i		: in std_logic; --common_rd_en_i / all_buf_rd_en_i
	cbc3_trigdata_buf_dout_o		: out cbc3_trigdata_chip_type;
	cbc3_trigdata_buf_valid_o		: out std_logic;
	cbc3_trigdata_buf_empty_o		: out std_logic;
	cbc3_trigdata_buf_full_o		: out std_logic;
	cbc3_trigdata_buf_prog_full_o	: out std_logic					
);
end cbc3_trigdata_proc;


architecture rtl of cbc3_trigdata_proc is

signal channels 				: std_logic_vector(253 downto 0) := (others => '0');
signal even_channels 			: std_logic_vector(126 downto 0) := (others => '0');
signal odd_channels 			: std_logic_vector(126 downto 0) := (others => '0');

signal cbc3_trigdata_from_buf  	: cbc3_trigdata_chip_type := (others => (others => '0'));



type buf_type is
record
	din 		: std_logic_vector(273 downto 0);
	wr_en 		: std_logic;
	dout 		: std_logic_vector(273 downto 0);	
	rd_en 		: std_logic;	
	valid 		: std_logic;		
	full		: std_logic;
	empty		: std_logic;	
	prog_full	: std_logic;
	prog_empty	: std_logic;		
	
end record;	

signal buf : buf_type := ( (others=>'0'), '0', (others=>'0'), '0', '0', '0', '0', '0', '0'); 


begin

--============--
-- OUTPUTTING --
--============--
cbc3_trigdata_buf_dout_o 		<= cbc3_trigdata_from_buf;
cbc3_trigdata_buf_valid_o 		<= buf.valid;
cbc3_trigdata_buf_empty_o 		<= buf.empty;
cbc3_trigdata_buf_full_o 		<= buf.full;
cbc3_trigdata_buf_prog_full_o 	<= buf.prog_full;

--======================--
-- CBC3 TRIGDATA BUFFER --
--======================--

buf.din 		<= cbc3_trigdata_i;
buf.wr_en 		<= cbc3_trigdata_valid_i;	
buf.rd_en 		<= cbc3_trigdata_buf_rd_en_i; 
	
cbc3_trigdata_buf: entity work.cbc3_trigdata_buf 
port map 
(	
	clk 				=> clk_i,
	--
	srst 				=> reset_i,
	--write
	din 				=> buf.din, 
	wr_en 				=> buf.wr_en,
	--read
	rd_en 				=> buf.rd_en,
	dout 				=> buf.dout,
	valid 				=> buf.valid,					
	--flags
	full 				=> buf.full,
	empty 				=> buf.empty,			
	prog_full 			=> buf.prog_full,
	prog_empty 			=> buf.prog_empty
);

	
--====================================--
-- New order & output data formatting --
--====================================--	

--> Channels / bits swapping
channels_swapp_order_gen: for i in 0 to 253 generate
	channels(253 - i) <= buf.dout(i); --buf.dout(253) <=> ch0 and buf.dout(0) <=> ch253
end generate;

--> Channels splitting: even & odd
even_channels_gen: for i in 126 downto 0 generate --[126:0] = [252,250,248,...,4,2,0]
	even_channels(i) <= channels(2*i);
end generate;

odd_channels_gen: for i in 126 downto 0 generate --[126:0] = [253,251,249,...,5,3,1]
	odd_channels(i) <= channels(2*i+1);
end generate;	

	
--> Output data formatting
--[1:4]: hits from even channels
cbc3_trigdata_from_buf(1) 				<= even_channels(126 downto 95);
cbc3_trigdata_from_buf(2) 				<= even_channels(94 downto 63);	
cbc3_trigdata_from_buf(3) 				<= even_channels(62 downto 31);	
cbc3_trigdata_from_buf(4) 				<= '0' & even_channels(30 downto 0);	
--[5:8]: hits from odd channels
cbc3_trigdata_from_buf(5) 				<= odd_channels(126 downto 95);
cbc3_trigdata_from_buf(6) 				<= odd_channels(94 downto 63);	
cbc3_trigdata_from_buf(7) 				<= odd_channels(62 downto 31);	
cbc3_trigdata_from_buf(8) 				<= '0' & odd_channels(30 downto 0);
--9: infos
cbc3_trigdata_from_buf(9)(0) 			<= buf.dout(273); --LatErr
cbc3_trigdata_from_buf(9)(1) 			<= buf.dout(272); --BufOvf
cbc3_trigdata_from_buf(9)(12 downto 4) 	<= buf.dout(271 downto 263); --PipeAddr
cbc3_trigdata_from_buf(9)(24 downto 16) <= buf.dout(262 downto 254); --L1Cnt
	
	


end rtl;
