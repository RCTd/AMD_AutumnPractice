class Intern_item #(parameter OUTSIZE = 1);
  // This is the base transaction object that will be used
  // in the environment to initiate new transactions and
  // capture transactions at DUT interface

  bit SampleData,StartTx;
  bit [3:0]state;
  
  // This function allows us to print contents of the data packet
  // so that it is easier to track in a logfile
  function void print(string tag="");
    $display ("T=%0t [%s] State=0x%0h SampleData=0x%0d StartTx=0x%0d",
              $time, tag, state, SampleData,StartTx);
  endfunction
endclass