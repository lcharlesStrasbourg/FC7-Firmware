----------------------------------------------------------------------------------
-- Engineer: Mykyta Haranko
-- Create Date: 12/21/2016 05:57:14 PM
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.user_package.all;
use work.system_package.all;
use work.ipbus.all;
use work.register_map_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ipbus_decoder_stat is
port (
        clk                   : in  std_logic;
        reset                 : in  std_logic;
        ipb_mosi_i            : in  ipb_wbus;
        ipb_miso_o            : out ipb_rbus;
        -- stat global block
        stat_global_clk_gen_i : in stat_global_clk_gen_type;
        stat_global_ttc_i 	  : in stat_global_ttc_type; 
        -- stat readout block
        stat_readout_i		  : in stat_readout_type; 
        -- stat be_proc block
        stat_be_proc_i		  : in stat_be_proc_type;      
        -- fast command block statuses
        stat_fast_block_i     : in stat_fastblock_type;
        -- stat command block
        stat_command_block_i  : in stat_command_block_type;
        test_clock_frequency  : in array_4x32bit;
        -- temporary line while HYBRID block is not existing
        trig_data_i         : in triggered_data_frame_r_array(0 to NUM_HYBRIDS-1)
     );
end ipbus_decoder_stat;

architecture rtl of ipbus_decoder_stat is

    constant reg_type   : register_type := stat;
    signal regs: stat_regs_type;
    signal sel: integer range 0 to 2**ADDR_WIDTH-1;
    signal ipb_ack_int: std_logic;
    signal block_id            : integer range 0 to 2**BLOCK_ID_WIDTH-1;
    signal register_address    : integer range 0 to 2**ADDR_WIDTH-1;
    
    attribute keep: boolean;
    attribute keep of sel: signal is true;
    
    -- signals are redirected here in case of overflow
    constant OVERFLOW_SEL                                : integer := convert_address(x"0_000",reg_type);
    
    --====================================--
    -- Commond Error from All Blocks  
    --====================================--
    constant GENERAL_STATUS_ERROR_SEL                    : integer := convert_address(x"0_001",reg_type);
    --====================================--
    constant GENERAL_STATUS_ERROR_BLOCKID_OFFSET         : integer := 0;
    constant GENERAL_STATUS_ERROR_BLOCKID_WIDTH          : integer := 4;
    constant GENERAL_STATUS_ERROR_CODE_OFFSET            : integer := 4;
    constant GENERAL_STATUS_ERROR_CODE_WIDTH             : integer := 8;
    --====================================--
    
    --====================================--
    -- Firmware Info
    --====================================--
    constant FIRMWARE_INFO_SEL                           : integer := convert_address(x"0_002",reg_type);
    --====================================--
    constant FIRMWARE_INFO_IMPLEMENTATION_OFFSET         : integer := 0;
    constant FIRMWARE_INFO_IMPLEMENTATION_WIDTH          : integer := 4;
    constant FIRMWARE_INFO_CBC_VERSION_OFFSET            : integer := 4;
    constant FIRMWARE_INFO_CBC_VERSION_WIDTH             : integer := 4;
    constant FIRMWARE_INFO_NUM_HYBRIDS_OFFSET            : integer := 8;
    constant FIRMWARE_INFO_NUM_HYBRIDS_WIDTH             : integer := 8;
    constant FIRMWARE_INFO_NUM_CHIPS_OFFSET              : integer := 16;
    constant FIRMWARE_INFO_NUM_CHIPS_WIDTH               : integer := 8;
    --====================================--
    
    --====================================--
    -- GLOBAL BLOCK
    --====================================--
    constant GLOBAL_CLK_GEN_SEL                         : integer := convert_address(x"0_003",reg_type);    
    constant GLOBAL_CLK_GEN_CLK40_LOCKED_BIT            : integer := 0;
    constant GLOBAL_CLK_GEN_REFCLK_LOCKED_BIT			: integer := 1;
    --====================================-- 
    constant GLOBAL_TTC_SEL1                          	: integer := convert_address(x"0_004",reg_type); 
    constant GLOBAL_TTC_RDY_BIT             			: integer := 0;
    constant GLOBAL_TTC_SEL2                          	: integer := convert_address(x"0_005",reg_type);
    constant GLOBAL_TTC_SINGLE_ERR_CNT_OFFSET     		: integer := 0;
    constant GLOBAL_TTC_SINGLE_ERR_CNT_WIDTH      		: integer := 16;
    constant GLOBAL_TTC_DOUBLE_ERR_CNT_OFFSET     		: integer := 16;
    constant GLOBAL_TTC_DOUBLE_ERR_CNT_WIDTH      		: integer := 16;

 
 
       
    --====================================--
    -- Command Processor Block Registers  
    --====================================--
    constant COMMAND_BLOCK_SEL                                 : integer := convert_address(x"1_000",reg_type);
    --====================================--
    constant COMMAND_BLOCK_I2C_MASTER_SEL                      : integer := convert_address(x"1_001",reg_type);
    constant COMMAND_BLOCK_I2C_MASTER_FSM_STATUS_OFFSET        : integer := 0;
    constant COMMAND_BLOCK_I2C_MASTER_FSM_STATUS_WIDTH         : integer := 4;
    constant COMMAND_BLOCK_I2C_COMMANDS_FIFO_STAT_SEL          : integer := convert_address(x"1_002",reg_type);
    constant COMMAND_BLOCK_I2C_COMMANDS_FIFO_EMPTY_BIT         : integer := 0;
    constant COMMAND_BLOCK_I2C_COMMANDS_FIFO_FULL_BIT          : integer := 1;
    constant COMMAND_BLOCK_I2C_REPLIES_FIFO_STAT_SEL           : integer := convert_address(x"1_003",reg_type);
    constant COMMAND_BLOCK_I2C_REPLIES_FIFO_EMPTY_BIT          : integer := 0;
    constant COMMAND_BLOCK_I2C_REPLIES_FIFO_FULL_BIT           : integer := 1;
    constant COMMAND_BLOCK_I2C_NREPLIES_SEL                    : integer := convert_address(x"1_004",reg_type);
    --====================================--
 
    --====================================--
    -- Fast Command Block Registers  
    --====================================--
    constant FAST_BLOCK_SEL                                 : integer := convert_address(x"2_000",reg_type);
    --====================================--
    constant FAST_BLOCK_FSG_STATUS_SEL                      : integer := convert_address(x"2_000",reg_type);    
    constant FAST_BLOCK_FSG_STATUS_SOURCE_OFFSET            : integer := 0;
    constant FAST_BLOCK_FSG_STATUS_SOURCE_WIDTH             : integer := 4;
    constant FAST_BLOCK_FSG_STATUS_STATE_BIT                : integer := 4;
    constant FAST_BLOCK_FSG_STATUS_CONFIGURED_BIT           : integer := 5;
    --====================================--
    
    --====================================--
    -- Physical Interface Block Registers  
    --====================================--
    constant PHY_BLOCK_SEL                                 : integer := convert_address(x"3_000",reg_type);
    --====================================--
    -- define addresses here
    --====================================--
    
    --====================================--
    -- Hybrid Block Registers  
    --====================================--
    constant HYB_BLOCK_SEL                                 : integer := convert_address(x"4_000",reg_type);
	--    
    constant BE_PROC_SEL             				   	   : integer := convert_address(x"4_000",reg_type);   
    constant EVNT_CNT_OFFSET            				   : integer := 0;
    constant EVNT_CNT_WIDTH             				   : integer := 24;    
    constant EVNT_CNT_BUF_EMPTY_BIT            			   : integer := 24;
    constant DATA_PAYLOAD_BUF_EMPTY            			   : integer := 25;
    constant TRIGDATA_BUF_EMPTY_BIT            			   : integer := 26;    
            
    --====================================--
    -- define addresses here
    --====================================--
    
    --====================================--
    -- Data Block Registers  --for readout
    --====================================--
    constant BE_DATA_BLOCK_SEL                             	: integer := convert_address(x"5_000",reg_type);
	--
    constant READOUT_BLOCK_SEL                             	: integer := convert_address(x"5_000",reg_type);
    constant READOUT_REQ_BIT             				   	: integer := 0;
    constant READOUT_FSM_STATUS_OFFSET     				   	: integer := 4;
    constant READOUT_FSM_STATUS_WIDTH						: integer := 8;     
  
    --====================================--
    -- define addresses here
    --====================================--
    
    --====================================--
    -- DIO5 Block Registers  
    --====================================--
    constant DIO5_BLOCK_SEL                                 : integer := convert_address(x"6_000",reg_type);
    --====================================--
    -- define addresses here
    --====================================--   
    
    --====================================--
    -- Temporary data output for 1 HYBRID 
    --====================================--
    constant TEMP_DATA_SEL                                 : integer := convert_address(x"e_000",reg_type);
    
    constant TEMP_DATA_HYBRID1_GEN_SEL                     : integer := convert_address(x"e_000",reg_type);
    constant TEMP_DATA_HYBRID1_GEN_LAT_ERR_BIT             : integer := 31;
    constant TEMP_DATA_HYBRID1_GEN_OVERFLOW_BIT            : integer := 30;
    constant TEMP_DATA_HYBRID1_GEN_PIPE_OFFSET             : integer := 0;
    constant TEMP_DATA_HYBRID1_GEN_PIPE_WIDTH              : integer := 9;
    constant TEMP_DATA_HYBRID1_GEN_LATENCY_OFFSET          : integer := 9;
    constant TEMP_DATA_HYBRID1_GEN_LATENCY_WIDTH           : integer := 9;
    constant TEMP_DATA_HYBRID1_GEN_TRIGGER_COUNTER_OFFSET  : integer := 18;
    constant TEMP_DATA_HYBRID1_GEN_TRIGGER_COUNTER_WIDTH   : integer := 9;
    constant TEMP_DATA_HYBRID1_CHANNELS1_SEL               : integer := convert_address(x"e_001",reg_type);
    constant TEMP_DATA_HYBRID1_CHANNELS2_SEL               : integer := convert_address(x"e_002",reg_type);  
    constant TEMP_DATA_HYBRID1_CHANNELS3_SEL               : integer := convert_address(x"e_003",reg_type);  
    constant TEMP_DATA_HYBRID1_CHANNELS4_SEL               : integer := convert_address(x"e_004",reg_type);  
    constant TEMP_DATA_HYBRID1_CHANNELS5_SEL               : integer := convert_address(x"e_005",reg_type);  
    constant TEMP_DATA_HYBRID1_CHANNELS6_SEL               : integer := convert_address(x"e_006",reg_type);  
    constant TEMP_DATA_HYBRID1_CHANNELS7_SEL               : integer := convert_address(x"e_007",reg_type);  
    constant TEMP_DATA_HYBRID1_CHANNELS8_SEL               : integer := convert_address(x"e_008",reg_type);  
    
    --====================================--
    -- Output of measured clock frequencies  
    --====================================--
    constant TEST_CLOCK_SEL                           : integer := convert_address(x"f_000",stat);
    --====================================--
    constant TEST_CLOCK_IPB_SEL                       : integer := convert_address(x"f_000",stat);
    constant TEST_CLOCK_40MHZ_SEL                     : integer := convert_address(x"f_001",stat);
    constant TEST_CLOCK_TRIGGER_SEL                   : integer := convert_address(x"f_002",stat);
    --====================================--
    
    -- errors out (from error handler)    
    signal status_error_block_id  : std_logic_vector(3 downto 0) := x"0";
    signal status_error_code      : std_logic_vector(7 downto 0) := x"00";   
         
begin

    block_id <= to_integer(unsigned(ipb_mosi_i.ipb_addr(ADDR_WIDTH-1 downto (ADDR_WIDTH-BLOCK_ID_WIDTH))));
    register_address <= to_integer(unsigned(ipb_mosi_i.ipb_addr(ADDR_WIDTH-BLOCK_ID_WIDTH-1 downto 0))); 
    --=============================--
    sel <= register_address + offset_stat(block_id) when register_address+1 <= fc7_register_map(block_id).register_width_stat else 0;
    --=============================--

	--=============================--
	process(reset, clk)
	--=============================--
	begin
	if reset='1' then
		ipb_ack_int 	 <= '0';
	elsif rising_edge(clk) then

      --=============================--
      -- read section
      --=============================--
      ipb_miso_o.ipb_rdata <= regs(sel);
      ipb_ack_int <= ipb_mosi_i.ipb_strobe and not ipb_ack_int;
      --=============================--
      
	end if;
	end process;
	
	ipb_miso_o.ipb_ack <= ipb_ack_int;
	ipb_miso_o.ipb_err <= '0';
		
    -- general status
	regs(GENERAL_STATUS_ERROR_SEL)((GENERAL_STATUS_ERROR_BLOCKID_OFFSET + GENERAL_STATUS_ERROR_BLOCKID_WIDTH-1) downto GENERAL_STATUS_ERROR_BLOCKID_OFFSET) <= status_error_block_id;
	regs(GENERAL_STATUS_ERROR_SEL)((GENERAL_STATUS_ERROR_CODE_OFFSET + GENERAL_STATUS_ERROR_CODE_WIDTH-1) downto GENERAL_STATUS_ERROR_CODE_OFFSET) <= status_error_code;
	
	-- firmware info
	regs(FIRMWARE_INFO_SEL)((FIRMWARE_INFO_IMPLEMENTATION_WIDTH+FIRMWARE_INFO_IMPLEMENTATION_OFFSET-1) downto FIRMWARE_INFO_IMPLEMENTATION_OFFSET) <= std_logic_vector(to_unsigned(implementation_type'pos(IMPLEMENTATION),FIRMWARE_INFO_IMPLEMENTATION_WIDTH));
    regs(FIRMWARE_INFO_SEL)((FIRMWARE_INFO_CBC_VERSION_WIDTH+FIRMWARE_INFO_CBC_VERSION_OFFSET-1) downto FIRMWARE_INFO_CBC_VERSION_OFFSET) <= std_logic_vector(to_unsigned(CBC_VERSION,FIRMWARE_INFO_CBC_VERSION_WIDTH));
	regs(FIRMWARE_INFO_SEL)((FIRMWARE_INFO_NUM_HYBRIDS_WIDTH+FIRMWARE_INFO_NUM_HYBRIDS_OFFSET-1) downto FIRMWARE_INFO_NUM_HYBRIDS_OFFSET) <= std_logic_vector(to_unsigned(NUM_HYBRIDS,FIRMWARE_INFO_NUM_HYBRIDS_WIDTH));
	regs(FIRMWARE_INFO_SEL)((FIRMWARE_INFO_NUM_CHIPS_WIDTH+FIRMWARE_INFO_NUM_CHIPS_OFFSET-1) downto FIRMWARE_INFO_NUM_CHIPS_OFFSET) <= std_logic_vector(to_unsigned(NUM_CHIPS,FIRMWARE_INFO_NUM_CHIPS_WIDTH));

    -- global status
	--clk_gen
	regs(GLOBAL_CLK_GEN_SEL)(GLOBAL_CLK_GEN_CLK40_LOCKED_BIT) <= stat_global_clk_gen_i.clk_40_locked;
	regs(GLOBAL_CLK_GEN_SEL)(GLOBAL_CLK_GEN_REFCLK_LOCKED_BIT) <= stat_global_clk_gen_i.ref_clk_locked;     
	--ttc / sel1
	regs(GLOBAL_TTC_SEL1)(GLOBAL_TTC_RDY_BIT) <= stat_global_ttc_i.ttc_rdy;   
	--ttc / sel2
	regs(GLOBAL_TTC_SEL2)((GLOBAL_TTC_SINGLE_ERR_CNT_OFFSET + GLOBAL_TTC_SINGLE_ERR_CNT_WIDTH-1) downto GLOBAL_TTC_SINGLE_ERR_CNT_OFFSET) <= stat_global_ttc_i.ttc_dec_single_err_cnt;
	regs(GLOBAL_TTC_SEL2)((GLOBAL_TTC_DOUBLE_ERR_CNT_OFFSET + GLOBAL_TTC_DOUBLE_ERR_CNT_WIDTH-1) downto GLOBAL_TTC_DOUBLE_ERR_CNT_OFFSET) <= stat_global_ttc_i.ttc_dec_double_err_cnt;

	-- readout status
	regs(READOUT_BLOCK_SEL)(READOUT_REQ_BIT) <= stat_readout_i.readout_req; 
	regs(READOUT_BLOCK_SEL)((READOUT_FSM_STATUS_OFFSET + READOUT_FSM_STATUS_WIDTH-1) downto READOUT_FSM_STATUS_OFFSET) <= stat_readout_i.fsm_status;

	-- be_proc status
	regs(BE_PROC_SEL)((EVNT_CNT_OFFSET + EVNT_CNT_WIDTH-1) downto EVNT_CNT_OFFSET) <= stat_be_proc_i.evnt_cnt;
	regs(BE_PROC_SEL)(EVNT_CNT_BUF_EMPTY_BIT) <= stat_be_proc_i.evnt_cnt_buf_empty; 
	regs(BE_PROC_SEL)(DATA_PAYLOAD_BUF_EMPTY) <= stat_be_proc_i.data_payload_buf_empty; 	
	regs(BE_PROC_SEL)(TRIGDATA_BUF_EMPTY_BIT) <= stat_be_proc_i.trigdata_buf_empty; 
		    
	-- command block status
	regs(COMMAND_BLOCK_I2C_MASTER_SEL)((COMMAND_BLOCK_I2C_MASTER_FSM_STATUS_OFFSET + COMMAND_BLOCK_I2C_MASTER_FSM_STATUS_WIDTH-1) downto COMMAND_BLOCK_I2C_MASTER_FSM_STATUS_OFFSET) <= stat_command_block_i.status_i2c_master_fsm;
    regs(COMMAND_BLOCK_I2C_COMMANDS_FIFO_STAT_SEL)(COMMAND_BLOCK_I2C_COMMANDS_FIFO_EMPTY_BIT) <= stat_command_block_i.fifo_statuses.i2c_commands_empty;
	regs(COMMAND_BLOCK_I2C_COMMANDS_FIFO_STAT_SEL)(COMMAND_BLOCK_I2C_COMMANDS_FIFO_FULL_BIT) <= stat_command_block_i.fifo_statuses.i2c_commands_full;
	regs(COMMAND_BLOCK_I2C_REPLIES_FIFO_STAT_SEL)(COMMAND_BLOCK_I2C_REPLIES_FIFO_EMPTY_BIT) <= stat_command_block_i.fifo_statuses.i2c_replies_empty;
    regs(COMMAND_BLOCK_I2C_REPLIES_FIFO_STAT_SEL)(COMMAND_BLOCK_I2C_REPLIES_FIFO_FULL_BIT) <= stat_command_block_i.fifo_statuses.i2c_replies_full;
    regs(COMMAND_BLOCK_I2C_NREPLIES_SEL)(15 downto 0) <= stat_command_block_i.fifo_statuses.i2c_nreplies_present;
    regs(COMMAND_BLOCK_I2C_NREPLIES_SEL)(31 downto 16) <= (others => '0');
    
    -- fast block status
    regs(FAST_BLOCK_FSG_STATUS_SEL)((FAST_BLOCK_FSG_STATUS_SOURCE_OFFSET + FAST_BLOCK_FSG_STATUS_SOURCE_WIDTH-1) downto FAST_BLOCK_FSG_STATUS_SOURCE_OFFSET) <= stat_fast_block_i.trigger_source;
    regs(FAST_BLOCK_FSG_STATUS_SEL)(FAST_BLOCK_FSG_STATUS_STATE_BIT) <= stat_fast_block_i.trigger_state;
    regs(FAST_BLOCK_FSG_STATUS_SEL)(FAST_BLOCK_FSG_STATUS_CONFIGURED_BIT) <= stat_fast_block_i.if_configured;  

    -- test clcok frequencies output
    regs(TEST_CLOCK_IPB_SEL) <= test_clock_frequency(0);
    regs(TEST_CLOCK_40MHZ_SEL) <= test_clock_frequency(1);
    regs(TEST_CLOCK_TRIGGER_SEL) <= test_clock_frequency(2);
    
    -- temp data process hybrid(0)
    process (reset, clk)
        constant index : natural := 0;
    begin
        if reset = '1' then
            regs(TEMP_DATA_HYBRID1_GEN_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS1_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS2_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS3_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS4_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS5_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS6_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS7_SEL) <= (others => '0');
            regs(TEMP_DATA_HYBRID1_CHANNELS8_SEL) <= (others => '0');
        elsif rising_edge(clk) then
            if(trig_data_i(index).start = "11") then
                regs(TEMP_DATA_HYBRID1_GEN_SEL)(TEMP_DATA_HYBRID1_GEN_LAT_ERR_BIT) <= trig_data_i(index).latency_error;
                regs(TEMP_DATA_HYBRID1_GEN_SEL)(TEMP_DATA_HYBRID1_GEN_OVERFLOW_BIT) <= trig_data_i(index).buffer_overflow;
                regs(TEMP_DATA_HYBRID1_GEN_SEL)(TEMP_DATA_HYBRID1_GEN_PIPE_WIDTH+TEMP_DATA_HYBRID1_GEN_PIPE_OFFSET-1 downto TEMP_DATA_HYBRID1_GEN_PIPE_OFFSET) <= trig_data_i(index).pipe_address;
                --regs(TEMP_DATA_HYBRID1_GEN_SEL)(TEMP_DATA_HYBRID1_GEN_LATENCY_WIDTH+TEMP_DATA_HYBRID1_GEN_LATENCY_OFFSET-1 downto TEMP_DATA_HYBRID1_GEN_LATENCY_OFFSET) <= trig_data_i(index).l1_counter;
                regs(TEMP_DATA_HYBRID1_GEN_SEL)(TEMP_DATA_HYBRID1_GEN_TRIGGER_COUNTER_WIDTH+TEMP_DATA_HYBRID1_GEN_TRIGGER_COUNTER_OFFSET-1 downto TEMP_DATA_HYBRID1_GEN_TRIGGER_COUNTER_OFFSET) <= trig_data_i(index).l1_counter;
                regs(TEMP_DATA_HYBRID1_CHANNELS8_SEL)(29 downto 0) <= trig_data_i(index).channels(253 downto 224);
                regs(TEMP_DATA_HYBRID1_CHANNELS7_SEL) <= trig_data_i(index).channels(223 downto 192);
                regs(TEMP_DATA_HYBRID1_CHANNELS6_SEL) <= trig_data_i(index).channels(191 downto 160);
                regs(TEMP_DATA_HYBRID1_CHANNELS5_SEL) <= trig_data_i(index).channels(159 downto 128);
                regs(TEMP_DATA_HYBRID1_CHANNELS4_SEL) <= trig_data_i(index).channels(127 downto 96);
                regs(TEMP_DATA_HYBRID1_CHANNELS3_SEL) <= trig_data_i(index).channels(95 downto 64);
                regs(TEMP_DATA_HYBRID1_CHANNELS2_SEL) <= trig_data_i(index).channels(63 downto 32);
                regs(TEMP_DATA_HYBRID1_CHANNELS1_SEL) <= trig_data_i(index).channels(31 downto 0);
                
            end if;
        end if;
    end process;
    	
ERROR_HANDLER: process(reset, clk)
begin
    if reset = '1' then
       status_error_block_id <= x"0";
       status_error_code <= x"00"; 
    elsif rising_edge(clk) then
        if stat_fast_block_i.error_code /= x"00" then
            status_error_block_id <= x"2";
            status_error_code <= stat_fast_block_i.error_code;
        elsif stat_command_block_i.error_i2c_master /= x"00" then
            status_error_block_id <= x"1";
            status_error_code <= stat_command_block_i.error_i2c_master; 
        else
            status_error_block_id <= x"0";
            status_error_code <= x"00";  
        end if;    
    end if;
end process;

end rtl;
