-- file: iddr_amc13.vhd
-- (c) Copyright 2009 - 2011 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
------------------------------------------------------------------------------
-- User entered comments
------------------------------------------------------------------------------
-- None
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity iddr_amc13 is
generic
 (-- width of the data for the system
  sys_w       : integer := 1;
  -- width of the data for the device
  dev_w       : integer := 2);
port
 (
  -- From the system into the device
  DATA_IN_FROM_PINS_P     : in    std_logic_vector(sys_w-1 downto 0);
  DATA_IN_FROM_PINS_N     : in    std_logic_vector(sys_w-1 downto 0);
  DATA_IN_TO_DEVICE       : out   std_logic_vector(dev_w-1 downto 0);

-- Input, Output delay control signals
  DELAY_CLK            : in    std_logic;
  DELAY_RESET          : in    std_logic;                    -- Active high synchronous reset for input delay
  DELAY_DATA_CE        : in    std_logic_vector(sys_w -1 downto 0);            -- Enable signal for delay for bit 
  DELAY_DATA_LD        : in    std_logic_vector(sys_w -1 downto 0);            -- Enable signal for delay for bit 
  DELAY_DATA_INC       : in    std_logic_vector(sys_w -1 downto 0);            -- Delay increment, decrement signal for bit 
  DELAY_TAP_IN         : in    std_logic_vector(5*sys_w -1 downto 0); -- Dynamically loadable delay tap value for bit 
  DELAY_TAP_OUT        : out   std_logic_vector(5*sys_w -1 downto 0); -- Bit  Delay tap value for monitoring
  DELAY_LOCKED            : out   std_logic;                    -- Locked signal from IDELAYCTRL
  REF_CLOCK               : in    std_logic;                    -- Reference Clock for IDELAYCTRL. Has to come from BUFG.
 
-- Clock and reset signals
  CLK_IN                  : in    std_logic;                    -- Fast clock from PLL/MMCM 
  IO_RESET                : in    std_logic;
--
	data_after_iodelay		: out std_logic
  
  );                   -- Reset signal for IO circuit
end iddr_amc13;

architecture xilinx of iddr_amc13 is
  attribute CORE_GENERATION_INFO            : string;
  attribute CORE_GENERATION_INFO of xilinx  : architecture is "iddr_amc13,selectio_wiz_v4_1,{component_name=iddr_amc13,bus_dir=INPUTS,bus_sig_type=DIFF,bus_io_std=LVDS_25,use_serialization=false,use_phase_detector=false,serialization_factor=4,enable_bitslip=false,enable_train=false,system_data_width=1,bus_in_delay=NONE,bus_out_delay=NONE,clk_sig_type=DIFF,clk_io_std=LVCMOS18,clk_buf=BUFIO2,active_edge=RISING,clk_delay=NONE,v6_bus_in_delay=VAR_LOADABLE,v6_bus_out_delay=NONE,v6_clk_buf=MMCM,v6_active_edge=DDR,v6_ddr_alignment=SAME_EDGE,v6_oddr_alignment=SAME_EDGE,ddr_alignment=C0,v6_interface_type=NETWORKING,interface_type=NETWORKING,v6_bus_in_tap=0,v6_bus_out_tap=0,v6_clk_io_std=LVCMOS25,v6_clk_sig_type=SINGLE}";
  constant clock_enable            : std_logic := '1';
  signal unused : std_logic;
  signal clk_in_int_buf            : std_logic;
  signal clk_gclk_in_int           : std_logic;


  -- After the buffer
  signal data_in_from_pins_int     : std_logic_vector(sys_w-1 downto 0);
  -- Between the delay and serdes
  signal data_in_from_pins_delay   : std_logic_vector(sys_w-1 downto 0);
  signal data_delay                : std_logic_vector(sys_w-1 downto 0); 
  signal delay_ce              : std_logic_vector(sys_w-1 downto 0);
  signal delay_ld              : std_logic_vector(sys_w-1 downto 0);
  signal delay_inc_dec         : std_logic_vector(sys_w-1 downto 0);
  type loadarr is array (0 to 15) of std_logic_vector(4 downto 0);
  signal intap                 : loadarr := (( others => (others => '0')));
  signal outtap                : loadarr := (( others => (others => '0')));

  attribute IODELAY_GROUP : string;
  attribute IODELAY_GROUP of delayctrl : label is "iddr_amc13_group";

begin

  delay_ce(0) <= DELAY_DATA_CE(0);
  delay_ld(0) <= DELAY_DATA_LD(0);
  delay_inc_dec(0) <= DELAY_DATA_INC(0);
  intap(0) <= DELAY_TAP_IN(5*(0 + 1) -1 downto 5*(0)); 
  DELAY_TAP_OUT(5*(0 + 1) -1 downto 5*(0)) <= outtap(0); 



  -- Create the clock logic
   clk_in_int_buf <= CLK_IN;

  
  -- We have multiple bits- step over every bit, instantiating the required elements
  pins: for pin_count in 0 to sys_w-1 generate
     attribute IODELAY_GROUP of iodelaye1_bus: label is "iddr_amc13_group";
  begin
    -- Instantiate the buffers
    ----------------------------------
    -- Instantiate a buffer for every bit of the data bus
     ibufds_inst : IBUFDS
       generic map (
         DIFF_TERM  => TRUE,             -- Differential termination
         IOSTANDARD => "LVDS_25")
       port map (
         I          => DATA_IN_FROM_PINS_P  (pin_count),
         IB         => DATA_IN_FROM_PINS_N  (pin_count),
         O          => data_in_from_pins_int(pin_count));

    -- Instantiate the delay primitive
    -----------------------------------

     iodelaye1_bus : IDELAYE2
       generic map (
         CINVCTRL_SEL           => "FALSE",    
         DELAY_SRC              => "IDATAIN",
         HIGH_PERFORMANCE_MODE  => "TRUE",      
         IDELAY_TYPE            => "VAR_LOAD",
         IDELAY_VALUE           => 0,         
         REFCLK_FREQUENCY       => 200.0,
         SIGNAL_PATTERN         => "DATA",          -- CLOCK, DATA
			PIPE_SEL					  => "FALSE"
			)
       port map (
         C                      => DELAY_CLK,
         REGRST                 => DELAY_RESET,
         IDATAIN                => data_in_from_pins_int  (pin_count), -- Driven by IOB
         DATAIN                 => '0', -- Data from FPGA logic
         DATAOUT                => data_delay (pin_count),
         LD                     => delay_ld(pin_count),
		 CE                     => delay_ce(pin_count), --DELAY_DATA_CE,
         INC                    => delay_inc_dec(pin_count), --DELAY_DATA_INC,
         LDPIPEEN				=> '0',
		 CNTVALUEIN             => intap(pin_count), --DELAY_TAP_IN,
         CNTVALUEOUT            => outtap(pin_count), --DELAY_TAP_OUT,
         CINVCTRL               => '0'
         );

           data_in_from_pins_delay(pin_count) <= data_delay(pin_count); 




    -- Connect the delayed data to the fabric
    ------------------------------------------
   -- DDR register instantation
    iddr_inst : IDDR
      generic map (
        INIT_Q1        => '0',
        INIT_Q2        => '0',
        DDR_CLK_EDGE   => "SAME_EDGE", --"SAME_EDGE", "OPPOSITE_EDGE", "SAME_EDGE", "SAME_EDGE_PIPELINED"
       SRTYPE         => "ASYNC")
      port map
       (Q1             => DATA_IN_TO_DEVICE(pin_count),
        Q2             => DATA_IN_TO_DEVICE(sys_w + pin_count),
        C              => clk_in_int_buf,
        CE             => clock_enable,
        D              => data_in_from_pins_delay(pin_count),
        R              => IO_RESET,
        S              => '0');

  end generate pins;

-- IDELAYCTRL is needed for calibration
delayctrl : IDELAYCTRL
    port map (
     RDY    => DELAY_LOCKED,
     REFCLK => REF_CLOCK,
     RST    => IO_RESET
     );


data_after_iodelay <= data_delay (0);

end xilinx;


