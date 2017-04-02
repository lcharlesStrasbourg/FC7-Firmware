library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.all;



--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ttc_decoder is
port 
(

	reset_i								: in  std_logic;	
	--== ttc chA & B ==--
	chA									: in  std_logic; 				
	chB									: in  std_logic; 				
	clk									: in  std_logic;				
	clken									: in  std_logic;				
	--== ttc decoder output ==--
	single_bit_error    				: out std_logic;
	double_bit_error    				: out std_logic;
	communication_error 				: out std_logic;
	l1a									: out std_logic;
	brc_strobe							: out std_logic;	--broadcast frame strobe
	add_strobe							: out std_logic;	--addressed frame strobe
	--Broadcast frame
	--TTDDDDDEB (see desciption above)
	brc_t2								: out std_logic_vector(1 downto 0);  
	brc_d4								: out std_logic_vector(3 downto 0);
	brc_e									: out std_logic; 
	brc_b									: out std_logic; 
	--Individually addressed frame
	--AAAAAAAAAAAAAAE1SSSSSSSSDDDDDDDD (see desciption above)
	add_a14								: out std_logic_vector(13 downto 0);
	add_e									: out std_logic;
	add_s8								: out std_logic_vector(7 downto 0);
	add_d8								: out std_logic_vector(7 downto 0);
	--== ttc decoder aux flags ==--
	ready									: out  std_logic
);
	
end ttc_decoder;

architecture core of ttc_decoder is



	--========================= Signal Declarations ==========================--

	signal channelB_on				: std_logic;
	signal testmode_on				: std_logic;
	
	signal chB_data					: std_logic_vector(38 downto 0);
	signal chB_data_rdy				: std_logic_vector(1 downto 0);
	signal single_bit_error_i		: std_logic;
	signal double_bit_error_i		: std_logic;
	signal channelB_comm_error_i	: std_logic;
	signal l1a_i						: std_logic;
	signal channelB					: std_logic;
	signal ttc_frame_reset			: std_logic;
	
	
--===========================================================================--
-----     --===================================================--
begin   --================== Architecture Body ==================-- 
-----     --===================================================--
--===========================================================================--




--=====================================--
serialb_com0: entity work.serialb_com
--=====================================--
generic map ( include_hamming => true)  
port map
(
	--== inputs ==--
	clk                 			=> clk, 
	clken					  			=> clken, 
	reset_n             			=> (not reset_i),
	serBchan            			=> chB,
	serB_en             			=> '1',
	testmode            			=> '0',
	--== outputs ==--			
	single_bit_error    			=> single_bit_error_i,
	double_bit_error    			=> double_bit_error_i,
	communication_error 			=> channelB_comm_error_i,
	data_ready          			=> chB_data_rdy,
	data_out            			=> chB_data
);
--=====================================--

		

----=====================================--
---- output mapping (data updated every 25ns)
----=====================================--
--process(clk)
--	variable brc, add : std_logic;
--begin
--if rising_edge(clk) then
--	brc_strobe <= chB_data_rdy(0);
--	add_strobe <= chB_data_rdy(1);
--	
--	brc := chB_data_rdy(0); 	brc_strobe <= brc;
--	add := chB_data_rdy(1);		add_strobe <= add;
--	
--	--TTDDDDDEB
--	if brc = '1' then
--	brc_t2	 <= chB_data(12 downto 11);  
--	brc_d4	 <= chB_data(10 downto 7); 
--	brc_e		 <= chB_data(6); 
--	brc_b		 <= chB_data(5); 
--	else
--	brc_t2	 <= (others =>'0');  
--	brc_d4	 <= (others =>'0'); 
--	brc_e		 <= '0'; 
--	brc_b		 <= '0'; 
--	end if;
--	
--	--AAAAAAAAAAAAAAE1SSSSSSSSDDDDDDDD
--	if add = '1' then
--	add_a14	 <= chB_data(38 downto 25);
--	add_e		 <= chB_data(24);
--	add_s8	 <= chB_data(22 downto 15);
--	add_d8	 <= chB_data(14 downto 7);
--	else
--	add_a14	 <= (others =>'0');
--	add_e		 <= '0';
--	add_s8	 <= (others =>'0');
--	add_d8	 <= (others =>'0');
--	end if;
--
--
--	single_bit_error    	<= single_bit_error_i;
--	double_bit_error    	<= double_bit_error_i;
--	communication_error 	<= channelB_comm_error_i;
--	--l1a						<= chA;
--end if;
--end process;
----=====================================--
	
-- reduce the latency by 1 clk	
	
-- A channel
l1a <= chA;

-- B-channel short [TTDDDDDEB]
brc_strobe 				<= chB_data_rdy(0); 
brc_t2	 				<= chB_data(12 downto 11);  
brc_d4	 				<= chB_data(10 downto 7); 
brc_e		 				<= chB_data(6); 
brc_b		 				<= chB_data(5); 

-- B-channel long [AAAAAAAAAAAAAAE1SSSSSSSSDDDDDDDD]
add_strobe 				<= chB_data_rdy(1);	
add_a14	 				<= chB_data(38 downto 25);
add_e		 				<= chB_data(24);
add_s8	 				<= chB_data(22 downto 15);
add_d8	 				<= chB_data(14 downto 7);

-- error flags
single_bit_error    	<= single_bit_error_i;
double_bit_error    	<= double_bit_error_i;
communication_error 	<= channelB_comm_error_i;

end core;