class In_item;
  // This is the base transaction object that will be used
  // in the environment to initiate new transactions and
  // capture transactions at DUT interface

  rand bit  InputKey, ValidCmd, RWMem;
  bit [7:0]Addr;
  rand bit [7:0] InA, InB;
  rand bit [3:0] Sel;
  rand bit  ConfigDiv;
  rand bit [31:0] Din;
  bit  Reset;
  
  // Constructor
  function new(input bit inputKey = 0,
               input bit validCmd = 0,
               input bit reset = 0,
               input bit configDiv = 0,
               input bit[31:0]din = 0);
    InputKey = inputKey;
    ValidCmd = validCmd;
    Reset=reset;
    ConfigDiv=configDiv;
    Din=din;
  endfunction


  // This function allows us to print contents of the data packet
  // so that it is easier to track in a logfile
  function void print(string tag="");
    $display ("T=%0t [%s] Reset=0x%0d ValidCmd=0x%0d InputKey=0x%0d RW=0x%0d ConfigDiv=0x%0d Din=0x%0h Addr=0x%0h InA=0x%0h InB=0x%0h Sel=0x%0h",
              $time, tag, Reset,ValidCmd,InputKey,RWMem,ConfigDiv,Din,Addr,InA,InB,Sel);
  endfunction
endclass