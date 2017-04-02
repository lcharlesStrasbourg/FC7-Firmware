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



entity data_packer is
port 
(
	--================--
	-- CBC3 INTERFACE --
	--================--	
	cbc3_trigdata_sys_i					: cbc3_trigdata_sys_type; --f x h x c x DF
	cbc3_stubdata_sys_i					: cbc3_stubdata_sys_type;
	cbc3_trigdata_and_stubdata_sys_i	: cbc3_trig_and_stubdata_sys_type;
	--
	evnt_nbr_i							: in std_logic_vector(23 downto 0);
	--
	data_payload_o						: out data_payload_type
	--bx_cnt...
	 

);
end data_packer;

architecture rtl of data_packer is

signal HEADER1 			: std_logic_vector(31 downto 0) := (others => '0');
signal data_payload 	: data_payload_type := (others => (others => '0'));



begin

data_payload_o <= data_payload;


HEADER1(15 downto 0) 	<= std_logic_vector(to_unsigned(HDR1_FE_NBR,16));
HEADER1(23 downto 16) 	<= std_logic_vector(to_unsigned(HDR1_BLOCK_SIZE,8));
HEADER1(31 downto 24) 	<= std_logic_vector(to_unsigned(0,8));



data_payload(1) <= HEADER1;


gen4: for f in 1 to 16 generate --fe / 16 or FE_NBR
begin
	--
	gen41: if cfg_modules(f).HYB_NBR /= 0 generate 
	begin

		--HDR2
		-->word1
		data_payload(OFFSET_FE(f) + 1)(7 downto 0) 		<= std_logic_vector(to_unsigned(HDR2_PARAM_NBR,8));
		data_payload(OFFSET_FE(f) + 1)(15 downto 8) 	<= std_logic_vector(to_unsigned(HDR2_SIZE,8));
		data_payload(OFFSET_FE(f) + 1)(23 downto 16) 	<= std_logic_vector(to_unsigned(HDR2_DATA_FORMAT_VER,8)); 	
		-->word2
		data_payload(OFFSET_FE(f) + 2)(15 downto 0) 	<= std_logic_vector(to_unsigned(FE_SIZE(f),16)); --(others => '0'); --calc_evt_size 	
		data_payload(OFFSET_FE(f) + 2)(23 downto 16) 	<= std_logic_vector(to_unsigned(cfg_modules(f).TRIGDATA_SIZE,8));    
		data_payload(OFFSET_FE(f) + 2)(31 downto 24) 	<= std_logic_vector(to_unsigned(cfg_modules(f).STUBDATA_SIZE,8));
		-->word3
		data_payload(OFFSET_FE(f) + 3)(7 downto 0) 		<= std_logic_vector(to_unsigned(0,8)); --CHIP_ID
		data_payload(OFFSET_FE(f) + 3)(15 downto 8) 	<= std_logic_vector(to_unsigned(0,8)); --(others => '0'); --BE_ID	
		data_payload(OFFSET_FE(f) + 3)(23 downto 16) 	<= std_logic_vector(to_unsigned(0,8)); --(others => '0'); --CIC_ID	
		data_payload(OFFSET_FE(f) + 3)(31 downto 24) 	<= std_logic_vector(to_unsigned(0,8)); --(others => '0'); --CONNEC_TYPE
		-->word4
		data_payload(OFFSET_FE(f) + 4)(7 downto 0) 		<= std_logic_vector(to_unsigned(cfg_modules(f).HYB_NBR,8));  
		data_payload(OFFSET_FE(f) + 4)(15 downto 8) 	<= std_logic_vector(to_unsigned(cfg_modules(f).HYB1_CHIP_NBR,8));  	
		data_payload(OFFSET_FE(f) + 4)(23 downto 16) 	<= std_logic_vector(to_unsigned(cfg_modules(f).HYB2_CHIP_NBR,8));
		data_payload(OFFSET_FE(f) + 4)(31 downto 24)	 <= std_logic_vector(to_unsigned(cfg_modules(f).HYB_POS,8));
		-->word5	
		data_payload(OFFSET_FE(f) + 5)(7 downto 0) 		<= std_logic_vector(to_unsigned(0,8)); --(others => '0'); --DATA_MODE
		data_payload(OFFSET_FE(f) + 5)(15 downto 8) 	<= std_logic_vector(to_unsigned(0,8)); --(others => '0'); --INTERNAL TRACKTRIG	
		data_payload(OFFSET_FE(f) + 5)(31 downto 16) 	<= std_logic_vector(to_unsigned(FW_ID,16)); --(others => '0'); --FW_ID		
		-->word6	
		data_payload(OFFSET_FE(f) + 6)(23 downto 0) 	<= evnt_nbr_i; --EVENT NBR
		data_payload(OFFSET_FE(f) + 6)(31 downto 24) 	<= std_logic_vector(to_unsigned(0,8)); --(others => '0'); --TDC		


		--h=1 + cbc
		gen411: if cfg_modules(f).HYB1_CHIP_NBR /= 0 and cfg_modules(f).CHIP_ID = "CBC3"  generate 
		begin
			--
			gen4111: for c in 1 to cfg_modules(f).HYB1_CHIP_NBR generate --chip
			begin				
				--
				gen41111: if cfg_modules(f).TRIGDATA_SIZE /= 0 and cfg_modules(f).STUBDATA_SIZE /= 0 generate
				constant S : integer := CBC3_TRIGDATA_AND_STUBDATA_SIZE;
				begin
					gen411111: for n in 1 to S generate --1:11
					begin
						data_payload(OFFSET_DATA_HYB1(f) + n + S*(c-1)) 	<= cbc3_trigdata_and_stubdata_sys_i(f)(1)(c)(n);  --N1 = CHIP_DATA_SIZE
					end generate;
				end generate;
				--
				gen41112: if cfg_modules(f).TRIGDATA_SIZE /= 0 and cfg_modules(f).STUBDATA_SIZE = 0 generate
				constant S : integer := CBC3_TRIGDATA_SIZE;				
				begin
					gen411121: for n in 1 to S generate --1:9
					begin
						data_payload(OFFSET_DATA_HYB1(f) + n + S*(c-1))		<= cbc3_trigdata_sys_i(f)(1)(c)(n);
					end generate;
				end generate;												
				--
				gen41113: if cfg_modules(f).TRIGDATA_SIZE = 0 and cfg_modules(f).STUBDATA_SIZE /= 0 generate
				constant S : integer := CBC3_STUBDATA_SIZE;	
				begin
					gen411131: for n in 1 to S generate --1:2
					begin
						data_payload(OFFSET_DATA_HYB1(f) + n + S*(c-1))		<= cbc3_stubdata_sys_i(f)(1)(c)(n);
					end generate;
				end generate;
			end generate;
		end generate;


		--h=2 + cbc
		gen412: if cfg_modules(f).HYB2_CHIP_NBR /= 0 and cfg_modules(f).CHIP_ID = "CBC3" generate
		begin	
			gen4121: for c in 1 to cfg_modules(f).HYB2_CHIP_NBR generate --chip
			begin				
				--
				gen41211: if cfg_modules(f).TRIGDATA_SIZE /= 0 and cfg_modules(f).STUBDATA_SIZE /= 0 generate
				constant S : integer := CBC3_TRIGDATA_AND_STUBDATA_SIZE;				
				begin
					gen412111: for n in 1 to S generate --1:11
					begin
						data_payload(OFFSET_DATA_HYB2(f) + n + S*(c-1)) 		<=	cbc3_trigdata_and_stubdata_sys_i(f)(2)(c)(n);
					end generate;
				end generate;
				--
				gen41212: if cfg_modules(f).TRIGDATA_SIZE /= 0 and cfg_modules(f).STUBDATA_SIZE = 0 generate
				constant S : integer := CBC3_TRIGDATA_SIZE;					
				begin
					gen412121: for n in 1 to S generate --1:9
					begin
						data_payload(OFFSET_DATA_HYB2(f) + n + S*(c-1)) 		<= cbc3_trigdata_sys_i(f)(2)(c)(n);
					end generate;
				end generate;												
				--
				gen41213: if cfg_modules(f).TRIGDATA_SIZE = 0 and cfg_modules(f).STUBDATA_SIZE /= 0 generate
				constant S : integer := CBC3_STUBDATA_SIZE;					
				begin
					gen412131: for n in 1 to S generate --1:2
					begin
						data_payload(OFFSET_DATA_HYB2(f) + n + S*(c-1)) 		<= cbc3_stubdata_sys_i(f)(2)(c)(n);
					end generate;
				end generate;
			end generate;
		end generate;	
	end generate;
end generate;


			
			

			
			


end rtl;
