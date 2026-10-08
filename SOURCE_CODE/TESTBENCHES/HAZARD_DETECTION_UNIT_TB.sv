`timescale 1ns/1ps

module HAZARD_DETECTION_UNIT_TB;

    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;
    reg [4:0] id_ex_rd;
    reg id_ex_mem_read;
    reg [4:0] if_id_rs1;
    reg [4:0] if_id_rs2;
    
    wire pc_write;
    wire if_id_write;
    wire id_ex_control_stall;
    
    HAZARD_DETECTION_UNIT HD_UNIT (.id_ex_rs1(id_ex_rs1),
                                   .id_ex_rs2(id_ex_rs2),
                                   .id_ex_rd(id_ex_rd),
                                   .id_ex_mem_read(id_ex_mem_read),
                                   .if_id_rs1(if_id_rs1),
                                   .if_id_rs2(if_id_rs2),
                                   .pc_write(pc_write),
                                   .if_id_write(if_id_write),
                                   .id_ex_control_stall(id_ex_control_stall));
    
    initial begin    
        id_ex_rs1 = 5'd11;
        id_ex_rs2 = 5'd17;
        id_ex_rd = 5'd9;
        id_ex_mem_read = 1'b0;
        if_id_rs1 = 5'd4;
        if_id_rs2 = 5'd13;
    
        #5;
    
        id_ex_mem_read = 1'b1;
    
        #5;
    
        if_id_rs1 = 5'd9;
        if_id_rs2 = 5'd13;
    
        #5;
    
        if_id_rs1 = 5'd4;
        if_id_rs2 = 5'd9;
    
        #5;
    
        if_id_rs1 = 5'd9;
        if_id_rs2 = 5'd9;
    
        #5;
    
        id_ex_rd = 5'd0;
        if_id_rs1 = 5'd0;
        if_id_rs2 = 5'd0;
    
        #5;
    
        id_ex_rd = 5'd23;
        if_id_rs1 = 5'd23;
        if_id_rs2 = 5'd8;
        id_ex_mem_read = 1'b0;
    
        #5;
    
        id_ex_mem_read = 1'b1;
        id_ex_rd = 5'd23;
        if_id_rs1 = 5'd23;
        if_id_rs2 = 5'd8;
    
        #5;
    
        id_ex_rd = 5'd18;
        if_id_rs1 = 5'd7;
        if_id_rs2 = 5'd18;
    
        #5;
    
        id_ex_rd = 5'd27;
        if_id_rs1 = 5'd6;
        if_id_rs2 = 5'd14;
    
        #5;
    
        $finish;
    end
endmodule