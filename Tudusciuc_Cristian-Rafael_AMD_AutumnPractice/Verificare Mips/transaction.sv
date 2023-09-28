class In_item;
  bit reset;
  rand bit [31:0]inst_mem[0:255];

  `define RtypeOpcode 6'h00
  `define lwOpcode 6'b100_011 //h23
  `define swOpcode 6'b101_011 //2b
  `define beqOpcode 6'b100   //4
  `define addiOpcode 6'b1000 //8
  `define jumpOpcode 6'b10  //2

  constraint opcode { 
    foreach(inst_mem[i]) {
      inst_mem[i][31:26] dist {`addiOpcode:=4,
                               `beqOpcode:=2,
                               `swOpcode:=2,
                               `RtypeOpcode:=8, 
                               `lwOpcode:=3,
                               `jumpOpcode:=3};
      if(inst_mem[i][31:26] inside{`lwOpcode})
      {
        inst_mem[i][15:0] dist {[0:12]};
        inst_mem[i-1][15:0]==inst_mem[i][15:0];//rs[i-1]=rs[i]
        inst_mem[i-1][25:21]==inst_mem[i][25:21];
        inst_mem[i-1][31:26]==`swOpcode;
      }else
        if(inst_mem[i][31:26]inside{`RtypeOpcode})
        {
          	inst_mem[i][5:0] dist {6'b100000,6'b100010,6'b100100,6'b100101,6'b101010};
        }
      else
        if(inst_mem[i][31:26] inside {`addiOpcode,`swOpcode})
          inst_mem[i][15:0] dist {[0:12]};
      else
        if(inst_mem[i][31:26] inside {`beqOpcode})
          inst_mem[i][15:0] dist {[0:12],[0-12:0-1]};
      else
        if(inst_mem[i][31:26]inside{`jumpOpcode})
          inst_mem[i][25:0] dist {[0:255]};

    }
  }

      // Constructor
      function new(input bit Reset = 0);//,input bit [31:0]mem[0:255]='{256{32'h0}});
    reset=Reset;
    //     inst_mem=mem;
    endfunction

    function void print(string tag="");
      $display ("T=%0t [%s] Reset=0x%0d", $time, tag, reset);
//       for(int i=0;i<256;i=i+1)
//       	$display("inst_mem[%d]=%0h",i,inst_mem[i]);
    endfunction
    endclass


    class Sig_item;
      bit RegDst,Jump,Branch,MemToReg,ALUSrc,MemWrite,RegWrite;
      bit [1:0]ALUOp;

      function void print(string tag="");
        $display ("T=%0t [%s] RegDst=0x%0d Jump=0x%0d Branch=0x%0d MemToReg=0x%0d ALUSrc=0x%0d MemWrite=0x%0d RegWrite=0x%0d ALUOp=0x%0h ", 
                  $time, tag, RegDst,Jump,Branch,MemToReg,ALUSrc,MemWrite,RegWrite,ALUOp);
      endfunction
    endclass


    class Intern_item;
      bit [4:0]rs,rd,rt;
      bit [31:0]mux_datamem_out,sel_mux_2_out,
      pcout,sel_mux_1_out,add_address_out,jump_address,instruction;
      bit [5:0]opcode,funct;
      bit [2:0]ALUConOut;  
      bit zeroflag;
      function void print(string tag="");
        $display ("T=%0t [%s] rs=0x%0h rd=0x%0h rt=0x%0h mux_datamem_out=0x%0h sel_mux_2_out=0x%0h pcout=0x%0h sel_mux_1_out=0x%0h add_address_out=0x%0h jump_address=0x%0h zeroflag=0x%0d opcode=0x%0h funct=0x%0h ALUConOut=0x%0h instruction=0x%0h", 
                  $time, tag, rs,rd,rt,mux_datamem_out,sel_mux_2_out,
                  pcout,sel_mux_1_out,add_address_out,jump_address,
                  zeroflag,opcode,funct,ALUConOut,instruction);
      endfunction
    endclass


    class Mem_item;
      logic [31:0] memory[0:31],registers[0:31],Imemory[0:255];

      function void print(string tag="");
        $display ("T=%0t [%s]  ", $time, tag);
        for(int i=0;i<32;i=i+1)
          begin
            $display ("%d:%0h  ", i,Imemory[i]);
          end
      endfunction
    endclass
