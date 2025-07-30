`include "alu_defines.sv"
class alu_monitor;
    alu_transaction mon_trans;
    mailbox #(alu_transaction) mbx_mon2scb;
    virtual alu_interface.MON vimon;

    event ev_rm;

    covergroup cg_monitor;
      RESULT_CHECK:coverpoint mon_trans.RES { bins result[]={[0:(2**`WIDTH)-1]};
                                                            option.auto_bin_max = 8;}
      CARR_OUT:coverpoint mon_trans.COUT{ bins cout_active = {1};
                                          bins cout_inactive = {0};
                                        }
      OVERFLOW:coverpoint mon_trans.OFLOW { bins oflow_active = {1};
                                            bins oflow_inactive = {0};
                                          }
      ERROR:coverpoint mon_trans.ERR { bins error_active = {1};
                                     }
      GREATER:coverpoint mon_trans.G { bins greater_active = {1};
                                     }
      EQUAL:coverpoint mon_trans.E { bins equal_active = {1};
                                   }
      LESSER:coverpoint mon_trans.L { bins lesser_active = {1};
                                    }
    endgroup

    function new(mailbox #(alu_transaction) mbx_mon2scb,virtual alu_interface.MON vimon,event ev_rm);
        this.mbx_mon2scb = mbx_mon2scb;
        this.vimon = vimon;
        this.ev_rm = ev_rm;
        cg_monitor = new();
    endfunction:new
 task start();
      int count;
      count = 0;
      repeat(1)@(vimon.cb_monitor);
        for(int i=0;i<`no_of_transaction;i++)begin:transaction_count
          mon_trans = new();
            @(ev_rm);
            mon_trans.RES = vimon.cb_monitor.RES;
            mon_trans.COUT = vimon.cb_monitor.COUT;
            mon_trans.ERR = vimon.cb_monitor.ERR;
            mon_trans.OFLOW = vimon.cb_monitor.OFLOW;
            mon_trans.G = vimon.cb_monitor.G;
            mon_trans.E = vimon.cb_monitor.E;
            mon_trans.L = vimon.cb_monitor.L;
            mon_trans.INP_VALID = vimon.cb_monitor.INP_VALID;
            mon_trans.CE = vimon.cb_monitor.CE;
            mon_trans.CIN = vimon.cb_monitor.CIN;
            mon_trans.OPA = vimon.cb_monitor.OPA;
            mon_trans.OPB = vimon.cb_monitor.OPB;
            mon_trans.CMD = vimon.cb_monitor.CMD;
            mon_trans.MODE = vimon.cb_monitor.MODE;
          /*  if(mon_trans.INP_VALID == 1 || mon_trans.INP_VALID == 2)begin
                count++;
                if(count > 16)begin
                    count = 0;
                end
                else begin
                    i--;
                end
            end
            if(i > `no_of_transaction - 1)begin
                break;
            end*/
            $display("MONITOR PASSING DATA TO SCOREBOARD INP_VALD = %0d, CE = %0d, CIN = %0D, OPA = %0d, OPB = %0d, CMD = %0d, MODE = %0d, RES = %0d, COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d",mon_trans.INP_VALID,mon_trans.CE,mon_trans.CIN,mon_trans.OPA,mon_trans.OPB,mon_trans.CMD,mon_trans.MODE,mon_trans.RES,mon_trans.COUT,mon_trans.ERR,mon_trans.OFLOW,mon_trans.G,mon_trans.E,mon_trans.L,$time);
        mbx_mon2scb.put(mon_trans);
        cg_monitor.sample();
            $display("The outputcoverage %.2f",cg_monitor.get_coverage());
        end:transaction_count
    endtask:start
endclass:alu_monitor
