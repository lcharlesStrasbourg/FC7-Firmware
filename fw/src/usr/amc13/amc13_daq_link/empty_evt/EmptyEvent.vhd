----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:25:11 08/31/2016 
-- Design Name: 
-- Module Name:    EmptyEvent - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- clk must be the clock that clocks L1A, bcnt, orn and evn
-- reset is an asynchrnous reset
-- bcnt, orn and evn must be valid at the time L1A is asserted
-- connect EventData etcto the corresponding ports of daq_link module,
-- EventDataClk must be connected to the same clock signal as the clk input of this module
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EmptyEvent is
    Port ( clk : in  STD_LOGIC;
           L1A : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           bcnt : in  STD_LOGIC_VECTOR (11 downto 0);
           orn : in  STD_LOGIC_VECTOR (15 downto 0);
           evn : in  STD_LOGIC_VECTOR (23 downto 0);
           EventData_header : out  STD_LOGIC; -- first data word
           EventData_trailer : out  STD_LOGIC; -- last data word
           EventData : out  STD_LOGIC_VECTOR (63 downto 0);
           EventData_valid : out  STD_LOGIC);
end EmptyEvent;

architecture Behavioral of EmptyEvent is
signal L1A_dl : std_logic_vector(1 downto 0) := "00";
signal orn_l : std_logic_vector(15 downto 0) := x"0000";
signal evn_l : std_logic_vector(7 downto 0) := x"00";
begin
process(clk, reset)
begin
	if(reset = '1')then
		L1A_dl <= "00";
		EventData_valid <= '0';
	elsif(clk'event and clk = '1')then
		L1A_dl <= L1A_dl(0) & L1A;
		EventData_valid <= L1A_dl(1) or L1A_dl(0) or L1A;		
	end if;
end process;
process(clk)
begin
	if(clk'event and clk = '1')then
		if(L1A = '1')then
			orn_l <= orn;		
			evn_l <=evn(7 downto 0);		
		end if;
		EventData_header <= L1A;
		EventData_trailer <= L1A_dl(1);
		if(L1A = '1')then
			EventData <= x"00" & evn & bcnt & x"00003";		
		elsif(L1A_dl(0) = '1')then
			EventData <= x"00000000" & orn_l & x"0000";		
		elsif(L1A_dl(1) = '1')then
			EventData <= x"00000000" & evn_l & x"000003";		
		end if;
	end if;
end process;

end Behavioral;

