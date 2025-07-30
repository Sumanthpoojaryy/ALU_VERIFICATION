`include "alu_defines.sv"
class alu_scoreboard;
    alu_transaction ref2scb_trans,mon2scb_trans;
    mailbox #(alu_transaction) mbx_mon2scb;
    mailbox #(alu_transaction) mbx_ref2scb;
    static int MATCH,MISMATCH;
    static int no_of_trans;

    function new(mailbox #(alu_transaction) mbx_mon2scb,mailbox #(alu_transaction) mbx_ref2scb);
        this.mbx_mon2scb = mbx_mon2scb;
        this.mbx_ref2scb = mbx_ref2scb;
    endfunction:new

    task start();
      int count;
      for(int i=0;i<`no_of_transaction;i++)begin
            ref2scb_trans = new();
            mon2scb_trans =new();
            fork
                begin
                    mbx_mon2scb.get(mon2scb_trans);
                    $display("MONITOR TO SCOREBOARD DATA INP_VALD = %0d, CE = %0d, CIN = %0D, OPA = %0d, OPB = %0d, CMD = %0d, MODE = %0d, RES = %0d, COUT = %0d, ERR = %0d,OFLOW = %0d, G = %0d, E = %0d, L = %0d",mon2scb_trans.INP_VALID,mon2scb_trans.CE,mon2scb_trans.CIN,mon2scb_trans.OPA,mon2scb_trans.OPB,mon2scb_trans.CMD,mon2scb_trans.MODE,mon2scb_trans.RES,mon2scb_trans.COUT,mon2scb_trans.ERR,mon2scb_trans.OFLOW,mon2scb_trans.G,mon2scb_trans.E,mon2scb_trans.L,$time);
                end
                begin
                    mbx_ref2scb.get(ref2scb_trans);
                    $display("REFERENCE MODEL TO SCOREBOARD DATA INP_VALD = %0d, CE = %0d, CIN = %0D, OPA = %0d, OPB = %0d, CMD = %0d, MODE = %0d, RES = %0d, COUT = %0d, ERR = %0d,OFLOW = %0d, G = %0d, E = %0d, L = %0d",ref2scb_trans.INP_VALID,ref2scb_trans.CE,ref2scb_trans.CIN,ref2scb_trans.OPA,ref2scb_trans.OPB,ref2scb_trans.CMD,ref2scb_trans.MODE,ref2scb_trans.RES,ref2scb_trans.COUT,ref2scb_trans.ERR,ref2scb_trans.OFLOW,ref2scb_trans.G,ref2scb_trans.E,ref2scb_trans.L,$time);
                end
            join
/*          if(mon2scb_trans.INP_VALID == 1 || mon2scb_trans.INP_VALID == 2)begin
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
            end
  */
            compare_report();
            no_of_trans++;
            $display("===FINAL REPORT===");
            $display("TOTAL TRANSACTION = %0d",`no_of_transaction);
            $display("MATCHES = %0d",MATCH);
            $display("MISMATCHES = %0d",MISMATCH);
            $display("SUCCESS RATE = %0.2f%%",(MATCH*100.00)/no_of_trans);
      end
    endtask:start
    task compare_report();
        bit inp_valid_match = (ref2scb_trans.INP_VALID === mon2scb_trans.INP_VALID);
        bit res_match = (ref2scb_trans.RES === mon2scb_trans.RES);
        bit cout_match = (ref2scb_trans.COUT === mon2scb_trans.COUT);
        bit oflow_match = (ref2scb_trans.OFLOW === mon2scb_trans.OFLOW);
        bit err_match = (ref2scb_trans.ERR === mon2scb_trans.ERR);
        bit greater_match = (ref2scb_trans.G === mon2scb_trans.G);
        bit equality_match = (ref2scb_trans.E === mon2scb_trans.E);
        bit lesser_match = (ref2scb_trans.L === mon2scb_trans.L);

        $display("%0d %0d %0d %0d %0d %0d %0d",res_match,cout_match,oflow_match,err_match,greater_match,equality_match,lesser_match);
        $display("%0d %0d",ref2scb_trans.RES,mon2scb_trans.RES);

        if(/*inp_valid_match && ce_match && cin_match && opa_match && opb_match && cmd_match && mode_match &&*/ res_match && cout_match && oflow_match && err_match && greater_match && equality_match && lesser_match)begin:compare_pass
            MATCH++;
            $display("SCOREBOARD: MATCH -expected RES = %0d,COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d",mon2scb_trans.RES,mon2scb_trans.COUT,mon2scb_trans.ERR,mon2scb_trans.OFLOW,mon2scb_trans.G,mon2scb_trans.E,mon2scb_trans.L,$time);
        end:compare_pass

        else begin:compare_fail
            MISMATCH++;
            $display("SCOREBOARD: MISMATCH -expected RES = %0d,COUT = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d",ref2scb_trans.RES,ref2scb_trans.COUT,ref2scb_trans.ERR,ref2scb_trans.OFLOW,ref2scb_trans.G,ref2scb_trans.E,ref2scb_trans.L,$time);
        end:compare_fail
    endtask:compare_report
endclass:alu_scoreboard
