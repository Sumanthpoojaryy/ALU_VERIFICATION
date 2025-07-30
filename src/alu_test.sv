class alu_test;
    virtual alu_interface vidrv;
    virtual alu_interface vimon;
    virtual alu_interface viref;

    alu_environment env;

    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        this.vidrv = vidrv;
        this.vimon = vimon;
        this.viref = viref;
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        env.start();
    endtask:run
endclass:alu_test

class test1 extends alu_test;
    alu_transaction1 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test1

class test2 extends alu_test;
    alu_transaction2 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test2

class test3 extends alu_test;
    alu_transaction3 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test3

class test4 extends alu_test;
    alu_transaction4 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test4

class test5 extends alu_test;
    alu_transaction5 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test5

class test6 extends alu_test;
    alu_transaction6 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test6

class test7 extends alu_test;
    alu_transaction7 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test7

class test8 extends alu_test;
    alu_transaction8 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test8

class test9 extends alu_test;
    alu_transaction9 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test9

class test10 extends alu_test;
    alu_transaction10 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test10

class test11 extends alu_test;
    alu_transaction11 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test11

class test12 extends alu_test;
    alu_transaction12 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test12

class test13 extends alu_test;
    alu_transaction13 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test13

class test14 extends alu_test;
    alu_transaction14 trans;
    function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        begin
            trans = new();
            env.gen.gen_trans = trans;
        end
        env.start();
    endtask:run
endclass:test14



class test_regression extends alu_test;
    alu_transaction trans0;
    alu_transaction1 trans1;
    alu_transaction2 trans2;
    alu_transaction3 trans3;
    alu_transaction4 trans4;
    alu_transaction5 trans5;
    alu_transaction6 trans6;
    alu_transaction7 trans7;
    alu_transaction8 trans8;
    alu_transaction9 trans9;
    alu_transaction10 trans10;
    alu_transaction11 trans11;
    alu_transaction12 trans12;
    alu_transaction13 trans13;
    alu_transaction14 trans14;

  function new(virtual alu_interface vidrv,virtual alu_interface vimon,virtual alu_interface viref);
        super.new(vidrv,vimon,viref);
    endfunction:new

    task run();
        env = new(vidrv,vimon,viref);
        env.build();
        $display("test0");
        begin
            trans0 = new();
            env.gen.gen_trans = trans0;
        end
        env.start();

        begin
            $display("test1");
            trans1 = new();
            env.gen.gen_trans = trans1;
        end
        env.start();

        begin
            $display("test2");
            trans2 = new();
            env.gen.gen_trans = trans2;
        end
        env.start();

        begin
            $display("test3");
            trans3 = new();
            env.gen.gen_trans = trans3;
        end
        env.start();

        begin
            $display("test4");
            trans4 = new();
            env.gen.gen_trans = trans4;
        end
        env.start();

       begin
            $display("test5");
            trans5 = new();
            env.gen.gen_trans = trans5;
        end
        env.start();

         begin
            $display("test6");
            trans6 = new();
            env.gen.gen_trans = trans6;
        end
        env.start();

        begin
            $display("test7");
            trans7 = new();
            env.gen.gen_trans = trans7;
        end
        env.start();

        begin
            $display("test8");
            trans8 = new();
            env.gen.gen_trans = trans8;
        end
        env.start();

        begin
            $display("test9");
            trans9 = new();
            env.gen.gen_trans = trans9;
        end
        env.start();

         begin
            $display("test10");
            trans10 = new();
            env.gen.gen_trans = trans10;
        end
        env.start();

        begin
            $display("test11");
            trans11 = new();
            env.gen.gen_trans = trans11;
        end
        env.start();

         begin
            $display("test12");
            trans12 = new();
            env.gen.gen_trans = trans12;
        end
        env.start();

         begin
            $display("test13");
            trans13 = new();
            env.gen.gen_trans = trans13;
        end
        env.start();

        begin
            $display("test14");
            trans14 = new();
            env.gen.gen_trans = trans14;
        end
        env.start();

    endtask:run
endclass:test_regression
