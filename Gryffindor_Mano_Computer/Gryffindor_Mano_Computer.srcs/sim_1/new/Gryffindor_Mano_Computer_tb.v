`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2024 01:57:17 PM
// Design Name: 
// Module Name: Gryffindor_Mano_Computer_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Gryffindor_Mano_Computer_tb();

    reg master_clock_tb = 0;
    wire [11:0] AR_tb, PC_tb;
    wire [15:0] DR_tb, AC_tb, IR_tb, TR_tb, T_tb;
    wire [7:0] D_tb, OUTR_tb, INPR_tb;
    wire E_tb, R_tb, FGI_tb, FGO_tb, IEN_tb;
    
    Gryff_Mano_Computer Gryff_Mano_Computer_tb( 
    .master_clock(master_clock_tb), 
    .IEN(IEN_tb), 
    .T(T_tb), 
    .D(D_tb), 
    .AR(AR_tb), 
    .PC(PC_tb), 
    .DR(DR_tb), 
    .AC(AC_tb), 
    .IR(IR_tb), 
    .TR(TR_tb), 
    .INPR(INPR_tb), 
    .OUTR(OUTR_tb), 
    .R(R_tb), 
    .FGI(FGI_tb), 
    .FGO(FGO_tb), 
    .E(E_tb)
    );
      initial begin 
        master_clock_tb = 0;
      end
    always #10 master_clock_tb = ~master_clock_tb;
    
endmodule

