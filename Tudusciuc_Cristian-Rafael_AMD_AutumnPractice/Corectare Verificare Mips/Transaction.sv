/*class transaction_intern;
  logic [31:0] outReg;
  logic [31:0] outAdder4,outAdderBranch,outReadData1,outReadData2,outAlu;
  logic [31:0] outMuxIntrare,outMux1,outMux2,outMuxWR,outMuxAlu,outMuxDM;
  logic [31:0] outIM,outDM;
  logic [4:0] WriteReg;
  logic RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite, Zero;
  logic [1:0] AluOp;
  logic [2:0] AluCtrl;
  
  function void print(string tag="");
    $display("TRANSACTION");
    $display("T=%0t [%s] outReg=0x%0h outAdder4=0x%0h outAdderBranch=0x%0h outReadData1=0x%0h outReadData2=0x%0h outAlu=0x%0h outMuxIntrare=0x%0h outMux1=0x%0h outMux2=0x%0h outMuxWR=0x%0h outMuxAlu=0x%0h outMuxDM=0x%0h outIM=0x%0h outDM=0x%0h WriteReg=0x%0h RegDst=0x%0h Jump=0x%0h Branch=0x%0h MemRead=0x%0h MemToReg=0x%0h MemWrite=0x%0h AluSrc=0x%0h RegWrite=0x%0h Zero=0x%0h AluOp=0x%0h AluCtrl=0x%0h", $time, tag, outReg, outAdder4, outAdderBranch, outReadData1, outReadData2, outAlu, outMuxIntrare, outMux1, outMux2, outMuxWR, outMuxAlu, outMuxDM, outIM, outDM, RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite, Zero, AluOp, AluCtrl);
  endfunction
  
  logic [31:0] outIM;
  
  function void print(string tag="");
    $display("INTERN TRANSACTION");
    $display("T=%0t [%s] outIM=0x%0h", $time, tag, outIM);
  endfunction
  
endclass*/

class transaction;
  logic [31:0] DI;
  bit reset;
  rand logic [31:0] outIM;
  logic [31:0] outReg;
  bit [31:0] mem[0:500];
  logic RegDst, Jump, Branch, MemToReg, MemWrite, AluSrc, RegWrite;
  logic [1:0] AluOp;
  logic [31:0] regs[0:31];
  logic [31:0] memory [0:255];
  
  function void print(string tag="");
    $display("T=%0t %s DI = 0x%0h reset = 0x%0h outIM = 0x%0h outReg = 0x%0h RegDst = 0x%0h Jump = 0x%0h Branch = 0x%0h MemToReg = 0x%0h MemWrite = 0x%0h AluSrc = 0x%0h RegWrite = 0x%0h AluOp = 0x%0h", $time, tag, DI, reset, outIM, outReg, RegDst, Jump, Branch, MemToReg, MemWrite, AluSrc, RegWrite, AluOp);
    endfunction
  
  function void print_data(string tag="");
    $display("T=%0t %s", $time, tag);
    for(int i = 0; i < 32; i = i + 1)
      $display("\t data[%0d] = 0x%8h", i, memory[i] );
  endfunction
  
  function void print_instr(string tag="");
    $display("T=%0t %s", $time, tag);
    for(int i = 0; i < 32; i = i + 1)
      $display("\t Instruction[%0d] = 0x%8h", i, mem[i] );
  endfunction
  
endclass

