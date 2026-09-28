`timescale 1ns/1ps

module IMMEDIATE_GENERATOR_TB;

    logic [31:0] instruction;
    logic [31:0] immediate;

    IMMEDIATE_GENERATOR IG (.instruction(instruction),
                             .immediate(immediate));

    task automatic check_immediate;
        input [31:0] test_instruction;
        input [31:0] expected_immediate;
        input [127:0] test_name;

        begin
            instruction = test_instruction;
            #1;

            if (immediate !== expected_immediate)
                $error("%s FAILED: Instruction = %h, Immediate = %h, Expected = %h",
                       test_name, instruction, immediate, expected_immediate);
            else
                $display("%s PASSED: Immediate = %h",
                         test_name, immediate);
        end
    endtask

    initial begin

        instruction = 32'd0;

        check_immediate(
            32'h0A73_9213,
            32'h0000_0A73,
            "I-TYPE POSITIVE");

        check_immediate(
            32'hF6C5_17A1,
            32'hFFFF_F6C5,
            "I-TYPE NEGATIVE");

        check_immediate(
            32'h0000_0013,
            32'h0000_0000,
            "I-TYPE ZERO");

        check_immediate(
            32'h7FF4_9613,
            32'h0000_07FF,
            "I-TYPE MAX POSITIVE");

        check_immediate(
            32'h8005_1693,
            32'hFFFF_F800,
            "I-TYPE MIN NEGATIVE");

        check_immediate(
            32'h1C82_A223,
            32'h0000_01C4,
            "S-TYPE POSITIVE");

        check_immediate(
            32'hE9B7_0D23,
            32'hFFFF_F9A6,
            "S-TYPE NEGATIVE");

        check_immediate(
            32'h0031_2023,
            32'h0000_0000,
            "S-TYPE ZERO");

        check_immediate(
            32'h0385_9863,
            32'h0000_0030,
            "B-TYPE POSITIVE");

        check_immediate(
            32'hF64D_1CE3,
            32'hFFFF_FFD0,
            "B-TYPE NEGATIVE");

        check_immediate(
            32'h0020_0063,
            32'h0000_0000,
            "B-TYPE ZERO");

        check_immediate(
            32'h3141_20B7,
            32'h3141_2000,
            "U-TYPE LUI");

        check_immediate(
            32'h8E37_4517,
            32'h8E37_4000,
            "U-TYPE AUIPC");

        check_immediate(
            32'h0000_00EF,
            32'h0000_0000,
            "J-TYPE ZERO");

        check_immediate(
            32'h1A2B_30EF,
            32'h000B_31A2,
            "J-TYPE POSITIVE");

        check_immediate(
            32'hE5D6_F0EF,
            32'hFFF6_E5D6,
            "J-TYPE NEGATIVE");

        check_immediate(
            32'hFFFFFFFF,
            32'h0000_0000,
            "UNSUPPORTED OPCODE");
        $finish;
    end
endmodule