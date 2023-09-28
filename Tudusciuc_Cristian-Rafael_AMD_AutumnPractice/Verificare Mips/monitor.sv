// The monitor has a virtual interface handle with which it can monitor
// the events happening on the interface. It sees new transactions and then
// captures information into a packet and sends it to the scoreboard
// using another mailbox.
`ifndef INTERFACE
`include "interface.sv"
`define INTERFACE
`endif

`ifndef TRANSACTION
`include "transaction.sv"
`define TRANSACTION
`endif

class monitor;
  virtual top_In in;
  virtual top_Signals sig;
  virtual top_Intern intern;
  virtual top_Mem mem;

  mailbox scb_imbx;
  mailbox scb_smbx;
  mailbox scb_nmbx;
  mailbox scb_mmbx;

  In_item Iitem;
  Sig_item Sitem;
  Intern_item Nitem;
  Mem_item Mitem;

  task run();
    $display ("T=%0t [Monitor] starting ...", $time);
    // Check forever at every clock edge to see if there is a
    // valid transaction and if yes, capture info into a class
    // object and send it to the scoreboard when the transaction
    // is over.
    forever begin

      `ifndef POSEDGE
      @(negedge in.clk or in.reset)
      `else
      @(posedge in.clk or in.reset)
      `endif

      Iitem = new();
      Sitem = new();
      Nitem = new();
      Mitem = new();

      Iitem.reset=in.reset;
      Iitem.inst_mem=in.inst_mem;

      Sitem.RegDst=sig.RegDst;
      Sitem.Jump=sig.Jump;
      Sitem.Branch=sig.Branch;
      Sitem.MemToReg=sig.MemToReg;
      Sitem.ALUSrc=sig.ALUSrc;
      Sitem.MemWrite=sig.MemWrite;
      Sitem.RegWrite=sig.RegWrite;
      Sitem.ALUOp=sig.ALUOp;

      Nitem.instruction=intern.instruction;
      Nitem.rs=intern.rs;
      Nitem.rd=intern.rd;
      Nitem.rt=intern.rt;
      Nitem.mux_datamem_out=intern.mux_datamem_out;
      Nitem.sel_mux_2_out=intern.sel_mux_2_out;
      Nitem.pcout=intern.pcout;
      Nitem.sel_mux_1_out=intern.sel_mux_1_out;
      Nitem.add_address_out=intern.add_address_out;
      Nitem.jump_address=intern.jump_address;
      Nitem.zeroflag=intern.zeroflag;
      Nitem.opcode=intern.opcode;
      Nitem.funct=intern.funct;
      Nitem.ALUConOut=intern.ALUConOut;

      Mitem.memory=mem.memory;
      Mitem.Imemory=mem.Imemory;
      Mitem.registers=mem.registers;


      //       Iitem.print("MonitorI");
      scb_imbx.put(Iitem);
      //       Sitem.print("MonitorS");
      scb_smbx.put(Sitem);
      scb_nmbx.put(Nitem);
      scb_mmbx.put(Mitem);

    end
  endtask
endclass