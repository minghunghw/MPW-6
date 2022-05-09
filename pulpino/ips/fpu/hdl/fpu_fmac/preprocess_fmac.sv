// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
////////////////////////////////////////////////////////////////////////////////
// Company:        IIS @ ETHZ - Federal Institute of Technology               //
//                                                                            //
// Engineers:      Lei Li  lile@iis.ee.ethz.ch                                //
//		                                                              //
// Additional contributions by:                                               //
//                                                                            //
//                                                                            //
//                                                                            //
// Create Date:    01/12/2016                                                 // 
// Design Name:    fmac                                                       //
// Module Name:    preprocess_fmac.sv                                         //
// Project Name:   Private FPU                                                //
// Language:       SystemVerilog                                              //
//                                                                            //
// Description:    Disassemble operands and operand detection                 //
//                                                                            //
//                                                                            //
//                                                                            //
// Revision:        13/09/2017                                                //
//                  Added some signals for normalization by Lei Li            //
////////////////////////////////////////////////////////////////////////////////

import fpu_defs_fmac::*;

module preprocess_fmac
  (//Inputs
   input logic [C_OP-1:0]          Operand_a_DI,
   input logic [C_OP-1:0]          Operand_b_DI,
   input logic [C_OP-1:0]          Operand_c_DI,
   //Outputs
   output logic [C_EXP-1:0]        Exp_a_DO,
   output logic [C_MANT:0]         Mant_a_DO,
   output logic                    Sign_a_DO,
   output logic [C_EXP-1:0]        Exp_b_DO,
   output logic [C_MANT:0]         Mant_b_DO,
   output logic                    Sign_b_DO,
   output logic [C_EXP-1:0]        Exp_c_DO,
   output logic [C_MANT:0]         Mant_c_DO,
   output logic                    Sign_c_DO,
   output logic                    Inf_a_SO,
   output logic                    Inf_b_SO,
   output logic                    Inf_c_SO,
   output logic                    Zero_a_SO,
   output logic                    Zero_b_SO,
   output logic                    Zero_c_SO,
   output logic                    NaN_a_SO,
   output logic                    NaN_b_SO,
   output logic                    NaN_c_SO,
   output logic                    DeN_a_SO,
   output logic                    DeN_b_SO,
   output logic                    DeN_c_SO
   );

   //Hidden Bits
   logic                        Hb_a_D;
   logic                        Hb_b_D;
   logic                        Hb_c_D;

   /////////////////////////////////////////////////////////////////////////////
   // Disassemble operands                                                    //
   /////////////////////////////////////////////////////////////////////////////

   assign Sign_a_DO = Operand_a_DI[C_OP-1];
   assign Sign_b_DO = Operand_b_DI[C_OP-1];
   assign Sign_c_DO = Operand_c_DI[C_OP-1];
   assign Exp_a_DO  = DeN_a_SO?C_EXP_ONE:Operand_a_DI[C_OP-2:C_MANT];
   assign Exp_b_DO  = DeN_b_SO?C_EXP_ONE:Operand_b_DI[C_OP-2:C_MANT];
   assign Exp_c_DO  = DeN_c_SO?C_EXP_ONE:Operand_c_DI[C_OP-2:C_MANT];
   assign Mant_a_DO = {Hb_a_D,Operand_a_DI[C_MANT-1:0]};
   assign Mant_b_DO = {Hb_b_D,Operand_b_DI[C_MANT-1:0]};
   assign Mant_c_DO = {Hb_c_D,Operand_c_DI[C_MANT-1:0]};
   assign Hb_a_D = | Operand_a_DI[C_OP-2:C_MANT]; // hidden bit
   assign Hb_b_D = | Operand_b_DI[C_OP-2:C_MANT]; // hidden bit
   assign Hb_c_D = | Operand_c_DI[C_OP-2:C_MANT]; // hidden bit

   /////////////////////////////////////////////////////////////////////////////
   // preliminary checks for infinite/zero/NaN/DeN operands                   //
   /////////////////////////////////////////////////////////////////////////////
   logic                        Mant_a_zero_S;
   logic                        Mant_b_zero_S;
   logic                        Mant_c_zero_S;
   assign Mant_a_zero_S=(Operand_a_DI[C_MANT-1:0] == C_MANT_ZERO);
   assign Mant_b_zero_S=(Operand_b_DI[C_MANT-1:0] == C_MANT_ZERO);
   assign Mant_c_zero_S=(Operand_c_DI[C_MANT-1:0] == C_MANT_ZERO);

   logic                       Exp_a_zero_S;
   logic                       Exp_b_zero_S;
   logic                       Exp_c_zero_S;
   assign Exp_a_zero_S=~Hb_a_D;
   assign Exp_b_zero_S=~Hb_b_D;
   assign Exp_c_zero_S=~Hb_c_D;

   logic                       Exp_a_Inf_NaN_S;
   logic                       Exp_b_Inf_NaN_S;
   logic                       Exp_c_Inf_NaN_S;
   assign Exp_a_Inf_NaN_S=(Exp_a_DO == C_EXP_INF);
   assign Exp_b_Inf_NaN_S=(Exp_b_DO == C_EXP_INF);
   assign Exp_c_Inf_NaN_S=(Exp_c_DO == C_EXP_INF);
   assign Zero_a_SO = Exp_a_zero_S&&Mant_a_zero_S;
   assign Zero_b_SO = Exp_b_zero_S&&Mant_b_zero_S;
   assign Zero_c_SO = Exp_c_zero_S&&Mant_c_zero_S;
   assign Inf_a_SO = Exp_a_Inf_NaN_S&&Mant_a_zero_S;
   assign Inf_b_SO = Exp_b_Inf_NaN_S&&Mant_b_zero_S;
   assign Inf_c_SO = Exp_c_Inf_NaN_S&&Mant_c_zero_S;
   assign NaN_a_SO = Exp_a_Inf_NaN_S&&(~Mant_a_zero_S);
   assign NaN_b_SO = Exp_b_Inf_NaN_S&&(~Mant_b_zero_S);
   assign NaN_c_SO = Exp_c_Inf_NaN_S&&(~Mant_c_zero_S);
   assign DeN_a_SO = Exp_a_zero_S&&(~Mant_a_zero_S);
   assign DeN_b_SO = Exp_b_zero_S&&(~Mant_b_zero_S);
   assign DeN_c_SO = Exp_c_zero_S&&(~Mant_c_zero_S);

endmodule
