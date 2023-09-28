// The environment is a container object simply to hold
// all verification  components together. This environment can
// then be reused later and all components in it would be
// automatically connected and available for use
`include "agent.sv" 
`include "scoreboard.sv"

class env;
  agent	a0;			// Agent handle
  scoreboard s0; 		// Scoreboard handle

  mailbox 	scb_imbx; 		// Connect MON -> SCB
  mailbox 	scb_smbx; 		// Connect MON -> SCB
  mailbox 	scb_nmbx; 		// Connect MON -> SCB
  mailbox 	scb_mmbx; 		// Connect MON -> SCB

  function new();
    a0 = new;
    s0 = new;
    scb_imbx = new();
    scb_smbx = new();
    scb_nmbx = new();
    scb_mmbx = new();

    a0.scb_imbx = scb_imbx;
    s0.scb_imbx = scb_imbx;
    a0.scb_smbx = scb_smbx;
    s0.scb_smbx = scb_smbx;
    a0.scb_nmbx = scb_nmbx;
    s0.scb_nmbx = scb_nmbx;
    a0.scb_mmbx = scb_mmbx;
    s0.scb_mmbx = scb_mmbx;
  endfunction

  virtual task run();
    fork
      a0.run();
      s0.run();
    join_any
  endtask
endclass