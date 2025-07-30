`include "alu_defines.sv"
interface alu_interface( input logic CLK,RESET);
    logic [1:0]             INP_VALID;
    logic                   MODE;
    logic [`CMD_WIDTH-1:0]  CMD;
    logic                   CE;
    logic [`WIDTH-1:0]      OPA;
    logic [`WIDTH-1:0]      OPB;
    logic                   CIN;
    logic                   ERR;
    logic [`WIDTH:0]        RES;
    logic                   COUT;
    logic                   OFLOW;
    logic                   G;
    logic                   E;
    logic                   L;

    clocking cb_driver @(posedge CLK);
        default input #0 output #0;
        output INP_VALID,MODE,CMD,CE,OPA,OPB,CIN;
    endclocking:cb_driver

    clocking cb_monitor @(posedge CLK);
        default input #0 output #0;
        input ERR,RES,COUT,OFLOW,E,G,L;
        input INP_VALID,MODE,CMD,CE,OPA,OPB,CIN;
    endclocking:cb_monitor

    clocking cb_reference_model @(posedge CLK or posedge RESET);
        default input #0 output #0;
        input INP_VALID,MODE,CMD,CE,OPA,OPB,CIN,RESET;
    endclocking:cb_reference_model

    modport DRV(clocking cb_driver);
    modport MON(clocking cb_monitor);
    modport REF(clocking cb_reference_model);

     property ppt_reset;
        @(posedge CLK) RESET |=> ##[1:10] (RES === 9'bzzzzzzzz && ERR === 1'bz && E === 1'bz && G === 1'bz && L === 1'bz && COUT === 1'bz && OFLOW === 1'bz)
    endproperty:ppt_reset
    assert property(ppt_reset)
        $display("RST assertion PASSED at time %0t", $time);
    else
        $info("RST assertion FAILED @ time %0t", $time);

    //2. 16- cycle TIMEOUT assertion
    property ppt_timeout_arithmetic;
        @(posedge CLK) disable iff(RESET) (CE && (CMD == `ADD || CMD == `SUB || CMD == `ADD_CIN || CMD == `SUB_CIN || CMD == `MUL_SHIFT || CMD == `MUL_INC) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
    endproperty:ppt_timeout_arithmetic
    assert property(ppt_timeout_arithmetic)
        $display("TIMEOUT FOR ARITHMETIC assertion PASSED at time %0t", $time);
    else
        $warning("Timeout assertion failed at time %0t", $time);

    property ppt_timeout_logical;
        @(posedge CLK) disable iff(RESET) (CE && (CMD == `AND || CMD == `OR || CMD == `NAND || CMD == `XOR || CMD == `XNOR || CMD == `NOR || CMD == `SHR1_A || CMD == `SHR1_B || CMD == `SHL1_A || CMD == `SHL1_B || CMD == `ROR_A_B  || CMD == `ROL_A_B) && (INP_VALID == 2'b01 || INP_VALID == 2'b10)) |-> ##16 (ERR == 1'b1);
    endproperty:ppt_timeout_logical
    assert property(ppt_timeout_logical)
        $display("TIMEOUT FOR LOGICAL assertion PASSED at time %0t", $time);
    else
        $warning("Timeout assertion failed at time %0t", $time);

    //3. ROR/ROL error
    assert property (@(posedge CLK) disable iff(RESET) (CE && MODE && (CMD == `ROR_A_B || CMD == `ROL_A_B) && $countones(OPB) > `ROR_WIDTH) |=> ##[1:6] ERR )
        $display("ROR ERROR assertion PASSED at time %0t", $time);
    else
        $info("NO ERROR FLAG RAISED");

       //4. CMD out of range
    property Invalid_command;
      @(posedge CLK) (MODE && CMD > 10) |-> ##[1:5] ERR;
    endproperty:Invalid_command
    assert property (Invalid_command)
        $display("CMD out of range for arithmetic assertion PASSED at time %0t", $time);
    else
        $info("CMD INVALID ERR NOT RAISED");

    //5. CMD out of range logical
    property out_range_logical;
        @(posedge CLK) (!MODE && CMD > 13) |-> ##[1:5] ERR;
    endproperty: out_range_logical
    assert property (out_range_logical)
        $info("CMD out of range for logical assertion PASSED at time %0t", $time);
    else
        $info("CMD INVALID ERR NOT RAISED");

    // 7. INP_VALID 00 case
    property invalid_00;
        @(posedge CLK) (INP_VALID == 2'b00) |-> ##[1:3] ERR;
    endproperty:invalid_00
    assert property ( invalid_00)
        $display("INP_VALID 00  assertion PASSED at time %0t", $time);
    else
        $info("ERROR NOT raised");

    //8. CE assertion
    property ppt_clock_enable;
        @(posedge CLK) disable iff(RESET) !CE |-> ##[1:5] ($stable(RES) && $stable(COUT) && $stable(OFLOW) && $stable(G) && $stable(L) && $stable(E) && $stable(ERR));
    endproperty:ppt_clock_enable
    assert property(ppt_clock_enable)
        $display("ENABLE  assertion PASSED at time %0t", $time);
    else
        $info("Clock enable assertion failed at time %0t", $time);
endinterface:alu_interface
