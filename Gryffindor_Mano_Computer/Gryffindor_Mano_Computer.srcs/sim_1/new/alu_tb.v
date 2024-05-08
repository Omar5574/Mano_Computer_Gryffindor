`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 02:17:01 AM
// Design Name: 
// Module Name: alu_tb
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

//[01.] Declare top level tb Module
module alu_tb();
    //[02.] Declare Values
    //remember: input -> reg , output/inout -> Wire
        reg [15:0]  DR;
        reg [15:0]  in_AC;
        reg         in_E;
        reg [7:0]   D;
        reg [15:0]  IR;
        reg [15:0]  T;
        wire [3:0] INR;
        wire E;
        wire S;
        wire [15:0] AC;
    //[03.] Instantiate DUT
    //remember: main module name + instance name
    arithmetic_logic_unit alu_tb(
        .DR(DR),
        .in_AC(in_AC),
        .in_E(in_E),
        .D(D),
        .T(T),
        .INR(INR),
        .E(E),
        .S(S),
        .AC(AC)
    );
    //[04.] Put Initial values
    initial begin
        D = 8'b00100000;
        #10 D = 8'b00000001;
        #10 D = 8'b00000010;
        #10 D = 8'b00000100;
    end
    //[05.] Checker Code

endmodule
