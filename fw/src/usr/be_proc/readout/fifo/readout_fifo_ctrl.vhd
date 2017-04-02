--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			Readout by Fifo (FSM)                                                                  
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


entity readout_fifo_ctrl is
generic 
(
	--
	PKT_NB_SIZE							: positive := 21
);
port 
(
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								: in std_logic;
	reset_i								: in std_logic; 			
	--===============--
	-- S/W INTERFACE --
	--===============--
	ipb_clk_i							: in std_logic;
	packet_nbr_i						: in std_logic_vector(PKT_NB_SIZE-1 downto 0);	
	readout_done_i						: in std_logic; 
	readout_req_o						: out std_logic;
	packet_cnt_o						: out std_logic_vector(PKT_NB_SIZE-1 downto 0);
	--
	readout_fifo_read_next_i			: in std_logic;
	readout_fifo_dout_o					: out std_logic_vector(31 downto 0);
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
	fsm_status_o						: out std_logic_vector(7 downto 0)
);

			
end readout_fifo_ctrl;

architecture Behavioral of readout_fifo_ctrl is

   --========================= Signals Declaration ==========================--

type states is (		idle,																
						init,							
						test_evnt_rdy,				
						waiting,								
						data_storage_1,
						data_storage_2,
						data_storage_3,
						read_rdy,			
						test_read_done,
						test_read_done_2
					);												
signal state : states;


--packet cnt
signal packet_cnt 					: unsigned(packet_nbr_i'range);

--word cnt
signal words_cnt					: integer range 1 to HDR1_BLOCK_SIZE := 1;

--fifo interface	
signal data_payload_buf_rd_en		: std_logic := '0';

--top interface	
signal fsm_status					: std_logic_vector(7 downto 0) := (others=>'0');

--s/w interface
signal readout_req					: std_logic := '0';	

--data payload
signal data							: data_payload_type := (others => (others => '0'));

--fifo
signal readout_fifo_wr_en_tmp		: std_logic := '0'; 
signal readout_fifo_wr_en			: std_logic := '0';	
signal readout_fifo_din				: std_logic_vector(31 downto 0) := (others => '0');
signal readout_fifo_dout			: std_logic_vector(31 downto 0) := (others => '0');
signal readout_fifo_empty			: std_logic := '0';
signal readout_fifo_full			: std_logic := '0';
signal readout_fifo_prog_full		: std_logic := '0';	
signal readout_fifo_data_count		: std_logic_vector(13 downto 0) := (others => '0'); 


--type buf_type is
--record
--	wr_data 		: std_logic_vector(31 downto 0);
--	wr_en 			: std_logic;
--	rd_data 		: std_logic_vector(31 downto 0);	
--	rd_en 			: std_logic;	
--	valid 			: std_logic;		
--	full			: std_logic;
--	empty			: std_logic;	
--	prog_full		: std_logic;
--	prog_empty		: std_logic;
--	wr_data_count 	: std_logic_vector(13 downto 0);		
--end record;	
--signal buf : buf_type := ( (others=>'0'), '0', (others=>'0'), '0', '0', '0', '0', '0', '0',(others=>'0')); 

	
begin

--============--
-- OUTPUTTING --
--============--
packet_cnt_o				<= std_logic_vector(packet_cnt);
data_payload_buf_rd_en_o 	<= data_payload_buf_rd_en;
fsm_status_o				<= fsm_status;
readout_req_o				<= readout_req;
readout_fifo_dout_o			<= readout_fifo_dout;


--=====================--
-- DATA PAYLOAD SELECT --
--=====================--
data 	<= data_payload_buf_data_i;
	

--===============--
-- STATE MACHINE --
--===============--			
fsm_proc: process		
begin	
wait until rising_edge(clk_i);		
	if reset_i = '1' then 				
		data_payload_buf_rd_en					<= '0'; --'1'; --force readout during clr if clock stable		
		readout_req								<= '0';
		state 									<= idle;
		readout_fifo_wr_en_tmp					<= '0';
		packet_cnt								<= unsigned(packet_nbr_i); --init				
		fsm_status 								<= std_logic_vector(to_unsigned(0,8));					
	else
		case state is	
			--
			when idle => 
				data_payload_buf_rd_en			<= '0'; --off		
				readout_req						<= '0';
				readout_fifo_wr_en_tmp			<= '0';
				packet_cnt						<= unsigned(packet_nbr_i); --init
				if readout_fifo_prog_full = '0' and readout_fifo_empty = '1' then 
					state 						<= init;
				end if;
				fsm_status 						<= std_logic_vector(to_unsigned(1,8));							
			--
			when init => 					
				packet_cnt						<= unsigned(packet_nbr_i); --re-load
				state 							<= test_evnt_rdy;						
				fsm_status						<= std_logic_vector(to_unsigned(2,8));		
			--
			when test_evnt_rdy =>															
				if data_payload_buf_not_empty_i = '1' then --buf not empty
					data_payload_buf_rd_en 		<= '1'; --on
					state						<= waiting;						
				else
					data_payload_buf_rd_en 		<= '0'; --off					
				end if;
				--
				fsm_status						<= std_logic_vector(to_unsigned(3,8)); 					
			--	
			when waiting => 
				data_payload_buf_rd_en 			<= '0'; --DIS									
				--
				if data_payload_buf_valid_i = '1' then 
					state 						<= data_storage_1;	
				end if;	
				--
				state 							<= data_storage_1;
				--
				fsm_status						<= std_logic_vector(to_unsigned(4,8));						
			--					
			when data_storage_1 => 
				--
				if words_cnt = HDR1_BLOCK_SIZE  then 
					readout_fifo_wr_en_tmp 		<= '0'; 
					state 						<= data_storage_2;	
				--
				else
					readout_fifo_wr_en_tmp 		<= '1'; 
				end if;
				--
				fsm_status						<= std_logic_vector(to_unsigned(5,8));
			--					
			when data_storage_2 => 						
				--
				if packet_cnt = 0  then
					state 						<= read_rdy;							
				else
					packet_cnt					<= packet_cnt - 1; --Decrement
					state						<= data_storage_3; --test_evnt_rdy;							
				end if;						
				--
				fsm_status						<= std_logic_vector(to_unsigned(6,8));								
			--					
			when data_storage_3 =>  
				if readout_fifo_wr_en = '0' then
					state						<= test_evnt_rdy;	
				end if;
				--
				fsm_status						<= std_logic_vector(to_unsigned(7,8));
			-- handshaking double
			when read_rdy => --flag readout_req asserted				
				--
				if readout_done_i = '0' then 
					readout_req					<= '1';	
					state						<= test_read_done;
				end if;
				--
				fsm_status						<= std_logic_vector(to_unsigned(8,8));	
			--
			when test_read_done => 
				--	
				if readout_done_i = '1' then 
					readout_req					<= '0';
					state						<= test_read_done_2;
				end if;	
				--
				fsm_status						<= std_logic_vector(to_unsigned(9,8));		
				--
			--
			when test_read_done_2 => --flag readout_req if readout done by s/w
				--	
				if readout_done_i = '0' then 
					readout_req					<= '0';
					state						<= init;
				end if;	
				--
				fsm_status						<= std_logic_vector(to_unsigned(10,8));		
		
		end case;
	end if;
end process;


words_cnt_proc: process 	
begin
wait until rising_edge(clk_i);
	if reset_i = '1' or data_payload_buf_rd_en = '1' then
		words_cnt <= 1;
	elsif words_cnt = HDR1_BLOCK_SIZE then
		null;
	elsif readout_fifo_wr_en_tmp = '1' then
		words_cnt <= words_cnt + 1;
	end if;
end process;



readout_fifo_din_proc: process 	
begin
wait until rising_edge(clk_i);
	readout_fifo_din 	<= data(words_cnt); 
	readout_fifo_wr_en 	<= readout_fifo_wr_en_tmp;		
end process;




readout_fifo_i: entity work.readout_fifo --FWFT mode
port map  
(
	wr_clk			=> clk_i,
	rd_clk			=> ipb_clk_i,
	rst				=> reset_i,
	din				=> readout_fifo_din,
	wr_en			=> readout_fifo_wr_en,
	rd_en			=> readout_fifo_read_next_i,
	dout			=> readout_fifo_dout,
	full			=> open,
	empty			=> readout_fifo_empty,
	valid			=> open,
	wr_data_count 	=> open, --readout_fifo_wr_data_count,
	prog_full 		=> readout_fifo_prog_full			
);





end Behavioral;

