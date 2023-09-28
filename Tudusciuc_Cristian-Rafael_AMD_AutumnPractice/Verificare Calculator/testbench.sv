`include "environment.sv"
`define OUTSIZE 8

module testTop;

  reg clk;

  top_In in(clk);
  top_Out #(.OUTSIZE(`OUTSIZE)) out(clk);  
  top_Intern #(.OUTSIZE(`OUTSIZE)) intern();  

  top #(.OUTSIZE(`OUTSIZE))t (.InputKey(in.InputKey),
                              .ValidCmd(in.ValidCmd),
                              .RWMem(in.RWMem),
                              .Addr(in.Addr),
                              .InA(in.InA),
                              .InB(in.InB),
                              .Sel(in.Sel),
                              .ConfigDiv(in.ConfigDiv),
                              .Din(in.Din),
                              .Reset(in.Reset),
                              .Clk(clk),
                              .CalcActive(out.CalcActive),
                              .CalcMode(out.CalcMode),
                              .Busy(out.Busy),
                              .DOutValid(out.DOutValid),
                              .DataOut(out.DataOut),
                              .ClkTx(out.ClkTx));

  env #(`OUTSIZE)e0;


  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  assign intern.SampleData=t.SampleDataTmp;
  assign intern.StartTx=t.TransferDataTmp;
    
  
  initial begin
    e0= new;
    e0.a0.vIif=in;
    e0.a0.vOif=out;
    e0.a0.vNif=intern;
    e0.run();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #310
    e0.a0.vIif.RWMem=1'b1;
    #120
    $finish;
  end
endmodule


//  One scenario must check the functionality of the DUT that when we activate Sample the next posedge of Clk, StartTx is active .
// One scenario must check the functionality of the DUT when reset is active, that all the internal registers and output signals have reset value.
// One scenario must check the functionality of the DUT when we cross between Mode 0 and Mode 1.
// One scenario must make 7 different operations and write the different 7 results to memory in mode 1 and the MEMORY_SIZE is 8, after MEMORY_SIZE should be changed to 4 and 1 result to be written.
// One scenario must write the results of 8 operations in mode 1 when MEMORY_SIZE is 8, after the mode should be changed to 0, make 3 new operations, then the mode changed to 1 and read from memory from 9 different addresses.
// One scenario must check what happens when the RTL is in Mode 1 write to memory, but a reset is randomly activated.
// One scenario must check if, after reset, we enter in Mode 1 and we try to read something, if we can get any valid data.
// One scenario must check the functionality of the DUT when we cross from Mode 1 read to Mode 1 write, if we have any errors.
// One scenario must check the functionality of the DUT when we cross from a CLK frequency (ClkX is divided by 2) to a different one (ClkX is divided by 5) and we are in Mode 1 Read from memory, if we have any errors.
// One scenario must check what happens if we fill the memory then empty the memory, but we keep trying to read from the memory.
// One scenario must check the functionality of the DUT when we cross between INVALID INPUT_KEY and VALID INPUT_KEY.
// One scenario must check the functionality of the DUT when the mode 0 is active, and a reset is activated for 3 clock cycles.