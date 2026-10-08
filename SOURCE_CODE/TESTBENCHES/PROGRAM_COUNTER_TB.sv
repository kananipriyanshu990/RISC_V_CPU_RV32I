`timescale 1ns/1ps

module PROGRAM_COUNTER_TB;

    logic clk;
    logic reset;
    logic [31:0]next_pc;
    logic [31:0]pc;

    PROGRAM_COUNTER PC (.clk(clk),
                        .reset(reset),
                        .next_pc(next_pc),
                        .pc(pc));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;                                  // Clock: 10 ns period
    end

    initial begin
        reset   = 1'b1;                                         // Initial conditions
        next_pc = 32'h0000_0000;

        @(posedge clk);                                         // Reset must force PC to zero
        #1;
        reset   = 1'b0;                                        // Release reset and load first PC value
        next_pc = 32'h0000_0100;

        @(posedge clk);
        next_pc = 32'h0000_0200;                               // try to change next_pc without a clock.
        #2;

        @(posedge clk);                                        // Load second PC value
        #1;

        reset   = 1'b1;                                       // Verify reset has priority over next_pc
        next_pc = 32'hD015_E79F;

        @(posedge clk);
        #1;
        $finish;
    end
endmodule