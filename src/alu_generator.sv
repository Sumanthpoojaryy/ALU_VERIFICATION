`include "alu_defines.sv"
class alu_generator;
    alu_transaction gen_trans;
    mailbox #(alu_transaction) mbx_gen2drv;

    function new(mailbox #(alu_transaction) mbx_gen2drv);
        this.mbx_gen2drv = mbx_gen2drv;
        gen_trans = new();
    endfunction:new

    task start();
      for(int i=0;i<`no_of_transaction;i++)begin
          gen_trans.randomize();
          mbx_gen2drv.put(gen_trans.copy());
          $display("Generator randomized transaction IPV_VALID = %0d,MODE = %0d, CMD = %0d, CE = %0d, OPA =%0d, OPB = %0d, CIN = %0d",gen_trans.INP_VALID,gen_trans.MODE,gen_trans.CMD,gen_trans.CE,gen_trans.OPA,gen_trans.OPB,gen_trans.CIN,$time);
      end
    endtask:start

endclass:alu_generator
