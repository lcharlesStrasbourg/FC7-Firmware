library ieee;
use ieee.std_logic_1164.all;
 
package user_package is
	
	--===================================--
	-- Important types
        -- implementation enum type
        type implementation_type is (OPTICAL, ELECTRICAL, EMULATION_CBC3);
        -- fmc connection enum type (enumarates, which hardware can be connected to the FMC)
        type fmc_hardware_type is (FMC_NONE, FMC_DIO5, FMC_2CBC2, FMC_8CBC2, FMC_2CBC3, FMC_8CBC3, FMC_OPTO_QUAD);
	--===================================--

    --===================================--
    -- FMC Config
    --===================================--
    -- which implementation? electrical or optical? that is the question!
    constant IMPLEMENTATION         : implementation_type := ELECTRICAL;
    -- specifies, what's connected to the FMC1 (l12)
    constant FMC1                   : fmc_hardware_type := FMC_8CBC2;
    -- specifies, what's connected to the FMC2 (l8)
    constant FMC2                   : fmc_hardware_type := FMC_DIO5;
    --===================================--
    
    --===================================--
    -- Important configs (have to correspond the FMC's configs)
    --===================================--
    -- 2 for CBC2, 3 for CBC3 (be careful!!!)
    constant CBC_VERSION            : integer := 2;     

    constant NUM_HYBRIDS            : integer := 1;
    constant NUM_CHIPS              : integer := 8;    
    --===================================--
    
    
    
    constant sys_phase_mon_freq      : string   := "160MHz"; -- valid options only "160MHz" or "240MHz"    

   --=== ipb slaves =============--
    constant nbr_usr_slaves                : positive := 3 ;

    constant user_ipb_stat_regs        : integer  := 0 ;
    constant user_ipb_ctrl_regs        : integer  := 1 ;
    
    -- this function helps to create a proper ammount of buffers and lines
    function number_of_lines_from_cbc(cbc_version_i: in integer) return integer;  
    
    -- address map type for different fmcs
    type i2c_address_map_type is array (natural range <>) of std_logic_vector(6 downto 0);
    type i2c_address_map_type_array is array (natural range <>) of i2c_address_map_type(0 to NUM_CHIPS-1);    

    --=== slow control records ===--
	-- The signals going from master to slaves
  	type cmd_wbus is
    record
       cmd_strobe            : std_logic;
       -- hybrid_id
       cmd_hybrid_id 	    : std_logic_vector(3 downto 0);
       -- cbc on hybrid id
       cmd_chip_id           : std_logic_vector(3 downto 0);
       -- page in CBC
       cmd_page              : std_logic;
       -- read or write setting
       cmd_read              : std_logic;
       -- register_address
       cmd_register          : std_logic_vector(7 downto 0);
       -- data to cbc
       cmd_data              : std_logic_vector(7 downto 0); 
       -- register write mask ( to avoid overriding of the current settings )
       cmd_write_mask        : std_logic_vector(7 downto 0);
    end record;
  	type cmd_wbus_array is array(natural range <>) of cmd_wbus;
	 
    -- The signals going from slaves to master	 
    type cmd_rbus is
    record
       cmd_strobe            : std_logic;
       cmd_data              : std_logic_vector(7 downto 0);
       cmd_err 	            : std_logic;
    end record;
  	type cmd_rbus_array is array(natural range <>) of cmd_rbus;
  	
  	--==========================-- 
    --=== cbc2 control lines ===--
    --==========================--
    type control_to_cbc2_dp_type is
    record
        clk40_p_o      : std_logic;
        clk40_n_o      : std_logic;
                    
        i2c_refresh_p       : std_logic;
        i2c_refresh_n       : std_logic;
        
        test_pulse_p        : std_logic;
        test_pulse_n        : std_logic;
        
        fast_reset_p        : std_logic;
        fast_reset_n        : std_logic;
        
        l1_trigger_p        : std_logic;
        l1_trigger_n        : std_logic; 
    end record;

    --============================-- 
    --=== triggered data lines ===--
    --============================--
    --== triggered data to hybrid block ==--
    subtype trig_data_to_hb_t is std_logic_vector(275 downto 0);
    type trig_data_to_hb_t_array is array(natural range <>) of trig_data_to_hb_t;
    
    --== triggered data from front-end ==--
    subtype trig_data_from_fe_t is std_logic_vector(0 to NUM_CHIPS-1);
    type trig_data_from_fe_t_array is array(natural range <>) of trig_data_from_fe_t;
    
    --== triggered data frame record ==--
    type triggered_data_frame_r is
    record
        start           : std_logic_vector(1 downto 0);
        latency_error   : std_logic;
        buffer_overflow : std_logic;
        pipe_address    : std_logic_vector(8 downto 0);
        l1_counter      : std_logic_vector(8 downto 0);
        channels        : std_logic_vector(253 downto 0);
    end record;
    
    --== triggered data frame record array (multiple hybrids) ==--
    --type triggered_data_frame_r_array is array (0 to NUM_CHIPS-1) of triggered_data_frame_r;
    type triggered_data_frame_r_array is array (natural range <>) of triggered_data_frame_r;

    --============================-- 
    --===== stub data lines  =====--
    --============================--   
    --== differential pairs to buffer ==--
    type cbc_dp_to_buf_single is
    record
        p   : std_logic;
        n   : std_logic;
    end record;
    type cbc_dp_to_buf is array(number_of_lines_from_cbc(CBC_VERSION)-1 downto 0) of cbc_dp_to_buf_single;
    type cbc_dp_to_buf_array is array(0 to NUM_CHIPS-1) of cbc_dp_to_buf;
    type cbc_dp_to_buf_array_array is array(natural range <>) of cbc_dp_to_buf_array;
    
    subtype cbc_lines_from_buf is std_logic_vector(number_of_lines_from_cbc(CBC_VERSION)-1 downto 0);
    type cbc_lines_from_buf_array is array(0 to NUM_CHIPS-1) of cbc_lines_from_buf;
    type cbc_lines_from_buf_array_array is array(natural range <>) of cbc_lines_from_buf_array;
    
    --== stub data from front-end ==--
    type stub_lines_r is
    record
        dp1 : std_logic;
        dp2 : std_logic;
        dp3 : std_logic;
        dp4 : std_logic;
        dp5 : std_logic;
    end record; 
    --== stub data from front-end array (for mutliple chips) ==--
    type stub_lines_r_array is array(0 to NUM_CHIPS-1) of stub_lines_r;
    subtype stub_lines_r_cbc2_array is std_logic_vector(0 to NUM_CHIPS-1);
    --== stub data from front-end array (for mutliple hybrids) ==--
    type stub_lines_r_array_array is array(natural range <>) of stub_lines_r_array;
    type stub_lines_r_cbc2_array_array is array(natural range <>) of stub_lines_r_cbc2_array;
    --== stub data record to hybrid block ==--
    type one_cbc_stubs_r is
    record
        sync_bit : std_logic;
        error_flags : std_logic;
        or254 : std_logic;
        s_overflow : std_logic;
        stub1 : std_logic_vector(7 downto 0);
        bend1 : std_logic_vector(3 downto 0);
        stub2 : std_logic_vector(7 downto 0);
        bend2 : std_logic_vector(3 downto 0);
        stub3 : std_logic_vector(7 downto 0);
        bend3 : std_logic_vector(3 downto 0);                
    end record;      
    --== stub data to hybrid block array for multiple chips==--
    type one_cbc_stubs_r_array is array(0 to NUM_CHIPS-1) of one_cbc_stubs_r;
    --== stub data to hybrid block array for multiple hybrids==--
    type stub_data_to_hb_t_array is array(natural range <>) of one_cbc_stubs_r_array;
    
    --============================--
    --======= Fast command =======--
    --============================--
	-- Fast Command Bus, operates at 40MHz
  	type cmd_fastbus is
    record
      -- fast reset bit
      fast_reset            : std_logic;
      -- trigger bit
      trigger               : std_logic;
      -- trigger pulse bit
      test_pulse_trigger    : std_logic;
      -- orbit reset bit
      orbit_reset           : std_logic;
      -- i2c refresh (for cbc2)
      i2c_refresh           : std_logic;
    end record;

   
    constant ipb_daq_system_cnfg_sel: integer  := 0;
    constant ipb_daq_system_ctrl_sel: integer  := 1;
    constant ipb_daq_system_stat_sel: integer  := 2;
	
	constant MAX_NTRIGGERS_TO_ACCEPT    : integer := 1_000_000;
    constant CLK_FREQUENCY_HZ           : integer := 40_000_000;
    -- maximal trigger frequency in khz
	constant MAX_USER_TRIGGER_FREQUENCY    : integer := 1000;
	-- when checking trigger, maximal amount of time without trigger, seconds
	constant MAX_TIME_WITHOUT_TRIGGER      : integer := 1;
	

	type array_8x8bit  is array  (0 to  7) of std_logic_vector(7 downto 0);
	type sel_size_type  is array (0 to 15) of integer range 0 to 256;
   
    -- Config Bus From Command Processor to Fast Command Block
    type cnfg_fastblock_type is
    record
      -- source of the trigger signal
      trigger_source        : std_logic_vector(3 downto 0);
      -- number of triggers to accept
      triggers_to_accept    : integer range 0 to MAX_NTRIGGERS_TO_ACCEPT;
      -- trigger frequency divider, minimal frequency is 0.1Hz
      user_trigger_frequency: integer range 1 to MAX_USER_TRIGGER_FREQUENCY;
      -- stubs mask to get coincidence
      stubs_mask            : std_logic_vector(31 downto 0);
      -- for test pulse: delay after fast reset
      delay_after_fast_reset : natural;
      -- for test pulse: delay after test pulse
      delay_after_test_pulse : natural;
    end record;    
    -- Control Bus From Command Processor to Fast Command Block
    type ctrl_fastblock_type is
    record
      cmd_strobe            : std_logic;
      -- reset bit
      reset                 : std_logic;
      -- load config
      load_config           : std_logic;
      -- start/stop
      start_trigger         : std_logic;
      stop_trigger          : std_logic;
      -- fast signals
      ipb_fast_reset        : std_logic;
      ipb_test_pulse        : std_logic;
      ipb_trigger           : std_logic;
      ipb_orbit_reset       : std_logic;
      ipb_i2c_refresh       : std_logic;
    end record;
    
    type stat_fastblock_type is
    record
        trigger_source        : std_logic_vector(3 downto 0);
        trigger_state         : std_logic;
        if_configured         : std_logic;
        -- fast command block error
        error_code            : std_logic_vector(7 downto 0);
    end record;
    
    type cnfg_command_block_type is
    record
      -- mask for i2c data writing
      i2c_mask              : std_logic_vector(7 downto 0);
    end record;
    
    -- bus which goes from ipbus to command processor block
    type ctrl_command_block_from_ipbus_type is
    record
        -- i2c resets from ipbus
        i2c_reset             : std_logic;
        i2c_reset_fifos       : std_logic;
        -- command fifo writing from ipbus
        command_fifo_we       : std_logic;
        command_fifo_data     : std_logic_vector(31 downto 0);
        -- read next reply fifo data from command processor block
        reply_fifo_read_next  : std_logic;
    end record;
    
    -- bus which goes back from command processor block to ipbus (needed for fifo's)
    type ctrl_command_block_to_ipbus_type is
    record
        -- reply fifo data from command processor block
        reply_fifo_data       : std_logic_vector(31 downto 0);
    end record;
    
    type fifo_stat is
    record
        i2c_commands_empty   : std_logic;
        i2c_commands_full    : std_logic; 
        i2c_replies_empty    : std_logic;       
        i2c_replies_full     : std_logic;
        i2c_nreplies_present : std_logic_vector(15 downto 0);  
    end record;
    
    type stat_command_block_type is
    record
        status_i2c_master_fsm  : std_logic_vector(3 downto 0);
        error_i2c_master       : std_logic_vector(7 downto 0);
        fifo_statuses          : fifo_stat;
    end record;



    type stat_global_clk_gen_type is
    record
		-- from clk gen
		clk_40_locked			: std_logic;
		ref_clk_locked			: std_logic;
    end record;

    type stat_global_ttc_type is
    record
		-- from ttc dec	
		ttc_rdy					: std_logic;
		ttc_dec_single_err_cnt	: std_logic_vector(15 downto 0);
		ttc_dec_double_err_cnt	: std_logic_vector(15 downto 0);
    end record;

    type ctrl_global_clk_gen_type is
    record
		-- to clk gen
		clk_40_reset			: std_logic;
		clk_40_mux_sel			: std_logic;
		ref_clk_reset			: std_logic;		
    end record;

    type ctrl_global_ttc_type is
    record
		-- to ttc dec
		ttc_dec_reset			: std_logic;		
    end record;

    type ctrl_global_amc13_type is
    record
		-- to amc13 block
		amc13_link_reset		: std_logic;
		sw_TTS_state_valid		: std_logic;		
		sw_TTS_state			: std_logic_vector(3 downto 0);	
    end record;

    type ctrl_readout_to_ipbus_type is
    record
		-- from readout
		readout_fifo_dout		: std_logic_vector(31 downto 0);	
    end record;
 
    type ctrl_readout_from_ipbus_type is
    record
		-- to readout
		packet_nbr 				: std_logic_vector(15 downto 0);
		readout_done 			: std_logic;
		readout_reset			: std_logic;	
		int_trig_enable			: std_logic;	
		int_trig_rate 			: std_logic_vector(4 downto 0);				
		trigger_type 			: std_logic_vector(3 downto 0);	
		data_type 				: std_logic_vector(3 downto 0);
		common_stubdata_delay 	: std_logic_vector(7 downto 0);	
		--
		readout_fifo_read_next	: std_logic;					
    end record;
    
    type stat_readout_type is
    record
		-- to s/w
		readout_req 			: std_logic;
		fsm_status 				: std_logic_vector(7 downto 0);			
    end record;    

    type stat_be_proc_type is
    record
		-- to s/w
		evnt_cnt 				: std_logic_vector(23 downto 0);
		evnt_cnt_buf_empty 	    : std_logic;
		data_payload_buf_empty  : std_logic;	
		trigdata_buf_empty      : std_logic;										
    end record;   


 
       
end user_package;




   
package body user_package is

    function number_of_lines_from_cbc(cbc_version_i: in integer) return integer is
        variable nlines : integer;
    begin
    
        if cbc_version_i = 2 then
            nlines := 2;
        elsif cbc_version_i = 3 then
            nlines := 6;
        else
            nlines := 1;
        end if;
        
        return nlines;
    end number_of_lines_from_cbc;

end user_package;
