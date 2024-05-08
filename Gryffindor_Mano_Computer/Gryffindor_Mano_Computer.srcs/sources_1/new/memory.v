`timescale 1ns / 1ps

module memory(
    input memory_read, // Read signal'
    input memory_write, // Write signal'
    input [11:0] address_bus,
    input [15:0] memory_in_data,
    output reg [15:0] memory_out_data
    );
    
    //[00.] INITIATE SOME VARIABLES
    reg [15:0] temp_data;
    reg [15:0] stored_memory_words [4095:0]; //memory word is 16-bit and repeated 4kb times in one column [4KB x 16]
    
    //[01.] INITIATE MEMORY LOCATION AND STORE DATA
    initial begin 
        $readmemh ("E:/Microprocessor_Verilog/Gryffindor_Mano_Computerr_V2/Gryffindor_Mano_Computer/memory.txt" , stored_memory_words );
    end
    
    //[02.] SPECIFY MEMORY BEHAVIOR
    always @(*) begin
        if (memory_write && ~memory_read) //w=1 && r=0
        // in [WRITE MODE], store the data from the data_bus to the stored_memory_words
            stored_memory_words[address_bus] <= memory_in_data; // DB <- M[AB]
        else if (~memory_write && memory_read) //w=0 && r=1
        // in [READ MODE], 1. Get the data from stored_memory_words, 2. Store it into memory_out_data register
            memory_out_data = stored_memory_words[address_bus];
    end
endmodule
