`include "alu_defines.sv"
`include "design.v"
`include "alu_transaction.sv"
`include "alu_generator.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_scoreboard.sv"
`include "alu_reference_model.sv"
`include "alu_environment.sv"
`include "alu_test.sv"
`include "alu_interface.sv"

module top;
    bit CLK;
    bit RESET;

    initial begin:clock_begin
        CLK = 1'b0;
        forever #(`CLK_PERIOD/2) CLK = ~ CLK;
    end:clock_begin

    initial begin:reset_begin
        @(posedge CLK)
        RESET = 1'b0;
        #200;RESET = 1'b0;
    end:reset_begin

    initial begin
       $dumpfile("waveform.vcd"); // Specifies the VCD file name
       $dumpvars(1, top);
    end

    alu_interface intf(CLK,RESET);

     ALU_DESIGN #(.DW(`WIDTH),.CW(`CMD_WIDTH)) DUT(
      .CLK(CLK),
      .RST(RESET),
      .OPA(intf.OPA),
      .OPB(intf.OPB),
      .INP_VALID(intf.INP_VALID),
      .CMD(intf.CMD),
      .MODE(intf.MODE),
      .CE(intf.CE),
      .CIN(intf.CIN),
      .RES(intf.RES),
      .COUT(intf.COUT),
      .ERR(intf.ERR),
      .OFLOW(intf.OFLOW),
      .G(intf.G),
      .E(intf.E),
      .L(intf.L)
    );

    alu_test tb = new(intf.DRV,intf.MON,intf.REF);
    test1 tb1 = new(intf.DRV,intf.MON,intf.REF);
    test2 tb2 = new(intf.DRV,intf.MON,intf.REF);
    test3 tb3 = new(intf.DRV,intf.MON,intf.REF);
    test4 tb4 = new(intf.DRV,intf.MON,intf.REF);
    test5 tb5 = new(intf.DRV,intf.MON,intf.REF);
    test6 tb6 = new(intf.DRV,intf.MON,intf.REF);
    test7 tb7 = new(intf.DRV,intf.MON,intf.REF);
    test8 tb8 = new(intf.DRV,intf.MON,intf.REF);
    test9 tb9 = new(intf.DRV,intf.MON,intf.REF);
    test10 tb10 = new(intf.DRV,intf.MON,intf.REF);
    test11 tb11 = new(intf.DRV,intf.MON,intf.REF);
    test12 tb12 = new(intf.DRV,intf.MON,intf.REF);
    test13 tb13 = new(intf.DRV,intf.MON,intf.REF);
    test14 tb14 = new(intf.DRV,intf.MON,intf.REF);
    test_regression tb_regression = new(intf.DRV,intf.MON,intf.REF);

     initial begin:regression
        $display("=== ALU TEST BENCH STARTED ===");
        tb_regression.run();
        tb.run();
        $display("=== ALU TEST BENCH COMPLETED ===");
        $finish();
    end:regression

endmodule:top
