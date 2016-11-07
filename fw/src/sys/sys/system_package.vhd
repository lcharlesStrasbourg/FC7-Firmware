library ieee;
use ieee.std_logic_1164.all;
 
package system_package is

	type array_2x32bit   is array (0 to  1)  of std_logic_vector(31 downto 0);
	type array_4x32bit   is array (0 to  3)  of std_logic_vector(31 downto 0);
	type array_16x32bit  is array (0 to 15)  of std_logic_vector(31 downto 0);
	type array_32x32bit  is array (0 to 31)  of std_logic_vector(31 downto 0);
	type array_64x32bit  is array (0 to 63)  of std_logic_vector(31 downto 0);
	type array_128x32bit is array (0 to 127) of std_logic_vector(31 downto 0);
	type array_256x32bit is array (0 to 255) of std_logic_vector(31 downto 0);

    type array_2x8bit  is array  (0 to  1) of std_logic_vector( 7 downto 0);	
    type array_4x8bit  is array  (0 to  3) of std_logic_vector( 7 downto 0);
    type array_6x8bit  is array  (0 to  5) of std_logic_vector( 7 downto 0);
	type array_16x8bit is array  (0 to 15) of std_logic_vector( 7 downto 0);
	type array_32x8bit is array  (0 to 31) of std_logic_vector( 7 downto 0);
	type array_64x8bit is array  (0 to 63) of std_logic_vector( 7 downto 0);

	--=== ipb sys slaves ==========--
	constant nbr_sys_slaves				: positive:= 3 ; --> sys_regs, icap, uc, user_wb
    constant sys_regs	               : integer := 0 ;	
	constant icap		               : integer := 1 ;   
	constant uc			               : integer := 2 ;
	
end system_package;
   
package body system_package is
end system_package;