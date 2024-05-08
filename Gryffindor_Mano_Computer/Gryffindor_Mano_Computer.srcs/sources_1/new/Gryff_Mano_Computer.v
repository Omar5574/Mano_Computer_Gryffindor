`timescale 1ns / 1ps

/*
========================Gryff_Mano_Computer============================
Inputs:
    [00.] master_clock : master clock source
Outputs:
    [01.] T        : decoder output of SC[15:0] {T0,T1,....,T15}
    [02.] D        : decoder output of IR[14:12] {D0,D1,....,D7} [DONE]
    [03.] AR   : Address Register       Output Value [DONE]
    [04.] PC   : Program Counter        Output Value [DONE]
    [05.] DR   : Data Register          Output Value [DONE]
    [06.] AC   : Accumulator            Output Value
    [07.] E    : Extended Flag          Output Value
    [08.] IR   : Instruction Register   Output Value
*/

module Gryff_Mano_Computer #(parameter N_L = 16, N_M = 12 , N_S = 8)( 
                             input                  master_clock,
                             output      [15:0]     T,
                             output wire [7:0]      D,
                             output wire            E,
                             output wire [11:0]     AR,
                             output wire [11:0]     PC,
                             output wire [15:0]     DR,
                             output wire [15:0]     AC,
                             output wire [15:0]     IR
                             );
    wire [15:0] common_bus;
    wire [3:0] INR;        //increament, Each bit of INR could be controlling the increment operation of a different register [operation will be done in ALU]
    wire [15:0] B = IR;  // equals the IR output [used in Register and I/O Reference]
    wire J = IR[15];        // Indirect Flag
    wire S;                 // Stop Flag [used in sequence counter]
    
    // [03.] AR   : Address Register
    wire [11:0] in_AR = common_bus; // Data input from common bus
    wire AR_clk = master_clock;
    wire AR_INR = INR[0]; //bit [0] of INR is controlling the increment operation of Address Register
    wire AR_LD = T[0] || T[2] || (~(D[7]) && J && T[3]); //From table 5-6 "AR <-"
    wire AR_CLRn = 1;    // CLR Complement
    //reg_12 instantiation
        register_12 address_register(
            .D(in_AR),      // Data input
            .Q(AR),         // Data output
            .CLK(AR_clk),   // Clock input
            .NCLR(AR_CLRn), // Asynchronous clear (active low)
            .LD(AR_LD),     // Load
            .INR(AR_INR)    // Increment
        );
    
    // [04.] PC   : Program Counter
    wire [11:0] in_PC = common_bus; // Data input from common bus
    wire PC_clk = master_clock;
    wire PC_INR = INR[1]; //bit [1] of INR is controlling the increment operation of Program Counter
    wire PC_LD = (D[4] && T[4]) || (D[5] && T[5]);   //From table 5-6 "PC <-"
    wire PC_CLRn = 1;    // CLR from table 5-6 then Complement
    //reg_12 instantiation
        register_12 program_counter(
            .D(in_PC),      // Data input
            .Q(PC),         // Data output
            .CLK(PC_clk),   // Clock input
            .NCLR(PC_CLRn), // Asynchronous clear (active low)
            .LD(PC_LD),     // Load
            .INR(PC_INR)    // Increment
        );
        
     // [05.] DR   : Data Register Value
     wire [15:0] in_DR = common_bus; // Data input from common bus
     wire DR_clk = master_clock;
     wire DR_INR = INR[2]; //bit [2] of INR is controlling the increment operation of Data Register
     wire DR_LD = (D[0] && T[4]) || (D[1] && T[4]) || (D[2] && T[4]) || (D[6] && T[4]);   //From table 5-6 "DR <-"
     wire DR_CLRn = 1;    // CLR from table 5-6 then Complement
        register_16 data_register(
           .D(in_DR),      // Data input
           .Q(DR),         // Data output
           .CLK(DR_clk),   // Clock input
           .NCLR(DR_CLRn), // Asynchronous clear (active low)
           .LD(DR_LD),     // Load
           .INR(DR_INR)    // Increment
         );
         
    // [06.] AC   : Accumulator Register Value
    wire [15:0] in_AC; // ACC input from common bus
    wire AC_clk = master_clock;
    wire AC_INR = INR[3]; //bit [3] of INR is controlling the increment operation of Accumulator Register
    wire AC_LD = (D[0] && T[5]) || (D[1] && T[5]) || (D[2] && T[5]) || ((D[7] && (~J) && T[3]/*r*/) && B[9]) || ((D[7] && (~J) && T[3]/*r*/) && B[7]) || ((D[7] && (~J) && T[3]/*r*/) && B[6]); //From table 5-6 "AC <-"
    wire AC_CLRn;    // CLR from table 5-6 then Complement
         register_16 Accumulator_register(
            .D(in_AC),   // Data input
            .Q(AC),         // Data output
            .CLK(AC_clk),   // Clock input
            .NCLR(AC_CLRn), // Asynchronous clear (active low)
            .LD(AC_LD),     // Load
            .INR(AC_INR)    // Increment
         );
         
    // [07.] E    : Extended Flag
    wire in_E; // Extended input from common bus
    wire E_clk = master_clock;
    wire E_LD = (D[1] && T[5]) || ((D[7] && (~J) && T[3]/*r*/) && B[8]) || ((D[7] && (~J) && T[3]/*r*/) && B[6]);   //From table 5-6 "E <-"
    wire E_CLRn;    // CLR from table 5-6 then Complement
         dff Extended_flag (
            .D(in_E),      // Data input
            .Q(E),         // Data output
            .CLK(E_clk),   // Clock input
            .NCLR(E_CLRn), // Asynchronous clear (active low)
            .LD(E_LD)      // Load
         );
         
    // [09.] IR   : Instruction Register Value
    wire [15:0] in_IR = common_bus; // Instruction input from common bus
    wire IR_clk = master_clock;
    wire IR_INR = 0; 
    wire IR_LD = T[1];   //From table 5-6 "IR <-"
    wire IR_CLRn = 1;    // CLR from table 5-6 then Complement
         register_16 instruction_register(
              .D(in_IR),      // Instruction input
              .Q(IR),         // Instruction output
              .CLK(IR_clk),   // Clock input
              .NCLR(IR_CLRn), // Asynchronous clear (active low)
              .LD(IR_LD),     // Load
              .INR(IR_INR)    // Increment
         );
         
    // [--] Decoder 3x8
    
    decoder_3x8 d_generator (
            .dec_in(IR[14:12]), // decoder 3x8 <- IR[14:12]
            .dec_out(D)         //{D0,D1,....,D7}
    );
    
    // [--] Memory
    wire [15:0] memory_in_data = common_bus;
    wire [15:0] memory_out_data;
    wire memory_read = T[1] || ((~D[7]) && J && T[3]) || (D[0] && T[4]) || (D[1] && T[4]) || (D[2] && T[4]) || (D[6] && T[4]); // read from memory " XX <- M[AR] "
    wire memory_write = (D[3] && T[4]) || (D[5] && T[4]) || (D[6] && T[6]);   // write into memory " M[AR] <- XX "
        memory SRAM (
            .address_bus(AR),
            .memory_read(memory_read),
            .memory_write(memory_write),
            .memory_in_data(memory_in_data),
            .memory_out_data(memory_out_data)
        );
    // [--] Selection Line       
    
        wire [7:0] EN;
        assign  EN[0] = 0;                                                // Adder & Logic
        assign  EN[1] = (D[4] && T[4]) || (D[5] && T[5]);                 // AR
        assign  EN[2] = T[0] || (D[5] && T[4]);                           // PC
        assign  EN[3] = (D[2] && T[5]) || (D[6] && T[6]);                 // DR
        assign  EN[4] = D[3] && T[4];                                     // AC
        assign  EN[5] = T[2];                                             // IR
        assign  EN[6] = 0;
        assign  EN[7] = memory_read;                                      // Memory
        Selection_Line select_line (
            .AR({4'b0000, AR}),
            .PC({4'b0000, PC}), 
            .DR(DR), 
            .AC(AC), 
            .IR(IR),
            .Memory(memory_out_data),
            .selection(EN),
            .bus(common_bus)
        );
        // [--] Arithmetic and Logic Unit (ALU)
        
         arithmetic_logic_unit ALU(
           .DR(DR),
           .AC(in_AC),
           .D(D),
           .in_E(E),
           .E(in_E), 
           .S(S),
           .IR(IR),
           .T(T),
           .INR(INR),
           .in_AC(AC),
           .AC_CLRn(AC_CLRn)
         );
        
    // [--] Sequence Counter
    wire sc_clk= S && master_clock;
    wire sc_RSTn = ~( (D[0] && T[5]) || (D[1] && T[5]) || (D[2] && T[5]) || (D[3] && T[4]) || (D[4] && T[4]) || (D[5] && T[5]) || (D[6] && T[6]) || (D[7] && ~(J) && T[3])/*r*/ ); //From table 5-6
        Sequence_Counter S_counter(
            .clk(sc_clk),
            .RSTn(sc_RSTn),
            .counter(T)
            );
endmodule