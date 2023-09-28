module DecInputKey(input ValidCmd, InputKey, Reset, Clk,
                   output reg Active, Mode);
  
  reg[6:0]state;
  
  initial begin
    state = 7'b0000001;
    Active = 0;
    Mode = 0;
  end
  
  always@(posedge Clk)
    begin
      if(Reset)//nou
        state=7'h1;//nou
      state[0] <= (state[0] | state[2]) & ~(ValidCmd & InputKey & ~Reset) |
      (state[1] |state[3]) & ~(ValidCmd & ~InputKey & ~Reset) |
      state[4] & ~(ValidCmd & ~Reset) |
      (state[5] | state[6]) & Reset;
      state[1] <= state[0] & ValidCmd & InputKey & ~Reset;
      state[2] <= state[1] & ValidCmd & ~InputKey & ~Reset;
      state[3] <= state[2] & ValidCmd & InputKey & ~Reset;
      state[4] <= state[3] & ValidCmd & ~InputKey & ~Reset;
      state[5] <= (state[4] & ValidCmd & ~InputKey | state[5]) & ~Reset;
      state[6] <= (state[4] & ValidCmd & InputKey | state[6]) & ~Reset;
      Active <= state[5] | state[6];
      Mode<= state[6];
    end
  
endmodule

module Control_RW_Flow(input ValidCmd, RW, Reset, TxDone, Active, Mode, Clk,
                       output reg AccessMem, RWMem, SampleData, TxData, Busy);
  
  reg[6:0] s;
  
  initial begin
    s = 7'b0000001;
    AccessMem = 0;
    RWMem = 0;
    SampleData = 0;
    TxData = 0;
    Busy = 0;
  end
  
  always@(posedge Clk)
    begin
      s[0] <= s[0] & ~(ValidCmd & ~Reset & Active) | (s[1] | s[2]) & ~(~Reset & Active & Mode) |
      s[3] & ~(~Reset & ~TxDone & Active & Mode) | s[4] | s[5] & ~(~Reset& Active & ~Mode) |
      	s[6] & ~(~Reset & ~TxDone & Active & ~Mode);
      s[1] <= s[0] & ValidCmd & ~RW & ~Reset & Active & Mode;
      s[2] <= s[1] & ~Reset & Active & Mode;
      s[3] <= s[2] & ~Reset & Active & Mode | s[3] & ~Reset & ~TxDone & Active & Mode;
      s[4] <= s[0] & ValidCmd & RW & ~Reset & Active & Mode;
      s[5] <= s[0] & ValidCmd & ~Reset & Active & ~Mode;
      s[6] <= s[5] & ~Reset & Active & ~Mode | s[6] & ~Reset & ~TxDone & Active & ~Mode;
      
      AccessMem <= s[1] | s[4];
      RWMem <= s[4];
      SampleData <= s[2] | s[5];
      TxData <= s[3] | s[6];
      Busy = ~s[0];
      
    end
  
endmodule

module control(input InputKey, Clk, ValidCmd, Reset, RW, TransferDone,
               output Active, Busy, RWMem, AccessMem, Mode, SampleData, TransferData);
  
  DecInputKey di (.ValidCmd(ValidCmd),
                  .InputKey(InputKey),
                  .Reset(Reset),
                  .Clk(Clk),
                  .Active(Active),
                  .Mode(Mode));
  
  Control_RW_Flow crwf (.ValidCmd(ValidCmd),
                        .RW(RW),
                        .Reset(Reset),
                        .TxDone(TransferDone),
                        .Active(Active),
                        .Mode(Mode),
                        .Clk(Clk),
                        .AccessMem(AccessMem),
                        .RWMem(RWMem),
                        .SampleData(SampleData),
                        .TxData(TransferData),
                        .Busy(Busy));
  
endmodule