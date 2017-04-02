library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package user_pkg_cfg_modules is


constant FE_NBR_MAX : integer 			:= 16; ----16 modules max (module = FE) / add RAW, STUBS & TRIG or ONLY DATA
constant FE_NBR 						: integer := 1; --4

--RAW
constant CBC3_TRIGDATA_SIZE 				: integer := 9; --RAW mode
constant CBC3_STUBDATA_SIZE 				: integer := 2;
constant CBC3_TRIGDATA_AND_STUBDATA_SIZE 	: integer := CBC3_TRIGDATA_SIZE + CBC3_STUBDATA_SIZE; --11

--MPAx
constant MPA_TRIGDATA_SIZE 					: integer := 0;
constant MPA_STUBDATA_SIZE 					: integer := 0;	


type cfg_module_type is
record
	HYB_NBR     	: integer range 0 to 2;
	CHIP_ID			: string (1 to 4); --CBC3 or MPAx (+version???)
	HYB1_CHIP_NBR   : integer range 0 to 8;
	HYB2_CHIP_NBR   : integer range 0 to 8;
	HYB_POS         : integer range 0 to 1; --left or right
	TRIGDATA_SIZE   : integer;
	STUBDATA_SIZE   : integer;	
end record;	




type cfg_modules_type is array(1 to FE_NBR_MAX) of cfg_module_type;

constant cfg_modules : cfg_modules_type := 
(
	1  	=> ( HYB_NBR => 1, CHIP_ID => "CBC3", HYB1_CHIP_NBR => 2, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  CBC3_TRIGDATA_SIZE,  STUBDATA_SIZE => CBC3_STUBDATA_SIZE),
	2  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
--	1  	=> ( HYB_NBR => 2, CHIP_ID => "CBC3", HYB1_CHIP_NBR => 2, HYB2_CHIP_NBR => 2, HYB_POS  => 0, TRIGDATA_SIZE =>  CBC3_TRIGDATA_SIZE,  STUBDATA_SIZE => CBC3_STUBDATA_SIZE),
--	2  	=> ( HYB_NBR => 2, CHIP_ID => "CBC3", HYB1_CHIP_NBR => 8, HYB2_CHIP_NBR => 8, HYB_POS  => 0, TRIGDATA_SIZE =>  CBC3_TRIGDATA_SIZE,  STUBDATA_SIZE => CBC3_STUBDATA_SIZE),	
	3  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	4  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
--	3  	=> ( HYB_NBR => 2, CHIP_ID => "CBC3", HYB1_CHIP_NBR => 8, HYB2_CHIP_NBR => 8, HYB_POS  => 0, TRIGDATA_SIZE =>  CBC3_TRIGDATA_SIZE,  STUBDATA_SIZE => CBC3_STUBDATA_SIZE),
--	4  	=> ( HYB_NBR => 2, CHIP_ID => "CBC3", HYB1_CHIP_NBR => 8, HYB2_CHIP_NBR => 8, HYB_POS  => 0, TRIGDATA_SIZE =>  CBC3_TRIGDATA_SIZE,  STUBDATA_SIZE => CBC3_STUBDATA_SIZE),	
	5  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	6  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	7  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	8  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	9  	=> ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	10  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	11  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	12  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	13  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	14  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),
	15  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0),		
	16  => ( HYB_NBR => 0, CHIP_ID => "xxxx", HYB1_CHIP_NBR => 0, HYB2_CHIP_NBR => 0, HYB_POS  => 0, TRIGDATA_SIZE =>  0,   				STUBDATA_SIZE => 0)	
); 	




end user_pkg_cfg_modules;