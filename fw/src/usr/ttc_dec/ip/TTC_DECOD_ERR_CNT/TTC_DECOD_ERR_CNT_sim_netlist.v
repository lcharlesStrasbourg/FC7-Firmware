// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (win64) Build 1368829 Mon Sep 28 20:06:43 MDT 2015
// Date        : Wed Nov 23 13:18:02 2016
// Host        : sbgat349 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode funcsim
//               C:/lcharles/cms/ph1/pixfed/fw/viv2015.3/prj_iphc_strasbourg/fc7_pixfed_viv/fc7_pixfed_viv.srcs/TTC_DECOD_ERR_CNT/TTC_DECOD_ERR_CNT/TTC_DECOD_ERR_CNT_sim_netlist.v
// Design      : TTC_DECOD_ERR_CNT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k420tffg1156-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "TTC_DECOD_ERR_CNT,c_counter_binary_v12_0_7,{}" *) (* core_generation_info = "TTC_DECOD_ERR_CNT,c_counter_binary_v12_0_7,{x_ipProduct=Vivado 2015.3,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=c_counter_binary,x_ipVersion=12.0,x_ipCoreRevision=7,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_IMPLEMENTATION=1,C_VERBOSITY=0,C_XDEVICEFAMILY=kintex7,C_WIDTH=16,C_HAS_CE=1,C_HAS_SCLR=1,C_RESTRICT_COUNT=1,C_COUNT_TO=1111111111111110,C_COUNT_BY=1,C_COUNT_MODE=0,C_THRESH0_VALUE=1,C_CE_OVERRIDES_SYNC=0,C_HAS_THRESH0=0,C_HAS_LOAD=0,C_LOAD_LOW=0,C_LATENCY=1,C_FB_LATENCY=0,C_AINIT_VAL=0,C_SINIT_VAL=0,C_SCLR_OVERRIDES_SSET=1,C_HAS_SSET=0,C_HAS_SINIT=0}" *) (* downgradeipidentifiedwarnings = "yes" *) 
(* x_core_info = "c_counter_binary_v12_0_7,Vivado 2015.3" *) 
(* NotValidForBitStream *)
module TTC_DECOD_ERR_CNT
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
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) 
  TTC_DECOD_ERR_CNT_c_counter_binary_v12_0_7 U0
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
(* C_XDEVICEFAMILY = "kintex7" *) (* ORIG_REF_NAME = "c_counter_binary_v12_0_7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module TTC_DECOD_ERR_CNT_c_counter_binary_v12_0_7
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

  wire CE;
  wire CLK;
  wire [15:0]L;
  wire LOAD;
  wire [15:0]Q;
  wire SCLR;
  wire SINIT;
  wire SSET;
  wire THRESH0;
  wire UP;

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
  TTC_DECOD_ERR_CNT_c_counter_binary_v12_0_7_viv i_synth
       (.CE(CE),
        .CLK(CLK),
        .L(L),
        .LOAD(LOAD),
        .Q(Q),
        .SCLR(SCLR),
        .SINIT(SINIT),
        .SSET(SSET),
        .THRESH0(THRESH0),
        .UP(UP));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2014"
`pragma protect key_keyowner = "Cadence Design Systems.", key_keyname= "cds_rsa_key", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 64)
`pragma protect key_block
AKfUXcjzpTTjxnCbI4SxwOkZnE58D3tiocFWNrMwV722LXYd000TwYgQlk5ujoDOJF/nz/2A5T+7
AJp96SzOyA==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-VERIF-SIM-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
LtTqZrAhk/q1QkSKmDN5sJzQFskguvdU9sv0XI3ntR8Ph+NQW2YQMZ9VzZ1BUR1srieotIFN0g56
uODTIzE8j1O4d3rPhz5kRzct5VLzasxYeHmcT3tY/2D+y4+0ULlPCLGsj774+3qjbgn8x9/FiAD8
KvzOGPJPYRdZ1nGT5o4=


`pragma protect key_keyowner = "Xilinx", key_keyname= "xilinx_2014_03", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
oKiqQC6fvNitKm9dOxWFVjqnCOrHMbjRom5tTGIvKgOrkHeZlapqQPK1ubl58eT4+yPLc//jO9EE
85Znx8BZ9LRHj9pHFz166cU8LJDhUppVhJjaBhqJPQV2HKSF7cfhlvi5lxz3JNS5cfNoFMvRnpSM
Jr5e3c1S8i3f0/aDtnjx0js26KuLjp7srjQKHdb/J1DvubsWni9OKN2AY6uPvxlRWmmKu5pLXfTo
E6FmkyBCkZBnEhQl4GUgbbmi3IXjdn/H8gxrzHsD3XzirttPaugAvarKUUeg2cafdi0ZTxp4Lekw
nR82TuQUicGWwB3EerAGh+ojrod0gTh+2urWrQ==


`pragma protect key_keyowner = "Synopsys", key_keyname= "SNPS-VCS-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
Ng2NMCuUexlKnMvpguylNq7RAjEJHuT1qm7QIoO1f031U7eEEI/BEX+1tcF6AqblfwDsq3J54P2D
mFpcWqTH1CPiYJguP+T+lrcs+FA8mYseq5i+LXX287pWiwh/DgOxMrbviOb15U1uHenRmCAsKuj4
z4Xmo4lSXBP5ldJqJ0Y=


`pragma protect key_keyowner = "Aldec", key_keyname= "ALDEC15_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
wfoPZFsp9EUivW07iOMN4Jgih6GtoGet4cRzDFeN3pq8bVTUA3ObQenotVB+efUNMd3GKqITKMuh
ZfjuZJFPrnR7dtuJNTAmDVfqQYqy8GXBybugWVbEwtqVSRpStkN5hStCUGuuTtkUmlikegn0keeM
+/qKQUI5CrNpYi74eEVHpvx5iO0+mS3zEznKnLvBmemk23M/aF85N0ltr1R0AgwoBY3bcS6yrg4j
KIdRpJQat7b51h0/kH1Ddbsd5m0/gGRyP9Ec+35CLUAAVc29noWzftnirszjP+EsOOsfjcqxj2NF
qqNr4dGKizxfcPzkU50oIo0AsD5v9jrpRSOR5Q==


`pragma protect key_keyowner = "ATRENTA", key_keyname= "ATR-SG-2015-RSA-3", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
JiC9wE/o6Io/aM66IF0YI4c1kw2ArJ+5lyF0Zq5nRXb3qc/GtjsFzOuli4TI5BfuPCPiVQPmDnGk
2F/5Rr1p1+nqdWq8ei/GD+eaflRVxnQuR4RAnFwdhObT7gCjAzd7OwgOhIiFsWCXU95NbHZa11MF
hUcMzoXh5+EYHoqUrA3Jg6Aok7EetCcnH5ypUn6JFiGhvyuc9Mxkqoz3/tNgmcKxcD/jk4Z/a9Mj
sNoIfSrcObUWMd48S+7TzmJpMeMFQq6kPcIezpHa0eboO2Kl7P3/OFxkEy+4b2212r05FH1MMDRF
TeWUoptdAW0ALqip3ncgsh7iFn7o0P4t5nTAAQ==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-PREC-RSA", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
onhpJBg/yagehBBYRqeucjnoVvE8fEde4MHQwBlHLRi7HbaRG3l/FXxdWqFf9MCXTas8HwWxvAIo
KLsrttjKrwh+jYnpsNgx+8HP6zZB0XG/OC1pgdUST7wAmkhtTa7smBn8GRhcVrLkLzovrFp/7tnq
9coN27KisCLrytFWQ0+sco1B11c/x57T6bNE4i097g/+GF2rPX91pnOJ+vTXAoGzZCsE/Z4CTrDj
p3FqcsGzBfGn1ZhOjn5KWlU1VRlX+AajJoKToch0VdiUKcn7uX2Tc8K0OoV3XgRgWdHRSMsMmIE4
LZaCwf+BsHSnr+jej5gRCLHuH8lRjIiHKMxEqg==


`pragma protect key_keyowner = "Synplicity", key_keyname= "SYNP05_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
FhBZfo1qByn98c73RIrLeZgxtgeWDZK9KY3kgFbp0mazOhsUmq/K94ydFqZJm+tNX9iKKU3YvObN
c3RqMepWQZ+r6pq57MRPv7gg45Ix1IrpKJnO8BmyZb3vt9JEbb8TN9pML/BDr/mx3ItTdBhmO2A1
l4sPAT2sHgu/PPxp75dZuwQjhvFX3s09ENdP6YP0ox7YToigdlenIkRYufI0+HziIhvNeH7iRT6L
5VjthPvabaaAVDMaqsa8960ge8Bu2wlDP/VFlqq7U2NHPfKsHEZYlnDTIU6yWecIIr6lCKMdgogz
f8VDFse/V5V0ljdHvs+e0+v7zekL1y0e3v8k3g==


`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 2672)
`pragma protect data_block
kgAAAAAAAACn1Mzn/gcAALVEP0FYshvnN3oITzbuswSWibsFna0BytlaC2W5tRB/lmq0l0ydQA9W
uSYS70GXWHb/+eYPYSpo1vNe3Pw7Eaj5Ap6bArYec/P6gEyUlai08yfAHeDIbCjFAVMyBbr5ASjd
J6Pm+7ih5vUwJakQDwEJbuONBtnnes48jxVnIF6WWXNOWclLOiuejS/cGYBfojTSAimFsDMmoqOh
pUA4fAcwjRLLXX/qU34Hsby1EZ5dDBFfsLNQ4q3T3PXzamPcnw4wYLm2fO+sk2b/nHqQ7mN4T7UZ
fp+K+cwnk5xOLGHufUwM2mPKkNTlh6vTFxpZNFrSYdsYtg/45FJvV4lLGMgCYs5QQviWy8CHj6/+
NVLeaeMP+qWa5/o7+0UzhFg3pymthmQbbG0xmjP1ksMNd5o2D4dr9x6QQoGcnwsIrldCgbGG3vGk
xl5ap2mTDyLEsNR3RsexKW7YTphQnOcvwUkgS3eFueqrOpuZ2f4wcYaBJ8xbKSgiLgIW1SN5LoPk
2C9IvyFhMmpjPFdEX/HQQ5L2WzHsNGFL6zQPKbnxw5FjshlMGsYotmdKAvuAGg105Wlf0ETLnqxF
suX1IdRNw6/4GA/MbD6WoudLwrqPZEwiKWHdlRPVJJv2xQ+vHTsKxF6TGU0FWRHA8kifMOUk1c2U
i+YOiHHKiJP6ch+6Y409E/W1sG3gPJczVqgsItvuQMv/zAEq+8MYccFd1tEZo7ZKKjlitM5dVBV8
iQEeeuu/OGjyPkCPCUt3p/88lCdIZEgejFoIS9Dai+hUBOQylv6AM50lT4N+3X15MFj+HYNnuC2g
G+l1tr9i16+wSoXAt0PLG0WmvGgWz/fBfDbHBd06zoJMj2xE6VG0p9KeEQpezD8VYj99sEh7TiIF
pVESWE9HBN8m9zyI+jUoN/prRTLZBnuf/SxCBamigIcDYsxH9anc8ycWTdR+DtsaE8Ia5vYacClF
AVity3Jbk8N7l0U15L6uMSXqKQRr3kDd2y6hISsQPhX3y0c/wD64dB6hMhbysqPUW1CYO1YqMmAG
J+j5XJJGCfV8zfayA+55byWWseY0/YbO/l8Sk9F4WfVud2C4FwzkkhXBFpP2lDS1A2qTXdPypmkL
T/nzypP2B4H6N5Iek0glh23oU91cQcD+GJ6xN91+Pk9dJiegwaBkEDnXeeSPObHqbaGq7Ep5spAZ
RhvWPQvyUoPeRK+ryqO5rOEgnQLdlxe/OUoNzkp9zDr8h0cgCAYnwpJnnTnPWiastNWS7eboDEhb
jnC+nWgNJp9FxBDlOnIvAUD0LJPuT+HpB6+RJBxOwWzjqp9KtP2jAd7kuo9fOXiNxSw2RV0aEsGA
CJKnLPEG5hEwbTk86Q4mQn4Dn/gfqNdfDYdx+QzUEjoWcm3l3R/4ENXFR5nmx6qwlhhAT1aO4ydl
2zpXvHL4R/O+g7Z+gFuMAAlbxmvahR8t6r6ZiUpfrSaSGFu0QhVqYmZU3EbUUj4Xee7XbxXMWTSH
Bdt3gZzJjZ7Ee2qKcCR6Z5ObbhADsXCH99B4R5Kk7GmFFVW/Le+Y7csjFxqUfqKk4f/S9BzUYPCl
/FceuaY6G7zmULizx/64I5Sq5nZ5r4+M2R81hCAtJFSdu6gG22FPBppzdFCXjQeT4lVCRcfL26P6
XyL4lIutDhJYDJp0Yj/YOO6xMbmAc+0PQ9B8o1sqOwpR+0KdymHy6oWlj1Kgvlz+oQYOp9DnRwWd
lRHDjVCwT5PkAcKntzxxqtJzRKf5dcPRhVp/gvPE0e5q44eWo3zxEs6fPHRfohkfIlcgIQ1r3Ws7
bl9xpxgFAbFYIZKWHVTgCi5dz6+DQp3eqDpqfg4cL/ER0zjBEe6dKDuKmkadCfHr1aMpUA5BB75q
6wX/qhDSgy/iH9aPH3bq/c6M3P/dn1iol+Lx4+hAmrURMjjrxg6W4Bou/kuwNgG8P0CMzInH/Ypg
pQ68SAifd3k8DT1mpPS58rzUuf9ZzDZYTwaQrb0n8B6epJb29S6JOniqcCeBwZcgCllgFkkccXMl
Xv+Zk/VkLPUjIctIUXH/+3CaaEj9PwjT4xxpI8bMjSXLgJfQik5sVdpbG31s/ETgu3Y875SPeVpj
ib7ahWiRaXwUHfhnoTVo1J1vF2xwfVABNzNZw6oE6OyqSgnRIIeZgo5u1m1HzCPUbDarOKkI74AQ
MctBbzc/MXbUfyhyrBmdNT32W4FGo6wRy7fbFZ9dJe/l5hiy4SlH2HADis8ZazKOjJDTQwaSYH1Z
42Ui5yQV1WKonYpaqG7JaKI5rPViqNftHpl8WD8ybPmDakb13U8sT6Pq5vXrFmp33bs9A8TINF2o
JT5DxxMfjV8dG8q0XUHA4l0hKSrcgQAlM9fjxPqqQGIF7GXvjcv2bbud0l6etc5eVD4pbFDXPLBS
p5fh6IrPc3dapNhSKoJS647Z2J9jJnAzFVaOW+7NkIM6rFd3eKA8Spu5MuroSaOOYWwaKgQtTrVn
UDm18HLebYhk+KEjFk78wzwMfticDpEhDoNiLf//sldR/DBpnQhhltvtW1AxWdozEDxAld0AWWAm
Dki/3vHfVKMddZ9ZNu2GCKl+un+tBy7qJFLGVVxHHvA74j0MwMGi1/AQe6GWcjqxyaL3+hcUYknb
YzsufO4jFtiHAiOByVWChHBMAArUDM1LsjfKu3TzF53T2DthkcP/+jNWeycsYbFZ1BK9bo4lEkhe
BgSQ6+P5CCxa6j6pVng4jRd9s0TBF9b09s3S7GBDatMPAY6Jqwy/AdoDD3ruWoMQHlKP+9rglkE3
zmTXNEBdFEf9SKR5h9cazmdWCMA9Oo9W6XlMvtQJzWByv775xwcpV2MqTDCydfSNts+zZQ1SFZJq
Y8j0GQHb1q/p46ZJlaCZhq12JdvKe7gnBKwO1qWyuZ7QwI/VpB9kXfgf2mlMmd9uJIeACPxOBvj3
3/GDvGKoVYwvmt9du3dwvgeDgr9dXX3gj8SkEyVH1L6xf+IMkZ0cZvd+N/1ciJSwhElDVEqoi79e
X2XapqO1FuuW8GRJtV1Si0lAAZYS1P5pAQuhiwrhRty1GoMMmpzB4UtPWhu0swhyqEpEjzugQ0Ct
/UIrRsSuinHi4RgIALhL4PR1Z3/c5ia3Wu3YwebWLosIusXr+9R8DvgoumJ8zw7O4hUn3po9ui7q
I8jPz52gsGlxk8c00MYfiSyuaOVjW0xZImTgF6kZDHME2PE5jYkUVai/3XnC0VNgcWUubgDzo6Q3
1oWFjRqq4cDt2J5teBMysWk348Rw+XHUDjzMLwjeB22IRvEVeZTkQKT9tYZdZ9S9Q1pc3miCk03y
akUrfrR/iTEeQQkXbWjQQxb6I16F5HOl1jks45+3+YV9D9EiP/yyBuTwNpmRi4lZMpf4EmoS+NRU
llcL8ohhWRXjShOzBeKQfz6kRS7rQRUJpywNp/V58tUlhZ48g6BtIMy0OOaaqMQLwz5xa6QnE9XF
vee7TmGmNkIzKM4C31QWbYW2w9zMhUpphQ/XlkLRQZ/TmHsNYoIG/Q4x+8TkFx/gz1M=
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2014"
`pragma protect key_keyowner = "Cadence Design Systems.", key_keyname= "cds_rsa_key", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 64)
`pragma protect key_block
AKfUXcjzpTTjxnCbI4SxwOkZnE58D3tiocFWNrMwV722LXYd000TwYgQlk5ujoDOJF/nz/2A5T+7
AJp96SzOyA==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-VERIF-SIM-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
LtTqZrAhk/q1QkSKmDN5sJzQFskguvdU9sv0XI3ntR8Ph+NQW2YQMZ9VzZ1BUR1srieotIFN0g56
uODTIzE8j1O4d3rPhz5kRzct5VLzasxYeHmcT3tY/2D+y4+0ULlPCLGsj774+3qjbgn8x9/FiAD8
KvzOGPJPYRdZ1nGT5o4=


`pragma protect key_keyowner = "Xilinx", key_keyname= "xilinx_2014_03", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
oKiqQC6fvNitKm9dOxWFVjqnCOrHMbjRom5tTGIvKgOrkHeZlapqQPK1ubl58eT4+yPLc//jO9EE
85Znx8BZ9LRHj9pHFz166cU8LJDhUppVhJjaBhqJPQV2HKSF7cfhlvi5lxz3JNS5cfNoFMvRnpSM
Jr5e3c1S8i3f0/aDtnjx0js26KuLjp7srjQKHdb/J1DvubsWni9OKN2AY6uPvxlRWmmKu5pLXfTo
E6FmkyBCkZBnEhQl4GUgbbmi3IXjdn/H8gxrzHsD3XzirttPaugAvarKUUeg2cafdi0ZTxp4Lekw
nR82TuQUicGWwB3EerAGh+ojrod0gTh+2urWrQ==


`pragma protect key_keyowner = "Synopsys", key_keyname= "SNPS-VCS-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
Ng2NMCuUexlKnMvpguylNq7RAjEJHuT1qm7QIoO1f031U7eEEI/BEX+1tcF6AqblfwDsq3J54P2D
mFpcWqTH1CPiYJguP+T+lrcs+FA8mYseq5i+LXX287pWiwh/DgOxMrbviOb15U1uHenRmCAsKuj4
z4Xmo4lSXBP5ldJqJ0Y=


`pragma protect key_keyowner = "Aldec", key_keyname= "ALDEC15_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
wfoPZFsp9EUivW07iOMN4Jgih6GtoGet4cRzDFeN3pq8bVTUA3ObQenotVB+efUNMd3GKqITKMuh
ZfjuZJFPrnR7dtuJNTAmDVfqQYqy8GXBybugWVbEwtqVSRpStkN5hStCUGuuTtkUmlikegn0keeM
+/qKQUI5CrNpYi74eEVHpvx5iO0+mS3zEznKnLvBmemk23M/aF85N0ltr1R0AgwoBY3bcS6yrg4j
KIdRpJQat7b51h0/kH1Ddbsd5m0/gGRyP9Ec+35CLUAAVc29noWzftnirszjP+EsOOsfjcqxj2NF
qqNr4dGKizxfcPzkU50oIo0AsD5v9jrpRSOR5Q==


`pragma protect key_keyowner = "ATRENTA", key_keyname= "ATR-SG-2015-RSA-3", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
JiC9wE/o6Io/aM66IF0YI4c1kw2ArJ+5lyF0Zq5nRXb3qc/GtjsFzOuli4TI5BfuPCPiVQPmDnGk
2F/5Rr1p1+nqdWq8ei/GD+eaflRVxnQuR4RAnFwdhObT7gCjAzd7OwgOhIiFsWCXU95NbHZa11MF
hUcMzoXh5+EYHoqUrA3Jg6Aok7EetCcnH5ypUn6JFiGhvyuc9Mxkqoz3/tNgmcKxcD/jk4Z/a9Mj
sNoIfSrcObUWMd48S+7TzmJpMeMFQq6kPcIezpHa0eboO2Kl7P3/OFxkEy+4b2212r05FH1MMDRF
TeWUoptdAW0ALqip3ncgsh7iFn7o0P4t5nTAAQ==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-PREC-RSA", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
onhpJBg/yagehBBYRqeucjnoVvE8fEde4MHQwBlHLRi7HbaRG3l/FXxdWqFf9MCXTas8HwWxvAIo
KLsrttjKrwh+jYnpsNgx+8HP6zZB0XG/OC1pgdUST7wAmkhtTa7smBn8GRhcVrLkLzovrFp/7tnq
9coN27KisCLrytFWQ0+sco1B11c/x57T6bNE4i097g/+GF2rPX91pnOJ+vTXAoGzZCsE/Z4CTrDj
p3FqcsGzBfGn1ZhOjn5KWlU1VRlX+AajJoKToch0VdiUKcn7uX2Tc8K0OoV3XgRgWdHRSMsMmIE4
LZaCwf+BsHSnr+jej5gRCLHuH8lRjIiHKMxEqg==


`pragma protect key_keyowner = "Synplicity", key_keyname= "SYNP05_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
FhBZfo1qByn98c73RIrLeZgxtgeWDZK9KY3kgFbp0mazOhsUmq/K94ydFqZJm+tNX9iKKU3YvObN
c3RqMepWQZ+r6pq57MRPv7gg45Ix1IrpKJnO8BmyZb3vt9JEbb8TN9pML/BDr/mx3ItTdBhmO2A1
l4sPAT2sHgu/PPxp75dZuwQjhvFX3s09ENdP6YP0ox7YToigdlenIkRYufI0+HziIhvNeH7iRT6L
5VjthPvabaaAVDMaqsa8960ge8Bu2wlDP/VFlqq7U2NHPfKsHEZYlnDTIU6yWecIIr6lCKMdgogz
f8VDFse/V5V0ljdHvs+e0+v7zekL1y0e3v8k3g==


`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 10528)
`pragma protect data_block
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
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2014"
`pragma protect key_keyowner = "Cadence Design Systems.", key_keyname= "cds_rsa_key", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 64)
`pragma protect key_block
AKfUXcjzpTTjxnCbI4SxwOkZnE58D3tiocFWNrMwV722LXYd000TwYgQlk5ujoDOJF/nz/2A5T+7
AJp96SzOyA==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-VERIF-SIM-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
LtTqZrAhk/q1QkSKmDN5sJzQFskguvdU9sv0XI3ntR8Ph+NQW2YQMZ9VzZ1BUR1srieotIFN0g56
uODTIzE8j1O4d3rPhz5kRzct5VLzasxYeHmcT3tY/2D+y4+0ULlPCLGsj774+3qjbgn8x9/FiAD8
KvzOGPJPYRdZ1nGT5o4=


`pragma protect key_keyowner = "Xilinx", key_keyname= "xilinx_2014_03", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
oKiqQC6fvNitKm9dOxWFVjqnCOrHMbjRom5tTGIvKgOrkHeZlapqQPK1ubl58eT4+yPLc//jO9EE
85Znx8BZ9LRHj9pHFz166cU8LJDhUppVhJjaBhqJPQV2HKSF7cfhlvi5lxz3JNS5cfNoFMvRnpSM
Jr5e3c1S8i3f0/aDtnjx0js26KuLjp7srjQKHdb/J1DvubsWni9OKN2AY6uPvxlRWmmKu5pLXfTo
E6FmkyBCkZBnEhQl4GUgbbmi3IXjdn/H8gxrzHsD3XzirttPaugAvarKUUeg2cafdi0ZTxp4Lekw
nR82TuQUicGWwB3EerAGh+ojrod0gTh+2urWrQ==


`pragma protect key_keyowner = "Synopsys", key_keyname= "SNPS-VCS-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
Ng2NMCuUexlKnMvpguylNq7RAjEJHuT1qm7QIoO1f031U7eEEI/BEX+1tcF6AqblfwDsq3J54P2D
mFpcWqTH1CPiYJguP+T+lrcs+FA8mYseq5i+LXX287pWiwh/DgOxMrbviOb15U1uHenRmCAsKuj4
z4Xmo4lSXBP5ldJqJ0Y=


`pragma protect key_keyowner = "Aldec", key_keyname= "ALDEC15_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
wfoPZFsp9EUivW07iOMN4Jgih6GtoGet4cRzDFeN3pq8bVTUA3ObQenotVB+efUNMd3GKqITKMuh
ZfjuZJFPrnR7dtuJNTAmDVfqQYqy8GXBybugWVbEwtqVSRpStkN5hStCUGuuTtkUmlikegn0keeM
+/qKQUI5CrNpYi74eEVHpvx5iO0+mS3zEznKnLvBmemk23M/aF85N0ltr1R0AgwoBY3bcS6yrg4j
KIdRpJQat7b51h0/kH1Ddbsd5m0/gGRyP9Ec+35CLUAAVc29noWzftnirszjP+EsOOsfjcqxj2NF
qqNr4dGKizxfcPzkU50oIo0AsD5v9jrpRSOR5Q==


`pragma protect key_keyowner = "ATRENTA", key_keyname= "ATR-SG-2015-RSA-3", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
JiC9wE/o6Io/aM66IF0YI4c1kw2ArJ+5lyF0Zq5nRXb3qc/GtjsFzOuli4TI5BfuPCPiVQPmDnGk
2F/5Rr1p1+nqdWq8ei/GD+eaflRVxnQuR4RAnFwdhObT7gCjAzd7OwgOhIiFsWCXU95NbHZa11MF
hUcMzoXh5+EYHoqUrA3Jg6Aok7EetCcnH5ypUn6JFiGhvyuc9Mxkqoz3/tNgmcKxcD/jk4Z/a9Mj
sNoIfSrcObUWMd48S+7TzmJpMeMFQq6kPcIezpHa0eboO2Kl7P3/OFxkEy+4b2212r05FH1MMDRF
TeWUoptdAW0ALqip3ncgsh7iFn7o0P4t5nTAAQ==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-PREC-RSA", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
onhpJBg/yagehBBYRqeucjnoVvE8fEde4MHQwBlHLRi7HbaRG3l/FXxdWqFf9MCXTas8HwWxvAIo
KLsrttjKrwh+jYnpsNgx+8HP6zZB0XG/OC1pgdUST7wAmkhtTa7smBn8GRhcVrLkLzovrFp/7tnq
9coN27KisCLrytFWQ0+sco1B11c/x57T6bNE4i097g/+GF2rPX91pnOJ+vTXAoGzZCsE/Z4CTrDj
p3FqcsGzBfGn1ZhOjn5KWlU1VRlX+AajJoKToch0VdiUKcn7uX2Tc8K0OoV3XgRgWdHRSMsMmIE4
LZaCwf+BsHSnr+jej5gRCLHuH8lRjIiHKMxEqg==


`pragma protect key_keyowner = "Synplicity", key_keyname= "SYNP05_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
FhBZfo1qByn98c73RIrLeZgxtgeWDZK9KY3kgFbp0mazOhsUmq/K94ydFqZJm+tNX9iKKU3YvObN
c3RqMepWQZ+r6pq57MRPv7gg45Ix1IrpKJnO8BmyZb3vt9JEbb8TN9pML/BDr/mx3ItTdBhmO2A1
l4sPAT2sHgu/PPxp75dZuwQjhvFX3s09ENdP6YP0ox7YToigdlenIkRYufI0+HziIhvNeH7iRT6L
5VjthPvabaaAVDMaqsa8960ge8Bu2wlDP/VFlqq7U2NHPfKsHEZYlnDTIU6yWecIIr6lCKMdgogz
f8VDFse/V5V0ljdHvs+e0+v7zekL1y0e3v8k3g==


`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 3328)
`pragma protect data_block
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
zXbk1CcUbbkFvBIhKENBytGZB7sapg==
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2014"
`pragma protect key_keyowner = "Cadence Design Systems.", key_keyname= "cds_rsa_key", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 64)
`pragma protect key_block
AKfUXcjzpTTjxnCbI4SxwOkZnE58D3tiocFWNrMwV722LXYd000TwYgQlk5ujoDOJF/nz/2A5T+7
AJp96SzOyA==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-VERIF-SIM-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
LtTqZrAhk/q1QkSKmDN5sJzQFskguvdU9sv0XI3ntR8Ph+NQW2YQMZ9VzZ1BUR1srieotIFN0g56
uODTIzE8j1O4d3rPhz5kRzct5VLzasxYeHmcT3tY/2D+y4+0ULlPCLGsj774+3qjbgn8x9/FiAD8
KvzOGPJPYRdZ1nGT5o4=


`pragma protect key_keyowner = "Xilinx", key_keyname= "xilinx_2014_03", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
oKiqQC6fvNitKm9dOxWFVjqnCOrHMbjRom5tTGIvKgOrkHeZlapqQPK1ubl58eT4+yPLc//jO9EE
85Znx8BZ9LRHj9pHFz166cU8LJDhUppVhJjaBhqJPQV2HKSF7cfhlvi5lxz3JNS5cfNoFMvRnpSM
Jr5e3c1S8i3f0/aDtnjx0js26KuLjp7srjQKHdb/J1DvubsWni9OKN2AY6uPvxlRWmmKu5pLXfTo
E6FmkyBCkZBnEhQl4GUgbbmi3IXjdn/H8gxrzHsD3XzirttPaugAvarKUUeg2cafdi0ZTxp4Lekw
nR82TuQUicGWwB3EerAGh+ojrod0gTh+2urWrQ==


`pragma protect key_keyowner = "Synopsys", key_keyname= "SNPS-VCS-RSA-1", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 128)
`pragma protect key_block
Ng2NMCuUexlKnMvpguylNq7RAjEJHuT1qm7QIoO1f031U7eEEI/BEX+1tcF6AqblfwDsq3J54P2D
mFpcWqTH1CPiYJguP+T+lrcs+FA8mYseq5i+LXX287pWiwh/DgOxMrbviOb15U1uHenRmCAsKuj4
z4Xmo4lSXBP5ldJqJ0Y=


`pragma protect key_keyowner = "Aldec", key_keyname= "ALDEC15_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
wfoPZFsp9EUivW07iOMN4Jgih6GtoGet4cRzDFeN3pq8bVTUA3ObQenotVB+efUNMd3GKqITKMuh
ZfjuZJFPrnR7dtuJNTAmDVfqQYqy8GXBybugWVbEwtqVSRpStkN5hStCUGuuTtkUmlikegn0keeM
+/qKQUI5CrNpYi74eEVHpvx5iO0+mS3zEznKnLvBmemk23M/aF85N0ltr1R0AgwoBY3bcS6yrg4j
KIdRpJQat7b51h0/kH1Ddbsd5m0/gGRyP9Ec+35CLUAAVc29noWzftnirszjP+EsOOsfjcqxj2NF
qqNr4dGKizxfcPzkU50oIo0AsD5v9jrpRSOR5Q==


`pragma protect key_keyowner = "ATRENTA", key_keyname= "ATR-SG-2015-RSA-3", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
JiC9wE/o6Io/aM66IF0YI4c1kw2ArJ+5lyF0Zq5nRXb3qc/GtjsFzOuli4TI5BfuPCPiVQPmDnGk
2F/5Rr1p1+nqdWq8ei/GD+eaflRVxnQuR4RAnFwdhObT7gCjAzd7OwgOhIiFsWCXU95NbHZa11MF
hUcMzoXh5+EYHoqUrA3Jg6Aok7EetCcnH5ypUn6JFiGhvyuc9Mxkqoz3/tNgmcKxcD/jk4Z/a9Mj
sNoIfSrcObUWMd48S+7TzmJpMeMFQq6kPcIezpHa0eboO2Kl7P3/OFxkEy+4b2212r05FH1MMDRF
TeWUoptdAW0ALqip3ncgsh7iFn7o0P4t5nTAAQ==


`pragma protect key_keyowner = "Mentor Graphics Corporation", key_keyname= "MGC-PREC-RSA", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
onhpJBg/yagehBBYRqeucjnoVvE8fEde4MHQwBlHLRi7HbaRG3l/FXxdWqFf9MCXTas8HwWxvAIo
KLsrttjKrwh+jYnpsNgx+8HP6zZB0XG/OC1pgdUST7wAmkhtTa7smBn8GRhcVrLkLzovrFp/7tnq
9coN27KisCLrytFWQ0+sco1B11c/x57T6bNE4i097g/+GF2rPX91pnOJ+vTXAoGzZCsE/Z4CTrDj
p3FqcsGzBfGn1ZhOjn5KWlU1VRlX+AajJoKToch0VdiUKcn7uX2Tc8K0OoV3XgRgWdHRSMsMmIE4
LZaCwf+BsHSnr+jej5gRCLHuH8lRjIiHKMxEqg==


`pragma protect key_keyowner = "Synplicity", key_keyname= "SYNP05_001", key_method = "rsa"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 256)
`pragma protect key_block
FhBZfo1qByn98c73RIrLeZgxtgeWDZK9KY3kgFbp0mazOhsUmq/K94ydFqZJm+tNX9iKKU3YvObN
c3RqMepWQZ+r6pq57MRPv7gg45Ix1IrpKJnO8BmyZb3vt9JEbb8TN9pML/BDr/mx3ItTdBhmO2A1
l4sPAT2sHgu/PPxp75dZuwQjhvFX3s09ENdP6YP0ox7YToigdlenIkRYufI0+HziIhvNeH7iRT6L
5VjthPvabaaAVDMaqsa8960ge8Bu2wlDP/VFlqq7U2NHPfKsHEZYlnDTIU6yWecIIr6lCKMdgogz
f8VDFse/V5V0ljdHvs+e0+v7zekL1y0e3v8k3g==


`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 1392)
`pragma protect data_block
kgAAAAAAAACn1Mzn/gcAAOjCSNL+gbJKeJaaOAdAFENPpavw04l5S/Wq8y1dhlUhh/b/GKr+c4ug
dabd8orzqpNClcDcl8tLigo92sWGr9RzgC+Xa4FRLEXBF4FN68g9GAN/bh1282W03rCv7SGGUXqk
8xlEHj1sMNp5TnguWYtK6c6K5hVx+3CFXjdOfG3I5MRY2KAUjkAVcKJSQrQSVFHyGoFRT4aIZ4If
/tuvd7dp+pL8QF+62ITqKF2cP4TxboGLaq0Y7s7cqZNArQMe6AVCf75YumjLGgRYl5k7JYxiIdZQ
JKxNr/v2P6qEaEDWb1ojw1B22AuO6vqn2ZxbJD/R6ktzTRGKrfXQDdJkjfy6JL8S3tyA05djMMRq
8Nga2iDzZzqcg1FmAy9owmxyz1FbfT2dnemDuM7Oyai3dhZG3Sfs7BoZLBMfJFxsDoaq4hKi5eCz
onC+ME/kFLKaBPpevslW/eg+MzBh5kdfpiUU9RtwJ2w88Zu2P1R6uuitkaW3LD8tIMPlMkZQbduG
IOuw61wez0orSZzH3PLR+0Hl8ANXu88kx14V26Xd9cOYLNPX4Imk2UichpCac46sGvzjj+KDWiW0
rWfY1A/E/V5EwiK/49Wkvo1ZMjubWavoexy5Ct4AT9ra5XOCMIrZwJhXQFafjFblXZVF8IhwaoLk
38vAfR5G96YFHitR8jQxtRkbxOjt3BhNbiLETbsB+ZjSo2udzgBmKTWSPw/GcbJfybVaJnbKGGWR
bzr2CNJHkBfos3gXMAKhEWtNO5svcMgOWuq1YoH2IK4Af/1Ydu+FNufaylo9xkM7KUUl57/TRySe
1DV/Tmm2oFsSLyF2ULxcFF+t2bxHlq8el+hiQv2O4iu+TZ0jmIriHPj3p4976oFaRoRJVLTWxYPn
6/CtSE5Mr7fmNbzQ5NoK2qox0+i/ZOv9HKJhlSEol7SGqBkmdVyA7dKSTZ9PmaZe/uJR5bRsseOv
i5jDAnVwgRY9guqX9AaGCIk/QDIWv3lSrw6IWV1t/WMAIfc3YjoCY5RCBJA3qoPhJojk++pvO9Td
leeriEJ6oRcVlN/j1irEc3Z/vFsm5lxeR8o9REoOpbuslII4D5tJ3rCm7mskgq0UBhTqQjbsmVZH
iARQgRVdX/xNv1mAxojJ6DDdaoVzMJ1BlabGyfD5ITxqEWRkhgBCEC3JOI6xkXNI9aAoqJB46Z2W
iwb40ozxyzKNQFMGbivQoTt39Qul/8fAjau7Bb8UhJaE6Sz6VzA4M6kVvTC6YLQXpFl9tXAemU4R
rz9BiMcDK2+H0ZWbNLsbUUsFa/VWiaDSPDAp5yKRTIfwWVjzG/0AZvCyhH35mR5gOIGh0md5FTcy
KYKUaAPpjKVpLqHyYJgiA5cu3IEaJpCsRgCxh5WQBg9A7Ec9FYNgWvloXZPBNGenUhBX9efdA6ua
hoIIWu6J81fA53TAwpLrymz+8319pfb6hMr7kgFQGCc455SjVn10ptE3/rUjtyW1WV0bw8UnPBVH
sGsqvN6qPcOpna8vWJxrKKVVelP9UVDmmDk5LT6NyVsmfkRSPgya3B+J1Iw1E8mBNGPXrj2Jw83W
g3t+DH5yzsDTrIBTvxCbA9+LuDUe0ZmK0phYtoIGhb/7ClEL8ENvtHKrw1TY3INzwc56dOWqT/VK
0uPKDq9RyPpxbjwTbg87rdrjrDd4EtdvFq7wTjBgaoYAzng2qttWSfoG30r5XMegcVWzkP8ycOPl
mmHgvteVEyWPHnpsE87Shcbi0Lque4jTBUiPfWVcGleNlq49oRVQv3HTX2awzpWGUsGoJk7c4avk
KM7FGljX+c/KoafaY44kA4tkgmDer20B
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
