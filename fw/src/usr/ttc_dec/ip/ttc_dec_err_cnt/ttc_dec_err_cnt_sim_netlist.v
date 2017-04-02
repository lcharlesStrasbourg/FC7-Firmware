// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
// Date        : Tue Feb 14 19:22:17 2017
// Host        : sbgat349 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode funcsim -rename_top ttc_dec_err_cnt -prefix
//               ttc_dec_err_cnt_ ttc_dec_err_cnt_sim_netlist.v
// Design      : ttc_dec_err_cnt
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k420tffg1156-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ttc_dec_err_cnt,c_counter_binary_v12_0_10,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_counter_binary_v12_0_10,Vivado 2016.3" *) 
(* NotValidForBitStream *)
module ttc_dec_err_cnt
   (CLK,
    CE,
    SCLR,
    Q);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) output [15:0]Q;

  wire CE;
  wire CLK;
  wire [15:0]Q;
  wire SCLR;
  wire NLW_U0_THRESH0_UNCONNECTED;

  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SYNC = "0" *) 
  (* C_COUNT_BY = "1" *) 
  (* C_COUNT_MODE = "0" *) 
  (* C_COUNT_TO = "1111111111111110" *) 
  (* C_FB_LATENCY = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_LOAD = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_HAS_THRESH0 = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "1" *) 
  (* C_LOAD_LOW = "0" *) 
  (* C_RESTRICT_COUNT = "1" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_THRESH0_VALUE = "1" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_WIDTH = "16" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  ttc_dec_err_cnt_c_counter_binary_v12_0_10 U0
       (.CE(CE),
        .CLK(CLK),
        .L({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .LOAD(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0),
        .THRESH0(NLW_U0_THRESH0_UNCONNECTED),
        .UP(1'b1));
endmodule

(* C_AINIT_VAL = "0" *) (* C_CE_OVERRIDES_SYNC = "0" *) (* C_COUNT_BY = "1" *) 
(* C_COUNT_MODE = "0" *) (* C_COUNT_TO = "1111111111111110" *) (* C_FB_LATENCY = "0" *) 
(* C_HAS_CE = "1" *) (* C_HAS_LOAD = "0" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_SINIT = "0" *) (* C_HAS_SSET = "0" *) (* C_HAS_THRESH0 = "0" *) 
(* C_IMPLEMENTATION = "1" *) (* C_LATENCY = "1" *) (* C_LOAD_LOW = "0" *) 
(* C_RESTRICT_COUNT = "1" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_THRESH0_VALUE = "1" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "16" *) 
(* C_XDEVICEFAMILY = "kintex7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module ttc_dec_err_cnt_c_counter_binary_v12_0_10
   (CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    UP,
    LOAD,
    L,
    THRESH0,
    Q);
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  input UP;
  input LOAD;
  input [15:0]L;
  output THRESH0;
  output [15:0]Q;

  wire \<const1> ;
  wire CE;
  wire CLK;
  wire [15:0]L;
  wire [15:0]Q;
  wire SCLR;
  wire NLW_i_synth_THRESH0_UNCONNECTED;

  assign THRESH0 = \<const1> ;
  VCC VCC
       (.P(\<const1> ));
  (* C_AINIT_VAL = "0" *) 
  (* C_CE_OVERRIDES_SYNC = "0" *) 
  (* C_COUNT_BY = "1" *) 
  (* C_COUNT_MODE = "0" *) 
  (* C_COUNT_TO = "1111111111111110" *) 
  (* C_FB_LATENCY = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_LOAD = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_HAS_THRESH0 = "0" *) 
  (* C_IMPLEMENTATION = "1" *) 
  (* C_LATENCY = "1" *) 
  (* C_LOAD_LOW = "0" *) 
  (* C_RESTRICT_COUNT = "1" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_THRESH0_VALUE = "1" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_WIDTH = "16" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  ttc_dec_err_cnt_c_counter_binary_v12_0_10_viv i_synth
       (.CE(CE),
        .CLK(CLK),
        .L(L),
        .LOAD(1'b0),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0),
        .THRESH0(NLW_i_synth_THRESH0_UNCONNECTED),
        .UP(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
PRBNg3KyY1TR8yWZsnJnzzW/dEsrSEDfE+1c6Hou7GiQUi2ny3LJr10cVebRXHTs9QGvYYRTSSn8
Gyz5sNLHnA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jp7GnVDs4XPGehBIKJsokm3xWBjOSlzqHCc4XQDu66HQLxD0ZCDJtK/0K8Il8OrKOoC65joOn1l3
Jor/QFU/jgbh9u8Cb2WE++syJa27o9YGvAlnaQpkj+0+N0NSqwnZUTbmC2/vBRF90ejN3z0SxSuf
7ogM20Bk3ecQGlrM6Fk=

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
C6JMRfgIV+Sc/HUYaNdQ7GIkz8COMQi8XUszLwYumZyMji0WWhDsAmhdfX5HH8cQ2yEACYyrTdP/
TPkP6isgOtKu5yx2FXkdBxlX4T/RYb8TFzYCouDdbbojP0Ri3EnQY6Os7fU6/Kh0RGbHNIurolFP
ynqKAqHwVx1foWG/fGE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Bfx6ABSTmJJG+apj7DJxhWrxKS3DSF5eBFzSfEJkgmzGC4adPP0+EtlS/8cA3WS05a9ZnMSU//dD
6Xa665Pgb6piwHZmJXNDVJXTPEU3BZXO0hD4lShd7QESdtDBIjPVNllsAMr5ICT9aeAuRZ4712CL
OsJBlMyyKq44NbiGgoZsrvYB3AOby14WleukeyrHVRqOVOJbPwg9fW0vsTdksfdW/S6AUHeuZNZw
FQzUlxYpG1/ulxKJRSWGF2rVs8INdMkWKU0mQNfz8Fbu9kCy5+qtyDgko+t+9b0QOndyALYwiMoX
plKql5/d/127rmaQfARfQyiN2GF83TwGN+q8SA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
uN7qo9Y7BtnOroN3nCx9a5nDr+AspFVYFgtL9vAD/836ZRiS2NZlcBzHW7l/qr+zJHZIwdEJdB4g
XTacuGx6jN9qRGwxsjd3FKG3v3ezqTrcg3ShQaxbt4rb1UWdD0rGM6JHU9UjV1v4FGjdDtrez7nV
yf8TbYVAIjeVuwTKz5QV7v+K5d3durINdZF1N3Te+ED6whBD4ikRKDsUQ1uT+omn+AEaJruouIng
kBII4smDkPDmW5SZwbcgCZanAN4z/r3pZdBTsYLi1WIMAt49n8T0NBr5BQX7Pwecdwn5uJ1uQo5u
PtrPHwF/NzhF6ki63bIUN1am+XxZ5abQxhzT+w==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinx_2016_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fxhZ+v8RjZpp04TYOWBrq4+/hxS3PdHwNldw733sowphaSpIOkexyA/fRFpFYgYAcOEJQVdGxlwj
L4vfVCeW2SSHwtR7VGPSbEIqenEpmN/BMJKkAqphU3QYmDdQQXwymCL5qvIaORVfIz1XLVnp5y+3
MOyNHjSIDozEwPBkzIs1+o3qqXij8+OqX3X3AFlhB2Ase2TBfPeBFWKpS/1dOAq1BfuotrmuCum6
+UTctjS5n2x+OZZxOe4vA73VwVVKsh8ptEGksrnhLVJ9Qp2EfA7FXAksUYeGRo3dHvFOeIvvledQ
eavcoTOBjEwcPZkek4i2nhhzqQQJ/0ZEfxZcnQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
kYEIlL6L7CzhR2t8PplMwQ9MapIClhhsTt2G9MuxgCMQp6tfOyVaEocRtQJWoIOv47ovRgmei/MM
2GT9cxv2gnnW7I4vNWDs7N5eFpnZI79xk/tOflUIbSrr3tglqIS8A3zUvA7vH6iYxdwS5FRkVmf6
4kmN3i/NltWbUoEWZwmM77l1XtzPu7DmjFlDOUOvkhDOq5NfLgAJgsfeVn6/Kc0bSCRug/VjDZEH
8C/ft7gjQFPhGYMYjkw0pm6E9XYFVxgAtEMMHE9n6tKqfZvdUwEUxWDugrr7YIEQj0Dv10HwMoH+
o3cEXCfWSr2sIvHxzBqgsdKh+g4BOORV+RTFKQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP05_001", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
r4gaMjC3c81XLl9ZWt+pg1Umsc22pI5AD+FBNSECVfpiuqxG+HSrUKKVqjYKHdX88sxw2P0iZyRk
LNWCqDRc/ZK+GitVWSPFLc3fgmlZJbRfY1aeI90lWvjIzY5gWPigOURn+tPVR1/79s9jX8DdgfDj
9X5l6TTiF0r6s9gQkyyeDgccWXjNUA/ekTD32XDPYKa3P0+rRqtZQHo59fknpWDSlLaxzirVe5wW
x/Kt1FcebFmqi0vhSY18rVNYZoRPtZqTfh3gNGZEjLsjLGodwVtQHRyp7dZflMp3yBRsMS67l1ko
Fxh7AhRUCYX0OpLTXgoAhCg73iyHuPcLEAn92w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 14240)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
