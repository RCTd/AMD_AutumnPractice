// The driver is responsible for driving transactions to the DUT
// All it does is to get a transaction from the mailbox if it is
// available and drive it out into the DUT interface.
`ifndef INTERFACE
	`include "interface.sv"
	`define INTERFACE
`endif

`ifndef TRANSACTION
	`include "transaction.sv"
 	`define TRANSACTION
`endif

class driver;
  virtual top_In in;
  event drv_done;
  mailbox drv_mbx;

  task run();
    $display ("T=%0t [Driver] starting ...", $time);
    // Try to get a new transaction every time and then assign
    // packet contents to the interface. But do this only if the
    // design is ready to accept new transactions
    forever begin
      `ifndef POSEDGE
      @(negedge in.clk)
      `else
      @(posedge in.clk)
      `endif
      begin
      In_item item;
      drv_mbx.get(item);
	  item.print("Driver");
      in.reset    	<=item.reset; 
      in.inst_mem	<=item.inst_mem;
//       @ (posedge in.clk);
      ->drv_done;
      end
    end
  endtask
endclass