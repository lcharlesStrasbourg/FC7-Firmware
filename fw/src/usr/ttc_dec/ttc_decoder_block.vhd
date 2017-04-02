--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			TTC decoder
	                                                                    
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file 
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
use work.user_package.all;

entity ttc_decoder_block is
generic
(
	SLOWCTRL_MODE				: integer := 1 
);
port 
(
	--================================--
	-- FABRIC CLOCK (before mmcm/pll) --
	--================================--
    fabric_clk_i                : in std_logic;  
	--===============================--
    -- FABRIC CLOCK (after mmcm/pll) --
    --===============================--
    BX_clk_i                    : in std_logic; 
	--===============--
    -- Powerup reset --
    --===============--    
    powerup_reset_i				: in std_logic;                     
    --======================--
    -- IPBUS / SLOW CONTROL --
    --======================--
    --# version1
    ttc_dec_reset_i             : in std_logic;
	iodelay_clk_i				: in	std_logic;
	iodelay_load_i     			: in	std_logic:= '0';								-- delay increment, decrement signal for bit 
    iodelay_inc_i      			: in	std_logic:= '0';								-- delay increment, decrement signal for bit 
    iodelay_ce_i       			: in	std_logic:= '0';								-- delay increment, decrement signal for bit 
    iodelay_tap_ctrl_i         	: in	std_logic_vector(4 downto 0):= "00000";			-- dynamically loadable delay tap value for bit 
    iodelay_tap_stat_o        	: out	std_logic_vector(4 downto 0);					-- bit  delay tap value for monitoring 
    --# version2
	ipb_clk_i					: in std_logic;	    
    stat_global_ttc_o			: out stat_global_ttc_type;          
    ctrl_global_ttc_i			: in ctrl_global_ttc_type;       
    --=================--
    -- TTC DATA INPUTS --
    --=================--
    ttc_data_p_i                : in std_logic;	
    ttc_data_n_i                : in std_logic;	  
    --=================--
    -- FLAGS or STATUS --
    --=================--  
    ttc_rdy_o					: out std_logic;
	ttc_dec_single_err_cnt_o	: out std_logic_vector(15 downto 0);
    ttc_dec_double_err_cnt_o	: out std_logic_vector(15 downto 0); 
    --=============--
    -- TTC OUTPUTS --
    --=============--    
    --ttc_sig_o                   : out ttc_sig_o_type; --or ttc_cmd_...
    ttc_l1a_o                   : out std_logic;
    ttc_cmd_ec0_o    			: out std_logic;
    ttc_cmd_bc0_o				: out std_logic;
    ttc_cmd_reset_o				: out std_logic
   
);


end ttc_decoder_block;

architecture rtl of ttc_decoder_block is



type ttc_sig_o_type is --pulse mode clocked at 40M (BX clk)
record
    rdy                 : std_logic;
	l1a					: std_logic;     
    cmd_ec0 			: std_logic;
    cmd_bc0 			: std_logic;
	cmd_reset			: std_logic;
	single_bit_error	: std_logic;	    
    double_bit_error    : std_logic;
end record;	
					

type ttc_dec_idelay_ctrl_type is
record
    load                : std_logic;
    inc                 : std_logic;    
    ce 			        : std_logic;
    tap_ctrl 			: std_logic_vector(4 downto 0);
	tap_stat			: std_logic_vector(4 downto 0);
end record;	

signal ttc_dec_idelay_ctrl : ttc_dec_idelay_ctrl_type := ('0','0','0',(others=>'0'),(others=>'0')); 


type ttc_sig_type is
record
    rdy                 : std_logic;
    brcst               : std_logic_vector(7 downto 2);
    brcst_strobe        : std_logic;    
    brcst_ec0 			: std_logic;
    brcst_bc0 			: std_logic;
	l1a					: std_logic;
	single_bit_err		: std_logic;	    
    double_bit_err    	: std_logic;
end record;	

signal ttc_sig          : ttc_sig_type := ('0',(others=>'0'),'0','0','0','0','0','0');


--
signal ttc_cmd_bc0          		: std_logic := '0';
signal ttc_cmd_bc0_del      		: std_logic := '0'; 
signal ttc_cmd_bc0_pulse    		: std_logic := '0'; 
--
signal ttc_cmd_ec0          		: std_logic := '0';
signal ttc_cmd_ec0_del      		: std_logic := '0';
signal ttc_cmd_ec0_pulse    		: std_logic := '0'; 
--
signal ttc_cmd_reset          		: std_logic := '0';
signal ttc_cmd_reset_del          	: std_logic := '0';
signal ttc_cmd_reset_pulse          : std_logic := '0';



--
signal ttc_l1a_del          		: std_logic_vector(1 downto 0) := (others => '0');
signal ttc_l1a_pulse        		: std_logic := '0';

signal ttc_rdy                      :  std_logic := '0';

signal ttc_single_bit_err     		: std_logic := '0';
signal ttc_single_bit_err_del     	: std_logic := '0';
signal ttc_single_bit_err_pulse     : std_logic := '0';

signal ttc_double_bit_err     		: std_logic := '0';
signal ttc_double_bit_err_del     	: std_logic := '0';
signal ttc_double_bit_err_pulse     : std_logic := '0';

signal ttc_dec_single_err_cnt		: std_logic_vector(15 downto 0) := (others => '0');
signal ttc_dec_double_err_cnt		: std_logic_vector(15 downto 0) := (others => '0');

signal ttc_dec_reset				: std_logic := '0';

begin

stat_global_ttc_proc: process
begin
wait until rising_edge(ipb_clk_i);
	stat_global_ttc_o.ttc_rdy 					<= ttc_rdy;
	stat_global_ttc_o.ttc_dec_single_err_cnt 	<= ttc_dec_single_err_cnt;
	stat_global_ttc_o.ttc_dec_double_err_cnt 	<= ttc_dec_double_err_cnt;
end process;

--ttc_sig_o.rdy               <= TTC_rdy;
--ttc_sig_o.ECO               <= ttc_ec0_pulse;
--ttc_sig_o.BCO               <= ttc_bc0_pulse;
--ttc_sig_o.l1a               <= TTC_l1a_pulse;
--ttc_sig_o.single_bit_error  <= TTC_single_bit_error_pulse;
--ttc_sig_o.double_bit_error  <= TTC_double_bit_error_pulse;


ttc_rdy_o               <= ttc_rdy;
ttc_l1a_o               <= ttc_l1a_pulse;
ttc_cmd_ec0_O			<= ttc_cmd_ec0_pulse;
ttc_cmd_bc0_o			<= ttc_cmd_bc0_pulse;
ttc_cmd_reset_o         <= ttc_cmd_reset_pulse;
--
ttc_dec_single_err_cnt_o <= ttc_dec_single_err_cnt;
ttc_dec_double_err_cnt_o <= ttc_dec_double_err_cnt;


--===========--
-- SLOW CTRL --
--===========--
slow_ctrl_gen0: if SLOWCTRL_MODE = 0 generate
	ttc_dec_reset	<= ttc_dec_reset_i or powerup_reset_i;
end generate;

slow_ctrl_gen1: if SLOWCTRL_MODE = 1 generate
	ttc_dec_reset	<= ctrl_global_ttc_i.ttc_dec_reset or powerup_reset_i;
end generate;



   
--=============--
-- TTC DECODER --
--=============--

ttc_core_inst: entity work.cpm_ttc_dec_wrapper
port map
(
    reset_i                     => ttc_dec_reset,
    --	   
    cpm_ttc_data_p              => ttc_data_p_i,
    cpm_ttc_data_n              => ttc_data_n_i,
    cpm_ttc_clk                 => fabric_clk_i, 
    --
    iodelay_clk_i               => iodelay_clk_i, --clk_200_0_idelay, 
    --== ttc decoder idelay IPbus registers==--
    iodelay_load                => iodelay_load_i, --ttc_dec_idelay_ctrl.load,                                     
    iodelay_inc                 => iodelay_inc_i, --ttc_dec_idelay_ctrl.inc,                                        
    iodelay_ce                  => iodelay_ce_i, --ttc_dec_idelay_ctrl.ce,                                        
    iodelay_tap_ctrl            => iodelay_tap_ctrl_i, --ttc_dec_idelay_ctrl.tap_ctrl,                                    
    iodelay_tap_stat            => iodelay_tap_stat_o, --ttc_dec_idelay_ctrl.tap_stat,                                        
    --== ttc decoder output ==--
    single_bit_error            => ttc_sig.single_bit_err,
    double_bit_error            => ttc_sig.double_bit_err,
    communication_error         => open,
    l1a                         => ttc_sig.l1a,
    brc_strobe                  => ttc_sig.brcst_strobe,
    add_strobe                  => open,
    --ttddddeb        
    brc_t2                      => ttc_sig.brcst(7 downto 6),
    brc_d4                      => ttc_sig.brcst(5 downto 2),
    brc_e                       => ttc_sig.brcst_ec0,
    brc_b                       => ttc_sig.brcst_bc0,
    --aaaaaaaaaaaaaae1ssssssssdddddddd
    add_a14                     => open,
    add_e                       => open,
    add_s8                      => open,
    add_d8                      => open,
    --== auxiliary outputs ===--
    ready                       => ttc_sig.rdy,
    tp                          => open,--test_a,
    tpp                         => open--test_b
);
--================================--



--ttc_l1a_o   <= ttc_sig.l1a and ttc_sig.ttc_rdy;
--ttc_cmd_ec0_o   <= ttc_sig.brcst_ec0 and ttc_sig.brcst_strobe and ttc_sig.ttc_rdy;
--ttc_cmd_bc0_o   <= ttc_sig.brcst_bc0 and ttc_sig.brcst_strobe and ttc_sig.ttc_rdy;




--=============================================================================================================================================--
-- L1A + TTC B-Channel Decoding -- 
--=============================================================================================================================================--
--RESET-TBM- This is the main Reset, coded in the B-channel as Brcst<5:2>=0101.
--Should generate the ResetTBM(101) sequence in the trigger/clock line.	

ttc_rdy_proc: process
begin
wait until rising_edge(BX_clk_i); 
    ttc_rdy <= ttc_sig.rdy;
end process; 


TTC_B_CHAN_CMD_proc: process
begin
wait until rising_edge(BX_clk_i); 
--    BC0
    ttc_cmd_bc0 		<= ttc_sig.brcst_bc0 and ttc_rdy;
    ttc_cmd_bc0_del		<= ttc_cmd_bc0;
    ttc_cmd_bc0_pulse	<= ttc_cmd_bc0 and not ttc_cmd_bc0_del;
--    EC0
    ttc_cmd_ec0 		<= ttc_sig.brcst_ec0 and ttc_rdy;
    ttc_cmd_ec0_del		<= ttc_cmd_ec0;
    ttc_cmd_ec0_pulse	<= ttc_cmd_ec0 and not ttc_cmd_ec0_del;
--    ttc_cmd_reset
    if ttc_sig.brcst_strobe = '1' and ttc_sig.brcst(5 downto 2) = "0101" and ttc_rdy = '1' then
        ttc_cmd_reset <= '1';
    else
        ttc_cmd_reset <= '0';	
    end if;
    ttc_cmd_reset_del		<= ttc_cmd_reset;
    ttc_cmd_reset_pulse 	<= ttc_cmd_reset and not ttc_cmd_reset_del; 
end process;


L1A_proc: process
begin
wait until rising_edge(BX_clk_i); 
    ttc_l1a_del(0) 	<= ttc_sig.l1a and ttc_rdy;
    ttc_l1a_del(1) 	<= ttc_l1a_del(0);	
    ttc_l1a_pulse 	<= ttc_l1a_del(0) and not ttc_l1a_del(1); 
end process;

err_proc: process
begin
wait until rising_edge(BX_clk_i); 
--    single_bit_error		
    ttc_single_bit_err          <= ttc_sig.single_bit_err;
    ttc_single_bit_err_del 	    <= ttc_single_bit_err;		
    ttc_single_bit_err_pulse	<= ttc_single_bit_err and not ttc_single_bit_err_del;
--    double_bit_error		
    ttc_double_bit_err          <= ttc_sig.double_bit_err;
    ttc_double_bit_err_del      <= ttc_double_bit_err;        
    ttc_double_bit_err_pulse    <= ttc_double_bit_err and not ttc_double_bit_err_del;
end process;

--Diag
ttc_dec_single_err_cnt_i: entity work.ttc_dec_err_cnt
port map(
    clk 	=> BX_clk_i,
    sclr 	=> ttc_dec_reset_i, 
    ce		=> ttc_single_bit_err_pulse,
    q 		=> ttc_dec_single_err_cnt --16b
);

ttc_dec_double_err_cnt_i: entity work.ttc_dec_err_cnt
port map(
    clk 	=> BX_clk_i,
    sclr 	=> ttc_dec_reset_i,
    ce		=> ttc_double_bit_err_pulse,
    q 		=> ttc_dec_double_err_cnt --16b
);




end rtl;
