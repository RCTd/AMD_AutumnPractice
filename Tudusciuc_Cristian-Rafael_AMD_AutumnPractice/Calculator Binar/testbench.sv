`define INBITS 8
`define WIDTH 8
`define SBITS 4

`define DIV 3
`define DinLENGTH 8+3*INBITS
module test();
  reg Clk,Reset,ValidCmd,RW,ConfigDiv,InputKey;
  reg[31:0]Din;
  reg[3:0]Sel;
  reg[`INBITS-1:0]InA,InB;
  reg[`WIDTH-1:0]Addr;
  wire CalcBusy,ClkTx,DoutValid;
  wire[`SBITS-1:0]DataOut;

  BinaryCalculator 
  #(`INBITS,`WIDTH,`SBITS) bc (Clk,
                               InputKey,
                               ValidCmd,
                               InA,
                               InB,
                               RW,
                               Addr,
                               Sel,
                               Din,
                               ConfigDiv,
                               CalcBusy,
                               ClkTx,
                               DoutValid,
                               DataOut,
                               Reset);

  initial
    begin
      Clk=1'b0;
      forever #5 Clk = ~Clk;
    end

  initial
    begin
      $dumpfile("dump.vcd"); 
      $dumpvars(0,bc);
      #0//Init values
      Reset=1'b0;
      ValidCmd=1'b0;
      RW=1'b0;
      ConfigDiv=1'b0;
      InputKey=1'b0;
      Din=32'h0;
      Sel=4'h0;
      InA=`INBITS'h4;
      InB=`INBITS'h4;
      Addr=`WIDTH'h0;

      #20//config clk divider
      Din=32'h`DIV;
      ConfigDiv=1'b1;
      #10
//       ConfigDiv=1'b0;

      #20//input key (mode 1)
      ValidCmd=1'b1;
      InputKey=1'b1;
      #10
      InputKey=1'b0;
      #10
      InputKey=1'b1;
      #10
      InputKey=1'b0;
      #10
      InputKey=1'b1;
      #20
      ValidCmd=1'b0;


      #30//start write cmd
      RW=1'b1;
      ValidCmd=1'b1;
      #10
      ValidCmd=1'b0;


      #30//start read cmd
      RW=1'b0;
      ValidCmd=1'b1;
      #10
      ValidCmd=1'b0;


//       #(60+ `DinLENGTH*10+20*`DIV)
      #360//wait finish read cmd
      #40//start mode 0
      RW=1'b0;
      InputKey=1'b0;
      ValidCmd=1'b1;
      #10
      ValidCmd=1'b0;


      #360//wait finish mode 0
      #40//start mode 0
      RW=1'b0;
      Addr=`WIDTH'h1;
      InputKey=1'b0;
      ValidCmd=1'b1;
      #10
      ValidCmd=1'b0;

      #145//reset
      Reset=1'b1;
      #10
      Reset=1'b0;


      #120
      $finish(1);	
    end

endmodule