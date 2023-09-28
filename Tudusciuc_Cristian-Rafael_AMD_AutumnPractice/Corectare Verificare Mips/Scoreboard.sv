class scoreboard;

  mailbox mon2scb_mbx;
  int counterclk;
  int counterRType;
  int counterITypeSW;
  int counterITypeLW;
  int counterIType;
  int counterJType;
  //transaction tr;
  reg [31:0] regscb [0:31];
  reg [31:0] memscb [0:255];
  //reg [31:0] rez;

  reg [4:0] adresaRType;
  reg [4:0] adresaIType;
  reg [4:0] adresaITypeSW;
  reg [4:0] adresaITypeLW;
  reg [31:0] adresaJType;
  
  `define RtypeOpcode 6'h00
  `define lwOpcode 6'b100_011 //h23
  `define swOpcode 6'b101_011 //2b
  `define beqOpcode 6'b100   //4
  `define addiOpcode 6'b1000 //8
  `define jumpOpcode 6'b10  //2

  transaction tr;
  transaction oldTr;

  function new(mailbox mon2scb_mbx);
    this.mon2scb_mbx = mon2scb_mbx;
    counterclk = 0;
    counterRType = 0;
    counterIType = 0;
    counterITypeSW = 0;
    counterITypeLW = 0;
    counterJType = 0;
    for(int i = 0; i < 32; i = i + 1)
      regscb[i] = 0;
  endfunction

  task run();
    $display("T=%0t [SCOREBOARD] starting... ", $time);

    forever begin  
      oldTr=tr;
      mon2scb_mbx.get(tr);
      //tr.print("SCOREBOARD");

      //reset daca PC se incrementeaza
      if(counterclk == 0) 
        begin
          if(tr.reset)
            counterclk = counterclk + 1;
        end
      else if(tr.reset == 0) 
        begin
          if(tr.outReg != oldTr.outReg)
            begin
              if(counterclk == 1)
                begin
                  $error("T=%0t [Sc] Pc(outReg) start at 4 : Scoreboard test failed", $time);
                  counterclk = counterclk + 1;
                end
              else
                $display("T=%0t [Sc] Pc(outReg) starts incrementing : Scoreboard test passed", $time);
            end
          else
            $error("T=%0t [Sc] Pc(outReg) doesn't start incrementing : Scoreboard test failed", $time);
        end
      else
        if(tr.outReg==0)
          $display("T=%0t [Sc] Reset : Scoreboard test passed", $time);
      else
        $error("T=%0t [Sc] Reset : Scoreboard test failed", $time);

      if(!tr.reset)
        begin
          RType(tr, counterRType, adresaRType);
          ITypeAddi(tr, counterIType, adresaIType);
          ITypeSW(tr, counterIType, adresaIType);
          ITypeLW(tr, counterIType, adresaIType);
          JType(tr, counterJType, adresaJType);

          if((tr.outIM[31:26] != `addiOpcode && 
              tr.outIM[31:26] != `beqOpcode && 
              tr.outIM[31:26] != `swOpcode && 
              tr.outIM[31:26] != `RtypeOpcode && 
              tr.outIM[31:26] != `lwOpcode && 
              tr.outIM[31:26] != `jumpOpcode)&&
             (tr.RegWrite != 1'b0 || 
              tr.RegDst != 1'b0 || 
              tr.AluSrc != 1'b0 || 
              tr.Branch != 1'b0 || 
              tr.MemWrite != 1'b0 || 
              tr.MemToReg != 1'b0 || 
              tr.AluOp != 2'b00 || 
              tr.Jump != 1'b0 ))
            $error("T=%d [SC] unknown inst fail - control has no default ",$time);
        end
    end
  endtask

  //in functie de opcode determin tipul instructiunii -> atata timp cat reset-ul este dezactivat si opcode-ul corespunde tipului de instructiune apelez functia 
  function automatic void RType(transaction tr, ref int counterRType, ref reg [4:0] adresaRType);
    //avem nevoie de registrele sursa  si destinatie + opcode-ul va fi 0 
    //R type folosite : add, sub, and, or, xor, slt 
    //Teo foloseste doar xor, and si slt
    if(counterRType == 0) 
      begin
        if(tr.outIM[31:26] == `RtypeOpcode)
          begin
            if(tr.RegWrite == 1'b1 && tr.RegDst == 1'b1 && tr.AluSrc == 1'b0 && tr.Branch == 1'b0 && tr.MemWrite == 1'b0 && tr.MemToReg == 1'b0 &&tr.AluOp == 2'b10 && tr.Jump == 1'b0 )
              begin

                reg [4:0] rs = tr.outIM[25:21];
                reg [4:0] rt = tr.outIM[20:16];
                reg [4:0] rd = tr.outIM[15:11];
                //                 $display("T=%0t [Sc] rs = 0x%0h rt = 0x%0h rd = 0x%0h", $time, rs, rt, rd);
                case(tr.outIM[5:0])  //funct -> folosita sa defineasca ce functie este facuta pe registre
                  //add
                  6'h20:
                    begin
                      regscb[rd] = tr.regs[rs] + tr.regs[rt];
                      $display("T=%0t [Sc] Add", $time);
                    end
                  //sub
                  6'h22:
                    begin
                      regscb[rd] = tr.regs[rs] - tr.regs[rt];
                      $display("T=%0t [Sc] Sub", $time);
                    end
                  //and
                  6'h24:
                    begin
                      regscb[rd] = tr.regs[rs] & tr.regs[rt];
                      $display("T=%0t [Sc] And", $time);
                    end
                  //or
                  6'h25:
                    begin
                      regscb[rd] = tr.regs[rs] | tr.regs[rt];
                      $display("T=%0t [Sc] Or", $time);
                    end
                  //xor
                  //                   6'h25:
                  //                     begin
                  //                       regscb[rd] = tr.regs[rs] ^ tr.regs[rt];
                  //                       $display("Xor");
                  //                     end
                  //slt
                  6'h2A:
                    begin
                      regscb[rd] = tr.regs[rs] < tr.regs[rt] ? 1:0;
                      $display("T=%0t [Sc] Slt", $time);
                    end
                  default:
                    $display("unknown function, instr=%0h",tr.outIM);
                endcase
                counterRType = counterRType + 1;
                adresaRType = rd;
              end
            else
              $error("T=%0t [Sc] R-Type signals problem  : Scoreboard test failed", $time);
          end
      end 
    else if(counterRType == 1) 
      begin

        if(regscb[adresaRType] == tr.regs[adresaRType]) 
          begin

            $display("T=%0t [Sc] R-Type instruction executed correct : Scoreboard test passed Register[%0d]:: Register from scoreboard(Expected) = %0d || Register from design(Actual) = %0d", $time, adresaRType, regscb[adresaRType], tr.regs[adresaRType]);
          end
        else begin
          $error("T=%0t [Sc] R-type instruction executed incorrect : Scoreboard test failed", $time);
        end
        counterRType = 0;
      end
  endfunction


  function automatic void ITypeAddi(transaction tr, ref int counterIType, ref reg [4:0] adresaIType);
    //I type folosite : addi, beq, sw, lw 
    if(counterIType == 0)
      begin
        if(tr.outIM[31:26] == `addiOpcode)
          begin
            if(tr.RegWrite == 1'b1 && tr.RegDst == 1'b0 && tr.AluSrc == 1'b1 && tr.Branch == 1'b0 && tr.MemWrite == 1'b0 && tr.MemToReg == 1'b0 &&tr.AluOp == 2'b00 && tr.Jump == 1'b0 )
              begin
                reg [4:0] rs = tr.outIM[25:21];
                reg [4:0] rt = tr.outIM[20:16];
                reg [31:0] imm = {{16{tr.outIM[15]}},tr.outIM[15:0]}; //SignExtend

                /*case(tr.outIM[31:26]) //folosesc opcode-ul
                      //addi
                      6'h8:
                        begin*/
                regscb[rt] = tr.regs[rs] + imm;
                $display("T=%0t [Sc] Addi",$time);
                /*end
                    endcase*/
                counterIType = counterIType + 1;
                adresaIType = rt; 
              end
            else
              $error("T=%0t [Sc]  I-Type addi signals problem  : Scoreboard test failed",$time);
          end
      end
    else if(counterIType == 1) 
      begin

        if(regscb[adresaIType] == tr.regs[adresaIType])
          begin
            $display("T=%0t [Sc] Addi instruction executed correct : Scoreboard test passed", $time);
          end
        else begin
          $error("T=%0t [Sc] Addi instruction executed incorrect : Scoreboard test failed \n Register[%0d]:: Register from scoreboard(Expected) = %0d || Register from design(Actual) = %0d", adresaIType, regscb[adresaIType], tr.regs[adresaIType], $time);
        end
        counterIType = 0;
      end
  endfunction


  function automatic void ITypeSW(transaction tr, ref int counterIType, ref reg [4:0] adresaIType);
    if(counterITypeSW == 0)
      begin 
        if(tr.outIM[31:26] == `swOpcode)
          begin 
            if(tr.RegWrite == 1'b0 && tr.RegDst == 1'b0 && tr.AluSrc == 1'b1 && tr.Branch == 1'b0 &&
               tr.MemWrite == 1'b1 && tr.MemToReg == 1'b0 &&tr.AluOp == 2'b00 && tr.Jump == 1'b0)
              begin 
                reg [4:0] rs = tr.outIM[25:21];
                reg [4:0] rt = tr.outIM[20:16];
                reg [31:0] imm = {{16{tr.outIM[15]}},tr.outIM[15:0]}; //SignExtend

                memscb[regscb[rs] + imm] = regscb[rt];
                counterITypeSW = counterITypeSW + 1;
                adresaITypeSW = regscb[rs] + imm;
                $display("T=%0t [Sc] SW",$time);
              end
            else
              $error("T=%0t [Sc]  I-Type sw signals problem  : Scoreboard test failed",$time);
          end
      end
    else if(counterITypeSW == 1)
      begin
        if(memscb[adresaITypeSW] == tr.memory[adresaITypeSW]) begin
          $display("T=%0t [Sc] Sw instruction executed correct : Scoreboard test passed", $time);
        end
        else begin
          $error("T=%0t [Sc] Sw instruction executed incorrect : Scoreboard test failed", $time);
          $display("memscb[%d]=%0h, tr.mem[%d] = %0h",
                   adresaITypeSW,memscb[adresaITypeSW],adresaITypeSW,tr.memory[adresaITypeSW]);
          //         tr.print_data("scb");
        end
        counterITypeSW = 0;
      end
  endfunction


  function automatic void ITypeLW(transaction tr, ref int counterIType, ref reg [4:0] adresaIType);
    if(counterITypeLW == 0)
      begin 
        if(tr.outIM[31:26] == `lwOpcode)
          begin 
            if(tr.RegWrite == 1'b1 && tr.RegDst == 1'b0 && tr.AluSrc == 1'b1 && tr.Branch == 1'b0 && tr.MemWrite == 1'b0 && tr.MemToReg == 1'b1 &&tr.AluOp == 2'b00 && tr.Jump == 1'b0 )//tr.Jump == 1'b1
              begin 
                reg [4:0] rs = tr.outIM[25:21];
                reg [4:0] rt = tr.outIM[20:16];
                reg [31:0] imm = {{16{tr.outIM[15]}},tr.outIM[15:0]}; //SignExtend

                regscb[rt] = memscb[tr.regs[rs] + imm];
                counterITypeLW = counterITypeLW + 1;
                adresaITypeLW = rt;
                $display("T=%0t [Sc] LW",$time);
              end
            else
              $error("T=%0t [Sc] I-Type lw signals problem  : Scoreboard test failed", $time);
          end
      end
    else if(counterITypeLW == 1)
      begin
        if(regscb[adresaITypeLW] == tr.regs[adresaITypeLW]) begin
          $display("T=%0t [Sc] LW instruction executed correct : Scoreboard test passed", $time);
        end
        else begin
          $error("T=%0t [Sc] LW instruction executed incorrect : Scoreboard test failed", $time);
        end
        counterITypeLW = 0;
      end
  endfunction


  function automatic void JType(transaction tr, ref int counterJType, ref reg [31:0] adresaJType);
    int instrant = 0;
    if(counterJType == 0)
      begin 
        if(tr.outIM[31:26] == `jumpOpcode)
          begin
            if(tr.RegWrite == 1'b0 && tr.RegDst == 1'b0 && tr.AluSrc == 1'b0 && tr.Branch == 1'b0 && tr.MemWrite == 1'b0 && tr.MemToReg == 1'b0 &&tr.AluOp == 2'b00 && tr.Jump == 1'b1)
              begin 
                instrant = tr.outReg + 4;
                adresaJType = {instrant[31:28], tr.outIM[27:0] << 2};
                counterJType = counterJType + 1;
                $display("T=%0t [Sc] Jump",$time);
              end
            else
              $error("T=%0t [Sc] J-Type signals problem  : Scoreboard test failed", $time);
          end
      end
    else if(counterJType == 1) begin

      if(adresaJType == tr.outReg) begin
        $display("T=%0t [Sc] Jump instruction executed correct : Scoreboard test passed", $time);
      end
      else begin
        $error("T=%0t [Sc] Jump instruction executed incorrect : Scoreboard test failed", $time);
      end
      counterJType = 0;
    end
  endfunction

  //evidentiere default -> introduci o instructiune invalida, adica pui o instructiune care nu se afla in cele de fata
  //daca nu se afla printre opcode-urile introduse in design -> semnalele din unitatea de control ar trebui sa fie pe z


endclass