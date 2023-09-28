class driver;
  
  virtual mips_if mips_vif;
  event drv_done;
  mailbox drv_mbx;

  function new(virtual mips_if mips_vif, mailbox drv_mbx);
    this.mips_vif = mips_vif;
    this.drv_mbx = drv_mbx;
  endfunction
  
  task run();
    $display("T=%0t [Driver] starting...", $time);
    
    forever begin
      transaction tr = new;


      $display("T=%0t [Driver] waiting for item...", $time);
      
      drv_mbx.get(tr);
      tr.print("Driver");
//       tr.print_instr("Driver instr");

      mips_vif.DI = tr.DI;
      mips_vif.reset = tr.reset;
      for(int i = 0; i < 501; i = i + 1)
        mips_vif.mem[i] = tr.mem[i];

      @(negedge mips_vif.clk);
      ->drv_done;

    end
    
  endtask
  
endclass