module Mux #(parameter SIZE = 8)(input[SIZE-1:0]I0,
                                 input[SIZE-1:0]I1,
                                 input Sel,
                                 output[SIZE-1:0] Out);
  
  assign Out = Sel ? I1 : I0;
endmodule