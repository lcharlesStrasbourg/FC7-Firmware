--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			Fifo instance	                                                                    
-- History:        			Date         Version   	Author            Changes
--                          2017/03/25   1.0       	lcharles          Initial file 
--                                                                                                                                                   
--=================================================================================================--
--=================================================================================================--

library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--! system packages
use work.ipbus.all;

--! user packages

entity readout_fifo_block is
port (
	--===============--
	-- ipb interface --
	--===============--	
	ipb_clk_i					: in std_logic;
	clk_i						: in std_logic;
	reset_i						: in std_logic; --active high,
	--
	ipb_mosi_i					: in ipb_wbus;  --see ipbus_package  
	ipb_miso_o					: out ipb_rbus;
	--==================--
	-- fabric interface --
	--==================--					 
	fifo_wr_en_i             	: in std_logic;
	fifo_wr_data_i           	: in std_logic_vector(31 downto 0);
	fifo_empty_o				: out std_logic;
	fifo_full_o					: out std_logic;		
	fifo_prog_full_o			: out std_logic;
	fifo_data_count_o			: out std_logic_vector(13 downto 0) --if
);
end readout_fifo_block;

architecture Behavioral of readout_fifo_block is


   --========================= Signals Declaration ==========================--

signal sel						: integer := 0;
signal ack						: std_logic := '0';


attribute keep					: boolean;
attribute keep of ack			: signal is true;


signal wr_en					: std_logic := '0';
signal rd_en					: std_logic := '0';
signal valid					: std_logic := '0';    
signal empty					: std_logic := '1';
signal full						: std_logic := '0';    
signal prog_full				: std_logic := '0';
signal data_count				: std_logic_vector(13 downto 0) := (others => '0'); --if 
signal wr_data					: std_logic_vector(31 downto 0) := (others => '0');
signal rd_data					: std_logic_vector(31 downto 0) := (others => '0');

     
   --========================================================================--   
 
--===========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--===========================================================================--
   
   --============================= User Logic ===============================--

      

--=========================--
-- io mapping 
--==========================--
wr_en						<= fifo_wr_en_i; 
wr_data						<= fifo_wr_data_i;
fifo_empty_o				<= empty;
fifo_full_o					<= full;
fifo_prog_full_o			<= prog_full;
fifo_data_count_o			<= data_count;


--
ipb_miso_o.ipb_ack 			<= ack;
ipb_miso_o.ipb_err 			<= '0';
ipb_miso_o.ipb_rdata 		<= rd_data;



--=========================--
-- rd_en / ipb_clk_i
--=========================--
--> one-pulse generation
rd_en 						<= ipb_mosi_i.ipb_strobe and not ack;  --and not empty

      
--   signal ipb_strobe 		: std_logic := '0';
--   signal ipb_strobe_del 	: std_logic := '0';
--	rd_en <= ipb_strobe and not ipb_strobe_del;
--	ack <= valid;
	

--=========================--
-- ack / ipb_clk_i 
--==========================--		
ack_proc: process
begin
wait until rising_edge(ipb_clk_i);
	if reset_i = '1' then
		ack		<= '0';
	else	
		ack 	<= ipb_mosi_i.ipb_strobe and not ack;
	end if;
end process;



readout_fifo_i: entity work.readout_fifo --
port map  
(
	wr_clk			=> clk_i,
	rd_clk			=> ipb_clk_i,
	rst				=> reset_i,
	din				=> wr_data,
	wr_en			=> wr_en,
	rd_en			=> rd_en,
	dout			=> rd_data,
	full			=> full,
	empty			=> empty,
	valid			=> valid,
	wr_data_count 	=> data_count,
	prog_full 		=> prog_full			
);




end Behavioral;

