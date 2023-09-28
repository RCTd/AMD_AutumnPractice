module ALU(input[7:0] A,B,
           input[3:0] Sel,
           output reg[7:0] Out,
           output reg[3:0] Flag);
  reg[15:0] temp;
  always@(Sel, A, B)
    begin
      Flag = 0; // asignare blocanta pentru a putea reasigna, daca este cazul
      case(Sel)
        4'h0: {Flag[1],Out} = A + B;
        4'h1: begin
          Flag[3] = A < B;
          Out = A - B;
        end
        4'h2:begin
          temp = A*B;
          Flag[2] = |temp[15:8];
          Out = temp[7:0];
        end
        4'h3:begin
          Flag[3] = A < B;
          Out = A / B;
        end
        4'h4: Out = A << B;
        4'h5: Out = A >> B;
        4'h6: Out = A & B;
        4'h7: Out = A | B;
        4'h8: Out = A ^ B;
        4'h9: Out = ~(A ^ B);
        4'ha: Out = ~(A & B);
        4'hb: Out = ~(A | B);
        default: begin
          Out = 8'h0;
          Flag = 4'h0;
        end
      endcase
    end
endmodule