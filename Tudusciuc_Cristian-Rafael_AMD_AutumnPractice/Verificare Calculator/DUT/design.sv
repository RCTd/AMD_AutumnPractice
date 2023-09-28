`include "alu.sv"
`include "concat.sv"
`include "mux.sv"
`include "memory.sv"
`include "serial.sv"
`include "freq.sv"
`include "control.sv"

module top #(parameter OUTSIZE = 1)(input InputKey, ValidCmd, RWMem,
                                    input[7:0]Addr, InA, InB,
                                    input[3:0] Sel,
                                    input ConfigDiv,
                                    input[31:0] Din,
                                    input Reset, Clk,
                                    output CalcActive, CalcMode, Busy, DOutValid,
                                    output[OUTSIZE-1:0]DataOut,
                                    output ClkTx);
  
  wire[7:0] MuxInATmp, MuxInBTmp, AluOutTmp;
  wire[3:0] MuxSelTmp, AluFlagTmp;
  wire[31:0] ConcatOutTmp, TxDinTmp, MemOutTmp;
  wire CtrlTransferDataTmp, CtrlRWMemTmp;
  wire CtrlAccessMemTmp, ResetTmp, RWTemp, SampleDataTmp, TransferDataTmp;
  
  assign ResetTmp = Reset & ~CalcActive;
  assign RWTemp = RWMem & CalcActive;
  
  Mux #(.SIZE(8)) AMux    (.I0(InA),
                           .I1(8'h0),
                           .Sel(ResetTmp),
                           .Out(MuxInATmp));
  
  Mux #(.SIZE(8)) BMux    (.I0(InB),
                           .I1(8'h0),
                           .Sel(ResetTmp),
                           .Out(MuxInBTmp));
  
  Mux #(.SIZE(4)) SelMux  (.I0(Sel),
                           .I1(4'h0),
                           .Sel(ResetTmp),
                           .Out(MuxSelTmp));
  
  Mux #(.SIZE(32)) DataMux(.I0(ConcatOutTmp),
                           .I1(MemOutTmp),
                           .Sel(CalcMode),
                           .Out(TxDinTmp));
  
  ALU alu (.A(MuxInATmp),
           .B(MuxInBTmp),
           .Sel(MuxSelTmp),
           .Out(AluOutTmp),
           .Flag(AluFlagTmp));
  
  concatenator concat (.InA(MuxInATmp),
                       .InB(MuxInBTmp),
                       .InC(AluOutTmp),
                       .InD(MuxSelTmp),
                       .InE(AluFlagTmp),
                       .Out(ConcatOutTmp));
  
  SerialTranceiver #(.SIZE(OUTSIZE)) serial (.DataIn(TxDinTmp),
                                      .Sample(SampleDataTmp),
                                      .StartTx(TransferDataTmp),
                                      .Clk(Clk),
                                      .ClkTx(ClkTx),
                                      .Reset(ResetTmp),
                                      .TxDone(CtrlTransferDataTmp),
                                      .TxBusy(DOutValid),
                                      .Dout(DataOut));
  
  FreqDivider freq (.Din(Din),
                    .ConfigDiv(ConfigDiv),
                    .Reset(ResetTmp),
                    .Clk(Clk),
                    .Enable(CalcActive),
                    .ClkOut(ClkTx));
  
  memory #(.WIDTH(8),.LENGHT(32)) mem (.Din(ConcatOutTmp),
                                       .Addr(Addr),
                                       .R_W(CtrlRWMemTmp),
                                       .Valid(CtrlAccessMemTmp),
                                       .Reset(ResetTmp),
                                       .Clk(Clk),
                                       .Dout(MemOutTmp));
  
  control ctrl (.InputKey(InputKey),
                .Clk(Clk),
                .ValidCmd(ValidCmd),
                .Reset(Reset),
                .RW(RWTemp),
                .TransferDone(CtrlTransferDataTmp),
                .Active(CalcActive),
                .Busy(Busy),
                .RWMem(CtrlRWMemTmp),
                .AccessMem(CtrlAccessMemTmp),
                .Mode(CalcMode),
                .SampleData(SampleDataTmp),
                .TransferData(TransferDataTmp));
  
endmodule