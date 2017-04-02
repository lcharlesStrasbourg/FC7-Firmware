// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
// Date        : Sat Mar 18 23:53:02 2017
// Host        : sbgat349 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub -rename_top cbc3_stubdata_shift -prefix
//               cbc3_stubdata_shift_ cbc3_stubdata_shift_stub.v
// Design      : cbc3_stubdata_shift
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k420tffg1156-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_10,Vivado 2016.3" *)
module cbc3_stubdata_shift(A, D, CLK, Q)
/* synthesis syn_black_box black_box_pad_pin="A[7:0],D[39:0],CLK,Q[39:0]" */;
  input [7:0]A;
  input [39:0]D;
  input CLK;
  output [39:0]Q;
endmodule
