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

    task automatic check_instruction (input logic [31:0]expected_instruction);
    begin
        instruction = expected_instruction;
        #1;
    end
    endtask

    initial begin

        check_instruction(32'h4C72_30B3);

        check_instruction(32'hB934_51B3);

        check_instruction(32'hA5D5_58B3);

        check_instruction(32'hD47A_8693);

        check_instruction(32'hF3C2_A783);

        check_instruction(32'hB6D4_2923);

        check_instruction(32'h1A73_84E3);

        check_instruction(32'h6C91_22B7);

        check_instruction(32'h59E3_4AEF);

        check_instruction(32'hF6B7_8567);

        check_instruction(32'hC3A7_5D7F);

        $finish;
    end
endmodule