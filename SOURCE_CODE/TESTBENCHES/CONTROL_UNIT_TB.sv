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

    task automatic check_control (input logic [6:0] expected_opcode);
    begin
        opcode = expected_opcode;
        #5;
    end
    endtask

    initial begin

        check_control(7'b0110011);

        check_control(7'b0010011);

        check_control(7'b0000011);

        check_control(7'b0100011);

        check_control(7'b1100011);

        check_control(7'b1101111);

        check_control(7'b1100111);

        check_control(7'b0110111);

        check_control(7'b0010111);

        check_control(7'b1011011);
        $finish;
    end
endmodule