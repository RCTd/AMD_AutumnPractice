class Out_item #(parameter OUTSIZE = 1);
  // This is the base transaction object that will be used
  // in the environment to initiate new transactions and
  // capture transactions at DUT interface

  bit CalcActive, CalcMode, Busy, DOutValid;
  bit [OUTSIZE-1:0]DataOut;
  bit ClkTx,StartTx;
  
//   // Constructor
//   function new();
//     CalcActive=1'bx;
//     CalcMode=1'bx;
//     Busy=1'bx;
//     DOutValid=1'bx;
//     DataOut={OUTSIZE{1'bx}};
//   	ClkTx=1'bx;
//   endfunction
  
  // This function allows us to print contents of the data packet
  // so that it is easier to track in a logfile
  function void print(string tag="");
    $display ("T=%0t [%s] Busy=0x%0d ClkTx=0x%0d DoutValid=0x%0d Active=0x%0d Mode=0x%0d DataOut=0x%0h",
              $time, tag, Busy,ClkTx,DOutValid,CalcActive,CalcMode,DataOut);
  endfunction
  
  function int reset();
    if(!CalcActive && !CalcMode && !Busy && !DOutValid && !StartTx && !ClkTx && !DataOut)
      return 1;
    else
      return 0;
  endfunction
  
endclass