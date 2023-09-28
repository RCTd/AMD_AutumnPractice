// The environment is a container object simply to hold
// all verification  components together. This environment can
// then be reused later and all components in it would be
// automatically connected and available for use
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent;
  driver d0; 		// Driver handle
  monitor m0; 		// Monitor handle
  generator	g0; 		// Generator Handle

  mailbox 	drv_mbx; 		// Connect GEN -> DRV
  mailbox 	scb_imbx; 		// Connect MON -> SCB
  mailbox 	scb_smbx;
  mailbox 	scb_nmbx;
  mailbox 	scb_mmbx;

  event 	drv_done; 		// Indicates when driver is done

  virtual top_In in;
  virtual top_Signals sig;
  virtual top_Intern intern;
  virtual top_Mem mem;

  function new();
    d0 = new;
    m0=new;
    g0 = new;
    drv_mbx = new();
    scb_imbx = new();
    scb_smbx = new();
    scb_nmbx = new();
    scb_mmbx = new();

  endfunction

  virtual task run();
    d0.in = in;
    m0.in=in;
    m0.sig=sig;
    m0.intern=intern;
    m0.mem=mem;
    
    d0.drv_mbx = drv_mbx;
    g0.drv_mbx = drv_mbx;
    m0.scb_imbx = scb_imbx;
    m0.scb_smbx = scb_smbx;
    m0.scb_nmbx = scb_nmbx;
    m0.scb_mmbx = scb_mmbx;

    d0.drv_done = drv_done;
    g0.drv_done = drv_done;
    

    fork
      d0.run();
      m0.run();
      g0.run();
    join_any
  endtask
endclass