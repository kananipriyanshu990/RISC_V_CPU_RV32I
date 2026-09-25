`timescale 1ns/1ps

module PROGRAM_COUNTER_TB;

    logic        clk;
    logic        reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

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

        if (pc !== 32'h0000_0000) begin
            $error("RESET TEST FAILED: PC = %h", pc);
        end
        else begin
            $display("RESET TEST PASSED");
        end

        reset   = 1'b0;                                        // Release reset and load first PC value
        next_pc = 32'h0000_0100;

        @(posedge clk);
        #1;

        if (pc !== 32'h0000_0100) begin
            $error("LOAD TEST FAILED: PC = %h", pc);
        end
        else begin
            $display("LOAD TEST 1 PASSED: PC = %h", pc);
        end

        next_pc = 32'h0000_0200;                               // try to change next_pc without a clock.

        #2;

        if (pc !== 32'h0000_0100) begin
            $error("HOLD TEST FAILED: PC changed before clock = %h", pc);
        end
        else begin
            $display("HOLD TEST PASSED");
        end

        @(posedge clk);                                        // Load second PC value
        #1;

        if (pc !== 32'h0000_0200) begin
            $error("LOAD TEST 2 FAILED: PC = %h", pc);
        end
        else begin
            $display("LOAD TEST 2 PASSED: PC = %h", pc);
        end

        reset   = 1'b1;                                       // Verify reset has priority over next_pc
        next_pc = 32'hD015_E79F;

        @(posedge clk);
        #1;

        if (pc !== 32'h0000_0000) begin
            $error("RESET PRIORITY TEST FAILED: PC = %h", pc);
        end
        else begin
            $display("RESET PRIORITY TEST PASSED");
        end
        $finish;
    end
endmodule