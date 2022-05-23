// Test Module
`timescale 1ns / 10ps

module tb_mem();

    reg                     CLK;
    reg                     CEN;
    reg                     WEN;
    `ifdef ibm130
    reg [11:0]              A;
    reg  [7:0]              D;
    wire [7:0]              Q;
    `endif
    `ifdef sky130
    reg  [9:0]              A;
    reg  [32:0]             D;
    wire [32:0]             Q;
    `endif

    integer                i;
    
    `ifdef ibm130
    RA1SHD mem(
        .*
    );
    `endif

    `ifdef sky130
    sky130_sram_2kbyte_1rw_32x512_8 mem (
        .clk0(CLK),
        .csb0(CEN),
        .web0(WEN),
        .wmask0(4'b1111),
        .spare_wen0(1'b0),
        .addr0(A),
        .din0(D),
        .dout0(Q)
    );
    `endif

    initial CLK = 0;
    always #(5.0) CLK = ~CLK;

    initial begin   
        `ifdef ibm130
        for (i = 0; i < 4096; i++) begin
            mem.mem[i] = 0;
        end
        `endif
        `ifdef sky130
        for (i = 0; i < 1024; i++) begin
            mem.mem[i] = 0;
        end
        `endif
        CEN = 0;
        WEN = 0;
        A = 0;
        D = 0;
        for (i = 0; i < 32; i++) begin
            write(i, i);
        end
        for (i = 0; i < 32; i++) begin
            read(i);
        end
        $finish;
    end

    task read;
        input [11:0] addr;
        begin
            @(posedge CLK);
            #1;
            CEN = 0;
            WEN = 1;
            A = addr;
            @(posedge CLK);
            #9;
            $display("read[%d]: %d", addr, Q);
            CEN = 1;
        end
    endtask

    task write;
        input [11:0] addr;
        input  [7:0] data;
        begin
            @(posedge CLK);
            #1;
            CEN = 0;
            WEN = 0;
            A = addr;
            D = data;
            @(posedge CLK);
            #1;
            CEN = 1;
        end
    endtask

endmodule

