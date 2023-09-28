// The interface allows verification components to access DUT signals
// using a virtual interface handle
interface top_In (input bit clk);
  logic  reset;
  logic [31:0]inst_mem[0:255];
endinterface

interface top_Signals ();
  logic  RegDst,Jump,Branch,MemToReg,ALUSrc,MemWrite,RegWrite;
  logic [1:0]ALUOp;
endinterface

interface top_Intern ();
  logic [4:0]rs,rd,rt;
  logic [31:0]mux_datamem_out,sel_mux_2_out,
  pcout,sel_mux_1_out,add_address_out,jump_address,instruction;
  logic [5:0]opcode,funct;
  logic [2:0]ALUConOut;  
  logic zeroflag;
endinterface

interface top_Mem ();
  logic [31:0] memory[0:31],registers[0:31],Imemory[0:255];
endinterface