// The monitor has a virtual interface handle with which it can monitor
// the events happening on the interface. It sees new transactions and then
// captures information into a packet and sends it to the scoreboard
// using another mailbox.
`ifndef INTERFACE
`include "interface.sv"
`define INTERFACE
`endif

`ifndef TRANSACTION_OUT
`include "transaction_out.sv"
`define TRANSACTION_OUT
`endif

`ifndef TRANSACTION_IN
`include "transaction_in.sv"
`define TRANSACTION_IN
`endif

`ifndef TRANSACTION_INTERN
`include "transaction_intern.sv"
`define TRANSACTION_INTERN
`endif

class monitor #(parameter OUTSIZE = 1);
  virtual top_Out #(OUTSIZE) vOif;
  virtual top_In vIif;
  mailbox scb_ombx; 		// Mailbox connected to scoreboard
  mailbox scb_imbx; 		// Mailbox connected to scoreboard
  In_item Iitem;
  Out_item #(OUTSIZE) Oitem;

  virtual top_Intern #(OUTSIZE) vNif;
  mailbox scb_nmbx; 		// Mailbox connected to scoreboard
  Intern_item #(OUTSIZE) Nitem;

  task run();
    $display ("T=%0t [Monitor] starting ...", $time);
    // Check forever at every clock edge to see if there is a
    // valid transaction and if yes, capture info into a class
    // object and send it to the scoreboard when the transaction
    // is over.
    forever begin

      @(vIif.clk or posedge vIif.Reset)

      Iitem = new();
      Oitem = new();
      Nitem = new();

      Iitem.Reset		= vIif.Reset;
      Iitem.Din			= vIif.Din;
      Iitem.InputKey	= vIif.InputKey;
      Iitem.ValidCmd	= vIif.ValidCmd;
      Iitem.RWMem		= vIif.RWMem;
      Iitem.Addr		= vIif.Addr;
      Iitem.InA			= vIif.InA;
      Iitem.InB			= vIif.InB;
      Iitem.Sel			= vIif.Sel;
      Iitem.ConfigDiv	= vIif.ConfigDiv;

      Oitem.Busy		= vOif.Busy;
      Oitem.ClkTx		= vOif.ClkTx;
      Oitem.DOutValid	= vOif.DOutValid;
      Oitem.CalcActive	= vOif.CalcActive;
      Oitem.CalcMode	= vOif.CalcMode;
      Oitem.DataOut		= vOif.DataOut;
      
      Nitem.state		= 0;
      Nitem.StartTx		= vNif.StartTx;
      Nitem.SampleData	= vNif.SampleData;

      if(vIif.Reset)//reset
        begin
          $display ("T=%0t [Monitor] Reset device", $time);
          Nitem.state=1;
        end
      else   
        if(vOif.CalcActive)
          begin
            if(vIif.ValidCmd && !vOif.Busy)
              begin
                if(vOif.CalcMode)
                  begin
                    if(vIif.RWMem)//Mode 1 Write
                      begin
                        $display ("T=%0t [Monitor] In Mode 1 Write", $time);
                        Nitem.state=4;
                      end
                    else//Mode 1 Read
                      begin
                        $display ("T=%0t [Monitor] In Mode 1 Read", $time);
                        Nitem.state=5;
                      end
                  end
                else//Mode 0
                  begin
                    $display ("T=%0t [Monitor] In Mode 0", $time);
                    Nitem.state=6;
                  end
              end
          end
      else
        if(vIif.ValidCmd)
          begin//insert key
            $display ("T=%0t [Monitor] Insert key", $time);
            Nitem.state=3;
          end
      else
        if(vIif.ConfigDiv)//config frequency divider
          begin
            $display ("T=%0t [Monitor] Configure frequency divider", $time);
            Nitem.state=2;
          end

      //       Iitem.print("MonitorI");
      scb_imbx.put(Iitem);
      //       Oitem.print("MonitorO");
      scb_ombx.put(Oitem);
      scb_nmbx.put(Nitem);

    end
  endtask
endclass