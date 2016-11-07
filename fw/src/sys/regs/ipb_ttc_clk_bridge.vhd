-- clock bridge
-- it works only if the ack goes back to zero for every transaction

library ieee;
use ieee.std_logic_1164.all;
use work.ipbus.all;

entity ipb_ttc_clk_bridge is
generic
(
		mem_type	: string(1 to 3) := "ram" -- "ram" or "reg" or "nop"
);
port
(
	 ipb_clk_i  : in  std_logic;
	 ipb_wbus_i : in  ipb_wbus;
	 ipb_rbus_o : out ipb_rbus;
	 -----------
	 ttc_clk_i  : in  std_logic;
	 -----------
	 ipb_clk_o  : out std_logic;
	 ipb_wbus_o : out ipb_wbus;
	 ipb_rbus_i : in  ipb_rbus
);
end ipb_ttc_clk_bridge;

architecture rtl of ipb_ttc_clk_bridge is

	signal ipb_rbus_i_r 				: ipb_rbus;
	signal ipb_wbus_i_r 				: ipb_wbus; 

	signal ipb_rbus_o_gb				: ipb_rbus;
	signal ipb_wbus_o_gb				: ipb_wbus; 
	 
	
	signal ipb_rbus_i_r_ack_2clk 	: std_logic;
	signal ipb_rbus_o_gb_ack_2clk : std_logic;
	 
begin




	--============================--
	ipb_clk_o <= ttc_clk_i;
	--============================--



	--============================--
	ipb_clk_r: process(ipb_clk_i) -- register buses to/from ipb_clk_domain
	--============================--
	begin
	if rising_edge(ipb_clk_i) then
		ipb_wbus_i_r 				<= ipb_wbus_i;
		ipb_rbus_o.ipb_rdata		<= ipb_rbus_o_gb.ipb_rdata;
		ipb_rbus_o.ipb_err		<= ipb_rbus_o_gb.ipb_err;
		--ipb_rbus_o.ipb_ack		<= ipb_rbus_o_gb.ipb_ack;
	end if;
	end process;
	--============================--
	

	
	--============================--
	ext_clk_r: process(ttc_clk_i) -- register buses to/from ext_clk_domain
	--============================--
	begin
	if rising_edge(ttc_clk_i) then

		ipb_rbus_i_r 	<= ipb_rbus_i;
		ipb_wbus_o 		<= ipb_wbus_o_gb;
	
	end if;
	end process;
	--============================--
	

	
	--============================--
	ack_i: process(ttc_clk_i) -- extends to 2clk width to ensure that at least one will appear on the other side
	--============================--
		variable ack_r : std_logic;
	begin
	if rising_edge(ttc_clk_i) then
		
		ipb_rbus_i_r_ack_2clk	<= ipb_rbus_i.ipb_ack or ack_r;
		ack_r							:= ipb_rbus_i.ipb_ack;
		
	end if;
	end process;
	--============================--
	


	--============================--
	ack_o: process(ipb_clk_i) -- reduces to 1clk width in case a 2clk width appears
	--============================--
		variable ack_r : std_logic;
	begin
	if rising_edge(ipb_clk_i) then
		
		ipb_rbus_o.ipb_ack 	<= ipb_rbus_o_gb_ack_2clk and (not ack_r);
		ack_r						:= ipb_rbus_o_gb_ack_2clk;
		
	end if;
	end process;
	--============================--



--############################################################
--############################################################
--############################################################
--############################################################
--############################################################
--############################################################



gb: if mem_type/="nop" generate

	--============================--
	wbus: entity work.clk_domain_bridge
	--============================--
	generic map (n => 66, mem => mem_type)
	port map
	(
		wrclk_i							=> ipb_clk_i,
		wdata_i(31 downto  0)		=> ipb_wbus_i_r.ipb_wdata,
		wdata_i(63 downto 32)		=> ipb_wbus_i_r.ipb_addr,
		wdata_i(64)						=> ipb_wbus_i_r.ipb_strobe,
		wdata_i(65)						=> ipb_wbus_i_r.ipb_write,
		--
		rdclk_i							=> ttc_clk_i,
		rdata_o(31 downto  0)		=> ipb_wbus_o_gb.ipb_wdata,
		rdata_o(63 downto 32)		=> ipb_wbus_o_gb.ipb_addr,
		rdata_o(64)						=> ipb_wbus_o_gb.ipb_strobe,
		rdata_o(65)						=> ipb_wbus_o_gb.ipb_write
	);



	--============================--
	rbus: entity work.clk_domain_bridge
	--============================--
	generic map (n => 34, mem => mem_type)
	port map
	(
		wrclk_i							=> ttc_clk_i,
		wdata_i(31 downto 0)			=> ipb_rbus_i_r.ipb_rdata,
		wdata_i(32)						=> ipb_rbus_i_r.ipb_err,
		wdata_i(33)						=> ipb_rbus_i_r_ack_2clk, --ipb_rbus_r.ipb_ack,
		--
		rdclk_i							=> ipb_clk_i,
		rdata_o(31 downto 0)			=> ipb_rbus_o_gb.ipb_rdata,
		rdata_o(32)						=> ipb_rbus_o_gb.ipb_err,
		rdata_o(33)						=> ipb_rbus_o_gb_ack_2clk
	);


end generate;


--############################################################
--############################################################
--############################################################
--############################################################
--############################################################
--############################################################


no_gb: if mem_type="nop" generate

		ipb_wbus_o_gb					<= ipb_wbus_i_r;

		ipb_rbus_o_gb.ipb_rdata		<= ipb_rbus_i_r.ipb_rdata	;
		ipb_rbus_o_gb.ipb_err		<= ipb_rbus_i_r.ipb_err		;
		ipb_rbus_o_gb_ack_2clk		<= ipb_rbus_i_r_ack_2clk	;

end generate;



--############################################################
--############################################################
--############################################################
--############################################################
--############################################################
--############################################################


end rtl;