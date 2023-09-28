`include "Interface.sv"
`include "Test.sv"
//`include "Interface_Intern.sv"

// `define debug
// `include "debug.sv"

module tb;
  reg clk;
  
  // conectez interfata In la modulul mips_dut
  MIPS mips_dut(
//     .DI(32'b0),
    .clk(clk), .reset(intf.reset));
  
  mips_if intf(clk);
  //intern internif(clk);
  test tst(intf);
  
  //generarea semnalului de ceas
  initial
    begin
		#0 clk = 1'b0;
		forever #5 clk = ~clk;
	end
  
  assign intf.outIM = mips_dut.instruction;
  assign intf.outReg = mips_dut.pcout;
  assign intf.RegDst = mips_dut.RegDst;
  assign intf.Jump = mips_dut.Jump;
  assign intf.Branch = mips_dut.Branch;
//   assign intf.MemRead =  mips_dut.instruction == 6'h23;
  assign intf.MemToReg = mips_dut.MemToReg;
  assign intf.MemWrite = mips_dut.MemWrite;
  assign intf.AluSrc = mips_dut.ALUSrc;
  assign intf.RegWrite = mips_dut.RegWrite;
  assign intf.AluOp = mips_dut.ALUOp;
  for(genvar i = 0; i < 32; i = i + 1)
    assign mips_dut.instr_mem.mem[i] = intf.mem[i];
  for(genvar i = 0; i < 32; i = i + 1)
    assign intf.regs[i] = mips_dut.reg_bank.registers[i];
  for(genvar i = 0; i < 256; i = i + 1)
    assign intf.memory[i] = mips_dut.dat_mem.mem[i];
//   assign intf.memory = mips_dut.dat_mem.mem;
  
//   `ifdef debug
//   `ifdef BITI8
//   `debugAssign(dat_mem.mem,reg_bank.registers,instr_mem.mem)
//   `else
//   `debugAssign
//   `endif
//   `endif

  //testare
  /*initial 
    begin
      #0 intf.reset = 1'b1;
      #20 intf.reset = 1'b0;
      //#1000 $finish;
    end*/
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
endmodule

