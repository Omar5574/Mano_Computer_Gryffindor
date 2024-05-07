`timescale 1ns / 1ps

module reg_8(
    input       [7:0]  D,
    output reg  [7:0]  Q,
    input               CLK,
    input               NCLR,
    input               LD,
    input               INR
    );
    
    initial begin
        Q <= 0;
    end
    
    always @ (posedge CLK)
        if (!NCLR)
            Q <= 0;
            else begin
                if(LD)
                    Q <= D;
                else if (INR)
                    Q <= Q + 1;
            end
endmodule
