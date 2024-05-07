`timescale 1ns / 1ps

module Selection_Line(
    input        CLK,
    input [15:0] AR,
    input [15:0] PC,
    input [15:0] DR,
    input [15:0] AC,
    input [15:0] IR,
    input [15:0] Memory,
    input [7:0] selection,
    output reg [15:0] bus	        
);

    always@(posedge CLK) begin
		case(selection)
		  0   : bus	 = 0;
		  2   : bus	 = AR;
		  4   : bus	 = PC;
		  8   : bus	 = DR;
		  16  : bus	 = AC;
		  32  : bus	 = IR;
		  64  : bus  = 0;
		  128 : bus	 = Memory;
          default : bus	 = 0;
        endcase
     end
endmodule
