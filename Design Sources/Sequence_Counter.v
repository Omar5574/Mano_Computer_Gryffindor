`timescale 1ns / 1ps

module Sequence_Counter(
        input clk,
        input RSTn,
        output [15:0] counter
    );
    reg [15:0] i = 0;
    
        always @ (posedge clk) begin
            if (!RSTn)
                i <= 16'b0;
            else
                i <= i + 1;
        end
        
        assign counter = 1 << i;
        
endmodule
