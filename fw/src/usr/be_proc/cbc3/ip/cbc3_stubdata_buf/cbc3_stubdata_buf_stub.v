// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Wed Mar 29 19:06:35 2017
// Host        : sbgat349 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               C:/lcharles/cms/ph2/tkdaq/FC7TestBoard/v2016.4/FC7-Firmware/fw/src/usr/be_proc/cbc3/ip/cbc3_stubdata_buf/cbc3_stubdata_buf_stub.v
// Design      : cbc3_stubdata_buf
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k420tffg1156-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_3,Vivado 2016.4" *)
module cbc3_stubdata_buf(clk, srst, din, wr_en, rd_en, dout, full, empty, valid, 
  prog_full, prog_empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[39:0],wr_en,rd_en,dout[39:0],full,empty,valid,prog_full,prog_empty" */;
  input clk;
  input srst;
  input [39:0]din;
  input wr_en;
  input rd_en;
  output [39:0]dout;
  output full;
  output empty;
  output valid;
  output prog_full;
  output prog_empty;
endmodule
