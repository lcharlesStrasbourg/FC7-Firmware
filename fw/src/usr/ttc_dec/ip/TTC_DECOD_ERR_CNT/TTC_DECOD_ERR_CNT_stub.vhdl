-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
-- Date        : Wed Nov 23 13:18:02 2016
-- Host        : sbgat349 running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/lcharles/cms/ph1/pixfed/fw/viv2015.3/prj_iphc_strasbourg/fc7_pixfed_viv/fc7_pixfed_viv.srcs/TTC_DECOD_ERR_CNT/TTC_DECOD_ERR_CNT/TTC_DECOD_ERR_CNT_stub.vhdl
-- Design      : TTC_DECOD_ERR_CNT
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k420tffg1156-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TTC_DECOD_ERR_CNT is
  Port ( 
    CLK : in STD_LOGIC;
    CE : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end TTC_DECOD_ERR_CNT;

architecture stub of TTC_DECOD_ERR_CNT is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,CE,SCLR,Q[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "c_counter_binary_v12_0_7,Vivado 2015.3";
begin
end;
