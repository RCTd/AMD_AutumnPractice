class monitor;

  virtual mips_if mips_vif;
  mailbox mon2scb_mbx;
  transaction tr;

  function new(virtual mips_if mips_vif, mailbox mon2scb_mbx);
    this.mips_vif = mips_vif;
    this.mon2scb_mbx = mon2scb_mbx;
  endfunction

  task run();

    $display("T=%0t [Monitor] starting...", $time);
    forever begin
      @(negedge mips_vif.clk);

      tr = new;

      tr.DI = mips_vif.DI;
      tr.reset = mips_vif.reset;
      tr.outIM = mips_vif.outIM;
      tr.outReg = mips_vif.outReg;
      tr.RegDst = mips_vif.RegDst;
      tr.Jump = mips_vif.Jump;
      tr.Branch = mips_vif.Branch;
//       tr.MemRead = mips_vif.MemRead;
      tr.MemToReg = mips_vif.MemToReg;
      tr.MemWrite = mips_vif.MemWrite;
      tr.AluSrc = mips_vif.AluSrc;
      tr.RegWrite = mips_vif.RegWrite;
      tr.AluOp = mips_vif.AluOp;
      for(int i = 0; i < 501; i = i + 1)
        tr.mem[i] = mips_vif.mem[i];
      for(int i = 0; i < 32; i = i + 1)
        tr.regs[i] = mips_vif.regs[i];
      for(int i = 0; i < 256; i = i + 1)
        tr.memory[i] = mips_vif.memory[i];
//       tr.memory = mips_vif.memory;

      //tr.print_instr("AICI");
//       tr.print("Monitor");
//       tr.print_data("Monitor");
      mon2scb_mbx.put(tr);
    end   
  endtask

endclass