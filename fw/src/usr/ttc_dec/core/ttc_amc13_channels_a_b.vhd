library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.all;



--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ttc_amc13_channels_a_b is
port 
(
	
	reset_i							: in	std_logic;
	iodelay_clk_i					: in	std_logic;
	
	amc13_ttc_data_p				: in	std_logic;
	amc13_ttc_data_n				: in	std_logic;
	amc13_ttc_clk					: in	std_logic;

	iodelay_load       			: in	std_logic;							-- delay increment, decrement signal for bit 
	iodelay_inc       			: in	std_logic;							-- delay increment, decrement signal for bit 
	iodelay_ce	       			: in	std_logic;							-- delay increment, decrement signal for bit 
	iodelay_tap_ctrl         	: in	std_logic_vector(4 downto 0);	-- dynamically loadable delay tap value for bit 
	iodelay_tap_stat        	: out	std_logic_vector(4 downto 0);	-- bit  delay tap value for monitoring

	-- ttc channel separation --
	a_channel_o						: out	std_logic;
	b_channel_o						: out	std_logic;
	ab_ready_o						: out	std_logic;
	clk_o								: out	std_logic;
	clken_o							: out	std_logic;
	-- auxiliary outputs
	amc13_ttc_data					: out	std_logic
	
);
	
end ttc_amc13_channels_a_b;



architecture top of ttc_amc13_channels_a_b is


	signal amc13_ttc_q1		: std_logic;
	signal amc13_ttc_q2		: std_logic;
	signal iodelay_locked	: std_logic;

	signal ab_ok				: std_logic;
	signal a_channel			: std_logic;
	signal b_channel			: std_logic;
	signal q1_prev				: std_logic;
	signal q1_is_A				: std_logic;
	signal clk160				: std_logic;
	

attribute keep             		: string;
attribute keep of amc13_ttc_q1	: signal is "true";
attribute keep of amc13_ttc_q2	: signal is "true";
attribute keep of a_channel_o		: signal is "true";
attribute keep of b_channel_o		: signal is "true";
attribute keep of ab_ok				: signal is "true";
attribute keep of amc13_ttc_data	: signal is "true";

begin


--=====================================--
ddr: entity work.iddr_amc13
--=====================================--
port map
(
	io_reset                	=> reset_i,				---- reset signal for io circuitdata_in_from_pins_p
	-- iddr signals
	clk_in                  	=> amc13_ttc_clk,		
	data_in_from_pins_p(0)    	=> amc13_ttc_data_p, 	
	data_in_from_pins_n(0)    	=> amc13_ttc_data_n, 	
	data_in_to_device(0)			=> amc13_ttc_q1,	
	data_in_to_device(1)			=> amc13_ttc_q2,	
	data_after_iodelay			=> amc13_ttc_data,
	-- iodelayctrl
	ref_clock               	=> iodelay_clk_i,		-- reference clock for idelayctrl. has to come from bufg.
	delay_locked            	=> iodelay_locked,	-- locked signal from idelayctrl
	-- iodelay
	delay_clk            		=> amc13_ttc_clk, 	-- iodelay_clk_i
	delay_reset          		=> reset_i, 
	delay_data_ld(0)		    => iodelay_load,	
	delay_data_ce(0)       		=> iodelay_ce,			
	delay_data_inc(0)      		=> iodelay_inc,		
	delay_tap_in         		=> iodelay_tap_ctrl,	
	delay_tap_out        		=> Iodelay_tap_stat	
);
--=====================================--



--===================================================--	
process(amc13_ttc_clk, iodelay_locked )
--Frame alignment (A and B channel detection) ensured by the fact that B(idle)=1 and A is not able to have more than 11 consecutive '1's
--===================================================--
	variable init_timer 	: integer range 0 to 65535;
	variable timer 		: integer range 0 to 65535;
	variable a1_b0_cnt	: integer range 0 to 15;
--	variable q1_prev		: std_logic;
--	variable q1_is_A		: std_logic;
	variable state			: integer range 0 to 1;
	
begin

if iodelay_locked = '0' then

	timer					:= 10000;
	a1_b0_cnt			:= 0;
	q1_is_A				<='0';
--	a_channel			<='0';
--	b_channel			<='0';
	state					:= 0 ;
	q1_prev				<='0';
	--LC
	ab_ok              <= '0';
elsif rising_edge(amc13_ttc_clk) then
		
		--	a/b channel selection outside the process in order to reduce latency

--	if q1_is_A='1' then
--			a_channel <= q1_prev;
--			b_channel <= amc13_ttc_q2;
--	else
--			a_channel <= amc13_ttc_q2;
--			b_channel <= amc13_ttc_q1;
--	
--	end if;
	q1_prev <= amc13_ttc_q1; --:= amc13_ttc_q1;
	

	--	l1a = '1' and b_channel data = '0' can not repeat 11 times. strng_length counts the repeat length of this data pattern
	case state is
	
		when 0 	=> ab_ok <= '0';
						if init_timer = 0 then 
							state				:= 1; 
							timer				:= 0;
						else 
							init_timer		:=init_timer-1;  
							a1_b0_cnt		:=0; 
						end if;
						
		when 1	=>	if a1_b0_cnt=11 then
							state			:= 0;
							init_timer	:= 4;
							q1_is_A		<= not q1_is_A;
						else
							if a_channel='1' and b_channel='0' then
								a1_b0_cnt:=a1_b0_cnt+1;
							else
								a1_b0_cnt:= 0;
							end if;
						end if;	
		
						if timer = 10000 then ab_ok <= '1'; else timer:=timer+1; end if;
						
	end case;
end if;
end process;
--===================================================--


ab_ready_o 		<= ab_ok;
a_channel_o 	<= a_channel;
b_channel_o 	<= b_channel;
clk_o				<= amc13_ttc_clk;
clken_o			<= '1';
-- reduce the latency by 1 clk
a_channel 		<= q1_prev				when q1_is_A='1' else 	amc13_ttc_q2;
b_channel 		<= amc13_ttc_q2		when q1_is_A='1' else  	amc13_ttc_q1;  

end top;


