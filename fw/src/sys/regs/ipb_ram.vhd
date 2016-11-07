library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--! xilinx packages
library unisim;
use unisim.vcomponents.all;
--! system packages
use work.ipbus.all;


entity ipb_ram is
generic
(
	addr_width			: positive:= 12;
	data_width			: positive:= 32;
	read_latency		: positive:=  3
);	
port
(
	reset_i				: in 	std_logic;
	------------------
	ipb_clk_i			: in 	std_logic;
	ipb_mosi_i			: in 	ipb_wbus;
	ipb_miso_o			: out ipb_rbus;
	------------------
	ram_ipb_addr_o		: out	std_logic_vector(addr_width-1 downto 0);
	ram_ipb_wren_o		: out	std_logic;
	ram_ipb_wdata_o	: out	std_logic_vector(data_width-1 downto 0);
	ram_ipb_rdata_i	: in	std_logic_vector(data_width-1 downto 0)
);
	
end ipb_ram;		

architecture rtl of ipb_ram is                              	

signal ack						: std_logic;
signal addr						: std_logic_vector(addr_width-1 downto 0);
signal wren						: std_logic;
signal wdata					: std_logic_vector(data_width-1 downto 0);

begin-- ARCHITECTURE


	process(ipb_clk_i, reset_i)
		variable ack_delay 	: std_logic_vector(read_latency downto 0);
	begin
	if reset_i='1' then

		ack			<= '0';
		ack_delay	:= (others => '0');
		wren			<= '0';

	elsif rising_edge(ipb_clk_i) then

		wren 		<= ipb_mosi_i.ipb_strobe and ipb_mosi_i.ipb_write;
		wdata		<= ipb_mosi_i.ipb_wdata(data_width-1 downto 0);
		
		--=== ack/addr control start ===--
		if ipb_mosi_i.ipb_strobe='1' then
			if ipb_mosi_i.ipb_write='1' then 
				addr		<= ipb_mosi_i.ipb_addr(addr_width-1 downto 0);
				ack 		<= '1';
			elsif ipb_mosi_i.ipb_write='0' then 
				if ack_delay(read_latency-1)='1' then
					addr	<= addr + 1;
				else
					addr	<= ipb_mosi_i.ipb_addr(addr_width-1 downto 0);
				end if;
				ack_delay:= ack_delay(read_latency-1 downto 0) & ipb_mosi_i.ipb_strobe;
				ack 		<= ack_delay(read_latency);
			end if;	
		else
			ack 			<= '0';
			ack_delay	:= (others => '0');
		end if;
		--=== ack/addr control end =====--
		
	end if;
	end process;
	
	
	--=== IO mapping =====--
	ram_ipb_wren_o 		<= wren;
	ram_ipb_wdata_o		<= wdata;
	ram_ipb_addr_o			<= addr;
	ipb_miso_o.ipb_ack 	<= ack;

	ipb_miso_o.ipb_err 	<= '0';
	
	rd1: if data_width=32 generate
		ipb_miso_o.ipb_rdata	<= ram_ipb_rdata_i;
	end generate;
	
	rd2: if data_width<32 generate
		ipb_miso_o.ipb_rdata( 31 downto data_width) <= (others => '0');
		ipb_miso_o.ipb_rdata(data_width-1 downto 0) <= ram_ipb_rdata_i;
	end generate;

end rtl;