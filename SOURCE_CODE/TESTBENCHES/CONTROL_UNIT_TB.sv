`timescale 1ns/1ps

module CONTROL_UNIT_TB;

    logic [6:0] opcode;
    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic mem_to_reg;
    logic alu_src;
    logic branch;
    logic jump;
    logic [2:0] alu_op;

    CONTROL_UNIT CTRL_UNIT (.opcode(opcode),
                            .reg_write(reg_write),
                            .mem_read(mem_read),
                            .mem_write(mem_write),
                            .mem_to_reg(mem_to_reg),
                            .alu_src(alu_src),
                            .branch(branch),
                            .jump(jump),
                            .alu_op(alu_op));

    task automatic check_control (input logic [6:0] expected_opcode,
                                  input logic expected_reg_write,
                                  input logic expected_mem_read,
                                  input logic expected_mem_write,
                                  input logic expected_mem_to_reg,
                                  input logic expected_alu_src,
                                  input logic expected_branch,
                                  input logic expected_jump,
                                  input logic [2:0] expected_alu_op);
    begin
        opcode = expected_opcode;
        #1;

        if ((reg_write !== expected_reg_write) ||
            (mem_read !== expected_mem_read) ||
            (mem_write !== expected_mem_write) ||
            (mem_to_reg !== expected_mem_to_reg) ||
            (alu_src !== expected_alu_src) ||
            (branch !== expected_branch) ||
            (jump !== expected_jump) ||
            (alu_op !== expected_alu_op)) begin

            $error("CONTROL TEST FAILED: opcode = %b, RW = %b, MR = %b, MW = %b, MTR = %b, AS = %b, BR = %b, JP = %b, ALUOp = %b",
                   opcode, reg_write, mem_read, mem_write, mem_to_reg, alu_src, branch, jump, alu_op);
        end
        else begin
            $display("CONTROL TEST PASSED: opcode = %b, ALUOp = %b", opcode, alu_op);
        end
    end
    endtask

    initial begin

        check_control(
            7'b0110011,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            3'b010);

        check_control(
            7'b0010011,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            3'b011);

        check_control(
            7'b0000011,
            1'b1,
            1'b1,
            1'b0,
            1'b1,
            1'b1,
            1'b0,
            1'b0,
            3'b000);

        check_control(
            7'b0100011,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            3'b000);

        check_control(
            7'b1100011,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            3'b001);

        check_control(
            7'b1101111,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            3'b000);

        check_control(
            7'b1100111,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b1,
            3'b000);

        check_control(
            7'b0110111,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            3'b100);

        check_control(
            7'b0010111,
            1'b1,
            1'b0,
            1'b0,
            1'b0,
            1'b1,
            1'b0,
            1'b0,
            3'b101);

        check_control(
            7'b1011011,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            1'b0,
            3'b000);
        $finish;
    end
endmodule