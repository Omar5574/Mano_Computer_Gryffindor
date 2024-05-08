`timescale 1ns / 1ps

module arithmetic_logic_unit( input [15:0] DR, in_AC,
                                input in_E,
                                input [7:0] D,
                                input [15:0] IR,
                                input [15:0] T,
                                output [3:0] INR,
                                output reg E,
                                output reg S,
                                output reg [15:0] AC
                                );
                                
    reg INR_CONDITIONS;
    assign INR[0] = (D[5] && T[4]); //AR
    assign INR[1] = T[1] || ((D[7] && (~IR[15]) && T[3]/*r*/) && IR[4] && INR_CONDITIONS) || ((D[7] && (~IR[15]) && T[3]/*r*/) && IR[3] && INR_CONDITIONS) || ((D[7] && (~IR[15]) && T[3]/*r*/) && IR[2] && INR_CONDITIONS) || ((D[7] && (~IR[15]) && T[3]/*r*/) && IR[1] && INR_CONDITIONS) || (D[6] && T[6] && INR_CONDITIONS); //PC
    assign INR[2] = (D[6] && T[5]); //DR
    assign INR[3] = ((D[7] && (~IR[15]) && T[3]/*r*/) && IR[5]); //AC
    

    initial begin
        S = 1;
    end

    always @*
    if (~D[7])                                             /// Mem ref
      case (D)
           01 : AC = in_AC & DR;                                            //AND
           02 : {E,AC} = DR + in_AC;                                        //ADD
           04 : AC = DR;                                                    //LDA
           64 : INR_CONDITIONS = DR ? 0 : 1;
        endcase
    else
        if(~(IR[15]))                                      /// reg ref
            case (IR)
                16'h7800 :  AC <= 16'h0;                                    //CLA
                16'h7400 :  E = 0;                                     //CLE
                16'h7200 :  AC = ~in_AC;                                    //CMA
                16'h7100 :  E = ~in_E;                                      //CME
                16'h7080 :  begin  AC <= (in_AC >> 1);                      //CIR
                                   AC[15] <= in_E;
				                   E <= in_AC[0];  
                            end 
				16'h7040 :  begin  AC <= (in_AC << 1);                      //CIL
					               AC[0] <= in_E;
					               E <= in_AC[15]; 
                            end
			    16'h7010 :  INR_CONDITIONS = in_AC[15] ? 0 : 1;             //SPA
			    16'h7008 :  INR_CONDITIONS = in_AC[15] ? 1 : 0;             //SNA
			    16'h7004 :  INR_CONDITIONS = in_AC ? 0 : 1;                 //SZA
			    16'h7002 :  INR_CONDITIONS = in_E ? 0 : 1;                  //SZE
			    16'h7001 :  S = 0;                                          //HLT
            endcase
        
endmodule
