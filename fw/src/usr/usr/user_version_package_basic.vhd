library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package user_version_package is

	constant usr_ver_major	:integer range 0 to 15 :=1;
	constant usr_ver_minor	:integer range 0 to 15 :=2;
	constant usr_ver_build	:integer range 0 to 255:=1;
	
	constant usr_ver_year 	:integer range 0 to 99 :=15;
	constant usr_ver_month	:integer range 0 to 12 :=08;
	constant usr_ver_day  	:integer range 0 to 31 :=31;
  
	constant usr_id_0		 	:std_logic_vector(31 downto 0):= x"67_6f_6c_64";	-- 'g' 'o' 'l' 'd'
	constant firmware_id	 	:std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(usr_ver_major,4)) &
																				std_logic_vector(to_unsigned(usr_ver_minor,4)) &
																				std_logic_vector(to_unsigned(usr_ver_build,8)) &
																				std_logic_vector(to_unsigned(usr_ver_year ,7)) &
																				std_logic_vector(to_unsigned(usr_ver_month,4)) &
																				std_logic_vector(to_unsigned(usr_ver_day  ,5)) ;


 
end user_version_package;
package body user_version_package is
end user_version_package;