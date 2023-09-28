// The driver is responsible for driving transactions to the DUT
// All it does is to get a transaction from the mailbox if it is
// available and drive it out into the DUT interface.
`ifndef INTERFACE
	`include "interface.sv"
	`define INTERFACE
`endif

`ifndef TRANSACTION_IN
	`include "transaction_in.sv"
 	`define TRANSACTION_IN
`endif

class driver;
  virtual top_In vif;
  event drv_done;
  mailbox drv_mbx;

  task run();
    $display ("T=%0t [Driver] starting ...", $time);
    // Try to get a new transaction every time and then assign
    // packet contents to the interface. But do this only if the
    // design is ready to accept new transactions
    forever begin
      In_item item;

//       $display ("T=%0t [Driver] waiting for item ...", $time);
      drv_mbx.get(item);
// 	  item.print("Driver");
      vif.Reset    	<=item.Reset; 	
      vif.ValidCmd 	<=item.ValidCmd; 	
      vif.InputKey 	<=item.InputKey;	
      vif.RWMem    	<=item.RWMem;	
      vif.ConfigDiv	<=item.ConfigDiv;	
      vif.Din		<=item.Din;
      vif.Addr		<=item.Addr;
      vif.InA		<=item.InA;
      vif.InB		<=item.InB;
      vif.Sel		<=item.Sel;
      @ (negedge vif.clk);
      ->drv_done;
    end
  endtask
endclass