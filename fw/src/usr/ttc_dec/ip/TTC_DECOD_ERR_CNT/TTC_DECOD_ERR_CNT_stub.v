// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Wed Nov 23 13:18:02 2016
// Host        : sbgat349 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               C:/lcharles/cms/ph1/pixfed/fw/viv2015.3/prj_iphc_strasbourg/fc7_pixfed_viv/fc7_pixfed_viv.srcs/TTC_DECOD_ERR_CNT/TTC_DECOD_ERR_CNT/TTC_DECOD_ERR_CNT_stub.v
// Design      : TTC_DECOD_ERR_CNT
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k420tffg1156-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_counter_binary_v12_0_7,Vivado 2015.3" *)
module TTC_DECOD_ERR_CNT(CLK, CE, SCLR, Q)
/* synthesis syn_black_box black_box_pad_pin="CLK,CE,SCLR,Q[15:0]" */;
  input CLK;
  input CE;
  input SCLR;
  output [15:0]Q;
endmodule
