----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2016 01:38:14 PM
-- Design Name: 
-- Module Name: be_data_buffer_core - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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



entity cbc3_data_sys_proc is
port 
(
	clk_i								: in std_logic;                            
	reset_i								: in std_logic;                          
	--TRIGDATA from PHY                                                   
	cbc3_trigdata_i						: in cbc3_trigdata_in_sys_type;    
	cbc3_trigdata_valid_i				: in valid_in_sys_type; 
	--STUBDATA from PHY                                                 
	cbc3_stubdata_i						: in cbc3_stubdata_in_sys_type;	   
	cbc3_stubdata_valid_i				: in valid_in_sys_type;	
	cbc3_stubdata_delay_value_i			: in cbc3_stubdata_delay_value_sys_type; 	
	L1A_i								: in std_logic;
	--Buffering interface for data payload / data packer                                                 
	all_buf_rd_en_i						: in std_logic;                    
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
		
);
end cbc3_data_sys_proc;


architecture rtl of cbc3_data_sys_proc is



begin


--gen1: for f in 1 to 16 generate
--	gen2: for h in 1 to 2 generate
--		gen3: for c in 1 to 8 generate
--			cbc3_data_proc_i: entity work.cbc3_data_proc
--			port map
--			(
--				clk_i								=> clk_i, 
--				reset_i								=> reset_i, 
--				--TRIGDATA 
--				cbc3_trigdata_i						=> cbc3_trigdata_i(f)(h)(c),  
--				cbc3_trigdata_valid_i				=> cbc3_trigdata_valid_i(f)(h)(c), 
--				--STUBDATA
--				cbc3_stubdata_i						=> cbc3_stubdata_i(f)(h)(c), 	
--				cbc3_stubdata_valid_i				=> cbc3_stubdata_valid_i(f)(h)(c), 
--				cbc3_stubdata_delay_value_i			=> cbc3_stubdata_delay_value_i(f)(h)(c), 
--				L1A_i								=> L1A_i,
--				--Buffering interface
--				all_buf_rd_en_i						=> all_buf_rd_en_i, 
--				cbc3_trigdata_buf_dout_o			=> cbc3_trigdata_buf_dout_o(f)(h)(c), 	
--				cbc3_stubdata_buf_dout_o			=> cbc3_stubdata_buf_dout_o(f)(h)(c),  
--				cbc3_trig_and_stubdata_buf_dout_o	=> cbc3_trig_and_stubdata_buf_dout_o(f)(h)(c),  
--				cbc3_data_buf_valid_o				=> cbc3_data_buf_valid_o(f)(h)(c)
--			);
--		end generate;
--	end generate;		
--end generate;		
		

fe: for f in 1 to 16 generate --fe / 16 or FE_NBR
begin
	--
	gen: if cfg_modules(f).HYB_NBR /= 0 generate
	begin
		--hyb1 + cbc3
		hyb1_cbc3: if cfg_modules(f).HYB1_CHIP_NBR /= 0 and cfg_modules(f).CHIP_ID = "CBC3"  generate 
		constant h : integer := 1;
		begin
			--
			chip: for c in 1 to cfg_modules(f).HYB1_CHIP_NBR generate --chip
			begin				
				--
				cbc3_data_proc_i: entity work.cbc3_data_proc
				port map
				(
					clk_i								=> clk_i, 
					reset_i								=> reset_i, 
					--TRIGDATA 
					cbc3_trigdata_i						=> cbc3_trigdata_i(f)(h)(c),  
					cbc3_trigdata_valid_i				=> cbc3_trigdata_valid_i(f)(h)(c), 
					--STUBDATA
					cbc3_stubdata_i						=> cbc3_stubdata_i(f)(h)(c), 	
					cbc3_stubdata_valid_i				=> cbc3_stubdata_valid_i(f)(h)(c), 
					cbc3_stubdata_delay_value_i			=> cbc3_stubdata_delay_value_i(f)(h)(c), 
					L1A_i								=> L1A_i,
					--Buffering interface
					all_buf_rd_en_i						=> all_buf_rd_en_i, 
					cbc3_trigdata_buf_dout_o			=> cbc3_trigdata_buf_dout_o(f)(h)(c), 	
					cbc3_stubdata_buf_dout_o			=> cbc3_stubdata_buf_dout_o(f)(h)(c),  
					cbc3_trig_and_stubdata_buf_dout_o	=> cbc3_trig_and_stubdata_buf_dout_o(f)(h)(c),  
					cbc3_data_buf_valid_o				=> cbc3_data_buf_valid_o(f)(h)(c),
					cbc3_trigdata_buf_empty_o			=> cbc3_trigdata_buf_empty_o(f)(h)(c),
					cbc3_trigdata_buf_full_o			=> cbc3_trigdata_buf_full_o(f)(h)(c),
					cbc3_trigdata_buf_prog_full_o		=> cbc3_trigdata_buf_prog_full_o(f)(h)(c),
					cbc3_stubdata_buf_empty_o			=> cbc3_stubdata_buf_empty_o(f)(h)(c),
					cbc3_stubdata_buf_full_o			=> cbc3_stubdata_buf_full_o(f)(h)(c),
					cbc3_stubdata_buf_prog_full_o		=> cbc3_stubdata_buf_prog_full_o(f)(h)(c)											
				);
			end generate;
		end generate;

		--hyb2 + cbc3
		hyb2_cbc3: if cfg_modules(f).HYB2_CHIP_NBR /= 0 and cfg_modules(f).CHIP_ID = "CBC3"  generate 
		constant h : integer := 2;
		begin		
			--
			chip: for c in 1 to cfg_modules(f).HYB2_CHIP_NBR generate --chip
			begin				
				cbc3_data_proc_i: entity work.cbc3_data_proc
				port map
				(
					clk_i								=> clk_i, 
					reset_i								=> reset_i, 
					--TRIGDATA 
					cbc3_trigdata_i						=> cbc3_trigdata_i(f)(h)(c),  
					cbc3_trigdata_valid_i				=> cbc3_trigdata_valid_i(f)(h)(c), 
					--STUBDATA
					cbc3_stubdata_i						=> cbc3_stubdata_i(f)(h)(c), 	
					cbc3_stubdata_valid_i				=> cbc3_stubdata_valid_i(f)(h)(c), 
					cbc3_stubdata_delay_value_i			=> cbc3_stubdata_delay_value_i(f)(h)(c), 
					L1A_i								=> L1A_i,
					--Buffering interface
					all_buf_rd_en_i						=> all_buf_rd_en_i, 
					cbc3_trigdata_buf_dout_o			=> cbc3_trigdata_buf_dout_o(f)(h)(c), 	
					cbc3_stubdata_buf_dout_o			=> cbc3_stubdata_buf_dout_o(f)(h)(c),  
					cbc3_trig_and_stubdata_buf_dout_o	=> cbc3_trig_and_stubdata_buf_dout_o(f)(h)(c),  
					cbc3_data_buf_valid_o				=> cbc3_data_buf_valid_o(f)(h)(c),
					cbc3_trigdata_buf_empty_o			=> cbc3_trigdata_buf_empty_o(f)(h)(c),
					cbc3_trigdata_buf_full_o			=> cbc3_trigdata_buf_full_o(f)(h)(c),
					cbc3_trigdata_buf_prog_full_o		=> cbc3_trigdata_buf_prog_full_o(f)(h)(c),
					cbc3_stubdata_buf_empty_o			=> cbc3_stubdata_buf_empty_o(f)(h)(c),
					cbc3_stubdata_buf_full_o			=> cbc3_stubdata_buf_full_o(f)(h)(c),
					cbc3_stubdata_buf_prog_full_o		=> cbc3_stubdata_buf_prog_full_o(f)(h)(c)
				);
			end generate;
		end generate;	
	end generate;
end generate;





end rtl;
