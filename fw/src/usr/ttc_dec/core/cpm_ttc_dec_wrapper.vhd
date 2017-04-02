--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                                                                
-- Engineer:                Laurent Charles (laurent.charles@iphc.cnrs.fr)                                                                                            
-- Project Name:            FC7TestBoard / CMS Tracker Upgrade Phase II                                                                                                 
-- Description: 		    TTC core                                                               
-- History:        			Date         Version   	Author            Changes
--                          2017/03/29   1.0       	lcharles          Initial file 
--                                                                                                                                                   
--=================================================================================================--
--=================================================================================================--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.all;



--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity cpm_ttc_dec_wrapper is
port 
(
	
	reset_i						: in	std_logic;
	iodelay_clk_i				: in	std_logic;
		
	cpm_ttc_data_p				: in	std_logic;
	cpm_ttc_data_n				: in	std_logic;
	cpm_ttc_clk					: in	std_logic;

	iodelay_load       			: in	std_logic:= '0';									-- delay increment, decrement signal for bit 
	iodelay_inc       			: in	std_logic:= '0';									-- delay increment, decrement signal for bit 
	iodelay_ce	       			: in	std_logic:= '0';									-- delay increment, decrement signal for bit 
	iodelay_tap_ctrl         	: in	std_logic_vector(4 downto 0):= "00000";	-- dynamically loadable delay tap value for bit 
	iodelay_tap_stat        	: out	std_logic_vector(4 downto 0);					-- bit  delay tap value for monitoring

	--== ttc decoder output ==--
	single_bit_error    		: out std_logic;
	double_bit_error    		: out std_logic;
	communication_error 		: out std_logic;
	l1a							: out std_logic;
	brc_strobe					: out std_logic;
	add_strobe					: out std_logic;
	--TTDDDDDEB
	brc_t2						: out std_logic_vector(1 downto 0);  
	brc_d4						: out std_logic_vector(3 downto 0);
	brc_e						: out std_logic; 
	brc_b						: out std_logic; 
	--AAAAAAAAAAAAAAE1SSSSSSSSDDDDDDDD
	add_a14						: out std_logic_vector(13 downto 0);
	add_e						: out std_logic;
	add_s8						: out std_logic_vector(7 downto 0);
	add_d8						: out std_logic_vector(7 downto 0);
	
	--== auxiliary outputs ===--
	ready						: out std_logic;
	tp							: out std_logic;
	tpp							: out std_logic
);
	
end cpm_ttc_dec_wrapper;



architecture top of cpm_ttc_dec_wrapper is


	signal ttc_amc13_ab_ready		: std_logic;	
	signal ttc_amc13_a_channel	 	: std_logic;			
	signal ttc_amc13_b_channel	 	: std_logic;			
	signal ttc_amc13_clk			: std_logic;	
	signal ttc_amc13_clken			: std_logic;
	signal posfl_iodelay_ce        	: std_logic;
	signal posfl_iodelay_inc        : std_logic;
	signal posfl_iodelay_load       : std_logic;

	--== keep attributes ====--
	attribute keep					: boolean;
		
	attribute keep of brc_d4		: signal is true;
	attribute keep of brc_e			: signal is true;
	attribute keep of brc_b			: signal is true; 
	attribute keep of l1a			: signal is true;
	attribute keep of brc_strobe	: signal is true;

	attribute keep of ttc_amc13_ab_ready	: signal is true;
	attribute keep of ttc_amc13_a_channel	: signal is true;
	attribute keep of ttc_amc13_b_channel	: signal is true; 
	
begin


	--=======================================================================================--
	--#######################################################################################--
	--#######################################################################################--
	--### ttc decoding ######################################################################--
	--#######################################################################################--
	--#######################################################################################--
	--=======================================================================================--
	
    -------- -----------------------------------------------------------------------
          process(cpm_ttc_clk)  
          variable pipe: std_logic_vector(1 to 2);
          begin
            if ( rising_edge(cpm_ttc_clk) ) then  
              posfl_iodelay_load <= (pipe(1) xor pipe(2))  and  ( not pipe(2));
                  pipe:=iodelay_load & pipe(1);
            end if;       
          end process;
   -------- -----------------------------------------------------------------------
          process(cpm_ttc_clk)  
          variable pipe: std_logic_vector(1 to 2);
          begin
            if ( rising_edge(cpm_ttc_clk) ) then  
              posfl_iodelay_ce <= (pipe(1) xor pipe(2))  and  ( not pipe(2));
                  pipe:=iodelay_ce & pipe(1);
            end if;       
          end process;
     -------- -----------------------------------------------------------------------
          process(cpm_ttc_clk)  
          variable pipe: std_logic_vector(1 to 2);
          begin
            if ( rising_edge(cpm_ttc_clk) ) then  
              posfl_iodelay_inc <= (pipe(1) xor pipe(2))  and  ( not pipe(2));
                  pipe:=iodelay_inc & pipe(1);
            end if;       
          end process;
    

	--==========================--
	ab_ttc_amc13: entity work.ttc_amc13_channels_a_b
	--==========================--
	port map
	(
		reset_i						=> reset_i,
		--
		amc13_ttc_data_p			=> cpm_ttc_data_p,
		amc13_ttc_data_n			=> cpm_ttc_data_n,
		amc13_ttc_clk				=> cpm_ttc_clk,
		--
		iodelay_clk_i				=> iodelay_clk_i,
		iodelay_load       			=> iodelay_load,--posfl_iodelay_load,--iodelay_load,
		iodelay_ce	       			=> iodelay_ce,--posfl_iodelay_ce,--iodelay_ce,
		iodelay_inc       			=> iodelay_inc, --posfl_iodelay_inc,--iodelay_inc, 
		iodelay_tap_ctrl       		=> iodelay_tap_ctrl,  
		iodelay_tap_stat       		=> iodelay_tap_stat, 
		-- ttc channel separation --
		a_channel_o					=> ttc_amc13_a_channel,	
		b_channel_o					=> ttc_amc13_b_channel,	
		ab_ready_o					=> ttc_amc13_ab_ready,	
		clk_o						=> ttc_amc13_clk,			
		clken_o						=> ttc_amc13_clken
	);
	--==========================--



	--==========================--
	ttc_dec: entity work.ttc_decoder
	--==========================--
	port map
	(
		reset_i						=> not ttc_amc13_ab_ready,	
		--== ttc chA & B ==--
		chA							=> ttc_amc13_a_channel,	 				
		chB							=> ttc_amc13_b_channel,	 				
		clk							=> ttc_amc13_clk,					
		clken						=> ttc_amc13_clken,					

		-- ttc data out --
		single_bit_error    		=> single_bit_error,
		double_bit_error    		=> double_bit_error,
		communication_error 		=> communication_error,
		l1a							=> l1a,
		add_strobe 	   				=> add_strobe,
		add_a14						=> add_a14,
		add_e						=> add_e,
		add_s8						=> add_s8,
		add_d8						=> add_d8,
		brc_strobe       			=> brc_strobe,
		brc_t2						=> brc_t2,
		brc_d4						=> brc_d4,
		brc_e						=> brc_e,
		brc_b						=> brc_b
	);
	--==========================--

	ready <= ttc_amc13_ab_ready;
	
    tp  <= ttc_amc13_a_channel;
    tpp <= ttc_amc13_b_channel;

end top;


