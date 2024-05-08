`timescale 1ns / 1ps

module decoder_tb();
    reg [2:0] dec_in_tb;
    wire [7:0] dec_out_tb;
    integer i;
    
    decoder_3x8 decoder_tb(
        .dec_in(dec_in_tb),
        .dec_out(dec_out_tb)
    );
    initial begin  
       for ( i=0; i<16; i=i+1) 
            begin
               dec_in_tb  = i;
                #1;
            end
    end
endmodule
