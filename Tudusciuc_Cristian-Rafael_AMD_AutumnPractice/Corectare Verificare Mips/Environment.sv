`include "Generator.sv"
`include "Driver.sv"
`include "Monitor.sv"
`include "Scoreboard.sv"
class env;
  
  generator g0;
  driver d0;
  monitor m0;
  scoreboard s0;
  
  mailbox drv_mbx;
  mailbox mon2scb_mbx;
  event drv_done;
  
  virtual mips_if mips_vif;
  
  function new(virtual mips_if mips_vif);
    this.mips_vif = mips_vif;
    
    drv_mbx = new();
    mon2scb_mbx = new();
    
    g0 = new(drv_mbx);
    d0 = new(mips_vif, drv_mbx);
    m0 = new(mips_vif, mon2scb_mbx);
    s0 = new(mon2scb_mbx);
    
    d0.drv_mbx = drv_mbx;
    g0.drv_mbx = drv_mbx;
    m0.mon2scb_mbx = mon2scb_mbx;
    d0.drv_done = drv_done;
    g0.drv_done = drv_done;
    
  endfunction
  
  virtual task run();
    $display("Environment");
    d0.mips_vif = mips_vif;
    m0.mips_vif = mips_vif;
    
    fork
      d0.run();
      g0.run();
      m0.run();
      s0.run();
    join_any
  endtask
  
endclass