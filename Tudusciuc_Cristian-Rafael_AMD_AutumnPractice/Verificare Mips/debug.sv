interface top_MemDebug ();
  int i=0;
  logic [31:0] memory0;
  logic [31:0] memory1;
  logic [31:0] memory2;
  logic [31:0] memory3;
  logic [31:0] memory4;
  logic [31:0] memory5;
  logic [31:0] memory6;
  logic [31:0] memory7;
  logic [31:0] memory8;
  logic [31:0] memory9;
  logic [31:0] memory10;
  logic [31:0] memory11;
  logic [31:0] memory12;
  logic [31:0] memory13;
  logic [31:0] memory14;
  logic [31:0] memory15;
  logic [31:0] memory16;
  logic [31:0] memory17;
  logic [31:0] memory18;
  logic [31:0] memory19;
  logic [31:0] memory20;
  logic [31:0] memory21;
  logic [31:0] memory22;
  logic [31:0] memory23;
  logic [31:0] memory24;
  logic [31:0] memory25;
  logic [31:0] memory26;
  logic [31:0] memory27;
  logic [31:0] memory28;
  logic [31:0] memory29;
  logic [31:0] memory30;
  logic [31:0] memory31;
  
  logic [31:0] Imemory0;
  logic [31:0] Imemory1;
  logic [31:0] Imemory2;
  logic [31:0] Imemory3;
  logic [31:0] Imemory4;
  logic [31:0] Imemory5;
  logic [31:0] Imemory6;
  logic [31:0] Imemory7;
  logic [31:0] Imemory8;
  logic [31:0] Imemory9;
  logic [31:0] Imemory10;
  logic [31:0] Imemory11;
  logic [31:0] Imemory12;
  logic [31:0] Imemory13;
  logic [31:0] Imemory14;
  logic [31:0] Imemory15;
  logic [31:0] Imemory16;
  logic [31:0] Imemory17;
  logic [31:0] Imemory18;
  logic [31:0] Imemory19;
  logic [31:0] Imemory20;
  logic [31:0] Imemory21;
  logic [31:0] Imemory22;
  logic [31:0] Imemory23;
  logic [31:0] Imemory24;
  logic [31:0] Imemory25;
  logic [31:0] Imemory26;
  logic [31:0] Imemory27;
  logic [31:0] Imemory28;
  logic [31:0] Imemory29;
  logic [31:0] Imemory30;
  logic [31:0] Imemory31;

  logic [31:0] registers0;
  logic [31:0] registers1;
  logic [31:0] registers2;
  logic [31:0] registers3;
  logic [31:0] registers4;
  logic [31:0] registers5;
  logic [31:0] registers6;
  logic [31:0] registers7;
  logic [31:0] registers8;
  logic [31:0] registers9;
  logic [31:0] registers10;
  logic [31:0] registers11;
  logic [31:0] registers12;
  logic [31:0] registers13;
  logic [31:0] registers14;
  logic [31:0] registers15;
  logic [31:0] registers16;
  logic [31:0] registers17;
  logic [31:0] registers18;
  logic [31:0] registers19;
  logic [31:0] registers20;
  logic [31:0] registers21;
  logic [31:0] registers22;
  logic [31:0] registers23;
  logic [31:0] registers24;
  logic [31:0] registers25;
  logic [31:0] registers26;
  logic [31:0] registers27;
  logic [31:0] registers28;
  logic [31:0] registers29;
  logic [31:0] registers30;
  logic [31:0] registers31;
  //   logic [31:0] memory[31],registers[0:31];
endinterface

`ifdef debug
`ifndef BITI8
`define debugAssign \
top_MemDebug memdebug();\
assign memdebug.memory0=mips_dut.dat_mem.mem[0];\
assign memdebug.memory1=mips_dut.dat_mem.mem[1];\
assign memdebug.memory2=mips_dut.dat_mem.mem[2];\
assign memdebug.memory3=mips_dut.dat_mem.mem[3];\
assign memdebug.memory4=mips_dut.dat_mem.mem[4];\
assign memdebug.memory5=mips_dut.dat_mem.mem[5];\
assign memdebug.memory6=mips_dut.dat_mem.mem[6];\
assign memdebug.memory7=mips_dut.dat_mem.mem[7];\
assign memdebug.memory8=mips_dut.dat_mem.mem[8];\
assign memdebug.memory9=mips_dut.dat_mem.mem[9];\
assign memdebug.memory10=mips_dut.dat_mem.mem[10];\
assign memdebug.memory11=mips_dut.dat_mem.mem[11];\
assign memdebug.memory12=mips_dut.dat_mem.mem[12];\
assign memdebug.memory13=mips_dut.dat_mem.mem[13];\
assign memdebug.memory14=mips_dut.dat_mem.mem[14];\
assign memdebug.memory15=mips_dut.dat_mem.mem[15];\
assign memdebug.memory16=mips_dut.dat_mem.mem[16];\
assign memdebug.memory17=mips_dut.dat_mem.mem[17];\
assign memdebug.memory18=mips_dut.dat_mem.mem[18];\
assign memdebug.memory19=mips_dut.dat_mem.mem[19];\
assign memdebug.memory20=mips_dut.dat_mem.mem[20];\
assign memdebug.memory21=mips_dut.dat_mem.mem[21];\
assign memdebug.memory22=mips_dut.dat_mem.mem[22];\
assign memdebug.memory23=mips_dut.dat_mem.mem[23];\
assign memdebug.memory24=mips_dut.dat_mem.mem[24];\
assign memdebug.memory25=mips_dut.dat_mem.mem[25];\
assign memdebug.memory26=mips_dut.dat_mem.mem[26];\
assign memdebug.memory27=mips_dut.dat_mem.mem[27];\
assign memdebug.memory28=mips_dut.dat_mem.mem[28];\
assign memdebug.memory29=mips_dut.dat_mem.mem[29];\
assign memdebug.memory30=mips_dut.dat_mem.mem[30];\
assign memdebug.memory31=mips_dut.dat_mem.mem[31];\
assign memdebug.registers0=mips_dut.reg_bank.registers[0];\
assign memdebug.registers1=mips_dut.reg_bank.registers[1];\
assign memdebug.registers2=mips_dut.reg_bank.registers[2];\
assign memdebug.registers3=mips_dut.reg_bank.registers[3];\
assign memdebug.registers4=mips_dut.reg_bank.registers[4];\
assign memdebug.registers5=mips_dut.reg_bank.registers[5];\
assign memdebug.registers6=mips_dut.reg_bank.registers[6];\
assign memdebug.registers7=mips_dut.reg_bank.registers[7];\
assign memdebug.registers8=mips_dut.reg_bank.registers[8];\
assign memdebug.registers9=mips_dut.reg_bank.registers[9];\
assign memdebug.registers10=mips_dut.reg_bank.registers[10];\
assign memdebug.registers11=mips_dut.reg_bank.registers[11];\
assign memdebug.registers12=mips_dut.reg_bank.registers[12];\
assign memdebug.registers13=mips_dut.reg_bank.registers[13];\
assign memdebug.registers14=mips_dut.reg_bank.registers[14];\
assign memdebug.registers15=mips_dut.reg_bank.registers[15];\
assign memdebug.registers16=mips_dut.reg_bank.registers[16];\
assign memdebug.registers17=mips_dut.reg_bank.registers[17];\
assign memdebug.registers18=mips_dut.reg_bank.registers[18];\
assign memdebug.registers19=mips_dut.reg_bank.registers[19];\
assign memdebug.registers20=mips_dut.reg_bank.registers[20];\
assign memdebug.registers21=mips_dut.reg_bank.registers[21];\
assign memdebug.registers22=mips_dut.reg_bank.registers[22];\
assign memdebug.registers23=mips_dut.reg_bank.registers[23];\
assign memdebug.registers24=mips_dut.reg_bank.registers[24];\
assign memdebug.registers25=mips_dut.reg_bank.registers[25];\
assign memdebug.registers26=mips_dut.reg_bank.registers[26];\
assign memdebug.registers27=mips_dut.reg_bank.registers[27];\
assign memdebug.registers28=mips_dut.reg_bank.registers[28];\
assign memdebug.registers29=mips_dut.reg_bank.registers[29];\
assign memdebug.registers30=mips_dut.reg_bank.registers[30];\
assign memdebug.registers31=mips_dut.reg_bank.registers[31];

`else

`define debugAssign(dat_mem,reg_bank,inst_mem) \
top_MemDebug memdebug();\
assign memdebug.memory0 ={ mips_dut.``dat_mem[3],mips_dut.``dat_mem[2],mips_dut.``dat_mem[1],mips_dut.``dat_mem[0]};\
assign memdebug.memory1 ={ mips_dut.``dat_mem[7],mips_dut.``dat_mem[6],mips_dut.``dat_mem[5],mips_dut.``dat_mem[4]};\
assign memdebug.memory2 ={ mips_dut.``dat_mem[11],mips_dut.``dat_mem[10],mips_dut.``dat_mem[9],mips_dut.``dat_mem[8]};\
assign memdebug.memory3 ={ mips_dut.``dat_mem[15],mips_dut.``dat_mem[14],mips_dut.``dat_mem[13],mips_dut.``dat_mem[12]};\
assign memdebug.memory4 ={ mips_dut.``dat_mem[19],mips_dut.``dat_mem[18],mips_dut.``dat_mem[17],mips_dut.``dat_mem[16]};\
assign memdebug.memory5 ={ mips_dut.``dat_mem[23],mips_dut.``dat_mem[22],mips_dut.``dat_mem[21],mips_dut.``dat_mem[20]};\
assign memdebug.memory6 ={ mips_dut.``dat_mem[27],mips_dut.``dat_mem[26],mips_dut.``dat_mem[25],mips_dut.``dat_mem[24]};\
assign memdebug.memory7 ={ mips_dut.``dat_mem[31],mips_dut.``dat_mem[30],mips_dut.``dat_mem[29],mips_dut.``dat_mem[28]};\
assign memdebug.memory8 ={ mips_dut.``dat_mem[35],mips_dut.``dat_mem[34],mips_dut.``dat_mem[33],mips_dut.``dat_mem[32]};\
assign memdebug.memory9 ={ mips_dut.``dat_mem[39],mips_dut.``dat_mem[38],mips_dut.``dat_mem[37],mips_dut.``dat_mem[36]};\
assign memdebug.memory10 ={ mips_dut.``dat_mem[43],mips_dut.``dat_mem[42],mips_dut.``dat_mem[41],mips_dut.``dat_mem[40]};\
assign memdebug.memory11 ={ mips_dut.``dat_mem[47],mips_dut.``dat_mem[46],mips_dut.``dat_mem[45],mips_dut.``dat_mem[44]};\
assign memdebug.memory12 ={ mips_dut.``dat_mem[51],mips_dut.``dat_mem[50],mips_dut.``dat_mem[49],mips_dut.``dat_mem[48]};\
assign memdebug.memory13 ={ mips_dut.``dat_mem[55],mips_dut.``dat_mem[54],mips_dut.``dat_mem[53],mips_dut.``dat_mem[52]};\
assign memdebug.memory14 ={ mips_dut.``dat_mem[59],mips_dut.``dat_mem[58],mips_dut.``dat_mem[57],mips_dut.``dat_mem[56]};\
assign memdebug.memory15 ={ mips_dut.``dat_mem[63],mips_dut.``dat_mem[62],mips_dut.``dat_mem[61],mips_dut.``dat_mem[60]};\
assign memdebug.memory16 ={ mips_dut.``dat_mem[67],mips_dut.``dat_mem[66],mips_dut.``dat_mem[65],mips_dut.``dat_mem[64]};\
assign memdebug.memory17 ={ mips_dut.``dat_mem[71],mips_dut.``dat_mem[70],mips_dut.``dat_mem[69],mips_dut.``dat_mem[68]};\
assign memdebug.memory18 ={ mips_dut.``dat_mem[75],mips_dut.``dat_mem[74],mips_dut.``dat_mem[73],mips_dut.``dat_mem[72]};\
assign memdebug.memory19 ={ mips_dut.``dat_mem[79],mips_dut.``dat_mem[78],mips_dut.``dat_mem[77],mips_dut.``dat_mem[76]};\
assign memdebug.memory20 ={ mips_dut.``dat_mem[83],mips_dut.``dat_mem[82],mips_dut.``dat_mem[81],mips_dut.``dat_mem[80]};\
assign memdebug.memory21 ={ mips_dut.``dat_mem[87],mips_dut.``dat_mem[86],mips_dut.``dat_mem[85],mips_dut.``dat_mem[84]};\
assign memdebug.memory22 ={ mips_dut.``dat_mem[91],mips_dut.``dat_mem[90],mips_dut.``dat_mem[89],mips_dut.``dat_mem[88]};\
assign memdebug.memory23 ={ mips_dut.``dat_mem[95],mips_dut.``dat_mem[94],mips_dut.``dat_mem[93],mips_dut.``dat_mem[92]};\
assign memdebug.memory24 ={ mips_dut.``dat_mem[99],mips_dut.``dat_mem[98],mips_dut.``dat_mem[97],mips_dut.``dat_mem[96]};\
assign memdebug.memory25 ={ mips_dut.``dat_mem[103],mips_dut.``dat_mem[102],mips_dut.``dat_mem[101],mips_dut.``dat_mem[100]};\
assign memdebug.memory26 ={ mips_dut.``dat_mem[107],mips_dut.``dat_mem[106],mips_dut.``dat_mem[105],mips_dut.``dat_mem[104]};\
assign memdebug.memory27 ={ mips_dut.``dat_mem[111],mips_dut.``dat_mem[110],mips_dut.``dat_mem[109],mips_dut.``dat_mem[108]};\
assign memdebug.memory28 ={ mips_dut.``dat_mem[115],mips_dut.``dat_mem[114],mips_dut.``dat_mem[113],mips_dut.``dat_mem[112]};\
assign memdebug.memory29 ={ mips_dut.``dat_mem[119],mips_dut.``dat_mem[118],mips_dut.``dat_mem[117],mips_dut.``dat_mem[116]};\
assign memdebug.memory30 ={ mips_dut.``dat_mem[123],mips_dut.``dat_mem[122],mips_dut.``dat_mem[121],mips_dut.``dat_mem[120]};\
assign memdebug.memory31 ={ mips_dut.``dat_mem[127],mips_dut.``dat_mem[126],mips_dut.``dat_mem[125],mips_dut.``dat_mem[124]};\
assign memdebug.registers0=mips_dut.``reg_bank[0];\
assign memdebug.registers1=mips_dut.``reg_bank[1];\
assign memdebug.registers2=mips_dut.``reg_bank[2];\
assign memdebug.registers3=mips_dut.``reg_bank[3];\
assign memdebug.registers4=mips_dut.``reg_bank[4];\
assign memdebug.registers5=mips_dut.``reg_bank[5];\
assign memdebug.registers6=mips_dut.``reg_bank[6];\
assign memdebug.registers7=mips_dut.``reg_bank[7];\
assign memdebug.registers8=mips_dut.``reg_bank[8];\
assign memdebug.registers9=mips_dut.``reg_bank[9];\
assign memdebug.registers10=mips_dut.``reg_bank[10];\
assign memdebug.registers11=mips_dut.``reg_bank[11];\
assign memdebug.registers12=mips_dut.``reg_bank[12];\
assign memdebug.registers13=mips_dut.``reg_bank[13];\
assign memdebug.registers14=mips_dut.``reg_bank[14];\
assign memdebug.registers15=mips_dut.``reg_bank[15];\
assign memdebug.registers16=mips_dut.``reg_bank[16];\
assign memdebug.registers17=mips_dut.``reg_bank[17];\
assign memdebug.registers18=mips_dut.``reg_bank[18];\
assign memdebug.registers19=mips_dut.``reg_bank[19];\
assign memdebug.registers20=mips_dut.``reg_bank[20];\
assign memdebug.registers21=mips_dut.``reg_bank[21];\
assign memdebug.registers22=mips_dut.``reg_bank[22];\
assign memdebug.registers23=mips_dut.``reg_bank[23];\
assign memdebug.registers24=mips_dut.``reg_bank[24];\
assign memdebug.registers25=mips_dut.``reg_bank[25];\
assign memdebug.registers26=mips_dut.``reg_bank[26];\
assign memdebug.registers27=mips_dut.``reg_bank[27];\
assign memdebug.registers28=mips_dut.``reg_bank[28];\
assign memdebug.registers29=mips_dut.``reg_bank[29];\
assign memdebug.registers30=mips_dut.``reg_bank[30];\
assign memdebug.registers31=mips_dut.``reg_bank[31];\
assign memdebug.Imemory0 ={ mips_dut.``inst_mem[3],mips_dut.``inst_mem[2],mips_dut.``inst_mem[1],mips_dut.``inst_mem[0]};\
assign memdebug.Imemory1 ={ mips_dut.``inst_mem[7],mips_dut.``inst_mem[6],mips_dut.``inst_mem[5],mips_dut.``inst_mem[4]};\
assign memdebug.Imemory2 ={ mips_dut.``inst_mem[11],mips_dut.``inst_mem[10],mips_dut.``inst_mem[9],mips_dut.``inst_mem[8]};\
assign memdebug.Imemory3 ={ mips_dut.``inst_mem[15],mips_dut.``inst_mem[14],mips_dut.``inst_mem[13],mips_dut.``inst_mem[12]};\
assign memdebug.Imemory4 ={ mips_dut.``inst_mem[19],mips_dut.``inst_mem[18],mips_dut.``inst_mem[17],mips_dut.``inst_mem[16]};\
assign memdebug.Imemory5 ={ mips_dut.``inst_mem[23],mips_dut.``inst_mem[22],mips_dut.``inst_mem[21],mips_dut.``inst_mem[20]};\
assign memdebug.Imemory6 ={ mips_dut.``inst_mem[27],mips_dut.``inst_mem[26],mips_dut.``inst_mem[25],mips_dut.``inst_mem[24]};\
assign memdebug.Imemory7 ={ mips_dut.``inst_mem[31],mips_dut.``inst_mem[30],mips_dut.``inst_mem[29],mips_dut.``inst_mem[28]};\
assign memdebug.Imemory8 ={ mips_dut.``inst_mem[35],mips_dut.``inst_mem[34],mips_dut.``inst_mem[33],mips_dut.``inst_mem[32]};\
assign memdebug.Imemory9 ={ mips_dut.``inst_mem[39],mips_dut.``inst_mem[38],mips_dut.``inst_mem[37],mips_dut.``inst_mem[36]};\
assign memdebug.Imemory10 ={ mips_dut.``inst_mem[43],mips_dut.``inst_mem[42],mips_dut.``inst_mem[41],mips_dut.``inst_mem[40]};\
assign memdebug.Imemory11 ={ mips_dut.``inst_mem[47],mips_dut.``inst_mem[46],mips_dut.``inst_mem[45],mips_dut.``inst_mem[44]};\
assign memdebug.Imemory12 ={ mips_dut.``inst_mem[51],mips_dut.``inst_mem[50],mips_dut.``inst_mem[49],mips_dut.``inst_mem[48]};\
assign memdebug.Imemory13 ={ mips_dut.``inst_mem[55],mips_dut.``inst_mem[54],mips_dut.``inst_mem[53],mips_dut.``inst_mem[52]};\
assign memdebug.Imemory14 ={ mips_dut.``inst_mem[59],mips_dut.``inst_mem[58],mips_dut.``inst_mem[57],mips_dut.``inst_mem[56]};\
assign memdebug.Imemory15 ={ mips_dut.``inst_mem[63],mips_dut.``inst_mem[62],mips_dut.``inst_mem[61],mips_dut.``inst_mem[60]};\
assign memdebug.Imemory16 ={ mips_dut.``inst_mem[67],mips_dut.``inst_mem[66],mips_dut.``inst_mem[65],mips_dut.``inst_mem[64]};\
assign memdebug.Imemory17 ={ mips_dut.``inst_mem[71],mips_dut.``inst_mem[70],mips_dut.``inst_mem[69],mips_dut.``inst_mem[68]};\
assign memdebug.Imemory18 ={ mips_dut.``inst_mem[75],mips_dut.``inst_mem[74],mips_dut.``inst_mem[73],mips_dut.``inst_mem[72]};\
assign memdebug.Imemory19 ={ mips_dut.``inst_mem[79],mips_dut.``inst_mem[78],mips_dut.``inst_mem[77],mips_dut.``inst_mem[76]};\
assign memdebug.Imemory20 ={ mips_dut.``inst_mem[83],mips_dut.``inst_mem[82],mips_dut.``inst_mem[81],mips_dut.``inst_mem[80]};\
assign memdebug.Imemory21 ={ mips_dut.``inst_mem[87],mips_dut.``inst_mem[86],mips_dut.``inst_mem[85],mips_dut.``inst_mem[84]};\
assign memdebug.Imemory22 ={ mips_dut.``inst_mem[91],mips_dut.``inst_mem[90],mips_dut.``inst_mem[89],mips_dut.``inst_mem[88]};\
assign memdebug.Imemory23 ={ mips_dut.``inst_mem[95],mips_dut.``inst_mem[94],mips_dut.``inst_mem[93],mips_dut.``inst_mem[92]};\
assign memdebug.Imemory24 ={ mips_dut.``inst_mem[99],mips_dut.``inst_mem[98],mips_dut.``inst_mem[97],mips_dut.``inst_mem[96]};\
assign memdebug.Imemory25 ={ mips_dut.``inst_mem[103],mips_dut.``inst_mem[102],mips_dut.``inst_mem[101],mips_dut.``inst_mem[100]};\
assign memdebug.Imemory26 ={ mips_dut.``inst_mem[107],mips_dut.``inst_mem[106],mips_dut.``inst_mem[105],mips_dut.``inst_mem[104]};\
assign memdebug.Imemory27 ={ mips_dut.``inst_mem[111],mips_dut.``inst_mem[110],mips_dut.``inst_mem[109],mips_dut.``inst_mem[108]};\
assign memdebug.Imemory28 ={ mips_dut.``inst_mem[115],mips_dut.``inst_mem[114],mips_dut.``inst_mem[113],mips_dut.``inst_mem[112]};\
assign memdebug.Imemory29 ={ mips_dut.``inst_mem[119],mips_dut.``inst_mem[118],mips_dut.``inst_mem[117],mips_dut.``inst_mem[116]};\
assign memdebug.Imemory30 ={ mips_dut.``inst_mem[123],mips_dut.``inst_mem[122],mips_dut.``inst_mem[121],mips_dut.``inst_mem[120]};\
assign memdebug.Imemory31 ={ mips_dut.``inst_mem[127],mips_dut.``inst_mem[126],mips_dut.``inst_mem[125],mips_dut.``inst_mem[124]};
`endif
`endif