`timescale 1ns / 1ps

module memory_tb();                
    //[02.] Declare Values
                      //remember: input -> reg , output/inout -> Wire
                          
                      reg CLK_tb , memory_read_tb , memory_write_tb;
                      reg [11:0] address_bus_tb;
                      reg [15:0] memory_in_data_tb;
                      wire [15:0] memory_out_data_tb;
                      
                      //[03.] Instantiate DUT
                      //remember: main module name + instance name
                     memory memory_tb( 
                        // .main module port(testbench signal)
                        .CLK(CLK_tb), 
                        .memory_read(memory_read_tb), 
                        .memory_write(memory_write_tb), 
                        .address_bus(address_bus_tb), 
                        .memory_in_data(memory_in_data_tb), 
                        .memory_out_data(memory_out_data_tb)
                        );
                          
                      //[04.] Put Initial values
                      always begin
                          #5 CLK_tb = ~CLK_tb; //Clock changes every 5ns
                      end
                      //[READ] data_bus_tb = (ZZZZ)h , Preventing it from having an actual value
                      //[WRITE] data_bus_tb = data_in_tb
                      
                      //[05.] Checker Code
                      initial begin
                          CLK_tb = 0;
                          memory_in_data_tb = 16'h247B;
                          /*
                          [NOTE]
                          Step (1): determine you are reading or writing
                          Step (2): determine the address you want to read/write from/in it
                          */
                          //1. Read address location 0 value, "which was in memory_words.txt" then we stored it in the memory [4002]
                          memory_write_tb = 0;
                          memory_read_tb = 1;
                          address_bus_tb = 0;
                          //2. Write 247B "as data_bus=247B" to location 0 after 10ns
                          #10 memory_write_tb = 1;
                              memory_read_tb = 0;
                          //3. Read address location 1 value
                          #10 memory_write_tb = 0;
                              memory_read_tb = 1;
                          #10 address_bus_tb = 1;
                          //4. Continue Reading address location 2,3,4,5 values
                          #10 address_bus_tb = 2;
                          #10 address_bus_tb = 3;
                          #10 address_bus_tb = 4;
                          #10 address_bus_tb = 5;
                      end
endmodule
