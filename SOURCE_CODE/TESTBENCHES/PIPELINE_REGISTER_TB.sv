`timescale 1ns/1ps

module PIPELINE_REGISTER_TB;

    localparam WIDTH = 32;
    
    reg clk;
    reg reset;
    reg enable;
    reg flush;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;

    PIPELINE_REGISTER #(.WIDTH(WIDTH)) 
    PL_REG (.clk(clk),
            .reset(reset),
            .enable(enable),
            .flush(flush),
            .data_in(data_in),
            .data_out(data_out));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        enable = 1'b0;
        flush = 1'b0;
        data_in = 32'h0000_0000;
    
        @(posedge clk);
        #1;
    
        reset   = 1'b0;
        enable  = 1'b1;
        data_in = 32'h6D31_A8F4;
    
        @(posedge clk);
        #1;
    
        data_in = 32'hB472_19CE;
    
        @(posedge clk);
        #1;
    
        enable  = 1'b0;
        data_in = 32'h39E5_C217;
    
        @(posedge clk);
        #1;
    
        enable  = 1'b1;
        data_in = 32'hF184_63DA;
    
        @(posedge clk);
        #1;
    
        flush   = 1'b1;
        data_in = 32'h27CA_95E1;
    
        @(posedge clk);
        #1;
    
        flush   = 1'b0;
        enable  = 1'b1;
        data_in = 32'h814B_3D76;
    
        @(posedge clk);
        #1;
    
        enable = 1'b0;
        flush  = 1'b1;
        data_in = 32'h5A96_E241;
    
        @(posedge clk);
        #1;
    
        flush  = 1'b0;
        enable = 1'b0;
        data_in = 32'hC731_4E8B;
    
        @(posedge clk);
        #1;
    
        reset  = 1'b1;
        enable = 1'b1;
        flush  = 1'b0;
        data_in = 32'hD48F_26B3;
    
        @(posedge clk);
        #1;
    
        reset = 1'b0;
        #5;
        $finish;
    end
endmodule