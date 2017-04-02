--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			Internal Trigger clocked at 40MHz                                                           
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file (from [1.2Hz : 78kHz])
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
use work.user_pkg_be_proc.all;



entity internal_trigger_proc is
port 
(
	clk_i					: in std_logic;                            
	reset_i					: in std_logic;   
	enable_i				: in std_logic; 
	int_trig_o				: out std_logic;
	int_trig_rate_i			: in std_logic_vector(4 downto 0)
	                     
);
end internal_trigger_proc;

architecture rtl of internal_trigger_proc is

signal int_trig : std_logic := '0';

begin

int_trig_o <= int_trig;


int_trig_proc: process 
variable cnt : unsigned(25 downto 0) := (others => '0'); --log(40M)/log(2) = 25,2 --> bit to test = 25 with range [25:0]
begin
wait until rising_edge(clk_i);
	if reset_i = '1' then 
		cnt 		:= (others=>'0');
		int_trig 	<= '0';	
	elsif  int_trig = '1' then 			
		cnt 		:= (others=>'0');
		int_trig 	<= '0';
	--else
	elsif enable_i = '1' then
		cnt 		:= cnt + 1;
		if 		unsigned(int_trig_rate_i) = 0 		and cnt(25) = '1' 		then 	int_trig <= '1'; --1.2 Hz
		elsif 	unsigned(int_trig_rate_i) = 1 		and cnt(24) = '1' 		then 	int_trig <= '1'; --2.4 Hz 
		elsif 	unsigned(int_trig_rate_i) = 2 		and cnt(23) = '1' 		then 	int_trig <= '1'; --4.8 Hz
		elsif 	unsigned(int_trig_rate_i) = 3 		and cnt(22) = '1' 		then 	int_trig <= '1'; --9.5 Hz
		elsif 	unsigned(int_trig_rate_i) = 4 		and cnt(21) = '1' 		then 	int_trig <= '1'; --19 Hz
		elsif 	unsigned(int_trig_rate_i) = 5 		and cnt(20) = '1' 		then 	int_trig <= '1'; --38 Hz
		elsif 	unsigned(int_trig_rate_i) = 6 		and cnt(19) = '1' 		then 	int_trig <= '1'; --76 Hz
		elsif 	unsigned(int_trig_rate_i) = 7 		and cnt(18) = '1' 		then 	int_trig <= '1'; --152 Hz
		elsif 	unsigned(int_trig_rate_i) = 8 		and cnt(17) = '1' 		then 	int_trig <= '1'; --305 Hz
		elsif 	unsigned(int_trig_rate_i) = 9 		and cnt(16) = '1' 		then 	int_trig <= '1'; --610 Hz
		elsif 	unsigned(int_trig_rate_i) = 10 		and cnt(15) = '1' 		then 	int_trig <= '1'; --1.2 kHz
		elsif 	unsigned(int_trig_rate_i) = 11 		and cnt(14) = '1' 		then 	int_trig <= '1'; --2.4 kHz
		elsif 	unsigned(int_trig_rate_i) = 12 		and cnt(13) = '1' 		then 	int_trig <= '1'; --4.9 kHz	
		elsif 	unsigned(int_trig_rate_i) = 13 		and cnt(12) = '1' 		then 	int_trig <= '1'; --9.8 kHz
		elsif 	unsigned(int_trig_rate_i) = 14 		and cnt(11) = '1' 		then 	int_trig <= '1'; --19.5 kHz
		elsif 	unsigned(int_trig_rate_i) = 15 		and cnt(10) = '1' 		then 	int_trig <= '1'; --39 kHz					
		elsif 	unsigned(int_trig_rate_i) = 16 		and cnt(9) = '1' 		then 	int_trig <= '1'; --78 kHz	
		else 																								
			int_trig <= '0';
		end if; 
	end if;
end process;
			
			


end rtl;
