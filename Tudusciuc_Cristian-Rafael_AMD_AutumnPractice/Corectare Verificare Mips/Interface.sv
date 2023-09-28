/*interface mips_if(input bit clk, output logic [31:0] outIM, output logic [31:0] outReg,  output logic [31:0] mem[0:500]);
  
  logic [31:0] DI;
  logic reset;
   
endinterface*/

interface mips_if(input bit clk);
  
  logic [31:0] DI;
  logic reset;
  logic [31:0] outIM;
  logic [31:0] outReg;
  logic [31:0] mem[0:500];
  logic RegDst, Jump, Branch, MemToReg, MemWrite, AluSrc, RegWrite;
  logic [1:0] AluOp;
  logic [31:0] regs[0:31];
  logic [31:0] memory [0:255];
endinterface