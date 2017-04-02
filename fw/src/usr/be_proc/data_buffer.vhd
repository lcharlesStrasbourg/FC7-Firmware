--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 			data processing & buffering for all kinds of chips (CBC3, CBC2, MPAx)                                                                   
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file (CBC3 only) 
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
use work.user_pkg_cfg_modules.all;
use work.user_pkg_be_proc.all;



entity data_buffer is
port 
(
	clk_i								: in std_logic;                            
	reset_i								: in std_logic;                          
	--
	L1A_i								: in std_logic;	
	--
	all_buf_rd_en_i						: in std_logic; 	
	--================--
	-- CBC3 INTERFACE --
	--================--
	--TRIGDATA from PHY                                                     
	cbc3_trigdata_i						: in cbc3_trigdata_in_sys_type;    
	cbc3_trigdata_valid_i				: in valid_in_sys_type; 
	--STUBDATA from PHY                                                      
	cbc3_stubdata_i						: in cbc3_stubdata_in_sys_type;	   
	cbc3_stubdata_valid_i				: in valid_in_sys_type;	
	cbc3_stubdata_delay_value_i			: in cbc3_stubdata_delay_value_sys_type; 	
	--Buffering interface for data payload / data packer                                                                
	cbc3_trigdata_buf_dout_o			: out cbc3_trigdata_sys_type;
	cbc3_stubdata_buf_dout_o			: out cbc3_stubdata_sys_type;
	cbc3_trig_and_stubdata_buf_dout_o 	: out cbc3_trig_and_stubdata_sys_type;
	cbc3_data_buf_valid_o				: out valid_in_sys_type;	
	cbc3_trigdata_buf_empty_o			: out valid_in_sys_type;
	cbc3_trigdata_buf_full_o			: out valid_in_sys_type;
	cbc3_trigdata_buf_prog_full_o		: out valid_in_sys_type;
	cbc3_stubdata_buf_empty_o			: out valid_in_sys_type;
	cbc3_stubdata_buf_full_o			: out valid_in_sys_type;
	cbc3_stubdata_buf_prog_full_o		: out valid_in_sys_type	


	--cbc2
--	cbc2_trigdata_i					: in cbc2_trigdata_in_sys_type;    
--	cbc2_trigdata_valid_i			: in valid_in_sys_type; 
--	--                                                     
--	cbc2_stubdata_i					: in cbc2_stubdata_in_sys_type;	   
--	cbc2_stubdata_valid_i			: in valid_in_sys_type;	
	--
	--mpa....
);
end data_buffer;

architecture rtl of data_buffer is




begin



cbc3_data_sys_proc_i: entity work.cbc3_data_sys_proc
port map 
(
	clk_i								=> clk_i,
	reset_i								=> reset_i,
	--TRIGDATA from PHY 
	cbc3_trigdata_i 					=> cbc3_trigdata_i,
	cbc3_trigdata_valid_i 				=> cbc3_trigdata_valid_i,
	--STUBDATA from PHY  
	cbc3_stubdata_i 					=> cbc3_stubdata_i,
	cbc3_stubdata_valid_i 				=> cbc3_stubdata_valid_i,	
	cbc3_stubdata_delay_value_i			=> cbc3_stubdata_delay_value_i, 	
	L1A_i								=> L1A_i,	
	--Buffering interface for data payload / data packer    
	all_buf_rd_en_i						=> all_buf_rd_en_i,
	--
	cbc3_trigdata_buf_dout_o			=> cbc3_trigdata_buf_dout_o,
	cbc3_stubdata_buf_dout_o			=> cbc3_stubdata_buf_dout_o,
	cbc3_trig_and_stubdata_buf_dout_o	=> cbc3_trig_and_stubdata_buf_dout_o,
	cbc3_data_buf_valid_o				=> cbc3_data_buf_valid_o,
	cbc3_trigdata_buf_empty_o			=> cbc3_trigdata_buf_empty_o,
	cbc3_trigdata_buf_full_o			=> cbc3_trigdata_buf_full_o,
	cbc3_trigdata_buf_prog_full_o		=> cbc3_trigdata_buf_prog_full_o,
	cbc3_stubdata_buf_empty_o			=> cbc3_stubdata_buf_empty_o,
	cbc3_stubdata_buf_full_o			=> cbc3_stubdata_buf_full_o,
	cbc3_stubdata_buf_prog_full_o		=> cbc3_stubdata_buf_prog_full_o			
);


--cbc2_data_sys_proc_i: entity work.cbc2_data_sys_proc
			
			
--mpax_data_sys_proc_i: entity work.mpax_data_sys_proc
			
			


end rtl;
