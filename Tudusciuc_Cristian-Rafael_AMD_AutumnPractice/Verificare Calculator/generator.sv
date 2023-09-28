// The generator class is used to generate a random
// number of transactions with random addresses and data
// that can be driven to the design
`ifndef TRANSACTION_IN
`include "transaction_in.sv"
`define TRANSACTION_IN
`endif

class generator;
  mailbox drv_mbx;
  event drv_done;
  int num = 20;
  In_item item;

  task run();

    item = new(0, 1,1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 0, num);
    drv_mbx.put(item);
    @(drv_done);
    drv_mbx.put(item);
    @(drv_done);
    
    item = new(0, 0,0,1,3);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 0, num);
    drv_mbx.put(item);
    @(drv_done);

    
    item = new(1, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    
    item = new(1, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    item = new(1, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    item = new(0, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    item = new(1, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    
    item = new(1, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    
    
//     Generate four transactions with ValidCmd=1 and alternating InputKey
    for (int i = 1; i <= 5; i++) begin
      In_item item = new(i % 2, 1);
      $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i, num);
      drv_mbx.put(item);
      @(drv_done);
    end
    
    item = new(0, 0);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);

    for (int i = 6; i < num; i++) begin
      item = new;
      item.randomize();
      $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i+1, num);
      drv_mbx.put(item);
      @(drv_done);
    end
    
    item = new(0, 0,1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 0, num);
    drv_mbx.put(item);
    @(drv_done);
    drv_mbx.put(item);
    @(drv_done);
    item = new(0, 0,0);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 0, num);
    drv_mbx.put(item);
    @(drv_done);
    drv_mbx.put(item);
    @(drv_done);
    for (int i = 1; i <= 5; i++) begin
      In_item item = new(i % 2, 1);
      $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i, num);
      drv_mbx.put(item);
      @(drv_done);
    end
    
    item = new(0, 0);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);
    item = new(0, 1);
    $display ("T=%0t [Generator] Loop:%0d/%0d create next item", $time, 1, num);
      drv_mbx.put(item);
      @(drv_done);

    
    $display ("T=%0t [Generator] Done generation of %0d items", $time, num);
  endtask
endclass