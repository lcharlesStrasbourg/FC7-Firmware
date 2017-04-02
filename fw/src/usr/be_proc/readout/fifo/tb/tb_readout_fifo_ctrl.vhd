library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

--! system packages
use work.ipbus.all;

--! IPHC packages
use work.pkg_tkfed.all;
--use work.pkg_readout.all;

 
ENTITY tb_readout_fifo_ctrl IS
generic (
			--
			PKT_NB_SIZE										: positive := 21--24; -- before 21
			);
END tb_readout_fifo_ctrl;
 
ARCHITECTURE behavior OF tb_readout_fifo_ctrl IS 
 
    -- Component Declaration for the Unit Under Test (UUT)



	--==================--
	-- Resets and Clock --
	--==================--
	signal clk_i 									: std_logic := '0';
	signal sclr_i									: std_logic := '0';			
	--=================--
	-- IPBUS INTERFACE --
	--=================--	
	signal ipb_clk_i				        	 	: std_logic := '0';
	signal ipb_mosi_i			            	: ipb_wbus_array(0 to 1):= (others => ((others => '0'), (others => '0'), '0', '0')); --see ipbus_package  
	signal ipb_miso_o			            	: ipb_rbus_array(0 to 1):= (others => ((others => '0'), '0', '0')); --0: fifo0 / 1: fifo1 

	--===============--
	-- S/W INTERFACE --
	--===============--
	--from s/w
	signal from_SW_packet_nb_i					: std_logic_vector(PKT_NB_SIZE-1 downto 0) := (others => '0');	
	signal from_SW_rd_done						: std_logic_vector(1 downto 0) := (others => '0'); -- SRAM_end_readout_i
	signal from_SW_data_type_i					: std_logic := '0';
	signal readoutRelease_i						: std_logic := '0';	--after a break_trigger	   
	--to s/w
	signal to_SW_rd_rq							: std_logic_vector(1 downto 0) := (others => '0');	 --SRAM_full_o
	--
	type packet_cnt_type 						is array(1 downto 0)  of std_logic_vector(PKT_NB_SIZE-1 downto 0);	
	signal packet_cnt								: packet_cnt_type := (others => (others => '0')); --0: sram0 / 1: sram1
	
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	signal fullEvtBuf_empty_i					: std_logic := '0';
	signal fullEvtBuf_not_empty_i				: std_logic := '0';			
	signal fullEvtBuf_valid_i					: std_logic := '0';
	signal fullEvtBuf_rd_en_tmp				: std_logic_vector(1 downto 0) := (others => '0');			
	--data to readout
	signal fullEvtBuf_data_i					: std_logic_vector(TOTAL_BITS_NB-1 downto 0) := (others => '0'); --TOTAL_WORDS_NB = FullEvtSize	
	
	signal fifo_active							: std_logic_vector(1 downto 0) := (others => '0');



   -- Clock period definitions
   constant clk_i_period 						: time := 10 ns;
 
BEGIN
 


	--SRAM0
   readout_fifo0_ctrl_i : entity work.readout_fifo_ctrl 
	GENERIC MAP (
					PKT_NB_SIZE										=> PKT_NB_SIZE,
					FIFO_ACTIVE_FIRST_INIT						=> '1' 								-- '1' <=> yes / '0' <=> no
					)
	port map (
					--==================--
					-- Resets and Clock --
					--==================--	
					clk_i 											=> clk_i,
					sclr_i 											=> sclr_i,
					--=================--
					-- IPBUS INTERFACE --
					--=================--	
					--ipb_reset_i										: in std_logic;
					ipb_clk_i				        	 			=> ipb_clk_i,
					ipb_mosi_i										=> ipb_mosi_i(sram0), --sram0 = 0  
					ipb_miso_o										=> ipb_miso_o(sram0),
					--==========--
					-- s/w link --
					--==========--					
					from_SW_packet_nb_i 							=> from_SW_packet_nb_i,				
					to_SW_rd_rq_o 									=> to_SW_rd_rq(sram0),
					from_SW_rd_done_i 							=> from_SW_rd_done(sram0),
					from_SW_data_type_i							=> from_SW_data_type_i,
					readoutRelease_i								=> readoutRelease_i,	--after a break_trigger
					packet_cnt_o									=> packet_cnt(sram0),					
					--======================--
					-- EVENT DATA INTERFACE --
					--======================--
					fullEvtBuf_empty_i							=> fullEvtBuf_empty_i, 
					fullEvtBuf_not_empty_i						=> fullEvtBuf_not_empty_i, 
					fullEvtBuf_valid_i							=> fullEvtBuf_valid_i, 
					fullEvtBuf_rd_en_o							=> fullEvtBuf_rd_en_tmp(sram0), 			
					--data to readout
					fullEvtBuf_data_i								=> fullEvtBuf_data_i,
					--===============--
					-- TOP interface --
					--===============--					
					readoutRdy_o 									=> open, --readoutRdy(sram0),
					another_FIFO_active_i 						=> '0', --fifo_active(sram1),
					current_FIFO_active_o 						=> fifo_active(sram0),
					--trigger_i										=> trigger_i, --for internal data emulator						
					fsm_flag_o										=> open --fsm_flag(sram0)
        );	

	from_SW_data_type_i 		<= '0'; --test pattern
	from_SW_packet_nb_i 		<= std_logic_vector(to_unsigned(2,from_SW_packet_nb_i'length));
	readoutRelease_i  		<= '0';


	
	process
	begin
	wait until rising_edge(clk_i);
		fullEvtBuf_valid_i <= fullEvtBuf_rd_en_tmp(sram0);
	end process;
					
					

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		sclr_i <= '1';
		fullEvtBuf_empty_i <= '1';
		fullEvtBuf_not_empty_i <= '0';
      wait for 113 ns;	
		sclr_i <= '0';
      wait for clk_i_period*5;
		fullEvtBuf_not_empty_i <= '1';


      wait;
   end process;

END;
