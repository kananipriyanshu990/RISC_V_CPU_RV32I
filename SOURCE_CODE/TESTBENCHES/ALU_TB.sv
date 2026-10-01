`timescale 1ns/1ps

module ALU_TB;

    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [31:0] pc;
    logic [3:0]  alu_control;
    logic [31:0] result;
    logic        zero;

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

    ALU dut (
        .operand_a  (operand_a),
        .operand_b  (operand_b),
        .pc         (pc),
        .alu_control(alu_control),
        .result     (result),
        .zero       (zero)
    );

    task automatic check_result (
        input logic [31:0] expected_result,
        input logic        expected_zero
    );
    begin
        #1;

        if ((result !== expected_result) || (zero !== expected_zero)) begin
            $error("ALU TEST FAILED: control = %b, A = %h, B = %h, PC = %h, result = %h, zero = %b, expected result = %h, expected zero = %b",
                   alu_control, operand_a, operand_b, pc, result, zero, expected_result, expected_zero);
        end
        else begin
            $display("ALU TEST PASSED: control = %b, result = %h, zero = %b",
                     alu_control, result, zero);
        end
    end
    endtask

    initial begin

        operand_a = 32'h63D1_8A27;
        operand_b = 32'h1E47_B5C9;
        pc = 32'h0000_0000;
        alu_control = ALU_ADD;
        check_result(32'h8219_3FF0, 1'b0);

        operand_a = 32'hA714_6C82;
        operand_b = 32'h2B93_174E;
        alu_control = ALU_SUB;
        check_result(32'h7B81_5524, 1'b0);

        operand_a = 32'hD6A3_91C7;
        operand_b = 32'h4B27_E5F2;
        alu_control = ALU_AND;
        check_result(32'h4223_81C2, 1'b0);

        operand_a = 32'h5A18_34D6;
        operand_b = 32'h93C1_27A9;
        alu_control = ALU_OR;
        check_result(32'hDBD9_37FF, 1'b0);

        operand_a = 32'h7C52_A1D8;
        operand_b = 32'h2F96_4B73;
        alu_control = ALU_XOR;
        check_result(32'h53C4_EAAB, 1'b0);

        operand_a = 32'h0000_001B;
        operand_b = 32'h0000_0005;
        alu_control = ALU_SLL;
        check_result(32'h0000_0360, 1'b0);

        operand_a = 32'hD840_0000;
        operand_b = 32'h0000_0007;
        alu_control = ALU_SRL;
        check_result(32'h01B0_8000, 1'b0);

        operand_a = 32'hD840_0000;
        operand_b = 32'h0000_0007;
        alu_control = ALU_SRA;
        check_result(32'hFFB0_8000, 1'b0);

        operand_a = 32'hFFFF_FFF1;
        operand_b = 32'h0000_002D;
        alu_control = ALU_SLT;
        check_result(32'h0000_0001, 1'b0);

        operand_a = 32'hE31A_407C;
        operand_b = 32'h72C9_BA11;
        alu_control = ALU_SLT;
        check_result(32'h0000_0001, 1'b0);

        operand_a = 32'hE31A_407C;
        operand_b = 32'h72C9_BA11;
        alu_control = ALU_SLTU;
        check_result(32'h0000_0000, 1'b1);

        operand_a = 32'h1357_9BDF;
        operand_b = 32'hECA8_6420;
        alu_control = ALU_XOR;
        check_result(32'hFFFF_FFFF, 1'b0);

        operand_a = 32'h0000_0000;
        operand_b = 32'h0000_0000;
        alu_control = ALU_ADD;
        check_result(32'h0000_0000, 1'b1);

        operand_a = 32'h0000_0000;
        operand_b = 32'h0000_0000;
        alu_control = ALU_SUB;
        check_result(32'h0000_0000, 1'b1);

        operand_a = 32'h91C4_2E73;
        operand_b = 32'hF3A1_9000;
        pc = 32'h0000_0000;
        alu_control = ALU_LUI;
        check_result(32'hF3A1_9000, 1'b0);

        operand_a = 32'h6B20_17D4;
        operand_b = 32'h3141_B000;
        pc = 32'h0040_2C18;
        alu_control = ALU_AUIPC;
        check_result(32'h3181_DC18, 1'b0);

        operand_a = 32'h7A13_5C29;
        operand_b = 32'h0000_0000;
        pc = 32'h0000_0000;
        alu_control = 4'b1111;
        check_result(32'h0000_0000, 1'b1);

        $display("----------------------------------------");
        $display("ALU TESTBENCH PASSED");
        $display("----------------------------------------");

        $finish;
    end

endmodule