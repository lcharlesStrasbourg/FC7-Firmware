--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			be_proc
--                          - data processing
--                          - readout	                                                                    
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file (CBC3 only, readout by 1 FIFO) 
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


--! system packages
use work.ipbus.all;

--! user packages
use work.user_package.all;
use work.user_pkg_cfg_modules.all;
use work.user_pkg_be_proc.all;



entity be_proc is
port 
(
	clk_i							: in std_logic;                            
	reset_i							: in std_logic;
    --======================--
	-- IPBUS / SLOW CONTROL --
	--======================--
	--# version1							    
	--# version2
	ipb_clk_i						: in std_logic;	 
	--stat
	stat_readout_o					: out stat_readout_type;
	--
	stat_be_proc_o					: out stat_be_proc_type;
	--ctrl
	ctrl_readout_to_ipbus_o			: out ctrl_readout_to_ipbus_type;  
	ctrl_readout_from_ipbus_i		: in ctrl_readout_from_ipbus_type;    
	--======================--
	
	ttc_cmd_ec0_i				: in std_logic;
	--
	evnt_cnt_o						: out std_logic_vector(23 downto 0);  --L1A_cnt24b_o
	--
	L1A_i							: in std_logic;                 
	--from PHY                                                     
	cbc3_trigdata_i					: in cbc3_trigdata_in_sys_type;    
	cbc3_trigdata_valid_i			: in valid_in_sys_type; 
	--                                                     
	cbc3_stubdata_i					: in cbc3_stubdata_in_sys_type   
	--cbc2
--	cbc2_trigdata_i					: in cbc2_trigdata_in_sys_type;    
--	cbc2_trigdata_valid_i			: in valid_in_sys_type; 
--	--                                                     
--	cbc2_stubdata_i					: in cbc2_stubdata_in_sys_type;	   
--	cbc2_stubdata_valid_i			: in valid_in_sys_type;	
	--
	--mpa....
	
	--readout	
);
end be_proc;

architecture rtl of be_proc is


--common_read_en			                            
signal all_buf_rd_en 					: std_logic := '0';		     

--evnt cnt
signal evnt_cnt 						: std_logic_vector(23 downto 0) := (others => '0');
signal evnt_cnt_reset 					: std_logic := '0';	
                                           
--evnt_cnt_buf                                 
signal evnt_cnt_buf_dout 				: std_logic_vector(23 downto 0) := (others => '0');
signal evnt_cnt_buf_full 				: std_logic := '0';	  
signal evnt_cnt_buf_empty 				: std_logic := '0';		
signal evnt_cnt_buf_prog_full			: std_logic := '0';			
signal evnt_cnt_buf_valid				: std_logic := '0';		


signal cbc3_trigdata_buf_dout 			: cbc3_trigdata_sys_type;
signal cbc3_stubdata_buf_dout 			: cbc3_stubdata_sys_type;
signal cbc3_trig_and_stubdata_buf_dout 	: cbc3_trig_and_stubdata_sys_type;
signal cbc3_data_buf_valid 				: valid_in_sys_type;	

signal cbc3_trigdata_buf_empty 			: valid_in_sys_type;
signal cbc3_trigdata_buf_full 			: valid_in_sys_type;
signal cbc3_trigdata_buf_prog_full 		: valid_in_sys_type;

signal cbc3_stubdata_buf_empty 			: valid_in_sys_type;
signal cbc3_stubdata_buf_full 			: valid_in_sys_type;
signal cbc3_stubdata_buf_prog_full 		: valid_in_sys_type;


signal data_payload 					: data_payload_type := (others => (others => '0'));
signal data_payload_emul 				: data_payload_type;

signal data_payload_buf_empty 			: std_logic := '0';	
signal data_payload_buf_not_empty 		: std_logic := '0';	
signal data_payload_buf_valid 			: std_logic := '0';


--for emul

--internal trigger
signal int_trig_rate 					: std_logic_vector(4 downto 0) := (others => '0'); 
signal int_trig_enable 					: std_logic := '0'; 
signal int_trig 						: std_logic := '0'; 

signal data_type 						: std_logic_vector(3 downto 0) := (others => '0'); 
signal trigger_type 					: std_logic_vector(3 downto 0) := (others => '0');


signal sw_readout_reset 				: std_logic := '0';
signal readout_backpressure 			: std_logic := '0';
signal sw_int_trig_enable 				: std_logic := '0';	
signal readout_busy 					: std_logic := '0';

signal L1A 								: std_logic := '0'; 
signal cbc3_trigdata 					: cbc3_trigdata_in_sys_type;
signal cbc3_stubdata 					: cbc3_stubdata_in_sys_type;
signal cbc3_trigdata_valid 				: valid_in_sys_type;	
signal cbc3_trigdata_emul 				: cbc3_trigdata_in_sys_type;
signal cbc3_stubdata_emul 				: cbc3_stubdata_in_sys_type;
signal cbc3_trigdata_valid_emul 		: valid_in_sys_type;

signal common_stubdata_delay 			: std_logic_vector(7 downto 0) := (others => '0');




begin

--out
evnt_cnt_o <= evnt_cnt;


--ctrl
process
begin
wait until rising_edge(clk_i);
	sw_readout_reset 		<= ctrl_readout_from_ipbus_i.readout_reset;
	sw_int_trig_enable 		<= ctrl_readout_from_ipbus_i.int_trig_enable;
	int_trig_rate			<= ctrl_readout_from_ipbus_i.int_trig_rate; 
	trigger_type			<= ctrl_readout_from_ipbus_i.trigger_type; 
	data_type				<= ctrl_readout_from_ipbus_i.data_type; 
	common_stubdata_delay	<= ctrl_readout_from_ipbus_i.common_stubdata_delay;	--8b
end process;

--stat be_proc
resync_stat_be_proc: process
begin
wait until rising_edge(ipb_clk_i); 
	stat_be_proc_o.evnt_cnt 				<= evnt_cnt; --L1A_cnt
	stat_be_proc_o.evnt_cnt_buf_empty 		<= evnt_cnt_buf_empty; 	
	stat_be_proc_o.data_payload_buf_empty 	<= data_payload_buf_empty; 	
	stat_be_proc_o.trigdata_buf_empty 		<= cbc3_trigdata_buf_empty(1)(1)(1); 	
	--wr_cnt trigdata
end process;








data_buffer_i: entity work.data_buffer
port map 
(
	clk_i								=> clk_i,
	reset_i								=> reset_i or sw_readout_reset,
	--
	L1A_i								=> L1A, --L1A_i,
	--
	all_buf_rd_en_i						=> all_buf_rd_en,
	--================--
	-- CBC3 INTERFACE --
	--================--
--	--TRIGDATA from PHY    	
--	cbc3_trigdata_i 					=> cbc3_trigdata_i,
--	cbc3_trigdata_valid_i 				=> cbc3_trigdata_valid_i,
--	--STUBDATA from PHY    
--	cbc3_stubdata_i 					=> cbc3_stubdata_i,
--	cbc3_stubdata_valid_i 				=> (others=>(others=>(others=>'0')));
	--TRIGDATA from PHY    	
	cbc3_trigdata_i 					=> cbc3_trigdata,
	cbc3_trigdata_valid_i 				=> cbc3_trigdata_valid,
	--STUBDATA from PHY    
	cbc3_stubdata_i 					=> cbc3_stubdata,
	cbc3_stubdata_valid_i 				=> (others=>(others=>(others=>'0'))), --not useful
--	cbc3_stubdata_delay_value_i			=> (others=>(others=>(others=>"00000001"))),
	cbc3_stubdata_delay_value_i			=> (others=>(others=>(others=> std_logic_vector(common_stubdata_delay)))),
	--Buffering interface for data payload / data packer   
	cbc3_trigdata_buf_dout_o			=> cbc3_trigdata_buf_dout,
	cbc3_stubdata_buf_dout_o			=> cbc3_stubdata_buf_dout,
	cbc3_trig_and_stubdata_buf_dout_o 	=> cbc3_trig_and_stubdata_buf_dout,
	cbc3_data_buf_valid_o				=> cbc3_data_buf_valid,	
	cbc3_trigdata_buf_empty_o			=> cbc3_trigdata_buf_empty,
	cbc3_trigdata_buf_full_o			=> cbc3_trigdata_buf_full,
	cbc3_trigdata_buf_prog_full_o		=> cbc3_trigdata_buf_prog_full,
	cbc3_stubdata_buf_empty_o			=> cbc3_stubdata_buf_empty,
	cbc3_stubdata_buf_full_o			=> cbc3_stubdata_buf_full,
	cbc3_stubdata_buf_prog_full_o		=> cbc3_stubdata_buf_prog_full
);


--evnt_cnt_reset <= ttc_cmd_ec0_i or sw_readout_reset; --if AMC13 really connected
evnt_cnt_reset <= sw_readout_reset;

evnt_cnt_proc_i: entity work.evnt_cnt_proc
port map 
(
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								=> clk_i,
	evnt_cnt_reset_i					=> evnt_cnt_reset,
	--=============--
	-- L1A Trigger --
	--=============--	
	L1A_i								=> L1A, --L1A_i, --L1A_VALID
	--==============--
	-- COUNTERS OUT --
	--==============--
	evnt_cnt_o							=> evnt_cnt, --L1A_cnt24b_o		
	--=================================--
	-- BUFs INTERFACE FOR DATA MERGING --
	--=================================--			
	all_buf_rd_en_i						=> all_buf_rd_en, --common for all FIFOs	
	evnt_cnt_buf_dout_o					=> evnt_cnt_buf_dout, 
	evnt_cnt_buf_empty_o				=> evnt_cnt_buf_empty,
	evnt_cnt_buf_full_o					=> evnt_cnt_buf_full,
	evnt_cnt_buf_prog_full_o			=> evnt_cnt_buf_prog_full,	
	evnt_cnt_buf_valid_o				=> evnt_cnt_buf_valid		
);


data_packer_i: entity work.data_packer
port map 
(
	cbc3_trigdata_sys_i					=> cbc3_trigdata_buf_dout,
	cbc3_stubdata_sys_i					=> cbc3_stubdata_buf_dout,
	cbc3_trigdata_and_stubdata_sys_i	=> cbc3_trig_and_stubdata_buf_dout,
	--
	evnt_nbr_i							=> evnt_cnt_buf_dout,
	--
	data_payload_o						=> data_payload
	--bx_cnt...
);





int_trig_enable <= not readout_backpressure and  sw_int_trig_enable;

--data or emul
internal_trigger_proc_i: entity work.internal_trigger_proc 
port map
(
	clk_i					=> clk_i, --BX_clk                            
	reset_i					=> reset_i or sw_readout_reset,   
	enable_i				=> int_trig_enable,
	int_trig_o				=> int_trig,
	int_trig_rate_i			=> int_trig_rate --5b	                     
); 

----> version1: connect to top
--cbc3_trigdata 		<= cbc3_trigdata_i;	
--cbc3_trigdata_valid	<= cbc3_trigdata_valid_i;	
--cbc3_stubdata 		<= cbc3_stubdata_i;
--L1A <= L1A_i;



----> version2: test 
--data_emul_gen1: for f in 1 to 1 generate --to 16
--	gen2: for h in 1 to 1 generate
--		gen3: for c in 1 to 8 generate
--			--trigdata	
--			cbc3_trigdata(f)(h)(c) <= (others => '1');
--			--stubdata			
--			cbc3_stubdata(f)(h)(c)(39 downto 36) 	<= "1010";
--			cbc3_stubdata(f)(h)(c)(35 downto 32) 	<= "0011";	--bend3		
--			cbc3_stubdata(f)(h)(c)(31 downto 28) 	<= "0010";	--bend2
--			cbc3_stubdata(f)(h)(c)(27 downto 24) 	<= "0001";	--bend1
--			cbc3_stubdata(f)(h)(c)(23 downto 16) 	<= x"33";	--stub3		
--			cbc3_stubdata(f)(h)(c)(15 downto 8) 	<= x"22";	--stub2
--			cbc3_stubdata(f)(h)(c)(7 downto 0) 		<= x"11";	--stub1
--			--
--			cbc3_trigdata_valid(f)(h)(c) <= int_trig; --L1A_i;			
--		end generate;
--	end generate;
--end generate;
--L1A <= int_trig; --L1A_i;


----> version3: 

--> TODO; problem with  ctrl registers!!!


--[39]: sync
--[38]: err flags
--[37]: or254
--[36]: s ovf
--[35:32]: bend3
--[31:28]: bend2
--[27:24]: bend1
--[23:16]: stub3
--[15:8]: stub2
--[7:0]: stub1

data_emul_gen1: for f in 1 to 1 generate --to 16
	gen2: for h in 1 to 1 generate
		gen3: for c in 1 to 8 generate
			--trigdata	
			cbc3_trigdata_emul(f)(h)(c) <= (others => '1');
			--stubdata			
			cbc3_stubdata_emul(f)(h)(c)(39 downto 36) 	<= "1010";
			cbc3_stubdata_emul(f)(h)(c)(35 downto 32) 	<= "0011";	--bend3		
			cbc3_stubdata_emul(f)(h)(c)(31 downto 28) 	<= "0010";	--bend2
			cbc3_stubdata_emul(f)(h)(c)(27 downto 24) 	<= "0001";	--bend1
			cbc3_stubdata_emul(f)(h)(c)(23 downto 16) 	<= x"33";	--stub3		
			cbc3_stubdata_emul(f)(h)(c)(15 downto 8) 	<= x"22";	--stub2
			cbc3_stubdata_emul(f)(h)(c)(7 downto 0) 	<= x"11";	--stub1
			--
			cbc3_trigdata_valid_emul(f)(h)(c) <= int_trig;			
		end generate;
	end generate;
end generate;	


data_sel_proc:process
begin
wait until rising_edge(clk_i);
	if	data_type = "0000" then --by def, data from PHY
		cbc3_trigdata 		<= cbc3_trigdata_i;		
		cbc3_stubdata 		<= cbc3_stubdata_i;
	elsif data_type = "0001" then --internal emul
		cbc3_trigdata 		<= cbc3_trigdata_emul;		
		cbc3_stubdata 		<= cbc3_stubdata_emul;
	else
		null;
	end if;
end process;

trigger_sel_proc: process
begin
wait until rising_edge(clk_i);
	if trigger_type = "0000" then --by def, L1A from user part (TTC or another one)
		L1A <= L1A_i;
		cbc3_trigdata_valid <= cbc3_trigdata_valid_i;		
	elsif trigger_type = "0001" then
		L1A <= int_trig;			
		cbc3_trigdata_valid <= cbc3_trigdata_valid_emul;
	else
		null;	
	end if;
end process;





readout_i: entity work.readout
port map 
(
	--==================--
	-- Resets and Clock --
	--==================--
	clk_i 								=> clk_i,
	reset_i								=> reset_i or sw_readout_reset, 			
    --======================--
	-- IPBUS / SLOW CONTROL --
	--======================--
	--# version1							    
	--# version2
	ipb_clk_i							=> ipb_clk_i,	 
	--stat
	stat_readout_o						=> stat_readout_o,
	--ctrl
	ctrl_readout_to_ipbus_o				=> ctrl_readout_to_ipbus_o,
	ctrl_readout_from_ipbus_i			=> ctrl_readout_from_ipbus_i,   
	--======================--
	-- EVENT DATA INTERFACE --
	--======================--
	data_payload_buf_rd_en_o			=> all_buf_rd_en,
	--
	data_payload_buf_empty_i			=> data_payload_buf_empty, 
	data_payload_buf_not_empty_i		=> data_payload_buf_not_empty, 		
	data_payload_buf_valid_i			=> data_payload_buf_valid, 
	--data to readout
	data_payload_buf_data_i				=> data_payload,
	--======================--
	-- TOP INTERFACE --
	--======================--
	backpressure_o						=> readout_backpressure
);

--if cbc3..if mpa..
data_payload_buf_empty 		<= cbc3_trigdata_buf_empty(1)(1)(1) and evnt_cnt_buf_empty;
data_payload_buf_not_empty	<= not data_payload_buf_empty;

data_payload_buf_valid 		<= evnt_cnt_buf_valid; --cbc3_data_buf_valid(1)(1)(1);




end rtl;
