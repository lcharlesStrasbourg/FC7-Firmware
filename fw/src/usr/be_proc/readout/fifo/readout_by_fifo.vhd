--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			Readout by Fifo                                                                   
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file  
--                                                                                                                                                   
--=================================================================================================--
--=================================================================================================--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

----! Custom libraries and packages: 
--use work.external_memory_interface_definitions.all;

--! system packages
use work.ipbus.all;

--! user packages
use work.user_pkg_be_proc.all;

entity readout_by_fifo is
generic
(
	PKT_NB_SIZE							: positive := 21--24; -- before 21
);
port 
(
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								: in std_logic;
	reset_i								: in std_logic; 	--PC_config_ok = '0' then --or BREAK_TRIGGER			
	--=================--
	-- IPBUS INTERFACE --
	--=================--	
	ipb_clk_i				        	: in std_logic;
	ipb_mosi_i			            	: in ipb_wbus_array(0 to 1); --see ipbus_package  
	ipb_miso_o			            	: out ipb_rbus_array(0 to 1); --0: fifo0 / 1: fifo1
	--===============--
	-- S/W INTERFACE --
	--===============--
	--from s/w
	from_SW_packet_nb_i					: in std_logic_vector(PKT_NB_SIZE-1 downto 0);	
	from_SW_rd_done_i					: in std_logic_vector(1 downto 0); -- SRAM_end_readout_i
	from_SW_data_type_i					: in std_logic;
	readoutRelease_i					: in std_logic;	--after a break_trigger	
	readout_mode_i						: in std_logic;	--'0' : dual mode / '1' : simple mode 	
	--to s/w
	to_SW_rd_rq_o						: out std_logic_vector(1 downto 0); --SRAM_full_o
	--
	packet_cnt_SRAM0_o					: out std_logic_vector(PKT_NB_SIZE-1 downto 0);			
	packet_cnt_SRAM1_o					: out std_logic_vector(PKT_NB_SIZE-1 downto 0);	
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	data_payload_buf_empty_i			: in std_logic;
	data_payload_buf_not_empty_i		: in std_logic;			
	data_payload_buf_valid_i			: in std_logic;
	data_payload_buf_rd_en_o			: out std_logic;			
	--data to readout
	data_payload_buf_data_i				: in data_payload_type;
	--===============--
	-- TOP INTERFACE --
	--===============--		
	--=======--
	-- DEBUG --
	--=======--
	--fsm_flag_o						: out array_Nx8b(1 downto 0); --0: sram0 / 1: sram1
	fifo_active_o						: out std_logic_vector(1 downto 0) --0: sram0 / 1: sram1
);

end readout_by_fifo;

architecture Behavioral of readout_by_fifo is


--data_payload_buf
signal data_payload_buf_rd_en		: std_logic := '0';			

--s/w interface
signal to_SW_rd_rq					: std_logic_vector(1 downto 0) := (others => '0'); 	

--signal fsm_flag					: array_Nx8b(1 downto 0) := (others => (others => '0')); --0: sram0 / 1: sram1

--temp
signal data_payload_buf_rd_en_tmp	: std_logic_vector(1 downto 0) := (others => '0'); 
signal fifo_active					: std_logic_vector(1 downto 0) := (others => '0'); 

type array_2xPKT_NB_SIZE_bit 		is array(1 downto 0)  of std_logic_vector(PKT_NB_SIZE-1 downto 0);	
signal packet_cnt					: array_2xPKT_NB_SIZE_bit := (others => (others => '0')); --0: sram0 / 1: sram1

signal readout_fifo1_ctrl_reset		: std_logic := '0';

begin

--============--
-- OUTPUTTING --
--============--
--	to_SW_rd_rq_o					<= to_SW_rd_rq;
to_SW_rd_rq_o(0)					<= to_SW_rd_rq(sram0);
to_SW_rd_rq_o(1)					<= to_SW_rd_rq(sram1);
--fsm_flag_o						<= fsm_flag;
fifo_active_o						<= fifo_active;
data_payload_buf_rd_en_o 			<= data_payload_buf_rd_en;
--tmp
data_payload_buf_rd_en				<= data_payload_buf_rd_en_tmp(sram0) or data_payload_buf_rd_en_tmp(sram1);
--	packet_cnt_o 					<= packet_cnt(sram1) when fifo_active(sram1) = '1' else packet_cnt(sram0); 
packet_cnt_SRAM0_o					<= packet_cnt(sram0);
packet_cnt_SRAM1_o					<= packet_cnt(sram1);


--=======--
-- FIFO0 --
--=======--
readout_fifo0_ctrl_i: entity work.readout_fifo_ctrl 
generic map 
(
	PKT_NB_SIZE						=> PKT_NB_SIZE,
	FIFO_ACTIVE_FIRST_INIT			=> '1' 		-- '1' <=> yes / '0' <=> no
)
port map 
(
	--==================--
	-- Resets and Clock --
	--==================--	
	clk_i 							=> clk_i,
	reset_i 						=> reset_i,
	--=================--
	-- IPBUS INTERFACE --
	--=================--	
	ipb_clk_i				        => ipb_clk_i,
	ipb_mosi_i						=> ipb_mosi_i(sram0), --sram0 = 0  
	ipb_miso_o						=> ipb_miso_o(sram0),
	--==========--
	-- s/w link --
	--==========--					
	from_SW_packet_nb_i 			=> from_SW_packet_nb_i,				
	to_SW_rd_rq_o 					=> to_SW_rd_rq(sram0),
	from_SW_rd_done_i 				=> from_SW_rd_done_i(sram0),
	from_SW_data_type_i				=> from_SW_data_type_i,
	readoutRelease_i				=> readoutRelease_i,	--after a break_trigger
	packet_cnt_o					=> packet_cnt(sram0),					
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	data_payload_buf_empty_i		=> data_payload_buf_empty_i, 
	data_payload_buf_not_empty_i	=> data_payload_buf_not_empty_i, 
	data_payload_buf_valid_i		=> data_payload_buf_valid_i, 
	data_payload_buf_rd_en_o		=> data_payload_buf_rd_en_tmp(sram0), 			
	--data to readout
	data_payload_buf_data_i			=> data_payload_buf_data_i, 
	--===============--
	-- TOP interface --
	--===============--					
	another_FIFO_active_i 			=> fifo_active(sram1),
	current_FIFO_active_o 			=> fifo_active(sram0),
	--trigger_i						=> trigger_i, --for internal data emulator						
	fsm_flag_o						=> open --fsm_flag(sram0)
);	



--=======--
-- FIFO1 --
--=======--

readout_fifo1_ctrl_reset <= reset_i or readout_mode_i;
--	readout_mode_i = '0' : dual mode (def. mode)
--	readout_mode_i = '1' : simple mode 	



readout_fifo1_ctrl_i: entity work.readout_fifo_ctrl 
generic map 
(
	PKT_NB_SIZE						=> PKT_NB_SIZE,
	FIFO_ACTIVE_FIRST_INIT			=> '0' 	-- '1' <=> yes / '0' <=> no
)
port map 
(
	--==================--
	-- Resets and Clock --
	--==================--	
	clk_i 							=> clk_i,
	reset_i							=> readout_fifo1_ctrl_reset, --sclr_i
	--=================--
	-- IPBUS INTERFACE --
	--=================--	
	ipb_clk_i				        => ipb_clk_i,
	ipb_mosi_i						=> ipb_mosi_i(sram1), --sram0 = 0  
	ipb_miso_o						=> ipb_miso_o(sram1),
	--==========--
	-- s/w link --
	--==========--					
	from_SW_packet_nb_i 			=> from_SW_packet_nb_i,				
	to_SW_rd_rq_o 					=> to_SW_rd_rq(sram1),
	from_SW_rd_done_i 				=> from_SW_rd_done_i(sram1),
	from_SW_data_type_i				=> from_SW_data_type_i,
	readoutRelease_i				=> readoutRelease_i,	--after a break_trigger
	packet_cnt_o					=> packet_cnt(sram1),					
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	data_payload_buf_empty_i		=> data_payload_buf_empty_i, 
	data_payload_buf_not_empty_i	=> data_payload_buf_not_empty_i, 
	data_payload_buf_valid_i		=> data_payload_buf_valid_i, 
	data_payload_buf_rd_en_o		=> data_payload_buf_rd_en_tmp(sram1), 			
	--data to readout
	data_payload_buf_data_i			=> data_payload_buf_data_i, 
	--===============--
	-- TOP interface --
	--===============--					
	another_FIFO_active_i 			=> fifo_active(sram0),
	current_FIFO_active_o 			=> fifo_active(sram1),
	--trigger_i						=> trigger_i, --for internal data emulator						
	fsm_flag_o						=> open --fsm_flag(sram1)
);	



end Behavioral;

