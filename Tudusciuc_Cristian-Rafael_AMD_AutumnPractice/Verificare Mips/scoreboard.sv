// The scoreboard is responsible to check data integrity. Since the design
// stores data it receives for each address, scoreboard helps to check if the
// same data is received when the same address is read at any later point
// in time. So the scoreboard has a "memory" element which updates it
// internally for every write operation.
`ifndef TRANSACTION
`include "transaction.sv"
`define TRANSACTION
`endif

`define opcode Nitem.instruction[31:26]
`define imm Nitem.instruction[15:0]
`define fnct Nitem.instruction[5:0]
`define rs Nitem.instruction[25:21]
`define rt Nitem.instruction[20:16]
`define rd Nitem.instruction[15:11]
`define jaddr Nitem.instruction[25:0]
`define pcout Nitem.pcout

`define Reg Mitem.registers
`define Mem Mitem.memory

`define verifR(op)\
Rmem[`rd]=Rmem[`rs] ``op Rmem[`rt];\
if(`Reg[`rd]!=Rmem[`rd])\
  $error("T=%0t [Scoreboard] FAIL! R-Type calculation ....................................................................................",$time)


  class scoreboard ;
    mailbox scb_imbx;
    mailbox scb_smbx;
    mailbox scb_nmbx;
    mailbox scb_mmbx;

    In_item Iitem;
    Sig_item Sitem;
    Intern_item Nitem;
    Mem_item Mitem;

    logic [31:0]Rmem[0:31]='{32{32'h0}};
    logic [31:0]Dmem[0:255]='{256{32'h0}};
    logic [31:0]pc=0;
    logic jflag=0;

    In_item pIitem;
    Intern_item pNitem;

    task run();
      forever begin
        pIitem = Iitem;
        pNitem = Nitem;

        scb_imbx.get(Iitem);
        scb_smbx.get(Sitem);
        scb_nmbx.get(Nitem);
        scb_mmbx.get(Mitem);

        //       Iitem.print("Scoreboard_in");
        //       Sitem.print("Scoreboard_sig");
        //       Nitem.print("Scoreboard_intern");
        //       Mitem.print("Scoreboard_mem");
        
        if(pIitem==null)
          begin
            pIitem=new;
            pIitem.reset=1;
          end

        if(!Iitem.reset && !pIitem.reset)
          begin
            if(`opcode===`RtypeOpcode && (Sitem.Jump || Sitem.ALUOp!==2'b10 || Sitem.MemToReg || 
                                          Sitem.MemWrite || Sitem.Branch || Sitem.ALUSrc || 
                                          !Sitem.RegDst || !Sitem.RegWrite))
              $error("T=%0t [Scoreboard] FAIL! R-Type signals ....................................................................................",$time);
            if(`opcode===`addiOpcode &&(Sitem.Jump || Sitem.ALUOp!==2'b00 || Sitem.MemToReg || 
                                        Sitem.MemWrite || Sitem.Branch || !Sitem.ALUSrc || 
                                        Sitem.RegDst || !Sitem.RegWrite))
              $error("T=%0t [Scoreboard] FAIL! I-Type signals addi ....................................................................................",$time);
            if(`opcode===`jumpOpcode &&(!Sitem.Jump || Sitem.ALUOp!==2'b00 || Sitem.MemToReg || 
                                        Sitem.MemWrite || Sitem.Branch || Sitem.ALUSrc || 
                                        Sitem.RegDst || Sitem.RegWrite))
              $error("T=%0t [Scoreboard] FAIL! J-Type signals jump ....................................................................................",$time);
            if(`opcode===`beqOpcode &&(Sitem.Jump || Sitem.ALUOp!==2'b01 || Sitem.MemToReg || 
                                       Sitem.MemWrite || !Sitem.Branch || Sitem.ALUSrc || 
                                       Sitem.RegDst || Sitem.RegWrite))
              $error("T=%0t [Scoreboard] FAIL! I-Type signals beq ....................................................................................",$time);
            if(`opcode===`swOpcode &&(Sitem.Jump || Sitem.ALUOp!==2'b00 || Sitem.MemToReg || 
                                      !Sitem.MemWrite || Sitem.Branch || !Sitem.ALUSrc || 
                                      Sitem.RegDst || Sitem.RegWrite))
              $error("T=%0t [Scoreboard] FAIL! I-Type signals sw ....................................................................................",$time);
            if(`opcode===`lwOpcode &&(Sitem.Jump || Sitem.ALUOp!==2'b00 || !Sitem.MemToReg || 
                                      Sitem.MemWrite || Sitem.Branch || !Sitem.ALUSrc || 
                                      Sitem.RegDst || !Sitem.RegWrite))
              $error("T=%0t [Scoreboard] FAIL! I-Type signals lw ....................................................................................",$time);

            
            if(jflag)
              begin
                if(`pcout != pc)
                    $error("T=%0t [Scoreboard] FAIL! J-Type calculation ....................................................................................",$time);
                jflag=0;
              end

            if(`opcode===`RtypeOpcode)
              begin
                $display("T=%0t [Scoreboard] R-Type",$time);
                case(`fnct)
                  6'b100000:  begin`verifR(+); end
                  6'b100010:  begin`verifR(-); end
                  6'b100100:  begin`verifR(&); end
                  6'b100101:  begin`verifR(|); end
                  6'b101010:  begin`verifR(<); end            
                endcase
              end
            else
              if(`opcode===`addiOpcode)
                begin
                  $display("T=%0t [Scoreboard] I-Type addi",$time);
                  Rmem[`rt]=Rmem[`rs]+`imm;
                  if(`Reg[`rt] != Rmem[`rt] )
                    begin
                      $error("T=%0t [Scoreboard] FAIL! I-Type addi calculation ....................................................................................",$time);
                      $display("Rmem[%d]=%0h , Rmem[%d]=%0h , imm=%0h, Reg=%0h",
                               `rt,Rmem[`rt],`rs,Rmem[`rs],`imm,`Reg[`rt]);
                    end
                end
            else
              if(`opcode===`jumpOpcode)
                begin
                  $display("T=%0t [Scoreboard] J-Type",$time);
                  pc=`jaddr*4-4;
                  jflag=1;
                end
            else
              if(`opcode===`beqOpcode)
                begin
                  $display("T=%0t [Scoreboard] I-Type beq",$time);
                  pc=Rmem[`rt]-Rmem[`rs]==0 ? pc+`imm*4 : pc;
                  jflag=1;
                end
            else
              if(`opcode===`swOpcode)
                begin
                  $display("T=%0t [Scoreboard] I-Type sw at %d",$time,`Reg[`rs]+`imm);
                  Dmem[Rmem[`rs]+`imm]=Rmem[`rt];
                  $display("Dmem[%d]=%0h, Mem[%d]=%0h",Rmem[`rs]+`imm,Dmem[Rmem[`rs]+`imm],
                           `Reg[`rs]+`imm,`Mem[(`Reg[`rs]+`imm)]);
                  if(`Mem[(`Reg[`rs]+`imm)]!==Dmem[Rmem[`rs]+`imm])
                    $error("T=%0t [Scoreboard] FAIL! I-Type sw calculation ....................................................................................",$time);
                end
            else
              if(`opcode===`lwOpcode)
                begin
                  $display("T=%0t [Scoreboard] I-Type lw",$time);
                  Rmem[`rt]=Dmem[Rmem[`rs]+`imm];
                  if(`Reg[`rt]!==Rmem[`rt])
                    $error("T=%0t [Scoreboard] FAIL! I-Type lw calculation ....................................................................................",$time);
                end
            
            pc=pc+4;

          end
      end
    endtask
  endclass