`timescale 1ns/1ps

module ALU_CONTROL_TB;

    logic [2:0] alu_op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [3:0] alu_control;

    localparam [2:0] ALU_OP_ADD    = 3'b000;                        // Addition operation class
    localparam [2:0] ALU_OP_BRANCH = 3'b001;                        // Branch operation class
    localparam [2:0] ALU_OP_R_TYPE = 3'b010;                        // R-type operation class
    localparam [2:0] ALU_OP_I_ALU  = 3'b011;                        // I-type ALU operation class
    localparam [2:0] ALU_OP_LUI    = 3'b100;                        // LUI operation class
    localparam [2:0] ALU_OP_AUIPC  = 3'b101;                        // AUIPC operation class

    localparam [3:0] ALU_ADD   = 4'b0000;                           // Addition operation
    localparam [3:0] ALU_SUB   = 4'b0001;                           // Subtraction operation
    localparam [3:0] ALU_AND   = 4'b0010;                           // Bitwise AND operation
    localparam [3:0] ALU_OR    = 4'b0011;                           // Bitwise OR operation
    localparam [3:0] ALU_XOR   = 4'b0100;                           // Bitwise XOR operation
    localparam [3:0] ALU_SLL   = 4'b0101;                           // Logical left shift operation
    localparam [3:0] ALU_SRL   = 4'b0110;                           // Logical right shift operation
    localparam [3:0] ALU_SRA   = 4'b0111;                           // Arithmetic right shift operation
    localparam [3:0] ALU_SLT   = 4'b1000;                           // Signed comparison operation
    localparam [3:0] ALU_SLTU  = 4'b1001;                           // Unsigned comparison operation
    localparam [3:0] ALU_LUI   = 4'b1010;                           // LUI operation
    localparam [3:0] ALU_AUIPC = 4'b1011;                           // AUIPC operation

    ALU_CONTROL ALU_CTRL (.alu_op(alu_op),
                     .funct3(funct3),
                     .funct7(funct7),
                     .alu_control(alu_control));

    task automatic check_control (input logic [2:0] expected_alu_op,
                                  input logic [2:0] expected_funct3,
                                  input logic [6:0] expected_funct7,
                                  input logic [3:0] expected_alu_control);
    begin
        alu_op = expected_alu_op;
        funct3 = expected_funct3;
        funct7 = expected_funct7;
        #1;

        if (alu_control !== expected_alu_control) begin
            $error("ALU CONTROL TEST FAILED: ALUOp = %b, funct3 = %b, funct7 = %b, result = %b, expected = %b",
                   alu_op, funct3, funct7, alu_control, expected_alu_control);
        end
        else begin
            $display("ALU CONTROL TEST PASSED: ALUOp = %b, funct3 = %b, funct7 = %b, result = %b",
                     alu_op, funct3, funct7, alu_control);
        end
    end
    endtask

    initial begin

        check_control(ALU_OP_ADD, 3'b000, 7'b0000000, ALU_ADD);
        check_control(ALU_OP_BRANCH, 3'b000, 7'b0000000, ALU_ADD);

        check_control(ALU_OP_R_TYPE, 3'b000, 7'b0000000, ALU_ADD);
        check_control(ALU_OP_R_TYPE, 3'b000, 7'b0100000, ALU_SUB);
        check_control(ALU_OP_R_TYPE, 3'b001, 7'b0000000, ALU_SLL);
        check_control(ALU_OP_R_TYPE, 3'b010, 7'b0000000, ALU_SLT);
        check_control(ALU_OP_R_TYPE, 3'b011, 7'b0000000, ALU_SLTU);
        check_control(ALU_OP_R_TYPE, 3'b100, 7'b0000000, ALU_XOR);
        check_control(ALU_OP_R_TYPE, 3'b101, 7'b0000000, ALU_SRL);
        check_control(ALU_OP_R_TYPE, 3'b101, 7'b0100000, ALU_SRA);
        check_control(ALU_OP_R_TYPE, 3'b110, 7'b0000000, ALU_OR);
        check_control(ALU_OP_R_TYPE, 3'b111, 7'b0000000, ALU_AND);

        check_control(ALU_OP_I_ALU, 3'b000, 7'b0000000, ALU_ADD);
        check_control(ALU_OP_I_ALU, 3'b001, 7'b0000000, ALU_SLL);
        check_control(ALU_OP_I_ALU, 3'b010, 7'b0000000, ALU_SLT);
        check_control(ALU_OP_I_ALU, 3'b011, 7'b0000000, ALU_SLTU);
        check_control(ALU_OP_I_ALU, 3'b100, 7'b0000000, ALU_XOR);
        check_control(ALU_OP_I_ALU, 3'b101, 7'b0000000, ALU_SRL);
        check_control(ALU_OP_I_ALU, 3'b101, 7'b0100000, ALU_SRA);
        check_control(ALU_OP_I_ALU, 3'b110, 7'b0000000, ALU_OR);
        check_control(ALU_OP_I_ALU, 3'b111, 7'b0000000, ALU_AND);

        check_control(ALU_OP_LUI, 3'b000, 7'b0000000, ALU_LUI);
        check_control(ALU_OP_AUIPC, 3'b000, 7'b0000000, ALU_AUIPC);

        check_control(3'b111, 3'b101, 7'b1011010, ALU_ADD);

        $finish;
    end
endmodule