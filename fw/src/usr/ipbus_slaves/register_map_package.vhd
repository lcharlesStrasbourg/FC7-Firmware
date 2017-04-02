----------------------------------------------------------------------------------
-- Engineer: Mykyta Haranko
-- Create Date: 02/16/2017 02:16:37 PM
-- Module Name: register_map_package - rtl
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package register_map_package is

constant ADDR_WIDTH :   natural := 16;
constant BLOCK_ID_WIDTH :   natural := 4;

type register_type is (cnfg, ctrl, stat);

-- The signals going from slaves to master	 
type register_map_entry is
record
    register_width_ctrl     :   integer range 0 to 2**ADDR_WIDTH;
    register_width_cnfg     :   integer range 0 to 2**ADDR_WIDTH;
    register_width_stat     :   integer range 0 to 2**ADDR_WIDTH;
    block_name              :   string (1 to 8);
end record;

type register_map is array(0 to 2**BLOCK_ID_WIDTH-1) of register_map_entry;
type block_offsets_type is array (0 to 2**ADDR_WIDTH-1) of integer range 0 to 2**ADDR_WIDTH-1;

function block_offsets(constant reg_type: in register_type) return block_offsets_type;    

function convert_address(ipb_address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
                         constant reg_type: in register_type) return integer;                                     

function calculate_total_width_cnfg return integer;
function calculate_total_width_ctrl return integer;                                                               
function calculate_total_width_stat return integer;                                                                 
                                                                 
                                
--================================================================================================================================================--
-- Set amount of allocated registers here
--================================================================================================================================================--
constant fc7_register_map : register_map :=
    (0  => ( register_width_cnfg =>  0,      register_width_ctrl =>  8,      register_width_stat =>  8,      block_name  =>  "global__" ),
    1   => ( register_width_cnfg =>  8,      register_width_ctrl =>  8,      register_width_stat =>  8,      block_name  =>  "command_" ),
    2   => ( register_width_cnfg =>  8,      register_width_ctrl =>  8,      register_width_stat =>  8,      block_name  =>  "fast____" ),
    3   => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "phy_____" ),
    4   => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  8,      block_name  =>  "hybrid__" ),
    5   => ( register_width_cnfg =>  0,      register_width_ctrl =>  8,      register_width_stat =>  8,      block_name  =>  "data____" ),
    6   => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    7   => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    8   => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    9   => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    10  => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    11  => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    12  => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    13  => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  0,      block_name  =>  "na______" ),
    14  => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  9,      block_name  =>  "temp____" ),
    15  => ( register_width_cnfg =>  0,      register_width_ctrl =>  0,      register_width_stat =>  4,      block_name  =>  "test_clk" )
); 
--================================================================================================================================================--

    
    type cnfg_regs_type is array (0 to calculate_total_width_cnfg-1) of std_logic_vector(31 downto 0);
    type ctrl_regs_type is array (0 to calculate_total_width_ctrl-1) of std_logic_vector(31 downto 0);
    type stat_regs_type is array (0 to calculate_total_width_stat-1) of std_logic_vector(31 downto 0);
    
    constant offset_cnfg :  block_offsets_type := block_offsets(cnfg);   
    constant offset_ctrl :  block_offsets_type := block_offsets(ctrl);  
    constant offset_stat :  block_offsets_type := block_offsets(stat);                              

end register_map_package;

package body register_map_package is

function block_offsets(reg_type: register_type) return block_offsets_type is
    variable offset : integer;
    variable block_offsets  : block_offsets_type;
begin
    offset := 0;
    if reg_type = cnfg then
        for I in 0 to 2**BLOCK_ID_WIDTH-1 loop
            block_offsets(I) := offset;
            offset := offset + fc7_register_map(I).register_width_cnfg;                   
        end loop;
    end if;
    if reg_type = ctrl then
        for I in 0 to 2**BLOCK_ID_WIDTH-1 loop
            block_offsets(I) := offset;
            offset := offset + fc7_register_map(I).register_width_ctrl;
        end loop;
    end if;
    if reg_type = stat then
        for I in 0 to 2**BLOCK_ID_WIDTH-1 loop
            block_offsets(I) := offset;
            offset := offset + fc7_register_map(I).register_width_stat;
        end loop;
    end if;
    return block_offsets;

end block_offsets;

function convert_address(ipb_address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
                         constant reg_type: in register_type) return integer is
    variable sel                 : integer;
    variable block_id            : integer;
    variable register_address    : integer;
    variable this_block_offset        : integer;
    variable overflow            : boolean;
begin
    block_id := to_integer(unsigned(ipb_address(ADDR_WIDTH-1 downto (ADDR_WIDTH-BLOCK_ID_WIDTH))));
    register_address := to_integer(unsigned(ipb_address(ADDR_WIDTH-BLOCK_ID_WIDTH-1 downto 0))); 
    overflow := false;
    if reg_type = cnfg then
        this_block_offset := offset_cnfg(block_id);
        if(register_address + 1 > fc7_register_map(block_id).register_width_cnfg) then
            overflow := true;
        end if;
    end if;
    if reg_type = ctrl then
        this_block_offset := offset_ctrl(block_id);
        if(register_address + 1 > fc7_register_map(block_id).register_width_ctrl) then
            overflow := true;
        end if;
    end if;
    if reg_type = stat then
        this_block_offset := offset_stat(block_id);
        if(register_address + 1 > fc7_register_map(block_id).register_width_stat) then
            overflow := true;
        end if;
    end if;
    
    if overflow then
        sel := 0;
    else
        sel := register_address + this_block_offset;
    end if;
    return sel;
    
end convert_address;
    
function calculate_total_width_cnfg return integer is
    variable total_size : integer;    
begin
    total_size := 0;          
    
    for I in 0 to 2**BLOCK_ID_WIDTH-1 loop
        total_size := total_size + fc7_register_map(I).register_width_cnfg;       
    end loop;
    
return total_size;                                                    
end calculate_total_width_cnfg;

function calculate_total_width_ctrl return integer is
    variable total_size : integer;    
begin
    total_size := 0;          
    
    for I in 0 to 2**BLOCK_ID_WIDTH-1 loop
        total_size := total_size + fc7_register_map(I).register_width_ctrl;       
    end loop;
    
return total_size;                                                    
end calculate_total_width_ctrl;

function calculate_total_width_stat return integer is
    variable total_size : integer;    
begin
    total_size := 0;          
    
    for I in 0 to 2**BLOCK_ID_WIDTH-1 loop
        total_size := total_size + fc7_register_map(I).register_width_stat;       
    end loop;
    
return total_size;                                                    
end calculate_total_width_stat;

end register_map_package;
