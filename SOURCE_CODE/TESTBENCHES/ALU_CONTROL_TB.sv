`timescale 1ns/1ps

module ALU_CONTROL_TB;

    logic [2:0] alu_op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [3:0] alu_control;

    localparam [2:0] ALU_OP_ADD = 3'b000;                           // Addition operation class
    localparam [2:0] ALU_OP_BRANCH = 3'b001;                        // Branch operation class
    localparam [2:0] ALU_OP_R_TYPE = 3'b010;                        // R-type operation class
    localparam [2:0] ALU_OP_I_ALU = 3'b011;                         // I-type ALU operation class
    localparam [2:0] ALU_OP_LUI = 3'b100;                           // LUI operation class
    localparam [2:0] ALU_OP_AUIPC = 3'b101;                         // AUIPC operation class

    localparam [3:0] ALU_ADD = 4'b0000;                             // Addition operation
    localparam [3:0] ALU_SUB = 4'b0001;                             // Subtraction operation
    localparam [3:0] ALU_AND = 4'b0010;                             // Bitwise AND operation
    localparam [3:0] ALU_OR = 4'b0011;                              // Bitwise OR operation
    localparam [3:0] ALU_XOR = 4'b0100;                             // Bitwise XOR operation
    localparam [3:0] ALU_SLL = 4'b0101;                             // Logical left shift operation
    localparam [3:0] ALU_SRL = 4'b0110;                             // Logical right shift operation
    localparam [3:0] ALU_SRA = 4'b0111;                             // Arithmetic right shift operation
    localparam [3:0] ALU_SLT = 4'b1000;                             // Signed comparison operation
    localparam [3:0] ALU_SLTU = 4'b1001;                            // Unsigned comparison operation
    localparam [3:0] ALU_LUI = 4'b1010;                             // LUI operation
    localparam [3:0] ALU_AUIPC = 4'b1011;                           // AUIPC operation

    ALU_CONTROL ALU_CTRL (.alu_op(alu_op),
                          .funct3(funct3),
                          .funct7(funct7),
                          .alu_control(alu_control));

    task automatic check_control (input logic [2:0] expected_alu_op,
                                  input logic [2:0] expected_funct3,
                                  input logic [6:0] expected_funct7);
    begin
        alu_op = expected_alu_op;
        funct3 = expected_funct3;
        funct7 = expected_funct7;
        #5;
    end
    endtask

    initial begin

        check_control(ALU_OP_ADD, 3'b000, 7'b0000000);
        check_control(ALU_OP_BRANCH, 3'b000, 7'b0000000);

        check_control(ALU_OP_R_TYPE, 3'b000, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b000, 7'b0100000);
        check_control(ALU_OP_R_TYPE, 3'b001, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b010, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b011, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b100, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b101, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b101, 7'b0100000);
        check_control(ALU_OP_R_TYPE, 3'b110, 7'b0000000);
        check_control(ALU_OP_R_TYPE, 3'b111, 7'b0000000);

        check_control(ALU_OP_I_ALU, 3'b000, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b001, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b010, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b011, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b100, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b101, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b101, 7'b0100000);
        check_control(ALU_OP_I_ALU, 3'b110, 7'b0000000);
        check_control(ALU_OP_I_ALU, 3'b111, 7'b0000000);

        check_control(ALU_OP_LUI, 3'b000, 7'b0000000);
        check_control(ALU_OP_AUIPC, 3'b000, 7'b0000000);

        check_control(3'b111, 3'b101, 7'b1011010);

        $finish;
    end
endmodule