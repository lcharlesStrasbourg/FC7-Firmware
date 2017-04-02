--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			Event Counter (L1A Counter) - Format 24-bit by def                                                                   
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

entity evnt_cnt_proc is
generic
(
	evnt_cnt_size 						: positive := 24
);
port 
(
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								: in std_logic;
	evnt_cnt_reset_i					: in std_logic; --active high / PC_config_ok = '0' or cmd_start_valid = '0'
	--=============--
	-- L1A Trigger --
	--=============--	
	L1A_i								: in std_logic; --L1A_VALID
	--==============--
	-- COUNTERS OUT --
	--==============--
	evnt_cnt_o							: out std_logic_vector(evnt_cnt_size-1 downto 0); --L1A_cnt24b_o		
	--=================================--
	-- BUFs INTERFACE FOR DATA MERGING --
	--=================================--			
	all_buf_rd_en_i						: in std_logic; --common for all FIFOs	
	evnt_cnt_buf_dout_o					: out std_logic_vector(evnt_cnt_size-1 downto 0); 
	evnt_cnt_buf_empty_o				: out std_logic;
	evnt_cnt_buf_full_o					: out std_logic;	
	evnt_cnt_buf_prog_full_o			: out std_logic;	
	evnt_cnt_buf_valid_o				: out std_logic		
);
			
			
end evnt_cnt_proc;

architecture archi of evnt_cnt_proc is


signal L1A_cnt_int 		: integer range 0 to 2**evnt_cnt_size - 1 := 0;
signal L1A_cnt		 	: std_logic_vector(evnt_cnt_size-1 downto 0) := (others => '0');	

	
type buf_type is
record
	din 		: std_logic_vector(evnt_cnt_size-1 downto 0);
	wr_en 		: std_logic;
	dout 		: std_logic_vector(evnt_cnt_size-1 downto 0);	
	rd_en 		: std_logic;	
	valid 		: std_logic;		
	full		: std_logic;
	empty		: std_logic;	
	prog_full	: std_logic;
	prog_empty	: std_logic;		
	
end record;	


signal buf 		: buf_type := ( (others=>'0'), '0', (others=>'0'), '0', '0', '0', '0', '0', '0'); 

signal L1A_del	: std_logic := '0';	
	
   --========================================================================--   
 
--===========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--===========================================================================--
   
   --============================= User Logic ===============================--


--=====--
-- I/O --
--=====--	
-->out
evnt_cnt_buf_dout_o 		<= buf.dout;
evnt_cnt_buf_empty_o		<= buf.empty;
evnt_cnt_buf_full_o			<= buf.full;
evnt_cnt_buf_prog_full_o	<= buf.prog_full;
evnt_cnt_buf_valid_o		<= buf.valid;
--
evnt_cnt_o					<= L1A_cnt;

--============--
--L1A COUNTER --
--============--
L1A_cnt_proc: process --full 24-bits counter
begin
wait until rising_edge(clk_i);
	if evnt_cnt_reset_i = '1' then
		L1A_cnt_int <= 0;			
	elsif L1A_i = '1' then  
		L1A_cnt_int <= L1A_cnt_int + 1;
	end if;
end process;
--
L1A_cnt <= std_logic_vector(to_unsigned(L1A_cnt_int, evnt_cnt_size)); 

--
L1A_del_proc: process 
begin
wait until rising_edge(clk_i);
	L1A_del <= L1A_i;
end process;


--=================--
-- EVNT CNT BUFFER --
--=================--	

buf.din 				<= L1A_cnt;
buf.wr_en 				<= L1A_del;	
buf.rd_en 				<= all_buf_rd_en_i; 

evnt_cnt_buf_i: entity work.evnt_cnt_buf 
port map 
(	
	clk 				=> clk_i,
	--
	srst 				=> evnt_cnt_reset_i,
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




end archi;