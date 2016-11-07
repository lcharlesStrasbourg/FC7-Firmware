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

entity ipbus_syncreg_v_stat is
	generic(
		N_STAT     : positive:= 1
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ipb_in: in ipb_wbus;
		ipb_out: out ipb_rbus;
		slv_clk: in std_logic;
		d: in ipb_reg_v(N_STAT - 1 downto 0);
        rstb: out std_logic_vector(N_STAT - 1 downto 0)
	);
	
end ipbus_syncreg_v_stat;

architecture rtl of ipbus_syncreg_v_stat is

	constant ADDR_WIDTH: integer := calc_width(N_STAT);
	signal sel: integer := 0;
	signal stat_cyc: std_logic; 
	signal sq: ipb_reg_v(2 ** ADDR_WIDTH - 1 downto 0);
	signal sre, sbusy, sack: std_logic_vector(N_STAT - 1 downto 0);
	signal busy, ack, busy_d, pend: std_logic;

begin

	sel <= to_integer(unsigned(ipb_in.ipb_addr(ADDR_WIDTH - 1 downto 0))) when ADDR_WIDTH > 0 else 0;

	stat_cyc <= ipb_in.ipb_strobe and not ipb_in.ipb_write; 
	
	r_gen: for i in N_STAT - 1 downto 0 generate

		sre(i) <= '1' when stat_cyc = '1' and sel = i and busy = '0' else '0';
	
		rsync: entity work.syncreg_r
			port map(
				m_clk => clk,
				m_rst => rst,
				m_re => sre(i),
				m_busy => sbusy(i),
				m_ack => sack(i),
				m_q => sq(i),
				s_clk => slv_clk,
				s_d => d(i),
				s_stb => rstb(i)
			);
	
	end generate;
	
	sq(2 ** ADDR_WIDTH - 1 downto N_STAT) <= (others => (others => '0'));
	
	process(clk)
	begin
		if rising_edge(clk) then
			busy_d <= busy;
			pend <= (pend or (busy and not busy_d)) and ipb_in.ipb_strobe and not rst;
		end if;
	end process;
	
	busy <= '1' when (sbusy /= (sbusy'range => '0'))                else '0'; --busy <= '1' when cbusy /= (cbusy'range => '0') or sbusy /= (sbusy'range => '0') else '0';
	ack  <= '1' when (sack  /= (sack'range  => '0') and pend = '1') else '0'; --ack  <= '1' when (cack /= (cack'range => '0') or sack /= (sack'range => '0')) and pend = '1' else '0';
	
	ipb_out.ipb_rdata <= sq(sel);          --ipb_out.ipb_rdata <= cq(sel) when ctrl_cyc_r = '1' else sq(sel);
	ipb_out.ipb_ack   <= stat_cyc and ack; --ipb_out.ipb_ack <= ((ctrl_cyc_w or stat_cyc) and ack) or ctrl_cyc_r;
	ipb_out.ipb_err   <= '0';
	
end rtl;

