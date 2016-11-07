library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity phase_mon is 
generic (freq: string:="160MHz");
port
(
	clk			 					: in 	std_logic;
	reset								: in	std_logic;
	ready								: in 	std_logic;
	--
	phase_mon_flag					: in 	std_logic;
	phase_mon_refclk 				: out std_logic;				
	--
	phase_mon_strobe				: in	std_logic;
	phase_mon_refclk_sel			: in	std_logic;
	phase_mon_lower				: in	std_logic_vector( 7 downto 0);
	phase_mon_upper				: in  std_logic_vector( 7 downto 0);		
	phase_mon_count				: out std_logic_vector(15 downto 0);		
	phase_mon_ok					: out std_logic;
	phase_mon_done					: out std_logic
);
end phase_mon;

architecture rtl of phase_mon is

signal phase_mon_clk240	:std_logic;
signal phase_mon_clk160	:std_logic;

signal phase_mon_clk		:std_logic;
signal phase_mon_locked	:std_logic;  
signal phase_mon_rst		:std_logic;

signal clk_oddr         : std_logic;

begin

--===================================--
phase_mon_pll: entity work.phase_mon_clk_manager
--===================================--
port map
 (
  CLK_IN_40   => clk,
  CLK_OUT_240 => phase_mon_clk240,
  CLK_OUT_160 => phase_mon_clk160,
  RESET       => '0',
  LOCKED      => phase_mon_locked
 );
--===================================--

clk160_g: if freq/="240MHz" generate phase_mon_clk <= phase_mon_clk160; end generate; -- default
clk240_g: if freq ="240MHz" generate phase_mon_clk <= phase_mon_clk240; end generate;

----===================================--
--mmcm_clksel: BUFGMUX
----===================================--   
--port map (
--      O 	=> phase_mon_mmcm_clk,   	-- 1-bit output: Clock output
--      I0 => phase_mon_mmcm_clk160, 	-- 1-bit input: Clock input (S=0)
--      I1 => phase_mon_mmcm_clk240, 	-- 1-bit input: Clock input (S=1)
--      S 	=> phase_mon_refclk_sel    -- 1-bit input: Clock select
--   );
----===================================--


phase_mon_rst <= reset or (not phase_mon_locked);


--===================================--
phase_mon: process(phase_mon_rst, phase_mon_clk)
--===================================--
		constant runtime 	: integer:= 65535; -- runtime
		variable run_timer: integer;
		constant delay 	: integer:= 4_000_000; -- after reset delay of 100ms (stable cdce operation after lock)
		variable del_timer: integer;
		variable flag		: std_logic;
		variable done		: std_logic;
		variable count 	: std_logic_vector(15 downto 0);
		variable strobe	: std_logic;
                
	begin

	if phase_mon_rst='1' then

		flag					:= '0';
		del_timer 			:= delay;
		run_timer 			:= runtime;
		done					:= '0';					phase_mon_done		<= '0';
		count					:=(others => '0');	phase_mon_count	<=(others => '0');
		phase_mon_ok		<= '0';
		
	elsif rising_edge(phase_mon_clk) then
		
		phase_mon_done  <= done;
		phase_mon_count <= count;
		
		-- essentially a syncronous reset that forces the process to re-run (by reloading the run_timer)
		if strobe = '1' then
			
			run_timer 			:= runtime;
			del_timer 			:= 0; -- no init delay needed when running manually
			--
			done					:= '0';					phase_mon_done		<= '0';
			count					:=(others => '0');	phase_mon_count	<=(others => '0');
			phase_mon_ok		<= '0';
		
		elsif ready = '1' then
			--
			if del_timer/=0 then -- after reset, there is an initial delay (but not after strobe)
				del_timer:= del_timer - 1;
			--
			else -- main process: runs when ready = 1 del_timer= 0 and stops counting when run_timer = 0
				--
				phase_mon_ok       <= '0';
				if done = '1' then         
					if ((count(15 downto 8) < phase_mon_upper) or (count(15 downto 8) = phase_mon_upper)) and            
						((count(15 downto 8) > phase_mon_lower) or (count(15 downto 8) = phase_mon_lower))             
					then
						phase_mon_ok      <= '1';
					end if;         
				end if;
				--
				if run_timer/=0 then
					done     := '0';
					if flag = '1' then
						count	:= count+1;
					end if;
					run_timer:= run_timer-1;
				else
					done     := '1';
				end if;
			end if;
		--
		else -- ready = 0
			run_timer 			:= runtime;
			done					:= '0';				
			count					:=(others => '0');
			phase_mon_ok		<= '0';
		end if;		
		--
		strobe:= phase_mon_strobe; 
		flag := phase_mon_flag; 
		--
	end if;
	end process;
--===================================--


phase_mon_refclk <= phase_mon_clk;

end rtl;