// The environment is a container object simply to hold
// all verification  components together. This environment can
// then be reused later and all components in it would be
// automatically connected and available for use
`include "agent.sv" 
`include "scoreboard.sv"

class env #(parameter OUTSIZE = 1);
  agent #(OUTSIZE)	a0;			// Agent handle
  scoreboard #(OUTSIZE)		s0; 		// Scoreboard handle

  mailbox 	scb_imbx; 		// Connect MON -> SCB
  mailbox 	scb_ombx; 		// Connect MON -> SCB
  mailbox 	scb_nmbx; 		// Connect MON -> SCB


//   virtual top_In vif; 	// Virtual interface handle

  function new();
    a0 = new;
    s0 = new;
    scb_imbx = new();
    scb_ombx = new();
    scb_nmbx = new();


    a0.scb_imbx = scb_imbx;
    s0.scb_imbx = scb_imbx;
    a0.scb_ombx = scb_ombx;
    s0.scb_ombx = scb_ombx;
    a0.scb_nmbx = scb_nmbx;
    s0.scb_nmbx = scb_nmbx;
  endfunction

  virtual task run();

    fork
      a0.run();
      s0.run();
    join_any
  endtask
endclass