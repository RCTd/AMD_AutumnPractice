`include "Environment.sv"

program test(mips_if mips_vif);
  
  env e0;
  
  initial
    begin
      $display("Enviroment starting...");
      e0 = new(mips_vif);
      //e0.g0.test = 0;
      e0.run();
      #180 $finish;
    end
  
endprogram

