module memory #(parameter WIDTH = 8,/* numarul de biti din adresa*/
                parameter LENGHT = 32/*numarulde biti de pe o "linie" din memorie*/)
  (input[LENGHT-1:0] Din,
   input[WIDTH-1:0] Addr,
   input R_W, Valid, Reset, Clk,
   output reg[LENGHT-1:0]Dout);
  
  reg[LENGHT-1:0] mem[0:(1 << WIDTH)-1];
  reg[8:0] i;
  
  initial begin
    for(i = 0; i < (1 << WIDTH); i = i + 1)
      mem[i] <= 0;
    Dout <= 0;
  end
  
  always@(posedge Clk, posedge Reset)
    begin
      if(Reset)
        begin
          Dout <= 0;
          for(i=0; i < (1 << WIDTH); i = i + 1)
            begin
              mem[i] <= 0;
            end
        end
      else if(Valid)
        begin
          if(R_W)
            mem[Addr] <= Din;
          else
            Dout <= mem[Addr];
        end
    end
  
endmodule