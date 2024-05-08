`timescale 1ns / 1ps

module decoder_3x8(
    input [2:0] dec_in,
    output [7:0] dec_out
    );
    assign dec_out = 1 << dec_in ; //shift left the input with 1, generating signals from 0 to 7
endmodule
