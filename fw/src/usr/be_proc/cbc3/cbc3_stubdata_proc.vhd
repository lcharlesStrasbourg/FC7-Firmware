--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			data processing & buffering (STUBDATA) for one chip CBC3 (chip-level)                                                                   
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



entity cbc3_stubdata_proc is
--generic
--(
--	stubdata_delay_value_size		: integer := 8
--);	
port 
(
	
	clk_i							: in std_logic;
	reset_i							: in std_logic;
	--Data from PHY
	cbc3_stubdata_i 				: in std_logic_vector(39 downto 0); --40b
	cbc3_stubdata_valid_i 			: in std_logic;	
	--Stubdata delaying
	cbc3_stubdata_delay_value_i		: in std_logic_vector(stubdata_delay_value_size-1 downto 0); 
	--Local L1A
	L1A_i							: in std_logic;	
	--Buffer interface
	cbc3_stubdata_buf_rd_en_i		: in std_logic; --common_rd_en_i / all_buf_rd_en_i
	cbc3_stubdata_buf_dout_o		: out cbc3_stubdata_chip_type;
	cbc3_stubdata_buf_valid_o		: out std_logic;
	cbc3_stubdata_buf_empty_o		: out std_logic;
	cbc3_stubdata_buf_full_o		: out std_logic;
	cbc3_stubdata_buf_prog_full_o	: out std_logic		
);
end cbc3_stubdata_proc;


architecture rtl of cbc3_stubdata_proc is

signal cbc3_stubdata_shifted 	: std_logic_vector(cbc3_stubdata_i'range) := (others => '0');

signal cbc3_stubdata_from_buf  	: cbc3_stubdata_chip_type := (others => (others => '0'));



type buf_type is
record
	din 		: std_logic_vector(39 downto 0); --40b
	wr_en 		: std_logic;
	dout 		: std_logic_vector(39 downto 0);	
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
cbc3_stubdata_buf_dout_o 		<= cbc3_stubdata_from_buf;
cbc3_stubdata_buf_valid_o 		<= buf.valid;
cbc3_stubdata_buf_empty_o 		<= buf.empty;
cbc3_stubdata_buf_full_o 		<= buf.full;
cbc3_stubdata_buf_prog_full_o 	<= buf.prog_full;

--===================--
-- STUBDATA SHIFTING --
--===================--	

cbc3_stubdata_shift_inst: entity work.cbc3_stubdata_shift --256 <=> 8b
port map 
(	
	clk 	=> clk_i,
	a		=> cbc3_stubdata_delay_value_i,
	d		=> cbc3_stubdata_i,
	q 		=> cbc3_stubdata_shifted
);


--======================--
-- CBC3 TRIGDATA BUFFER --
--======================--	

buf.din 		<= cbc3_stubdata_i;   
buf.wr_en 		<= L1A_i; --cbc3_stubdata_valid_i;
buf.rd_en 		<= cbc3_stubdata_buf_rd_en_i; 


cbc3_stubdata_buf: entity work.cbc3_stubdata_buf 
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
	
--[39]: sync
--[38]: err flags
--[37]: or254
--[36]: s ovf
--[35:32]: bend3
--[31:28]: bend2
--[27:24]: bend1
--[23:16]: stub3
--[15:8]: stub2
--[7:0]: stub1

	
-->indice 1
cbc3_stubdata_from_buf(1)(7 downto 0)	<= buf.dout(7 downto 0); --stub1
cbc3_stubdata_from_buf(1)(15 downto 8)	<= buf.dout(15 downto 8); --stub2
cbc3_stubdata_from_buf(1)(23 downto 16)	<= buf.dout(23 downto 16); --stub3	
-->indice 2
cbc3_stubdata_from_buf(2)(11 downto 8)	<= buf.dout(27 downto 24); --bend1
cbc3_stubdata_from_buf(2)(19 downto 16)	<= buf.dout(31 downto 28); --bend2	
cbc3_stubdata_from_buf(2)(27 downto 24)	<= buf.dout(35 downto 32); --bend3

cbc3_stubdata_from_buf(2)(3 downto 0)	<= buf.dout(39 downto 36); --all flags


end rtl;
