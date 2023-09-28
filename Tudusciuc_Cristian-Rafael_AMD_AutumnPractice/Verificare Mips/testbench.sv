`define debug
//comment for memorie pe 32 biti
// `define BITI8
//comment for execution on negedge
// `define POSEDGE

`include "environment.sv"
`include "debug.sv"

module MIPS_TESTBENCH;
  reg clk;

  top_In in(clk);
  top_Intern intern();
  top_Signals sig();
  top_Mem mem();

  MIPS mips_dut(clk, in.reset);
  
  env e0;
  
  initial begin  
    #0 clk = 1'b0;
    forever #5 clk=~clk;
  end
  
  typedef logic[7:0] memory [0:1023];
  function memory adaptor(logic [31:0] inst_mem[256]);
    memory mem;
    for(int i=0;i<=255;i=i+1)
      begin
        mem[i*4+0]=inst_mem[i][7:0];
        mem[i*4+1]=inst_mem[i][15:8];
        mem[i*4+2]=inst_mem[i][23:16];
        mem[i*4+3]=inst_mem[i][31:24];
      end
    return mem;
  endfunction

  `ifndef BITI8
  assign mips_dut.instr_mem.mem[0:255]=in.inst_mem;
  `else
  assign mips_dut.instr_mem.mem[0:1023]=adaptor(in.inst_mem);
  `endif
  
  assign intern.instruction=mips_dut.instruction;
  assign intern.rs=mips_dut.rs;
  assign intern.rd=mips_dut.rd;
  assign intern.rt=mips_dut.rt;
  assign intern.mux_datamem_out=mips_dut.mux_datamem_out;
  assign intern.sel_mux_2_out=mips_dut.sel_mux_2_out;
  assign intern.pcout=mips_dut.pcout;
  assign intern.sel_mux_1_out=mips_dut.sel_mux_1_out;
  assign intern.add_address_out=mips_dut.add_address_out;
  assign intern.jump_address=mips_dut.jump_address;
  assign intern.zeroflag=mips_dut.zeroflag;
  assign intern.opcode=mips_dut.opcode;
  assign intern.funct=mips_dut.funct;
  assign intern.ALUConOut=mips_dut.ALUConOut;

  assign sig.RegDst=mips_dut.RegDst;
  assign sig.Jump=mips_dut.Jump;
  assign sig.Branch=mips_dut.Branch;
  assign sig.MemToReg=mips_dut.MemToReg;
  assign sig.ALUSrc=mips_dut.ALUSrc;
  assign sig.MemWrite=mips_dut.MemWrite;
  assign sig.RegWrite=mips_dut.RegWrite;
  assign sig.ALUOp=mips_dut.ALUOp;
  
  assign mem.memory=mips_dut.dat_mem.mem[0:31];
  assign mem.Imemory=mips_dut.instr_mem.mem[0:255];
  assign mem.registers=mips_dut.reg_bank.registers;

  
  //for debug purpouses
  `ifdef debug
  `ifdef BITI8
  `debugAssign(dat_mem.mem,reg_bank.registers,instr_mem.mem)
  `else
  `debugAssign
  `endif
  `endif
  
  initial begin
    e0= new;
    e0.a0.in=in;
    e0.a0.sig=sig;
    e0.a0.intern=intern;
    e0.a0.mem=mem;
    e0.run();
//     #0 in.reset=1;
//     #10 in.reset=0;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    #1250 $finish;
  end

endmodule


