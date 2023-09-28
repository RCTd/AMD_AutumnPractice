// The interface allows verification components to access DUT signals
// using a virtual interface handle
interface top_In (input bit clk);
  logic  InputKey, ValidCmd, RWMem;
  logic [7:0]Addr, InA, InB;
  logic [3:0] Sel;
  logic  ConfigDiv;
  logic [31:0] Din;
  logic  Reset;
endinterface

interface top_Out #(parameter OUTSIZE=1)(input bit clk);
  logic  CalcActive, CalcMode, Busy, DOutValid;
  logic [OUTSIZE-1:0]DataOut;
  logic  ClkTx;
endinterface

interface top_Intern #(parameter OUTSIZE=1)();
  logic SampleData,StartTx;
endinterface