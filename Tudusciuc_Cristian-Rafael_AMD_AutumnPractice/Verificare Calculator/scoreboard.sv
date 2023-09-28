// The scoreboard is responsible to check data integrity. Since the design
// stores data it receives for each address, scoreboard helps to check if the
// same data is received when the same address is read at any later point
// in time. So the scoreboard has a "memory" element which updates it
// internally for every write operation.
`ifndef TRANSACTION_OUT
`include "transaction_out.sv"
`define TRANSACTION_OUT
`endif
`ifndef TRANSACTION_IN
`include "transaction_in.sv"
`define TRANSACTION_IN
`endif

`define idlemode 0
`define resetmode 1
`define configDivmode 2
`define inputkeymode 3
`define mode1write 4
`define mode1read 5
`define mode0 6

`define keyPeriods 2*5
`define samplePeriods 4+1
`define startTxPeriods `samplePeriods+2

class scoreboard #(parameter OUTSIZE = 1);
  mailbox scb_imbx;
  mailbox scb_ombx;
  mailbox scb_nmbx;

  logic [2:0]p_state=0,c_state=0;
  logic [4:0] counter=0,key;
  logic inkey=0,resetRead=0;
  logic [2:0]sa=0;

  In_item P_in_item;
  Out_item #(OUTSIZE) P_out_item;
  Intern_item #(OUTSIZE) P_intern_item;

  In_item in_item;
  Out_item #(OUTSIZE)out_item;
  Intern_item #(OUTSIZE)intern_item;

  task run();
    forever begin
      P_in_item=in_item;
      P_out_item=out_item;
      P_intern_item=intern_item;

      scb_ombx.get(out_item);
      scb_imbx.get(in_item);
      scb_nmbx.get(intern_item);

      if(c_state !=`idlemode)
        in_item.print("Scoreboard_in");
      out_item.print("Scoreboard_out");

      p_state=c_state;
      c_state=intern_item.state;

      //       $display ("T=%0t [Scoreboard] p_state=0x%0h c_state=0x%0h ", $time, p_state, c_state);


      //Scenario A
      if((sa!=0 ) || (c_state==`mode1read||c_state==`mode0))
        begin
          intern_item.print("Scoreboard_intern");
          sample_a(intern_item.StartTx,intern_item.SampleData,sa);
        end
      else
        sa=0;

      //Scenario B
      if(c_state==`resetmode)
        begin
          reset(out_item);
          inkey=0;
          sa=0;
          resetRead=1;
          counter=0;
          key=0;
        end

      //Scenario C
      if(out_item.CalcActive && in_item.ValidCmd && (out_item.CalcMode!=in_item.InputKey))
        $error ("T=%0t [Scoreboard] FAIL! Mode switch Mode 0 / Mode 1 ....................................................................................",$time);

      //Scenario G
      if(c_state==`mode1write)
        resetRead=0;
      else
        if(c_state==`mode1read)
          begin
            if(out_item.DataOut!=0)
              $error ("T=%0t [Scoreboard] FAIL! Read after reset ....................................................................................",$time);
          end

      //Scenario H
      if(p_state==`mode1read && (in_item.RWMem && c_state!=`mode1write))
        $error ("T=%0t [Scoreboard] FAIL! Mode R/W switch....................................................................................",$time);

      //Scenario K
      if((inkey!=0)||(c_state==`inputkeymode && c_state!=p_state))
        keyFun(inkey,counter,key,c_state,out_item,in_item);

    end
  endtask


  function void reset(Out_item #(OUTSIZE) out);
    if(!out.CalcActive && !out.CalcMode && !out.Busy && !out.DOutValid && !out.StartTx && !out.ClkTx && out.DataOut=='hz)
      $display ("T=%0t [Scoreboard] PASS! Reset....................................................................................",$time);
    else
      $error ("T=%0t [Scoreboard] FAIL! Reset....................................................................................",$time);
  endfunction


  function void sample_a(StartTx,SampleData,ref [2:0]sa);
              $display ("T=%0t [Scoreboard] Sample : sa%0h",$time,sa);
    if(sa>=`samplePeriods && sa<`startTxPeriods && !SampleData)
      $error ("T=%0t [Scoreboard] FAIL! Sample....................................................................................",$time);
    if(sa==`startTxPeriods)
      begin
        if(StartTx)
          $display ("T=%0t [Scoreboard] PASS! Sample....................................................................................",$time);
        else
          $error ("T=%0t [Scoreboard] FAIL! Sample....................................................................................",$time);
        sa=0;
      end
    else
      sa=sa+1;
  endfunction


  function void keyFun(ref logic inkey,
                       ref logic [4:0] counter,
                       ref logic [4:0] key,
                       logic [2:0] c_state,
                       Out_item #(OUTSIZE) out_item,
                       In_item in_item
                      );
    $display ("T=%0t ..... in func counter=%0h ", $time, counter);
    inkey=1;
    if(counter<`keyPeriods)
      begin
        inkeyoutput(out_item.CalcActive);
        if(c_state==`inputkeymode)
          begin
            counter=counter+1;
            if(counter%2==0)
              key = {key[3:0],in_item.InputKey};
          end
        else
          begin
            inkey=0;
            counter=0;
            key=0;
          end
      end
    else
      begin
        if(counter<=`keyPeriods)
          begin
            counter=counter+1;
            inkeyoutput(out_item.CalcActive);
          end
        else
          begin
            if(key[4:1]===4'b1010)
              begin
                if(out_item.CalcActive && out_item.CalcMode==key[0])
                  $display ("T=%0t [Scoreboard] PASS! Password....................................................................................",$time);
                else
                  begin
                    if(out_item.CalcActive)
                      $error ("T=%0t [Scoreboard] FAIL! Password no mode....................................................................................",$time);
                    else
                      $error ("T=%0t [Scoreboard] FAIL! Password mode but no active....................................................................................",$time);
                  end
              end
            else
              begin
                if(out_item.CalcMode)
                  $error ("T=%0t [Scoreboard] FAIL! mode active error....................................................................................",$time);
                else
                  $display ("T=%0t [Scoreboard] Wrong Password! but its ok ....................................................................................",$time);
                inkeyoutput(out_item.CalcActive);
              end
            inkey=0;
            counter=0;
            key=0;
            if(c_state==`inputkeymode)
              inkey=1;
          end
      end
  endfunction


  function void inkeyoutput(Active);
    if(Active)
      begin
        inkey=0;
        counter=0;
        key=0;
        $error ("T=%0t [Scoreboard] FAIL! Password....................................................................................",$time);
      end

  endfunction
endclass