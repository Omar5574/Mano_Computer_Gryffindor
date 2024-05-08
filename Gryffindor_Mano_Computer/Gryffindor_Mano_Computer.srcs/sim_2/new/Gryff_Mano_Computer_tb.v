`timescale 1ns / 1ps
//[01.] Declare top level tb Module
module Gryff_Mano_Computer_tb();
    //[02.] Declare Values
    //remember: input -> reg , output/inout -> Wire
    reg master_clock_tb = 0;
    wire [11:0] AR_tb, PC_tb;
    wire [15:0] DR_tb, AC_tb, IR_tb, T_tb;
    wire [7:0] D_tb;
    wire E_tb;
    
    /*[03.] Instantiate DUT: 
      remember: main module name + instance name */
      Gryff_Mano_Computer Gryff_Mano_Computer_tb( 
          // .main module port(testbench signal)
          .master_clock(master_clock_tb), 
          .T(T_tb), 
          .D(D_tb), 
          .AR(AR_tb), 
          .PC(PC_tb), 
          .DR(DR_tb), 
          .AC(AC_tb), 
          .IR(IR_tb), 
          .E(E_tb)
          );
      //[04.] Put Initial values
      initial begin 
              master_clock_tb = 0;
      end
      always #5 master_clock_tb = ~master_clock_tb;
      //[05.] Checker Code
      
endmodule