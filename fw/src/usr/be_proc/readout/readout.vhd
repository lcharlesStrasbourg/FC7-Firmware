--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			Readout (top-level) - Integrates all the types of readout                                                                   
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file (one FIFO only)  
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

--! system packages
use work.ipbus.all;

--! user packages
use work.user_package.all;
use work.user_pkg_be_proc.all;



entity readout is
generic
(
	PKT_NB_SIZE							: positive := 16 --21;--24; -- before 21
);
port 
( 
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								: in std_logic;
	reset_i								: in std_logic; 			
    --======================--
    -- IPBUS / SLOW CONTROL --
    --======================--
    --# version1							    
    --# version2
    ipb_clk_i							: in std_logic;	 
    --stat
    stat_readout_o						: out stat_readout_type;
    --ctrl
    ctrl_readout_to_ipbus_o				: out ctrl_readout_to_ipbus_type;  
    ctrl_readout_from_ipbus_i			: in ctrl_readout_from_ipbus_type;    
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	data_payload_buf_empty_i			: in std_logic;
	data_payload_buf_not_empty_i		: in std_logic;			
	data_payload_buf_valid_i			: in std_logic;
	data_payload_buf_rd_en_o			: out std_logic;			
	--data to readout
	data_payload_buf_data_i				: in data_payload_type;
	--======================--
	-- TOP INTERFACE --
	--======================--
	backpressure_o						: out std_logic
);
end readout;

architecture rtl of readout is

--ctrl from ipb
signal packet_nbr					: std_logic_vector(PKT_NB_SIZE-1 downto 0) := (others => '0');	
signal readout_done					: std_logic := '0';	
--ctrl to ipb
signal readout_fifo_read_next		: std_logic := '0';	
signal readout_fifo_dout			: std_logic_vector(31 downto 0) := (others => '0');
--stat
signal readout_req					: std_logic := '0';	
signal fsm_status					: std_logic_vector(7 downto 0) := (others => '0');		
--resync
signal readout_req_resync1 			: std_logic := '0';	
signal readout_req_resync2  		: std_logic := '0';	
signal fsm_status_resync1			: std_logic_vector(7 downto 0) := (others => '0');


signal ctrl_readout_from_ipbus_resync1 	: ctrl_readout_from_ipbus_type;
signal ctrl_readout_from_ipbus_resync2 	: ctrl_readout_from_ipbus_type;

begin

backpressure_o <= readout_req; --for internal trigger



resync_ctrl_readout_from_ipbu: process
begin
wait until rising_edge(clk_i);
	ctrl_readout_from_ipbus_resync1 <= ctrl_readout_from_ipbus_i;
	ctrl_readout_from_ipbus_resync2 <= ctrl_readout_from_ipbus_resync1;
end process;
--sw_readout_reset	<= ctrl_readout_from_ipbus_resync1.sw_readout_reset;
readout_done	<= ctrl_readout_from_ipbus_resync2.readout_done;		
packet_nbr		<= ctrl_readout_from_ipbus_resync1.packet_nbr;
--
readout_fifo_read_next 						<= ctrl_readout_from_ipbus_i.readout_fifo_read_next; --one-pulse
ctrl_readout_to_ipbus_o.readout_fifo_dout 	<= readout_fifo_dout; --no resync


resync_stat_readout: process
begin
wait until rising_edge(ipb_clk_i); 
	readout_req_resync1 <= readout_req;
	readout_req_resync2 <= readout_req_resync1;	
	--
	fsm_status_resync1	<= fsm_status;
end process;

stat_readout_o.readout_req 	<= readout_req_resync2; 
stat_readout_o.fsm_status 	<= fsm_status_resync1; 




readout_fifo_ctrl_i: entity work.readout_fifo_ctrl
generic map
(
	PKT_NB_SIZE							=> PKT_NB_SIZE 
)
port map 
(
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								=> clk_i,
	reset_i								=> reset_i,			
	--===============--
	-- S/W INTERFACE --
	--===============--
	ipb_clk_i							=> ipb_clk_i,
	packet_nbr_i						=> packet_nbr,	
	readout_done_i						=> readout_done,	
	readout_req_o						=> readout_req,	
	packet_cnt_o						=> open,	
	--
	readout_fifo_read_next_i			=> readout_fifo_read_next,	
	readout_fifo_dout_o					=> readout_fifo_dout,		
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	data_payload_buf_empty_i			=> data_payload_buf_empty_i,
	data_payload_buf_not_empty_i		=> data_payload_buf_not_empty_i,			
	data_payload_buf_valid_i			=> data_payload_buf_valid_i,
	data_payload_buf_rd_en_o			=> data_payload_buf_rd_en_o,			
	--data to readout
	data_payload_buf_data_i				=> data_payload_buf_data_i,
	--===============--
	-- TOP INTERFACE --
	--===============--		
	fsm_status_o						=> fsm_status--0: sram0 / 1: sram1
);




end rtl;
