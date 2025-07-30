`include "alu_defines.sv"
class alu_transaction;
    rand logic [1:0]            INP_VALID;
    rand logic                  MODE;
    rand logic [`CMD_WIDTH-1:0] CMD;
    rand logic                  CE;
    rand logic [`WIDTH-1:0]     OPA;
    rand logic [`WIDTH-1:0]     OPB;
    rand logic                  CIN;
    logic                       ERR;
    logic                       COUT;
    logic [`WIDTH:0]            RES;
    logic                       OFLOW;
    logic                       E;
    logic                       G;
    logic                       L;

    constraint CHECK_FOR_INP_VALID_11_MODE_1{ soft INP_VALID ==3;
                                              soft  CIN == 1;
                                              soft  CE == 1;
                                              soft MODE == 1;
                                              soft CMD inside {[0:8]};
                                            }
    virtual function alu_transaction copy();
        copy = new();
        copy.INP_VALID = this.INP_VALID;
        copy.MODE = this.MODE;
        copy.CMD = this.CMD;
        copy.CE = this.CE;
        copy.OPA = this.OPA;
        copy.OPB = this.OPB;
        copy.CIN = this.CIN;
        return copy;
    endfunction:copy
endclass:alu_transaction
class alu_transaction1 extends alu_transaction;
    constraint CHECK_FOR_INP_VALID_10_MODE_1{ INP_VALID == 2'b10;
                                              CE == 1;
                                              CIN == 1;
                                              MODE == 1;
                                              CMD inside {[6:7]};
                                             }
    virtual function alu_transaction copy();
        alu_transaction1 copy1;
        copy1 = new();
        copy1.INP_VALID = this.INP_VALID;
        copy1.MODE = this.MODE;
        copy1.CMD = this.CMD;
        copy1.CE = this.CE;
        copy1.OPA = this.OPA;
        copy1.OPB = this.OPB;
        copy1.CIN = this.CIN;
        return copy1;
    endfunction:copy
endclass:alu_transaction1


class alu_transaction2 extends alu_transaction;
    constraint CHECK_FOR_INP_VALID_01_MODE_1{ INP_VALID == 2'b01;
                                              CE == 1;
                                              CIN == 1;
                                              MODE == 1;
                                              CMD inside {[4:5]};
                                            }
    virtual function alu_transaction copy();
        alu_transaction2 copy2;
        copy2 = new();
        copy2.INP_VALID = this.INP_VALID;
        copy2.MODE = this.MODE;
        copy2.CMD = this.CMD;
        copy2.CE = this.CE;
        copy2.OPA = this.OPA;
        copy2.OPB = this.OPB;
        copy2.CIN = this.CIN;
        return copy2;
    endfunction:copy
endclass:alu_transaction2

class alu_transaction3 extends alu_transaction;
    constraint CHECK_FOR_INP_VALID_11_MODE_0{ INP_VALID == 2'b11;
                                              CE == 1;
                                              CIN == 1;
                                              MODE == 0;
                                              CMD inside {[0:13]};
                                             }
    virtual function alu_transaction copy();
        alu_transaction3 copy3;
        copy3 = new();
        copy3.INP_VALID = this.INP_VALID;
        copy3.MODE = this.MODE;
        copy3.CMD = this.CMD;
        copy3.CE = this.CE;
        copy3.OPA = this.OPA;
        copy3.OPB = this.OPB;
        copy3.CIN = this.CIN;
        return copy3;
    endfunction:copy
endclass:alu_transaction3

class alu_transaction4 extends alu_transaction;
    constraint CHECK_FOR_INP_VALID_10_MODE_0{ INP_VALID == 2'b10;
                                              MODE == 0;
                                              CE == 1;
                                              CIN == 1;
                                              CMD inside {7,10,11};
                                            }
    virtual function alu_transaction copy();
        alu_transaction4 copy4;
        copy4 = new();
        copy4.INP_VALID = this.INP_VALID;
        copy4.MODE = this.MODE;
        copy4.CMD = this.CMD;
        copy4.CE = this.CE;
        copy4.OPA = this.OPA;
        copy4.OPB = this.OPB;
        copy4.CIN = this.CIN;
        return copy4;
    endfunction:copy
endclass:alu_transaction4

class alu_transaction5 extends alu_transaction;
    constraint CHECK_FOR_INP_VALID_01_MODE_0{ INP_VALID == 2'b01;
                                              MODE == 0;
                                              CE == 1;
                                              CIN == 1;
                                              CMD inside {6,8,9};
                                            }
    virtual function alu_transaction copy();
        alu_transaction5 copy5;
        copy5 = new();
        copy5.INP_VALID = this.INP_VALID;
        copy5.MODE = this.MODE;
        copy5.CMD = this.CMD;
        copy5.CE = this.CE;
        copy5.OPA = this.OPA;
        copy5.OPB = this.OPB;
        copy5.CIN = this.CIN;
        return copy5;
    endfunction:copy
endclass:alu_transaction5

class alu_transaction6 extends alu_transaction;
    constraint CHECK_FOR_CE_INACTIVE{ INP_VALID == 2'b11;
                                      CMD == 0;
                                      CE == 0;
                                    }
    virtual function alu_transaction copy();
        alu_transaction6 copy6;
        copy6 = new();
        copy6.INP_VALID = this.INP_VALID;
        copy6.MODE = this.MODE;
        copy6.CMD = this.CMD;
        copy6.CE = this.CE;
        copy6.OPA = this.OPA;
        copy6.OPB = this.OPB;
        copy6.CIN = this.CIN;
        return copy6;
    endfunction:copy
endclass:alu_transaction6

class alu_transaction7 extends alu_transaction;
    constraint CHECK_FOR_INAVLID_CMD_FOR_MODE_1{ INP_VALID == 2'b11;
                                                 MODE == 1;
                                                 CE == 1;
                                                 CMD inside{[11:15]};
                                               }
    virtual function alu_transaction copy();
        alu_transaction7 copy7;
        copy7 = new();
        copy7.INP_VALID = this.INP_VALID;
        copy7.MODE = this.MODE;
        copy7.CMD = this.CMD;
        copy7.CE = this.CE;
        copy7.OPA = this.OPA;
        copy7.OPB = this.OPB;
        copy7.CIN = this.CIN;
        return copy7;
    endfunction:copy
endclass:alu_transaction7

class alu_transaction8 extends alu_transaction;
    constraint CHECK_FOR_INVALID_FOR_MODE_0{ INP_VALID == 2'b11;
                                             MODE == 0;
                                             CE == 1;
                                             CMD == 15;
                                           }
    virtual function alu_transaction copy();
        alu_transaction8 copy8;
        copy8 = new();
        copy8.INP_VALID = this.INP_VALID;
        copy8.MODE = this.MODE;
        copy8.CMD = this.CMD;
        copy8.CE = this.CE;
        copy8.OPA = this.OPA;
        copy8.OPB = this.OPB;
        copy8.CIN = this.CIN;
        return copy8;
    endfunction:copy
endclass:alu_transaction8

class alu_transaction9 extends alu_transaction;
    constraint CHECK_FOR_MULTIPLICATION{INP_VALID == 2'b11;
                                        MODE == 1;
                                        CE == 1;
                                        CMD inside {9,10};
                                       }
    virtual function alu_transaction copy();
        alu_transaction9 copy9;
        copy9 = new();
        copy9.INP_VALID = this.INP_VALID;
        copy9.MODE = this.MODE;
        copy9.CMD = this.CMD;
        copy9.CE = this.CE;
        copy9.OPA = this.OPA;
        copy9.OPB = this.OPB;
        copy9.CIN = this.CIN;
        return copy9;
    endfunction:copy
endclass:alu_transaction9

class alu_transaction10 extends alu_transaction;
    constraint CHECK_FOR_WAIT_CYCLE1{   INP_VALID dist{1:=50,3:=50};
                                        MODE == 1;
                                        CE == 1;
                                        !(CMD inside{[11:15]});
                                       }
    virtual function alu_transaction copy();
        alu_transaction10 copy10;
        copy10 = new();
        copy10.INP_VALID = this.INP_VALID;
        copy10.MODE = this.MODE;
        copy10.CMD = this.CMD;
        copy10.CE = this.CE;
        copy10.OPA = this.OPA;
        copy10.OPB = this.OPB;
        copy10.CIN = this.CIN;
        return copy10;
    endfunction:copy
endclass:alu_transaction10

class alu_transaction11 extends alu_transaction;
    constraint CHECK_FOR_WAIT_CYCLE2{   INP_VALID dist{2:=50,3:=50};
                                        MODE == 1;
                                        CE == 1;
                                        !(CMD inside{[11:15]});
                                       }
    virtual function alu_transaction copy();
        alu_transaction11 copy11;
        copy11 = new();
        copy11.INP_VALID = this.INP_VALID;
        copy11.MODE = this.MODE;
        copy11.CMD = this.CMD;
        copy11.CE = this.CE;
        copy11.OPA = this.OPA;
        copy11.OPB = this.OPB;
        copy11.CIN = this.CIN;
        return copy11;
    endfunction:copy
endclass:alu_transaction11

class alu_transaction12 extends alu_transaction;
    constraint CHECK_FOR_WAIT_CYCLE2{   INP_VALID ==0;
                                        CE == 1;
                                       }
    virtual function alu_transaction copy();
        alu_transaction12 copy12;
        copy12 = new();
        copy12.INP_VALID = this.INP_VALID;
        copy12.MODE = this.MODE;
        copy12.CMD = this.CMD;
        copy12.CE = this.CE;
        copy12.OPA = this.OPA;
        copy12.OPB = this.OPB;
        copy12.CIN = this.CIN;
        return copy12;
    endfunction:copy
endclass:alu_transaction12

class alu_transaction13 extends alu_transaction;
    constraint CHECK_FOR_WAIT_CYCLE_1_MODE_0{   INP_VALID dist{2:=50,3:=50};
                                        MODE == 0;
                                        CE == 1;
                                        !(CMD inside{15});
                                       }
    virtual function alu_transaction copy();
        alu_transaction13 copy13;
        copy13 = new();
        copy13.INP_VALID = this.INP_VALID;
        copy13.MODE = this.MODE;
        copy13.CMD = this.CMD;
        copy13.CE = this.CE;
        copy13.OPA = this.OPA;
        copy13.OPB = this.OPB;
        copy13.CIN = this.CIN;
        return copy13;
    endfunction:copy
endclass:alu_transaction13

class alu_transaction14 extends alu_transaction;
    constraint CHECK_FOR_WAIT_CYCLE2_mode_0{   INP_VALID dist{2:=50,3:=50};
                                                MODE == 1;
                                                CE == 1;
                                                !(CMD inside{15});
                                       }
    virtual function alu_transaction copy();
        alu_transaction14 copy14;
        copy14 = new();
        copy14.INP_VALID = this.INP_VALID;
        copy14.MODE = this.MODE;
        copy14.CMD = this.CMD;
        copy14.CE = this.CE;
        copy14.OPA = this.OPA;
        copy14.OPB = this.OPB;
        copy14.CIN = this.CIN;
        return copy14;
    endfunction:copy
endclass:alu_transaction14

