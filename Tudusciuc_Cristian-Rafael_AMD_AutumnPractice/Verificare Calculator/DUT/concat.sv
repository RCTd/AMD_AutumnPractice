module concatenator(input[7:0] InA, InB, InC,
                    input[3:0] InD, InE,
                    output[31:0] Out);
  assign Out = {InE,InD,InC,InB,InA};
endmodule
