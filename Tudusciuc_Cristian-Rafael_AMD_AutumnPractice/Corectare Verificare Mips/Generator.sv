`include "Transaction.sv"
class generator;

  mailbox drv_mbx;
  event drv_done;
  //int num = 2;
  reg [31:0] mem[0:500];
  transaction tr;


  function new(mailbox drv_mbx);
    this.drv_mbx = drv_mbx;
    $readmemh("instructiuni.txt",mem);
  endfunction

  task run();

     
    
    //reset
    tr = new;
    tr.reset = 1;
    drv_mbx.put(tr);
    /*tr = new;
    tr.reset = 0;
    drv_mbx.put(tr);*/
    
    tr = new;
    tr.reset = 1;
    tr.DI = 31'b0;
    tr.mem = mem;
    drv_mbx.put(tr);
    
    tr = new;
    tr.reset = 0;
    tr.DI = 31'b0;
    tr.mem = mem;
    drv_mbx.put(tr);
   
    /*tr.randomize();
      tr.reset = 1'b1;
      tr.outIM = 32'h01084026;
      tr.DI = 31'b0;

      drv_mbx.put(tr);

      tr = new;
      tr.reset = 1'b0;
      drv_mbx.put(tr);

      tr = new;
      tr.randomize();
      tr.outIM = 32'h20080010;
      tr.DI = 31'b0;*/

  endtask

endclass