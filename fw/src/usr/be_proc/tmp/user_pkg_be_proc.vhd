library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--! user packages
use work.user_pkg_cfg_modules.all;

package user_pkg_be_proc is

constant FW_ID 							: integer := 1;

constant DATA_FORMAT_VER 				: integer := 1;

--HEADER1
constant HDR1_FE_NBR					: integer := FE_NBR;	
constant HDR1_SIZE						: integer := 1;
----range for HEADER1
--constant r_HDR1_FE_NBR					: std_logic_vector(23 downto 16) := (others => '0');
--constant r_HDR1_BLOCK_SIZE				: std_logic_vector(15 downto 0) := (others => '0');
--ex: HEADER1(r_HDR1_FE_NBR'range) 		<= std_logic_vector(to_unsigned(HDR1_FE_NBR,r_HDR1_FE_NBR'length));

--HEADER2
constant HDR2_DATA_FORMAT_VER 			: integer := DATA_FORMAT_VER;
constant HDR2_PARAM_NBR 				: integer := 19; --for DATA_FORMAT_VER = 01
constant HDR2_SIZE						: integer := 6;	 --for DATA_FORMAT_VER = 01



type cbc3_trigdata_in_hyb_type 				is array (1 to 8) of std_logic_vector(273 downto 0);
type cbc3_trigdata_in_fe_type 				is array (1 to 2) of cbc3_trigdata_in_hyb_type;
type cbc3_trigdata_in_sys_type 				is array (1 to FE_NBR_MAX) of cbc3_trigdata_in_fe_type;

type cbc3_stubdata_in_hyb_type 				is array (1 to 8) of std_logic_vector(39 downto 0);
type cbc3_stubdata_in_fe_type 				is array (1 to 2) of cbc3_stubdata_in_hyb_type;
type cbc3_stubdata_in_sys_type 				is array (1 to FE_NBR_MAX) of cbc3_stubdata_in_fe_type;

type valid_in_hyb_type 						is array (1 to 8) of std_logic;
type valid_in_fe_type 						is array (1 to 2) of valid_in_hyb_type;
type valid_in_sys_type 						is array (1 to FE_NBR_MAX) of valid_in_fe_type;


type cbc2_stubdata_in_hyb_type 				is array (1 to 8) of std_logic;
type cbc2_stubdata_in_fe_type 				is array (1 to 2) of cbc2_stubdata_in_hyb_type;
type cbc2_stubdata_in_sys_type 				is array (1 to FE_NBR_MAX) of cbc2_stubdata_in_fe_type;


--for readout
type cbc3_trigdata_chip_type 				is array (1 to CBC3_TRIGDATA_SIZE) of std_logic_vector(31 downto 0);
type cbc3_trigdata_hyb_type 				is array (1 to 8) of cbc3_trigdata_chip_type;
type cbc3_trigdata_fe_type 					is array (1 to 2) of cbc3_trigdata_hyb_type;
type cbc3_trigdata_sys_type 				is array (1 to FE_NBR_MAX) of cbc3_trigdata_fe_type;
--signal cbc3_trigdata_sys					: cbc3_trigdata_sys_type := (others=>(others=>(others=>(others=>(others=>'0')))));


type cbc3_stubdata_chip_type 				is array (1 to CBC3_STUBDATA_SIZE) of std_logic_vector(31 downto 0);
type cbc3_stubdata_hyb_type 				is array (1 to 8) of cbc3_stubdata_chip_type;
type cbc3_stubdata_fe_type 					is array (1 to 2) of cbc3_stubdata_hyb_type;
type cbc3_stubdata_sys_type 				is array (1 to FE_NBR_MAX) of cbc3_stubdata_fe_type;
--signal cbc3_stubdata_sys					: cbc3_stubdata_sys_type := (others=>(others=>(others=>(others=>(others=>'0')))));

type cbc3_trig_and_stubdata_chip_type 		is array (1 to CBC3_TRIGDATA_AND_STUBDATA_SIZE) of std_logic_vector(31 downto 0);
type cbc3_trig_and_stubdata_hyb_type 		is array (1 to 8) of cbc3_trig_and_stubdata_chip_type;
type cbc3_trig_and_stubdata_fe_type 		is array (1 to 2) of cbc3_trig_and_stubdata_hyb_type;
type cbc3_trig_and_stubdata_sys_type 		is array (1 to FE_NBR_MAX) of cbc3_trig_and_stubdata_fe_type;
--signal cbc3_trig_and_stubdata_sys		: cbc3_trig_and_stubdata_sys_type := (others=>(others=>(others=>(others=>(others=>'0')))));

constant stubdata_delay_value_size			: integer := 8;
type cbc3_stubdata_delay_value_hyb_type		is  array (1 to 8) of std_logic_vector(stubdata_delay_value_size-1 downto 0);
type cbc3_stubdata_delay_value_fe_type 		is array (1 to 2) of cbc3_stubdata_delay_value_hyb_type;
type cbc3_stubdata_delay_value_sys_type 	is array (1 to FE_NBR_MAX) of cbc3_stubdata_delay_value_fe_type;



type FE_DATA_SIZE_type is array(1 to FE_NBR_MAX) of integer;
constant FE_DATA_SIZE : FE_DATA_SIZE_type := 
(
	1  	=> (cfg_modules(1).TRIGDATA_SIZE + cfg_modules(1).STUBDATA_SIZE) * (cfg_modules(1).HYB1_CHIP_NBR + cfg_modules(1).HYB2_CHIP_NBR),
	2  	=> (cfg_modules(2).TRIGDATA_SIZE + cfg_modules(2).STUBDATA_SIZE) * (cfg_modules(2).HYB1_CHIP_NBR + cfg_modules(2).HYB2_CHIP_NBR),	
	3  	=> (cfg_modules(3).TRIGDATA_SIZE + cfg_modules(3).STUBDATA_SIZE) * (cfg_modules(3).HYB1_CHIP_NBR + cfg_modules(3).HYB2_CHIP_NBR),
	4  	=> (cfg_modules(4).TRIGDATA_SIZE + cfg_modules(4).STUBDATA_SIZE) * (cfg_modules(4).HYB1_CHIP_NBR + cfg_modules(4).HYB2_CHIP_NBR),
	5  	=> (cfg_modules(5).TRIGDATA_SIZE + cfg_modules(5).STUBDATA_SIZE) * (cfg_modules(5).HYB1_CHIP_NBR + cfg_modules(5).HYB2_CHIP_NBR),
	6  	=> (cfg_modules(6).TRIGDATA_SIZE + cfg_modules(6).STUBDATA_SIZE) * (cfg_modules(6).HYB1_CHIP_NBR + cfg_modules(6).HYB2_CHIP_NBR),
	7  	=> (cfg_modules(7).TRIGDATA_SIZE + cfg_modules(7).STUBDATA_SIZE) * (cfg_modules(7).HYB1_CHIP_NBR + cfg_modules(7).HYB2_CHIP_NBR),
	8  	=> (cfg_modules(8).TRIGDATA_SIZE + cfg_modules(8).STUBDATA_SIZE) * (cfg_modules(8).HYB1_CHIP_NBR + cfg_modules(8).HYB2_CHIP_NBR),
	9  	=> (cfg_modules(9).TRIGDATA_SIZE + cfg_modules(9).STUBDATA_SIZE) * (cfg_modules(9).HYB1_CHIP_NBR + cfg_modules(9).HYB2_CHIP_NBR),
	10  => (cfg_modules(10).TRIGDATA_SIZE + cfg_modules(10).STUBDATA_SIZE) * (cfg_modules(10).HYB1_CHIP_NBR + cfg_modules(10).HYB2_CHIP_NBR),
	11  => (cfg_modules(11).TRIGDATA_SIZE + cfg_modules(11).STUBDATA_SIZE) * (cfg_modules(11).HYB1_CHIP_NBR + cfg_modules(11).HYB2_CHIP_NBR),
	12  => (cfg_modules(12).TRIGDATA_SIZE + cfg_modules(12).STUBDATA_SIZE) * (cfg_modules(12).HYB1_CHIP_NBR + cfg_modules(12).HYB2_CHIP_NBR),
	13  => (cfg_modules(13).TRIGDATA_SIZE + cfg_modules(13).STUBDATA_SIZE) * (cfg_modules(13).HYB1_CHIP_NBR + cfg_modules(13).HYB2_CHIP_NBR),
	14  => (cfg_modules(14).TRIGDATA_SIZE + cfg_modules(14).STUBDATA_SIZE) * (cfg_modules(14).HYB1_CHIP_NBR + cfg_modules(14).HYB2_CHIP_NBR),
	15  => (cfg_modules(15).TRIGDATA_SIZE + cfg_modules(15).STUBDATA_SIZE) * (cfg_modules(15).HYB1_CHIP_NBR + cfg_modules(15).HYB2_CHIP_NBR),		
	16  => (cfg_modules(16).TRIGDATA_SIZE + cfg_modules(16).STUBDATA_SIZE) * (cfg_modules(16).HYB1_CHIP_NBR + cfg_modules(16).HYB2_CHIP_NBR)	
); 


type FE_SIZE_type is array(1 to FE_NBR_MAX) of integer; --EVT_SIZE
constant FE_SIZE : FE_SIZE_type := 
(
	1  	=> HDR2_SIZE + (cfg_modules(1).TRIGDATA_SIZE + cfg_modules(1).STUBDATA_SIZE) * (cfg_modules(1).HYB1_CHIP_NBR + cfg_modules(1).HYB2_CHIP_NBR),
	2  	=> HDR2_SIZE + (cfg_modules(2).TRIGDATA_SIZE + cfg_modules(2).STUBDATA_SIZE) * (cfg_modules(2).HYB1_CHIP_NBR + cfg_modules(2).HYB2_CHIP_NBR),	
	3  	=> HDR2_SIZE + (cfg_modules(3).TRIGDATA_SIZE + cfg_modules(3).STUBDATA_SIZE) * (cfg_modules(3).HYB1_CHIP_NBR + cfg_modules(3).HYB2_CHIP_NBR),
	4  	=> HDR2_SIZE + (cfg_modules(4).TRIGDATA_SIZE + cfg_modules(4).STUBDATA_SIZE) * (cfg_modules(4).HYB1_CHIP_NBR + cfg_modules(4).HYB2_CHIP_NBR),
	5  	=> HDR2_SIZE + (cfg_modules(5).TRIGDATA_SIZE + cfg_modules(5).STUBDATA_SIZE) * (cfg_modules(5).HYB1_CHIP_NBR + cfg_modules(5).HYB2_CHIP_NBR),
	6  	=> HDR2_SIZE + (cfg_modules(6).TRIGDATA_SIZE + cfg_modules(6).STUBDATA_SIZE) * (cfg_modules(6).HYB1_CHIP_NBR + cfg_modules(6).HYB2_CHIP_NBR),
	7  	=> HDR2_SIZE + (cfg_modules(7).TRIGDATA_SIZE + cfg_modules(7).STUBDATA_SIZE) * (cfg_modules(7).HYB1_CHIP_NBR + cfg_modules(7).HYB2_CHIP_NBR),
	8  	=> HDR2_SIZE + (cfg_modules(8).TRIGDATA_SIZE + cfg_modules(8).STUBDATA_SIZE) * (cfg_modules(8).HYB1_CHIP_NBR + cfg_modules(8).HYB2_CHIP_NBR),
	9  	=> HDR2_SIZE + (cfg_modules(9).TRIGDATA_SIZE + cfg_modules(9).STUBDATA_SIZE) * (cfg_modules(9).HYB1_CHIP_NBR + cfg_modules(9).HYB2_CHIP_NBR),
	10  => HDR2_SIZE + (cfg_modules(10).TRIGDATA_SIZE + cfg_modules(10).STUBDATA_SIZE) * (cfg_modules(10).HYB1_CHIP_NBR + cfg_modules(10).HYB2_CHIP_NBR),
	11  => HDR2_SIZE + (cfg_modules(11).TRIGDATA_SIZE + cfg_modules(11).STUBDATA_SIZE) * (cfg_modules(11).HYB1_CHIP_NBR + cfg_modules(11).HYB2_CHIP_NBR),
	12  => HDR2_SIZE + (cfg_modules(12).TRIGDATA_SIZE + cfg_modules(12).STUBDATA_SIZE) * (cfg_modules(12).HYB1_CHIP_NBR + cfg_modules(12).HYB2_CHIP_NBR),
	13  => HDR2_SIZE + (cfg_modules(13).TRIGDATA_SIZE + cfg_modules(13).STUBDATA_SIZE) * (cfg_modules(13).HYB1_CHIP_NBR + cfg_modules(13).HYB2_CHIP_NBR),
	14  => HDR2_SIZE + (cfg_modules(14).TRIGDATA_SIZE + cfg_modules(14).STUBDATA_SIZE) * (cfg_modules(14).HYB1_CHIP_NBR + cfg_modules(14).HYB2_CHIP_NBR),
	15  => HDR2_SIZE + (cfg_modules(15).TRIGDATA_SIZE + cfg_modules(15).STUBDATA_SIZE) * (cfg_modules(15).HYB1_CHIP_NBR + cfg_modules(15).HYB2_CHIP_NBR),		
	16  => HDR2_SIZE + (cfg_modules(16).TRIGDATA_SIZE + cfg_modules(16).STUBDATA_SIZE) * (cfg_modules(16).HYB1_CHIP_NBR + cfg_modules(16).HYB2_CHIP_NBR)	
); 	




type OFFSET_FE_type is array (1 to FE_NBR_MAX) of integer;
constant OFFSET_FE : OFFSET_FE_type :=
(
	1  	=> HDR1_SIZE,							
	2  	=> HDR1_SIZE + FE_SIZE(1),	
	3  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2),	
	4  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3),	
	5  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4),	
	6  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5),	
	7  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6),	
	8  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7),	
	9  	=> HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8),	
	10  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9),	
	11  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9) + FE_SIZE(10),	
	12  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9) + FE_SIZE(10) + FE_SIZE(11),	
	13  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9) + FE_SIZE(10) + FE_SIZE(11) + FE_SIZE(12),	
	14  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9) + FE_SIZE(10) + FE_SIZE(11) + FE_SIZE(12) + FE_SIZE(13),	
	15  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9) + FE_SIZE(10) + FE_SIZE(11) + FE_SIZE(12) + FE_SIZE(13) + FE_SIZE(14),	
	16  => HDR1_SIZE + FE_SIZE(1) + FE_SIZE(2) + FE_SIZE(3) + FE_SIZE(4) + FE_SIZE(5) + FE_SIZE(6) + FE_SIZE(7) + FE_SIZE(8) + FE_SIZE(9) + FE_SIZE(10) + FE_SIZE(11) + FE_SIZE(12) + FE_SIZE(13) + FE_SIZE(14) + FE_SIZE(15)
); 	



constant OFFSET_DATA_HYB1 : OFFSET_FE_type :=
(
	1  	=> OFFSET_FE(1)  + HDR2_SIZE,							
	2  	=> OFFSET_FE(2)  + HDR2_SIZE,	
	3  	=> OFFSET_FE(3)  + HDR2_SIZE,	
	4  	=> OFFSET_FE(4)  + HDR2_SIZE,		
	5  	=> OFFSET_FE(5)  + HDR2_SIZE,	
	6  	=> OFFSET_FE(6)  + HDR2_SIZE, 	
	7  	=> OFFSET_FE(7)  + HDR2_SIZE,	
	8  	=> OFFSET_FE(8)  + HDR2_SIZE,	
	9  	=> OFFSET_FE(9)  + HDR2_SIZE,	
	10  => OFFSET_FE(10) + HDR2_SIZE,	
	11  => OFFSET_FE(11) + HDR2_SIZE,	
	12  => OFFSET_FE(12) + HDR2_SIZE,
	13  => OFFSET_FE(13) + HDR2_SIZE,	
	14  => OFFSET_FE(14) + HDR2_SIZE,
	15  => OFFSET_FE(15) + HDR2_SIZE,
	16  => OFFSET_FE(16) + HDR2_SIZE							
); 

constant OFFSET_DATA_HYB2 : OFFSET_FE_type :=
(
	1  	=> OFFSET_DATA_HYB1(1)  + (cfg_modules(1).TRIGDATA_SIZE  + cfg_modules(1).STUBDATA_SIZE) * cfg_modules(1).HYB1_CHIP_NBR,							
	2  	=> OFFSET_DATA_HYB1(2)  + (cfg_modules(2).TRIGDATA_SIZE  + cfg_modules(2).STUBDATA_SIZE) * cfg_modules(2).HYB1_CHIP_NBR,	
	3  	=> OFFSET_DATA_HYB1(3)  + (cfg_modules(3).TRIGDATA_SIZE  + cfg_modules(3).STUBDATA_SIZE) * cfg_modules(3).HYB1_CHIP_NBR,	
	4  	=> OFFSET_DATA_HYB1(4)  + (cfg_modules(4).TRIGDATA_SIZE  + cfg_modules(4).STUBDATA_SIZE) * cfg_modules(4).HYB1_CHIP_NBR,		
	5  	=> OFFSET_DATA_HYB1(5)  + (cfg_modules(5).TRIGDATA_SIZE  + cfg_modules(5).STUBDATA_SIZE) * cfg_modules(5).HYB1_CHIP_NBR,	
	6  	=> OFFSET_DATA_HYB1(6)  + (cfg_modules(6).TRIGDATA_SIZE  + cfg_modules(6).STUBDATA_SIZE) * cfg_modules(6).HYB1_CHIP_NBR, 	
	7  	=> OFFSET_DATA_HYB1(7)  + (cfg_modules(7).TRIGDATA_SIZE  + cfg_modules(7).STUBDATA_SIZE) * cfg_modules(7).HYB1_CHIP_NBR,	
	8  	=> OFFSET_DATA_HYB1(8)  + (cfg_modules(8).TRIGDATA_SIZE  + cfg_modules(8).STUBDATA_SIZE) * cfg_modules(8).HYB1_CHIP_NBR,	
	9  	=> OFFSET_DATA_HYB1(9)  + (cfg_modules(9).TRIGDATA_SIZE  + cfg_modules(9).STUBDATA_SIZE) * cfg_modules(9).HYB1_CHIP_NBR,	
	10  => OFFSET_DATA_HYB1(10) + (cfg_modules(10).TRIGDATA_SIZE + cfg_modules(10).STUBDATA_SIZE) * cfg_modules(10).HYB1_CHIP_NBR,	
	11  => OFFSET_DATA_HYB1(11) + (cfg_modules(11).TRIGDATA_SIZE + cfg_modules(11).STUBDATA_SIZE) * cfg_modules(11).HYB1_CHIP_NBR,	
	12  => OFFSET_DATA_HYB1(12) + (cfg_modules(12).TRIGDATA_SIZE + cfg_modules(12).STUBDATA_SIZE) * cfg_modules(12).HYB1_CHIP_NBR,
	13  => OFFSET_DATA_HYB1(13) + (cfg_modules(13).TRIGDATA_SIZE + cfg_modules(13).STUBDATA_SIZE) * cfg_modules(13).HYB1_CHIP_NBR,	
	14  => OFFSET_DATA_HYB1(14) + (cfg_modules(14).TRIGDATA_SIZE + cfg_modules(14).STUBDATA_SIZE) * cfg_modules(14).HYB1_CHIP_NBR,
	15  => OFFSET_DATA_HYB1(15) + (cfg_modules(15).TRIGDATA_SIZE + cfg_modules(15).STUBDATA_SIZE) * cfg_modules(15).HYB1_CHIP_NBR,
	16  => OFFSET_DATA_HYB1(16) + (cfg_modules(16).TRIGDATA_SIZE + cfg_modules(16).STUBDATA_SIZE) * cfg_modules(16).HYB1_CHIP_NBR								
); 




-- constant HDR1_BLOCK_SIZE		: integer := 	HDR1_SIZE + (HDR1_FE_NBR * HDR2_SIZE) + 
--															(cfg_modules(1).TRIGDATA_SIZE + cfg_modules(1).STUBDATA_SIZE) * (cfg_modules(1).HYB1_CHIP_NBR + cfg_modules(1).HYB2_CHIP_NBR) +
--															(cfg_modules(2).TRIGDATA_SIZE + cfg_modules(2).STUBDATA_SIZE) * (cfg_modules(2).HYB1_CHIP_NBR + cfg_modules(2).HYB2_CHIP_NBR);
															
constant HDR1_BLOCK_SIZE		: integer := 	HDR1_SIZE + (FE_NBR * HDR2_SIZE) +
												FE_DATA_SIZE(1) + FE_DATA_SIZE(2) + FE_DATA_SIZE(3) + FE_DATA_SIZE(4) + FE_DATA_SIZE(5) + FE_DATA_SIZE(6) + FE_DATA_SIZE(7) + FE_DATA_SIZE(8) + 
												FE_DATA_SIZE(9) + FE_DATA_SIZE(10) + FE_DATA_SIZE(11) + FE_DATA_SIZE(12) + FE_DATA_SIZE(13) + FE_DATA_SIZE(14) + FE_DATA_SIZE(15) + FE_DATA_SIZE(16);


type data_payload_type is array (1 to HDR1_BLOCK_SIZE) of std_logic_vector(31 downto 0);

constant sram0 : integer := 0;
constant sram1 : integer := 1;

end user_pkg_be_proc;


package body user_pkg_be_proc is




end user_pkg_be_proc;