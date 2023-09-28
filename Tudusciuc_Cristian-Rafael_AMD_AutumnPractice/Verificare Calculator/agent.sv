// The environment is a container object simply to hold
// all verification  components together. This environment can
// then be reused later and all components in it would be
// automatically connected and available for use
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent #(parameter OUTSIZE = 1);
  driver 				d0; 		// Driver handle
  monitor#(OUTSIZE)	m0; 		// Monitor handle

  
  generator				g0; 		// Generator Handle

  mailbox 	drv_mbx; 		// Connect GEN -> DRV
  mailbox 	scb_imbx; 		// Connect MON -> SCB
  mailbox 	scb_ombx;
  mailbox 	scb_nmbx;

  event 	drv_done; 		// Indicates when driver is done

  virtual top_In vIif; 	// Virtual interface handle
  virtual top_Out #(OUTSIZE) vOif;
  virtual top_Intern #(OUTSIZE) vNif;

  function new();
    d0 = new;
    m0=new;
    g0 = new;
    drv_mbx = new();
    scb_imbx = new();
    scb_ombx = new();
    scb_nmbx = new();

  endfunction

  virtual task run();
    d0.vif = vIif;
    m0.vIif=vIif;
    m0.vOif=vOif;
    m0.vNif=vNif;
    
    d0.drv_mbx = drv_mbx;
    g0.drv_mbx = drv_mbx;
    m0.scb_ombx = scb_ombx;
    m0.scb_imbx = scb_imbx;
    m0.scb_nmbx = scb_nmbx;

    d0.drv_done = drv_done;
    g0.drv_done = drv_done;
    

    fork
      d0.run();
      m0.run();
      g0.run();
    join_any
  endtask
endclass