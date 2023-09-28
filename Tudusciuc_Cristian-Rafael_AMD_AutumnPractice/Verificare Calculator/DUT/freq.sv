module FreqDivider(input[31:0] Din,
                   input ConfigDiv, Reset, Clk, Enable,
                   output reg ClkOut);
  
  reg[31:0] conf, cnt;
  
  initial begin
    conf = 1;
    cnt = 1;
    ClkOut = 1'b0;
  end
  
  always@(Clk)// si posedge si negedge
    begin
      if(Reset & Clk)
        begin
//           conf <= 0; //vechi
//           cnt <= 0;  //vechi
          conf <= 1;//nou
          cnt <= 1;//nou
          ClkOut <= 1'b0;
        end
      else if(~Enable & Clk)
        begin
          ClkOut <= 1'b0;
          if(ConfigDiv)
            conf <= Din;
        end
      else if(~Reset)
        begin
          if(conf == cnt)
            begin
              cnt <= 1;
              ClkOut <= ~ClkOut;
            end
          else
              cnt <= cnt + 1;
        end
    end
  
endmodule
