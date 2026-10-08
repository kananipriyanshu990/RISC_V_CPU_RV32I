`timescale 1ns/1ps

module FORWARDING_UNIT_TB;

    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [4:0] ex_mem_rd;
    reg ex_mem_reg_write;
    reg [4:0] mem_wb_rd;
    reg mem_wb_reg_write;
    
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    
    FORWARDING_UNIT FWD_UNIT (.id_ex_rs1(id_ex_rs1),
                              .id_ex_rs2(id_ex_rs2),
                              .ex_mem_rd(ex_mem_rd),
                              .ex_mem_reg_write(ex_mem_reg_write),
                              .mem_wb_rd(mem_wb_rd),
                              .mem_wb_reg_write(mem_wb_reg_write),
                              .forward_a(forward_a),
                              .forward_b(forward_b));
    
    initial begin    
        id_ex_rs1 = 5'd7;
        id_ex_rs2 = 5'd12;
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b0;
    
        #5;
    
        ex_mem_rd = 5'd7;
        ex_mem_reg_write = 1'b1;
    
        #5;
    
        ex_mem_rd = 5'd12;
    
        #5;
    
        ex_mem_rd = 5'd18;
        mem_wb_rd = 5'd7;
        mem_wb_reg_write = 1'b1;
    
        #5;
    
        mem_wb_rd = 5'd12;
    
        #5;
    
        ex_mem_rd = 5'd7;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd7;
        mem_wb_reg_write = 1'b1;
    
        #5;
    
        ex_mem_rd = 5'd12;
    
        #5;
    
        id_ex_rs1 = 5'd0;
        id_ex_rs2 = 5'd0;
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b1;
    
        #5;
    
        id_ex_rs1 = 5'd21;
        id_ex_rs2 = 5'd26;
        ex_mem_rd = 5'd21;
        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd26;
        mem_wb_reg_write = 1'b0;
    
        #5;
    
        id_ex_rs1 = 5'd9;
        id_ex_rs2 = 5'd14;
        ex_mem_rd = 5'd9;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd14;
        mem_wb_reg_write = 1'b1;
    
        #5;
    
        $finish;
    end
    
endmodule