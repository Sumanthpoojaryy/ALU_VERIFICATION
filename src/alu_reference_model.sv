`include "alu_defines.sv"
class alu_reference_model;
    alu_transaction ref_trans;
    mailbox #(alu_transaction) mbx_drv2ref;
    mailbox #(alu_transaction) mbx_ref2scb;
    virtual alu_interface.REF viref;
    int value1;

    event ev_rm;
    event ev_dr;

    logic [`WIDTH:0] prev_RES;
    logic prev_COUT;
    logic prev_OFLOW;
    logic prev_ERR;
    logic prev_G;
    logic prev_E;
    logic prev_L;
    bit first_transaction;

    function new(mailbox #(alu_transaction) mbx_drv2ref,mailbox #(alu_transaction) mbx_ref2scb,virtual alu_interface.REF viref,event ev_dr,event ev_rm);
        this.mbx_drv2ref = mbx_drv2ref;
        this.mbx_ref2scb = mbx_ref2scb;
        this.viref = viref;
        this.ev_dr = ev_dr;
        this.ev_rm = ev_rm;

        this.prev_RES = {`WIDTH+1{1'bz}};
        this.prev_COUT = 1'bz;
        this.prev_OFLOW = 1'bz;
        this.prev_ERR = 1'bz;
        this.prev_G = 1'bz;
        this.prev_E = 1'bz;
        this.prev_L = 1'bz;
        this.first_transaction = 1'b1;
    endfunction:new

    task start();
    repeat(1)@(viref.cb_reference_model);
        ref_trans = new();
        for(int i = 0; i<`no_of_transaction ; i++)begin:transaction_count
            @(ev_dr);
            $display("triggered",$time);
            mbx_drv2ref.get(ref_trans);
            if(is_two_operand_operation(ref_trans))begin:is_two_operand_operation_with_INP_VALID_01_10
                ref_trans.RES = {`WIDTH+1{1'bz}};
                ref_trans.COUT = 1'bz;
                ref_trans.OFLOW = 1'bz;
                ref_trans.ERR = 1'bz;
                ref_trans.G = 1'bz;
                ref_trans.E = 1'bz;
                ref_trans.L = 1'bz;
                display_and_send_result(ref_trans);
                ->ev_rm;
                wait_for_valid_11(ref_trans);
            end:is_two_operand_operation_with_INP_VALID_01_10

            else if(ref_trans.CMD == `MUL_INC || ref_trans.CMD == `MUL_SHIFT)begin:two_operand_operation_multiplication
                repeat(3)@(viref.cb_reference_model);
                $display("%0d",ref_trans.OPA);
                compute_result(ref_trans);
                display_and_send_result(ref_trans);
                ->ev_rm;
            end:two_operand_operation_multiplication

            else begin:INP_valid_11
                repeat(2)@(viref.cb_reference_model);
                compute_result(ref_trans);
                display_and_send_result(ref_trans);
                ->ev_rm;
            end:INP_valid_11
       end:transaction_count
    endtask:start

    task store_previous_outputs(alu_transaction trans);
        prev_RES = trans.RES;
        prev_COUT = trans.COUT;
        prev_OFLOW = trans.OFLOW;
        prev_ERR = trans.ERR;
        prev_G = trans.G;
        prev_E = trans.E;
        prev_L = trans.L;
        first_transaction = 1'b0;
    endtask:store_previous_outputs

    task load_previous_outputs(alu_transaction trans);
        if(first_transaction) begin
            trans.RES = {`WIDTH+1{1'bz}};
            trans.COUT = 1'bz;
            trans.OFLOW = 1'bz;
            trans.ERR = 1'bz;
            trans.G = 1'bz;
            trans.E = 1'bz;
            trans.L = 1'bz;
        end 
        else begin
            trans.RES = prev_RES;
            trans.COUT = prev_COUT;
            trans.OFLOW = prev_OFLOW;
            trans.ERR = prev_ERR;
            trans.G = prev_G;
            trans.E = prev_E;
            trans.L = prev_L;
        end
    endtask:load_previous_outputs

    function bit is_two_operand_operation(alu_transaction ref_trans);
        if(ref_trans.MODE == 1'b1)begin:arithmetic
          if(ref_trans.INP_VALID == 2'b01 || ref_trans.INP_VALID == 2'b10)begin:check_INP_VALID_01_10
            case(ref_trans.CMD)
              `ADD,`SUB,`ADD_CIN,`SUB_CIN,`CMP,`MUL_INC,`MUL_SHIFT : return 1;
              default : return 0;
            endcase
          end:check_INP_VALID_01_10
        end:arithmetic
       else begin:logical
          if(ref_trans.INP_VALID == 2'b01 || ref_trans.INP_VALID == 2'b10)begin:check_INP_VALID_01_10
            case(ref_trans.CMD)
              `AND,`NAND,`OR,`NOR,`XOR,`XNOR : return 1;
              default : return 0;
            endcase
          end:check_INP_VALID_01_10
        end:logical
    endfunction:is_two_operand_operation

    task wait_for_valid_11(alu_transaction ref_trans);
        alu_transaction temp_trans;
        int cycle_count = 0;
        bit found_valid_11 = 1'b0;

        $display("Two operand operation detected with INP_VALID = %0d ,waiting for INP_VALID = 2'b11",ref_trans.INP_VALID);

        temp_trans = new();

        while(cycle_count < `MAX_WAIT_CYCLE && !found_valid_11)begin:cycle_count_check
            @(ev_dr);
            $display("triggered",$time);
            mbx_drv2ref.get(temp_trans);
            cycle_count++;
            if(temp_trans.INP_VALID == 2'b11)begin:got_INP_VALID_11
                $display("INP_VALID = 2'b11 received at cycle = %0d",cycle_count);
                found_valid_11 = 1'b1;
                compute_result(temp_trans);
                display_and_send_result(temp_trans);
                @(viref.cb_reference_model);
                ->ev_rm;
                break;
            end:got_INP_VALID_11
            else begin:did_not_got_INP_VALID_11
                $display("Received INP_VALID = %0d at cycle = %0d,waiting for 11",temp_trans.INP_VALID,cycle_count);
                temp_trans.RES = {`WIDTH+1{1'bz}};
                temp_trans.COUT = 1'bz;
                temp_trans.OFLOW = 1'bz;
                temp_trans.ERR = 1'bz;
                temp_trans.G = 1'bz;
                temp_trans.E = 1'bz;
                temp_trans.L = 1'bz;

                display_and_send_result(temp_trans);
                ->ev_rm;
            end:did_not_got_INP_VALID_11
        end:cycle_count_check

        if(found_valid_11 == 1'b0)begin:error_case
            $display("INP_VALID = 11 not found");
            temp_trans.RES = {`WIDTH+1{1'bz}};
            temp_trans.COUT = 1'bz;
            temp_trans.OFLOW = 1'bz;
            temp_trans.ERR = 1'b1;
            temp_trans.G = 1'bz;
            temp_trans.E = 1'bz;
            temp_trans.L = 1'bz;

            display_and_send_result(temp_trans);
            ->ev_rm;
        end:error_case
    endtask:wait_for_valid_11

    task display_and_send_result(alu_transaction ref_trans);

        $display("REFERENCE MODEL OUTPUT : INP_VALID = %0d, CE = %0d, CIN = %0d, OPA = %0d, OPB = %0d, CMD = %0d, MODE = %0d, RES = %0d, COUT  = %0d, ERR = %0d, OFLOW = %0d, G = %0d, E = %0d, L = %0d",ref_trans.INP_VALID,ref_trans.CE,ref_trans.CIN,ref_trans.OPA,ref_trans.OPB,ref_trans.CMD,ref_trans.MODE,ref_trans.RES,ref_trans.COUT,ref_trans.ERR,ref_trans.OFLOW,ref_trans.G,ref_trans.E,ref_trans.L);

        mbx_ref2scb.put(ref_trans);
    endtask:display_and_send_result

   task compute_result(alu_transaction ref_trans);
        if(viref.cb_reference_model.RESET == 1'b1)begin:reset
            ref_trans.RES = {`WIDTH+1{1'bz}};
            ref_trans.COUT = 1'bz;
            ref_trans.ERR = 1'bz;
            ref_trans.OFLOW = 1'bz;
            ref_trans.G = 1'bz;
            ref_trans.E = 1'bz;
            ref_trans.L = 1'bz;
        end:reset

        else if(ref_trans.CE == 1'b0)begin
            load_previous_outputs(ref_trans);
        end

        else if(ref_trans.CE == 1'b1)begin:clock_enable_active
            ref_trans.RES = {`WIDTH+1{1'bz}};
            ref_trans.COUT = 1'bz;
            ref_trans.ERR = 1'bz;
            ref_trans.OFLOW = 1'bz;
            ref_trans.G = 1'bz;
            ref_trans.E = 1'bz;
            ref_trans.L = 1'bz;
            if(ref_trans.MODE == 1'b1)begin:arithmetic
                if(ref_trans.INP_VALID == 2'b00)begin:INP_VALID_00
                    ref_trans.ERR = 1'b1;
                end:INP_VALID_00

                else if(ref_trans.INP_VALID == 2'b01)begin:INP_VALID_01
                    case(ref_trans.CMD)
                        `INC_A : begin
                                    ref_trans.RES = ref_trans.OPA + 1;
                                 end
                        `DEC_A : begin
                                    ref_trans.RES = ref_trans.OPA - 1;
                                 end
                        default : ref_trans.ERR = 1'b1;
                    endcase
                end:INP_VALID_01
                else if(ref_trans.INP_VALID == 2'b10)begin:INP_VALID_10
                    case(ref_trans.CMD)
                        `INC_B : begin
                                    ref_trans.RES = ref_trans.OPB + 1;
                                 end
                        `DEC_B : begin
                                    ref_trans.RES = ref_trans.OPB - 1;
                                 end
                        default : ref_trans.ERR = 1'b1;
                    endcase
                end:INP_VALID_10

                else if(ref_trans.INP_VALID == 2'b11)begin:INP_valid_11
                    case(ref_trans.CMD)
                        `ADD : begin
                                  ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
                                  ref_trans.COUT = (ref_trans.RES[`WIDTH]) ? 1'b1 : 1'b0;
                               end
                        `SUB : begin
                                  ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
                                  ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB) ? 1'b1 : 1'b0;
                               end
                    `ADD_CIN : begin
                                  ref_trans.RES  = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
                                  ref_trans.COUT = (ref_trans.RES[`WIDTH]) ? 1'b1 : 1'b0;
                               end
                    `SUB_CIN : begin
                                  ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN;
                                  ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB || (ref_trans.OPA == ref_trans.OPB && ref_trans.CIN)) ? 1'b1 : 1'b0;
                               end
                      `INC_A : begin
                                  ref_trans.RES = ref_trans.OPA + 1;
                               end
                      `DEC_A : begin
                                  ref_trans.RES = ref_trans.OPA - 1;
                               end
                      `INC_B : begin
                                  ref_trans.RES = ref_trans.OPB + 1;
                               end
                      `DEC_A : begin
                                  ref_trans.RES = ref_trans.OPB - 1;
                               end
                        `CMP : begin:CMP
                                    if(ref_trans.OPA == ref_trans.OPB)begin:eqaul
                                          ref_trans.E = 1'b1;
                                    end:eqaul
                                    else if(ref_trans.OPA > ref_trans.OPB)begin:greater
                                          ref_trans.G = 1'b1;
                                    end:greater
                                    else begin:lesser
                                          ref_trans.L = 1'b1;
                                    end:lesser
                               end:CMP

                    `MUL_INC : begin:mul_increment
                                  ref_trans.OPA = ref_trans.OPA + 1;
                                  ref_trans.OPB = ref_trans.OPB + 1;
                                  ref_trans.RES = ref_trans.OPA * ref_trans.OPB;
                               end:mul_increment
                  `MUL_SHIFT : begin:mul_shift
                                  ref_trans.OPA = ref_trans.OPA << 1;
                                  ref_trans.RES = ref_trans.OPA * ref_trans.OPB;
                               end:mul_shift
                     default : ref_trans.ERR = 1'b1;
                    endcase
                end:INP_valid_11
            end:arithmetic
            else begin:logical
                if(ref_trans.INP_VALID == 2'b00)begin:INP_VALID_00
                    ref_trans.ERR = 1'b1;
                end:INP_VALID_00
                else if(ref_trans.INP_VALID == 2'b01)begin:INP_VALID_01
                   case(ref_trans.CMD)
                         `NOT_A : begin
                                    ref_trans.RES = {1'b0,~(ref_trans.OPA)};
                                  end
                        `SHR1_A : begin
                                    ref_trans.RES = {1'b0,ref_trans.OPA >> 1};
                                  end
                        `SHL1_A : begin
                                    ref_trans.RES = {1'b0,ref_trans.OPA << 1};
                                  end
                        default : ref_trans.ERR = 1'b1;
                    endcase
                end:INP_VALID_01
                else if(ref_trans.INP_VALID == 2'b10)begin:INP_VALID_10
                    case(ref_trans.CMD)
                         `NOT_B : begin
                                     ref_trans.RES = {1'b0,~(ref_trans.OPB)};
                                  end
                        `SHR1_B : begin
                                     ref_trans.RES = {1'b0,ref_trans.OPB >> 1};
                                  end
                        `SHL1_B : begin
                                     ref_trans.RES = {1'b0,ref_trans.OPB << 1};
                                  end
                        default : ref_trans.ERR = 1'b1;
                    endcase
                end:INP_VALID_10

                else if(ref_trans.INP_VALID == 2'b11)begin:INP_valid_11
                    case(ref_trans.CMD)
                         `AND : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPA & ref_trans.OPB};
                                end
                        `NAND : begin
                                   ref_trans.RES = {1'b0,~(ref_trans.OPA & ref_trans.OPB)};
                                end
                          `OR : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPA | ref_trans.OPB};
                                end
                         `NOR : begin
                                   ref_trans.RES = {1'b0,~(ref_trans.OPA | ref_trans.OPB)};
                                end
                         `XOR : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPA ^ ref_trans.OPB};
                                end
                        `XNOR : begin
                                   ref_trans.RES = {1'b0,~(ref_trans.OPA ^ ref_trans.OPB)};
                                end
                       `NOT_A : begin
                                   ref_trans.RES = {1'b0,~(ref_trans.OPA)};
                                end
                      `SHR1_A : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPA >> 1};
                                end
                      `SHL1_A : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPA << 1};
                                end
                       `NOT_B : begin
                                   ref_trans.RES = {1'b0,~(ref_trans.OPB)};
                                end
                      `SHR1_B : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPB >> 1};
                                end
                      `SHL1_B : begin
                                   ref_trans.RES = {1'b0,ref_trans.OPB << 1};
                                end
                     `ROL_A_B : begin
                                   value1 =  ref_trans.OPB[`ROR_WIDTH-1:0];
                                   ref_trans.RES = {1'b0,(ref_trans.OPA << value1 | ref_trans.OPA >> (`WIDTH - value1))};
                                   ref_trans.ERR = (ref_trans.OPB > {`ROR_WIDTH + 1{1'b1}});
                                end
                     `ROR_A_B : begin
                                   value1 =  ref_trans.OPB[`ROR_WIDTH-1:0];
                                   ref_trans.RES = {1'b0,(ref_trans.OPA >> value1 | ref_trans.OPA << (`WIDTH - value1))};
                                   ref_trans.ERR = (ref_trans.OPB > {`ROR_WIDTH + 1{1'b1}});
                                end
                      default : ref_trans.ERR = 1'b1;
                    endcase
                end:INP_valid_11
            end:logical

            store_previous_outputs(ref_trans);
        end:clock_enable_active
    endtask:compute_result
endclass:alu_reference_model
