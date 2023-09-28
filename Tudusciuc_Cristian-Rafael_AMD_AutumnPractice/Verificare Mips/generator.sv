// The generator class is used to generate a random
// number of transactions with random addresses and data
// that can be driven to the design
`ifndef TRANSACTION
`include "transaction.sv"
`define TRANSACTION
`endif

class generator;
  mailbox drv_mbx;
  event drv_done;
  int num = 33;
  In_item item;
  //   bit [31:0] mem [0:255];

  task run();

    //     $readmemb("instr.txt", mem);

    item = new(1);//,mem);
    item.randomize();
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 0, num);
    drv_mbx.put(item);
    @(drv_done);

    //     for(int i=0;i<32;i=i+1)
    //       begin
    item = new();//,mem);
    item.randomize();
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 2, num);
    drv_mbx.put(item);
    @(drv_done);
    //       end


    $display ("T=%0t [Generator] Done generation of items", $time);
  endtask

endclass