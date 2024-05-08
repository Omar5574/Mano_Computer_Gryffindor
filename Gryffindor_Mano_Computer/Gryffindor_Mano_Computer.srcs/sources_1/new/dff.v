`timescale 1ns / 1ps

module dff 	( input D,
              input NCLR,
              input CLK,
              input LD,
              output reg Q
              );
              
    initial Q = 0;

	always @ (posedge CLK)
       if (!NCLR)
          Q <= 0;
       else if (LD)
          Q <= D;
endmodule
