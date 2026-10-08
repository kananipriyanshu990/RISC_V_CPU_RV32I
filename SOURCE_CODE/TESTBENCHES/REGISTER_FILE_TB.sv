`timescale 1ns/1ps

module REGISTER_FILE_TB;

    logic clk;
    logic reset;
    logic [4:0]rs1_addr;
    logic [4:0]rs2_addr;
    logic [4:0]rd_addr;
    logic [31:0]rd_data;
    logic rd_write_enable;
    logic [31:0]rs1_data;
    logic [31:0]rs2_data;

    REGISTER_FILE dut (.clk(clk),
                       .reset(reset),
                       .rs1_addr(rs1_addr),
                       .rs2_addr(rs2_addr),
                       .rd_addr(rd_addr),
                       .rd_data(rd_data),
                       .rd_write_enable(rd_write_enable),
                       .rs1_data(rs1_data),
                       .rs2_data(rs2_data));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin

        reset = 1'b1;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;
        rd_addr = 5'd0;
        rd_data = 32'd0;
        rd_write_enable = 1'b0;

        @(posedge clk);
        #1;

        reset = 1'b0;
        rd_addr = 5'd1;
        rd_data = 32'h06D3_91A7;
        rd_write_enable = 1'b1;

        @(posedge clk);
        #1;

        rs1_addr = 5'd1;
        #1;
        
        rd_addr = 5'd2;
        rd_data = 32'hB824_16CE;

        @(posedge clk);
        #1;

        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        #1;

        rd_addr = 5'd0;
        rd_data = 32'h719C_35E2;

        @(posedge clk);
        #1;

        rs1_addr = 5'd0;
        #1;

        rd_addr = 5'd1;
        rd_data = 32'hD24F_087B;

        @(posedge clk);
        #1;

        rs1_addr = 5'd1;
        #1;

        rd_write_enable = 1'b0;
        rd_addr = 5'd3;
        rd_data = 32'h3A71_C4D9;

        @(posedge clk);
        #1;

        rs1_addr = 5'd3;
        #5;

        $finish;
    end
endmodule