////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: O.40d
//  \   \         Application: netgen
//  /   /         Filename: Acc12x20.v
// /___/   /\     Timestamp: Fri Jun 24 16:42:09 2011
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -w -sim -ofmt verilog X:/xilinx/mksuii_x/ipcore_dir/tmp/_cg/Acc12x20.ngc X:/xilinx/mksuii_x/ipcore_dir/tmp/_cg/Acc12x20.v 
// Device	: 5vlx30tff665-1
// Input file	: X:/xilinx/mksuii_x/ipcore_dir/tmp/_cg/Acc12x20.ngc
// Output file	: X:/xilinx/mksuii_x/ipcore_dir/tmp/_cg/Acc12x20.v
// # of Modules	: 1
// Design Name	: Acc12x20
// Xilinx        : C:\Xilinx\13.1\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module Acc12x20 (
  clk, ce, bypass, q, b
)/* synthesis syn_black_box syn_noprune=1 */;
  input clk;
  input ce;
  input bypass;
  output [19 : 0] q;
  input [11 : 0] b;
  
  // synthesis translate_off
  
  wire N0;
  wire \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ;
  wire [18 : 0] \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple ;
  wire [19 : 0] \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum ;
  wire [20 : 1] \NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output ;
  wire [19 : 0] \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple ;
  assign
    q[19] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [20]
,
    q[18] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [19]
,
    q[17] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [18]
,
    q[16] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [17]
,
    q[15] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [16]
,
    q[14] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [15]
,
    q[13] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [14]
,
    q[12] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [13]
,
    q[11] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [12]
,
    q[10] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [11]
,
    q[9] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [10]
,
    q[8] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [9]
,
    q[7] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [8]
,
    q[6] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [7]
,
    q[5] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [6]
,
    q[4] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [5]
,
    q[3] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [4]
,
    q[2] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [3]
,
    q[1] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [2]
,
    q[0] = 
\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [1]
;
  GND   XST_GND (
    .G(N0)
  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_1  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [0]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [1])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_2  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [1]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [2])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_3  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [2]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [3])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_4  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [3]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [4])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_5  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [4]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [5])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_6  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [5]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [6])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_7  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [6]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [7])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_8  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [7]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [8])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_9  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [8]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [9])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_10  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [9]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [10])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_11  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [10]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [11])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_12  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [11]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [12])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_13  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [12]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [13])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_14  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [13]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [14])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_15  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [14]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [15])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_16  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [15]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [16])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_17  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [16]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [17])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_18  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [17]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [18])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_19  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [18]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [19])

  );
  FDE #(
    .INIT ( 1'b0 ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output_20  (
    .C(clk),
    .CE(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg ),
    .D
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [19]),
    .Q
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [20])

  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[18].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [17])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [18]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [18])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[18].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [17])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [18]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [18])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[17].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [16])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [17]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [17])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[17].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [16])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [17]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [17])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[16].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [15])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [16]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [16])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[16].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [15])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [16]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [16])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[15].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [14])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [15]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [15])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[15].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [14])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [15]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [15])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[14].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [13])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [14]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [14])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[14].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [13])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [14]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [14])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[13].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [12])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [13]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [13])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[13].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [12])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [13]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [13])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[12].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [11])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [12]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [12])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[12].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [11])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [12]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [12])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[11].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [10])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [11]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [11])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[11].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [10])
,
    .DI(b[11]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [11]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [11])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[10].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [9]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [10]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [10])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[10].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [9]),
    .DI(b[10]),
    .S
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [10]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [10])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[9].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [8]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [9]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [9])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[9].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [8]),
    .DI(b[9]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [9])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [9])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[8].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [7]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [8]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [8])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[8].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [7]),
    .DI(b[8]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [8])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [8])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[7].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [6]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [7]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [7])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[7].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [6]),
    .DI(b[7]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [7])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [7])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[6].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [5]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [6]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [6])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[6].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [5]),
    .DI(b[6]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [6])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [6])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[5].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [4]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [5]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [5])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[5].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [4]),
    .DI(b[5]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [5])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [5])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[4].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [3]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [4]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [4])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[4].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [3]),
    .DI(b[4]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [4])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [4])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[3].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [2]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [3]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [3])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[3].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [2]),
    .DI(b[3]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [3])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [3])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[2].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [1]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [2]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [2])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[2].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [1]),
    .DI(b[2]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [2])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [2])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[1].carryxor  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [0]),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [1]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [1])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carrychaingen[1].carrymux  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [0]),
    .DI(b[1]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [1])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [1])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.i_gt_1.carryxortop  (
    .CI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [18])
,
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [19]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [19])
  );
  XORCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.carryxor0  (
    .CI(N0),
    .LI
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [0]),
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/sum_simple [0])
  );
  MUXCY 
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_simple_model.carrymux0  (
    .CI(N0),
    .DI(b[0]),
    .S(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [0])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/carry_simple [0])
  );
  LUT2 #(
    .INIT ( 4'hE ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg1  (
    .I0(ce),
    .I1(bypass),
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/ce_reg )
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<19>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [20])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [19])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<18>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [19])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [18])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<17>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [18])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [17])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<16>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [17])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [16])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<15>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [16])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [15])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<14>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [15])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [14])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<13>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [14])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [13])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<12>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [13])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [12])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<11>1  (
    .I0(b[11]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [12])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [11])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<10>1  (
    .I0(b[10]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [11])
,
    .O
(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [10])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<9>1  (
    .I0(b[9]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [10])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [9])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<8>1  (
    .I0(b[8]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [9])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [8])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<7>1  (
    .I0(b[7]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [8])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [7])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<6>1  (
    .I0(b[6]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [7])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [6])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<5>1  (
    .I0(b[5]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [6])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [5])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<4>1  (
    .I0(b[4]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [5])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [4])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<3>1  (
    .I0(b[3]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [4])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [3])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<2>1  (
    .I0(b[2]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [3])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [2])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<1>1  (
    .I0(b[1]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [2])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [1])
  );
  LUT3 #(
    .INIT ( 8'h9A ))
  \U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum<0>1  (
    .I0(b[0]),
    .I1(bypass),
    .I2
(\NlwRenamedSig_OI_U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/i_q.i_simple.qreg/fd/output [1])
,
    .O(\U0/i_synth/i_baseblox.i_baseblox_accum/i_gen_accum_fabric.i_accum_fabric/the_addsub/no_pipelining.the_addsub/i_lut6.i_lut6_addsub/halfsum [0])
  );

// synthesis translate_on

endmodule

// synthesis translate_off

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

// synthesis translate_on
