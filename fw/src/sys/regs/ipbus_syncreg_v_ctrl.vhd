-- ipbus_syncreg_v
--
-- Generic control / status register bank
--
-- Provides N_CTRL control registers (32b each), rw
-- Provides N_STAT status registers (32b each), ro
--
-- Bottom part of read address space is control, top is status
--
-- Both control and status are moved across clock domains with full handshaking
-- This may be overkill for some applications
--
-- Dave Newbold, June 2013 (Edited by PV for TCDS)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.ipbus_reg_types.all;

entity ipbus_syncreg_v_ctrl is
	generic(
		N_CTRL     : positive := 1
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ipb_in: in ipb_wbus;
		ipb_out: out ipb_rbus;
		slv_clk: in std_logic;
		q: out ipb_reg_v(N_CTRL - 1 downto 0);
		stb: out std_logic_vector(N_CTRL - 1 downto 0)
	);
	
end ipbus_syncreg_v_ctrl;

architecture rtl of ipbus_syncreg_v_ctrl is

	constant ADDR_WIDTH: integer := calc_width(N_CTRL) ;

	signal sel: integer := 0;
	signal ctrl_cyc_w, ctrl_cyc_r: std_logic; --signal ctrl_cyc_w, ctrl_cyc_r, stat_cyc: std_logic;
	signal cq: ipb_reg_v(2 ** ADDR_WIDTH - 1 downto 0);
	signal cwe, cbusy, cack: std_logic_vector(N_CTRL - 1 downto 0);
	signal busy, ack, busy_d, pend: std_logic;

begin

	sel <= to_integer(unsigned(ipb_in.ipb_addr(ADDR_WIDTH - 1 downto 0))) when ADDR_WIDTH > 0 else 0;

	ctrl_cyc_w <= ipb_in.ipb_strobe and     ipb_in.ipb_write; --ctrl_cyc_w <= ipb_in.ipb_strobe and ipb_in.ipb_write and not ipb_in.ipb_addr(ADDR_WIDTH);
	ctrl_cyc_r <= ipb_in.ipb_strobe and not ipb_in.ipb_write; --ctrl_cyc_r <= ipb_in.ipb_strobe and not ipb_in.ipb_write and not ipb_in.ipb_addr(ADDR_WIDTH);
	
	w_gen: for i in N_CTRL - 1 downto 0 generate
	
		cwe(i) <= '1' when ctrl_cyc_w = '1' and sel = i and busy = '0' else '0';
		
		wsync: entity work.syncreg_w
			port map(
				m_clk => clk,
				m_rst => rst,
				m_we => cwe(i),
				m_busy => cbusy(i),
				m_ack => cack(i),
				m_d => ipb_in.ipb_wdata,
				m_q => cq(i),
				s_clk => slv_clk,
				s_q => q(i),
				s_stb => stb(i)
			);

	end generate;
	
	cq(2 ** ADDR_WIDTH - 1 downto N_CTRL) <= (others => (others => '0'));
	
	process(clk)
	begin
		if rising_edge(clk) then
			busy_d <= busy;
			pend <= (pend or (busy and not busy_d)) and ipb_in.ipb_strobe and not rst;
		end if;
	end process;
	
	busy <= '1' when (cbusy /= (cbusy'range => '0'))               else '0'; --busy <= '1' when cbusy /= (cbusy'range => '0') or sbusy /= (sbusy'range => '0') else '0';
	ack <= '1' when  (cack /= (cack'range => '0')  and pend = '1') else '0'; -- ack <= '1' when (cack /= (cack'range => '0') or sack /= (sack'range => '0')) and pend = '1' else '0';
	
	ipb_out.ipb_rdata <= cq(sel);                            --ipb_out.ipb_rdata <= cq(sel) when ctrl_cyc_r = '1' else sq(sel);
	ipb_out.ipb_ack <= (ctrl_cyc_w and ack) or ctrl_cyc_r;   --ipb_out.ipb_ack <= ((ctrl_cyc_w or stat_cyc) and ack) or ctrl_cyc_r;
	ipb_out.ipb_err <= '0';
	
end rtl;

