`include "alu_defines.sv"
class alu_driver;
    alu_transaction drv_trans;
    mailbox #(alu_transaction) mbx_gen2drv;
    mailbox #(alu_transaction) mbx_drv2ref;
    virtual alu_interface.DRV vidrv;
    alu_transaction temp_trans;
    bit found_valid_11;

    event ev_dr;

    covergroup cg_drv;
      INPUT_VALID : coverpoint drv_trans.INP_VALID { bins valid_opa = {2'b01};
                                                     bins valid_opb = {2'b10};
                                                     bins valid_both = {2'b11};
                                                     bins invalid = {2'b00};
                                                   }
      COMMAND : coverpoint drv_trans.CMD { bins arithmetic[] = {[0:10]};
                                           bins logical[] = {[0:13]};
                                           bins arithmetic_invalid[] = {[11:15]};
                                           bins logical_invalid[] = {14,15};
                                          }
      MODE : coverpoint drv_trans.MODE { bins arithmetic = {1};
                                         bins logical = {0};
                                       }
      CLOCK_ENABLE : coverpoint drv_trans.CE { bins clock_enable_valid = {1};
                                               bins clock_enable_invalid = {0};
                                               }
      OPERAND_A : coverpoint drv_trans.OPA { bins opa[]={[0:(2**`WIDTH)-1]};}
      OPERAND_B : coverpoint drv_trans.OPB { bins opb[]={[0:(2**`WIDTH)-1]};}
      CARRY_IN : coverpoint drv_trans.CIN { bins cin_high = {1};
                                            bins cin_low = {0};
                                          }
      MODE_CMD_: cross MODE,COMMAND;
    endgroup:cg_drv

    function new(mailbox #(alu_transaction) mbx_gen2drv,mailbox #(alu_transaction) mbx_drv2ref,virtual alu_interface.DRV vidrv,event ev_dr);
        this.mbx_gen2drv = mbx_gen2drv;
        this.mbx_drv2ref = mbx_drv2ref;
        this.vidrv = vidrv;
        this.ev_dr = ev_dr;
        cg_drv = new();
    endfunction:new

     task start();
    repeat(3)@(vidrv.cb_driver);
          for(int i=0;i<`no_of_transaction;i++)begin:transaction_count
                drv_trans = new();
                mbx_gen2drv.get(drv_trans);
              if(is_single_operand_operation(drv_trans))begin:is_single_operand_operation_check
                  vidrv.cb_driver.INP_VALID <= drv_trans.INP_VALID;
                  vidrv.cb_driver.CMD <= drv_trans.CMD;
                  vidrv.cb_driver.MODE <= drv_trans.MODE;
                  vidrv.cb_driver.OPA <= drv_trans.OPA;
                  vidrv.cb_driver.OPB <= drv_trans.OPB;
                  vidrv.cb_driver.CIN <= drv_trans.CIN;
                  vidrv.cb_driver.CE <= drv_trans.CE;

                  $display("Driver driving the data to interface IPV_VALID = %0b,MODE = %0b, CMD = %0b, CE = %0b, OPA =%0b, OPB = %0b, CIN = %0b",vidrv.cb_driver.INP_VALID,vidrv.cb_driver.MODE,vidrv.cb_driver.CMD,vidrv.cb_driver.CE,vidrv.cb_driver.OPA,vidrv.cb_driver.OPB,vidrv.cb_driver.CIN,$time);
                  mbx_drv2ref.put(drv_trans);
                  ->ev_dr;
                  cg_drv.sample();
                  $display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage());
                  repeat(4)@(vidrv.cb_driver);
              end:is_single_operand_operation_check

              else if(drv_trans.INP_VALID == 2'b11 || drv_trans.INP_VALID == 2'b00)begin:multiple_operand_with_INP_VALID_11_00
                  vidrv.cb_driver.INP_VALID <=drv_trans.INP_VALID;
                  vidrv.cb_driver.CMD <= drv_trans.CMD;
                  vidrv.cb_driver.MODE <= drv_trans.MODE;
                  vidrv.cb_driver.OPA <= drv_trans.OPA;
                  vidrv.cb_driver.OPB <= drv_trans.OPB;
                  vidrv.cb_driver.CIN <= drv_trans.CIN;
                  vidrv.cb_driver.CE <= drv_trans.CE;

                  $display("Driver driving the data to interface IPV_VALID = %0b,MODE = %0b, CMD = %0b, CE = %0b, OPA =%0b, OPB = %0b, CIN = %0b",vidrv.cb_driver.INP_VALID,vidrv.cb_driver.MODE,vidrv.cb_driver.CMD,vidrv.cb_driver.CE,vidrv.cb_driver.OPA,vidrv.cb_driver.OPB,vidrv.cb_driver.CIN,$time);
                  mbx_drv2ref.put(drv_trans);
                  ->ev_dr;
                  cg_drv.sample();
                  $display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage());
                  repeat(4)@(vidrv.cb_driver);
              end:multiple_operand_with_INP_VALID_11_00
              else begin:waiting_for_16_cycle
                  vidrv.cb_driver.INP_VALID <= drv_trans.INP_VALID;
                  vidrv.cb_driver.CMD <= drv_trans.CMD;
                  vidrv.cb_driver.MODE <= drv_trans.MODE;
                  vidrv.cb_driver.OPA <= drv_trans.OPA;
                  vidrv.cb_driver.OPB <= drv_trans.OPB;
                  vidrv.cb_driver.CIN <= drv_trans.CIN;
                  vidrv.cb_driver.CE <= drv_trans.CE;

                  $display("Driver driving the data to interface IPV_VALID = %0b,MODE = %0b, CMD = %0b, CE = %0b, OPA =%0b, OPB = %0b, CIN = %0b",vidrv.cb_driver.INP_VALID,vidrv.cb_driver.MODE,vidrv.cb_driver.CMD,vidrv.cb_driver.CE,vidrv.cb_driver.OPA,vidrv.cb_driver.OPB,vidrv.cb_driver.CIN,$time);
                  mbx_drv2ref.put(drv_trans);
                  @(vidrv.cb_driver);
                  ->ev_dr;
                  cg_drv.sample();
                  $display("INPUT FUNCTIONAL COVERAGE =%2f ",cg_drv.get_coverage());

                  found_valid_11 = 1'b0;
                  temp_trans = new();

                  for(int clk_count = 0; clk_count < `MAX_WAIT_CYCLE && !found_valid_11; clk_count++)begin:cycle_16
                      temp_trans.CMD.rand_mode(0);
                      temp_trans.MODE.rand_mode(0);

                      temp_trans.CMD = drv_trans.CMD;
                      temp_trans.MODE = drv_trans.MODE;

                      void'(temp_trans.randomize());
                      @(vidrv.cb_driver);
                      if(temp_trans.INP_VALID == 2'b11)begin:got_INP_VALID_11
                          found_valid_11 = 1'b1;
                          $display("FOUND INP_VALID == 11 AT CYCLE %0d ",clk_count+1);
                          vidrv.cb_driver.INP_VALID <= temp_trans.INP_VALID;
                          vidrv.cb_driver.CMD <= temp_trans.CMD;
                          vidrv.cb_driver.MODE <= temp_trans.MODE;
                          vidrv.cb_driver.OPA <= temp_trans.OPA;
                          vidrv.cb_driver.OPB <= temp_trans.OPB;
                          vidrv.cb_driver.CIN <= temp_trans.CIN;
                          vidrv.cb_driver.CE <= temp_trans.CE;

                           $display("Driver driving the data to interface IPV_VALID = %0b,MODE = %0b, CMD = %0b, CE = %0b, OPA =%0b, OPB = %0b, CIN = %0b",vidrv.cb_driver.INP_VALID,vidrv.cb_driver.MODE,vidrv.cb_driver.CMD,vidrv.cb_driver.CE,vidrv.cb_driver.OPA,vidrv.cb_driver.OPB,vidrv.cb_driver.CIN,$time);
                          mbx_drv2ref.put( temp_trans);

                          @(vidrv.cb_driver);
                          ->ev_dr;
                          cg_drv.sample();
                          $display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage());
                          repeat(4)@(vidrv.cb_driver);
                          break;
                    end:got_INP_VALID_11

                    else begin:did_not_got_INP_VALID_11
                          vidrv.cb_driver.CMD <= temp_trans.CMD;
                          vidrv.cb_driver.MODE <= temp_trans.MODE;
                          vidrv.cb_driver.OPA <= temp_trans.OPA;
                          vidrv.cb_driver.OPB <= temp_trans.OPB;
                          vidrv.cb_driver.CIN <= temp_trans.CIN;
                          vidrv.cb_driver.CE <= temp_trans.CE;

                          $display("Driver driving the data to interface and waiting for 11 IPV_VALID = %0b,MODE = %0b, CMD = %0b, CE = %0b, OPA =%0b, OPB = %0b, CIN = %0b",vidrv.cb_driver.INP_VALID,vidrv.cb_driver.MODE,vidrv.cb_driver.CMD,vidrv.cb_driver.CE,vidrv.cb_driver.OPA,vidrv.cb_driver.OPB,vidrv.cb_driver.CIN,$time);
                          mbx_drv2ref.put(drv_trans);
                          @(vidrv.cb_driver);
                          ->ev_dr;
                          cg_drv.sample();
                          $display("INPUT FUNCTIONAL COVERAGE =%.2f ",cg_drv.get_coverage());
                          repeat(4)@(vidrv.cb_driver);
                    end:did_not_got_INP_VALID_11
                  end:cycle_16

                  if(!found_valid_11)begin:error_case
                      $display("DID NOT FOUND INP_VALID == 1 WITHIN %0d CLOCK CYCLE",`MAX_WAIT_CYCLE);
                  end:error_case
               end:waiting_for_16_cycle
            end:transaction_count
    endtask:start

    function bit is_single_operand_operation(alu_transaction drv_trans);
        if(drv_trans.MODE == 1'b1)begin:arithmetic_single_operand_operation
          case (drv_trans.CMD)
              `INC_A,`INC_B,`DEC_A,`DEC_B: return 1;
              default : return 0;
          endcase
        end:arithmetic_single_operand_operation

        else begin:logical_single_operand_operation
          case(drv_trans.CMD)
              `NOT_A,`NOT_B,`SHR1_A,`SHL1_A,`SHR1_B,`SHL1_B : return 1;
              default : return 0;
          endcase
       end:logical_single_operand_operation
    endfunction:is_single_operand_operation
endclass:alu_driver
                    
