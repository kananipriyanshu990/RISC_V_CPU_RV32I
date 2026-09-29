`timescale 1ns/1ps

module INSTRUCTION_DECODER_TB;

    logic [31:0] instruction;
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [2:0]  funct3;
    logic [6:0]  funct7;

    INSTRUCTION_DECODER INS_DEC (.instruction(instruction),
                                 .opcode(opcode),
                                 .rd(rd),
                                 .rs1(rs1),
                                 .rs2(rs2),
                                 .funct3(funct3),
                                 .funct7(funct7));

    task automatic check_instruction (input logic [31:0] expected_instruction,
                                      input logic [6:0]  expected_opcode,
                                      input logic [4:0]  expected_rd,
                                      input logic [4:0]  expected_rs1,
                                      input logic [4:0]  expected_rs2,
                                      input logic [2:0]  expected_funct3,
                                      input logic [6:0]  expected_funct7);
    begin
        instruction = expected_instruction;
        #1;

        if ((opcode !== expected_opcode) ||
            (rd !== expected_rd) ||
            (rs1 !== expected_rs1) ||
            (rs2 !== expected_rs2) ||
            (funct3 !== expected_funct3) ||
            (funct7 !== expected_funct7)) begin

            $error("DECODER TEST FAILED: instruction = %h, opcode = %b, rd = %d, rs1 = %d, rs2 = %d, funct3 = %b, funct7 = %b",
                   instruction, opcode, rd, rs1, rs2, funct3, funct7);
        end
        else begin
            $display("DECODER TEST PASSED: instruction = %h", instruction);
        end
    end
    endtask

    initial begin

        check_instruction(
            32'h4C72_30B3,
            7'b0110011,
            5'd1,
            5'd4,
            5'd7,
            3'b011,
            7'b0100110);

        check_instruction(
            32'hB934_51B3,
            7'b0110011,
            5'd3,
            5'd8,
            5'd25,
            3'b101,
            7'b1011100);

        check_instruction(
            32'hA5D5_58B3,
            7'b0110011,
            5'd17,
            5'd10,
            5'd29,
            3'b101,
            7'b1010010);

        check_instruction(
            32'hD47A_8693,
            7'b0010011,
            5'd13,
            5'd21,
            5'd4,
            3'b000,
            7'b1101010);

        check_instruction(
            32'hF3C2_A783,
            7'b0000011,
            5'd15,
            5'd5,
            5'd28,
            3'b010,
            7'b1111001);

        check_instruction(
            32'hB6D4_2923,
            7'b0100011,
            5'd18,
            5'd8,
            5'd13,
            3'b010,
            7'b1011010);

        check_instruction(
            32'h1A73_84E3,
            7'b1100011,
            5'd9,
            5'd7,
            5'd23,
            3'b000,
            7'b0001101);

        check_instruction(
            32'h6C91_22B7,
            7'b0110111,
            5'd5,
            5'd2,
            5'd25,
            3'b010,
            7'b0110110);

        check_instruction(
            32'h59E3_4AEF,
            7'b1101111,
            5'd21,
            5'd20,
            5'd30,
            3'b100,
            7'b0101100);

        check_instruction(
            32'hF6B7_8567,
            7'b1100111,
            5'd10,
            5'd15,
            5'd11,
            3'b000,
            7'b1111011);

        check_instruction(
            32'hC3A7_5D7F,
            7'b1111111,
            5'd26,
            5'd14,
            5'd26,
            3'b101,
            7'b1100001);

        $finish;
    end
endmodule