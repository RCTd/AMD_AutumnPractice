module SerialTranceiver#(parameter SIZE = 1) (input[31:0] DataIn,
                                              input Sample, StartTx, Clk, ClkTx, Reset,
                                              output reg TxDone, TxBusy,
                                              output reg[SIZE-1:0] Dout);
  
  reg[31:0] data;
  reg[5:0] cnt;
  reg flag;//1 semnaleaza transmiterea ultimului bit 
  
  initial begin
    TxDone = 1'b0;
    TxBusy = 1'b0;
    Dout = 0;
    cnt = 0;
    data = 0;
    flag = 0;
  end
  
  always@(posedge Clk, posedge Reset)
    begin
      if(Reset)
        begin
          TxDone <= 1'b0;
          TxBusy <= 1'b0;
          Dout <= 0;
          cnt <= 0;
          data <= 0;
          flag <= 0;
        end
      if(Sample)
        data <= DataIn;
      else if(flag & StartTx)
        TxDone <= 1'b1;
      else if(~StartTx & ~TxBusy & flag)//unitatea de control stie ca am terminat trimiterea bitilor, resetam pt o noua transmisiune
        begin
          TxDone <= 0;
          flag <= 0;
          cnt <= 0;
        end
    end
  
  always@(posedge ClkTx)
    begin
      if(StartTx | flag)// trebuie "| flag" altfel busy numai devine 0
        begin
          if(cnt >= 32)
            TxBusy <= 1'b0;
          else
            begin
              TxBusy <= 1'b1;
              Dout <= data[31:32-SIZE];
              data <= data << SIZE;
              cnt <= cnt + SIZE;
              if(cnt >= (32 - SIZE))// fiind asignare neblocant "daca urmatorul cnt e 32 sau mai mare"
                flag <= 1;
            end
        end
    end
  
endmodule