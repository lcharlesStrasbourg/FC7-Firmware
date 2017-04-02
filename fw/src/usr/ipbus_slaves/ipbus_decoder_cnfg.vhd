----------------------------------------------------------------------------------
-- Engineer: Mykyta Haranko
-- Create Date: 12/20/2016 05:05:17 PM
----------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
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

entity ipbus_decoder_cnfg is
port (
        clk                   : in  std_logic;
        reset                 : in  std_logic;
        ipb_mosi_i            : in  ipb_wbus;
        ipb_miso_o            : out ipb_rbus;
        -- fast command block configuration
        cnfg_fastblock_o      : out cnfg_fastblock_type;
        -- command block configuration
        cnfg_command_block_o  : out cnfg_command_block_type
     );
end ipbus_decoder_cnfg;

architecture rtl of ipbus_decoder_cnfg is

    constant reg_type   : register_type := cnfg;
    signal regs: cnfg_regs_type;
    signal sel: integer range 0 to 2**ADDR_WIDTH-1;
    signal block_id            : integer range 0 to 2**BLOCK_ID_WIDTH-1;
    signal register_address    : integer range 0 to 2**ADDR_WIDTH-1;
    signal ipb_ack_int: std_logic;
    
    attribute keep: boolean;
    attribute keep of sel: signal is true;   
    
    -- signals are redirected here in case of overflow
    constant OVERFLOW_SEL                                : integer := convert_address(x"0_000",reg_type);
    
    --====================================--
    -- Command Processor Block Registers  
    --====================================--
    constant COMMAND_BLOCK_SEL                          : integer := convert_address(x"1_000",reg_type);
    --====================================--
    -- i2c mask to write the register
    constant COMMAND_BLOCK_I2C_WRITE_MASK_SEL           : integer := convert_address(x"1_001",reg_type);
    constant COMMAND_BLOCK_I2C_WRITE_MASK_OFFSET        : integer := 0;
    constant COMMAND_BLOCK_I2C_WRITE_MASK_WIDTH          : integer := 8;
    --====================================--
 
    --====================================--
    -- Fast Command Block Registers  
    --====================================--
    constant FAST_BLOCK_SEL                                 : integer := convert_address(x"2_000",reg_type);
    --====================================--
    -- fast command block commands    
    constant FAST_BLOCK_SCG_FSG_NCYCLE_SEL                       : integer := convert_address(x"2_000",reg_type);
    constant FAST_BLOCK_SCG_FSG_CYCLE_FREQUENCY_SEL              : integer := convert_address(x"2_001",reg_type);
    constant FAST_BLOCK_SCG_FSG_SOURCE_SEL                       : integer := convert_address(x"2_002",reg_type);
    constant FAST_BLOCK_SCG_FSG_SOURCE_OFFSET                    : integer := 0;
    constant FAST_BLOCK_SCG_FSG_SOURCE_WIDTH                     : integer := 4;
    constant FAST_BLOCK_SCG_FSG_MASK_SEL                         : integer := convert_address(x"2_003",reg_type);
    constant FAST_BLOCK_DELAY_AFTER_FAST_RESET_SEL               : integer := convert_address(x"2_004",reg_type); 
    constant FAST_BLOCK_DELAY_AFTER_TEST_PULSE_SEL               : integer := convert_address(x"2_005",reg_type); 
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
    --====================================--
    -- define addresses here
    --====================================--
    
    --====================================--
    -- Data Block Registers  
    --====================================--
    constant BE_DATA_BLOCK_SEL                             : integer := convert_address(x"5_000",reg_type);
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
         
begin

    block_id <= to_integer(unsigned(ipb_mosi_i.ipb_addr(ADDR_WIDTH-1 downto (ADDR_WIDTH-BLOCK_ID_WIDTH))));
    register_address <= to_integer(unsigned(ipb_mosi_i.ipb_addr(ADDR_WIDTH-BLOCK_ID_WIDTH-1 downto 0))); 
	--=============================--
	sel <= register_address + offset_cnfg(block_id) when register_address+1 <= fc7_register_map(block_id).register_width_cnfg else 0;
	--=============================--
	              
	--=============================--
	process(reset, clk)
	--=============================--
	begin
	if reset='1' then
		regs 	 <= (others=> (others=>'0'));
		ipb_ack_int 	 <= '0';
		
		regs(FAST_BLOCK_SCG_FSG_NCYCLE_SEL) <= (others => '0');
		regs(FAST_BLOCK_SCG_FSG_CYCLE_FREQUENCY_SEL) <= x"00000001";
		regs(FAST_BLOCK_SCG_FSG_SOURCE_SEL)(FAST_BLOCK_SCG_FSG_SOURCE_OFFSET + FAST_BLOCK_SCG_FSG_SOURCE_WIDTH -1 downto FAST_BLOCK_SCG_FSG_SOURCE_OFFSET) <= x"1";
		regs(FAST_BLOCK_SCG_FSG_MASK_SEL) <= (others => '0');
		regs(FAST_BLOCK_DELAY_AFTER_FAST_RESET_SEL) <= x"00000032";
		regs(FAST_BLOCK_DELAY_AFTER_TEST_PULSE_SEL) <= x"000000c8";
		
		regs(COMMAND_BLOCK_I2C_WRITE_MASK_SEL)(COMMAND_BLOCK_I2C_WRITE_MASK_OFFSET + COMMAND_BLOCK_I2C_WRITE_MASK_WIDTH -1 downto COMMAND_BLOCK_I2C_WRITE_MASK_OFFSET) <= x"FF";		
		
	elsif rising_edge(clk) then
		if ipb_mosi_i.ipb_strobe='1' then
	      --=============================--
          -- write section
          --=============================--
		  if ipb_mosi_i.ipb_write='1' then
		      regs(sel) <= ipb_mosi_i.ipb_wdata;
		  end if;		    
		  --=============================--
		end if;
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
	
	-- trigger config
	cnfg_fastblock_o.trigger_source <= regs(FAST_BLOCK_SCG_FSG_SOURCE_SEL)(FAST_BLOCK_SCG_FSG_SOURCE_OFFSET + FAST_BLOCK_SCG_FSG_SOURCE_WIDTH -1 downto FAST_BLOCK_SCG_FSG_SOURCE_OFFSET);
	cnfg_fastblock_o.triggers_to_accept <= to_integer(unsigned(regs(FAST_BLOCK_SCG_FSG_NCYCLE_SEL)));
	cnfg_fastblock_o.user_trigger_frequency <= to_integer(unsigned(regs(FAST_BLOCK_SCG_FSG_CYCLE_FREQUENCY_SEL)));
	cnfg_fastblock_o.stubs_mask <= regs(FAST_BLOCK_SCG_FSG_MASK_SEL);
	cnfg_fastblock_o.delay_after_fast_reset <= to_integer(unsigned(regs(FAST_BLOCK_DELAY_AFTER_FAST_RESET_SEL)));
	cnfg_fastblock_o.delay_after_test_pulse <= to_integer(unsigned(regs(FAST_BLOCK_DELAY_AFTER_TEST_PULSE_SEL)));
	
	cnfg_command_block_o.i2c_mask <= regs(COMMAND_BLOCK_I2C_WRITE_MASK_SEL)(COMMAND_BLOCK_I2C_WRITE_MASK_OFFSET + COMMAND_BLOCK_I2C_WRITE_MASK_WIDTH -1 downto COMMAND_BLOCK_I2C_WRITE_MASK_OFFSET);

end rtl;
