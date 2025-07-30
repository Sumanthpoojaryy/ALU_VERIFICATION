`include "alu_defines.sv"
class alu_environment;
    virtual alu_interface vidrv;
    virtual alu_interface vimon;
    virtual alu_interface viref;

    event ev_rm;
    event ev_dr;

    mailbox #(alu_transaction) mbx_gen2drv;
    mailbox #(alu_transaction) mbx_drv2ref;
    mailbox #(alu_transaction) mbx_mon2scb;
    mailbox #(alu_transaction) mbx_ref2scb;

    alu_generator gen;
    alu_driver drv;
    alu_monitor mon;
    alu_reference_model ref_model;
    alu_scoreboard scb;

    function new (virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        this.vidrv = vidrv;
        this.vimon = vimon;
        this.viref = viref;
    endfunction:new

    task build();
    mbx_gen2drv = new();
    mbx_drv2ref = new();
    mbx_mon2scb = new();
    mbx_ref2scb = new();

    gen = new(mbx_gen2drv);
    drv = new(mbx_gen2drv,mbx_drv2ref,vidrv,ev_dr);
    mon = new(mbx_mon2scb,vimon,ev_rm);
    ref_model = new(mbx_drv2ref,mbx_ref2scb,viref,ev_dr,ev_rm);
    scb = new(mbx_mon2scb,mbx_ref2scb);
    endtask:build
     task start();
        fork
            gen.start();
            drv.start();
            mon.start();
            scb.start();
            ref_model.start();
        join
    endtask:start
endclass:alu_environment
