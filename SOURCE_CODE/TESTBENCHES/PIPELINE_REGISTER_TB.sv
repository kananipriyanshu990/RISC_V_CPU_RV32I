`timescale 1ns/1ps

module PIPELINE_REGISTER_TB;

    localparam WIDTH = 32;
    
    reg clk;
    reg reset;
    reg enable;
    reg flush;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;
    
    integer pass_count;
    integer fail_count;
    
    PIPELINE_REGISTER #(.WIDTH(WIDTH)) 
    PL_REG (.clk(clk),
            .reset(reset),
            .enable(enable),
            .flush(flush),
            .data_in(data_in),
            .data_out(data_out));
    
    always #5 clk = ~clk;
    
    task automatic CHECK_OUTPUT;
        input [WIDTH-1:0] expected;
        input [127:0] test_name;
    
        begin
            if (data_out !== expected) begin
                fail_count = fail_count + 1;
                $display("FAIL: %s | expected=%h got=%h",
                         test_name, expected, data_out);
            end
            else begin
                pass_count = pass_count + 1;
                $display("PASS: %s | data_out=%h",
                         test_name, data_out);
            end
        end
    endtask
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        enable = 1'b0;
        flush = 1'b0;
        data_in = 32'h0000_0000;
        pass_count = 0;
        fail_count = 0;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h0000_0000, "Reset");
    
        reset   = 1'b0;
        enable  = 1'b1;
        data_in = 32'h6D31_A8F4;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h6D31_A8F4, "Normal capture");
    
        data_in = 32'hB472_19CE;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'hB472_19CE, "Second capture");
    
        enable  = 1'b0;
        data_in = 32'h39E5_C217;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'hB472_19CE, "Stall holds previous value");
    
        enable  = 1'b1;
        data_in = 32'hF184_63DA;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'hF184_63DA, "Capture after stall");
    
        flush   = 1'b1;
        data_in = 32'h27CA_95E1;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h0000_0000, "Flush clears register");
    
        flush   = 1'b0;
        enable  = 1'b1;
        data_in = 32'h814B_3D76;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h814B_3D76, "Capture after flush");
    
        enable = 1'b0;
        flush  = 1'b1;
        data_in = 32'h5A96_E241;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h0000_0000, "Flush overrides stall");
    
        flush  = 1'b0;
        enable = 1'b0;
        data_in = 32'hC731_4E8B;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h0000_0000, "Stall after flush holds zero");
    
        reset  = 1'b1;
        enable = 1'b1;
        flush  = 1'b0;
        data_in = 32'hD48F_26B3;
    
        @(posedge clk);
        #1;
        CHECK_OUTPUT(32'h0000_0000, "Reset overrides capture");
    
        reset = 1'b0;

        if (fail_count == 0)
            $display("ALL PIPELINE REGISTER TESTS PASSED");
        else
            $display("PIPELINE REGISTER TEST FAILED");
    
        $finish;
    end
endmodule