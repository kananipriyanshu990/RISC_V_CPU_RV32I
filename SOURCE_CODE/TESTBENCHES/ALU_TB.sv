`timescale 1ns/1ps

module ALU_TB;

    logic [31:0]operand_a;
    logic [31:0]operand_b;
    logic [31:0]pc;
    logic [3:0]alu_control;
    logic [31:0]result;
    logic zero;

    localparam [3:0]ALU_ADD = 4'b0000;                            // Addition operation
    localparam [3:0]ALU_SUB = 4'b0001;                            // Subtraction operation
    localparam [3:0]ALU_AND = 4'b0010;                            // Bitwise AND operation
    localparam [3:0]ALU_OR = 4'b0011;                             // Bitwise OR operation
    localparam [3:0]ALU_XOR = 4'b0100;                            // Bitwise XOR operation
    localparam [3:0]ALU_SLL = 4'b0101;                            // Logical left shift operation
    localparam [3:0]ALU_SRL = 4'b0110;                            // Logical right shift operation
    localparam [3:0]ALU_SRA = 4'b0111;                            // Arithmetic right shift operation
    localparam [3:0]ALU_SLT = 4'b1000;                            // Signed comparison operation
    localparam [3:0]ALU_SLTU = 4'b1001;                           // Unsigned comparison operation
    localparam [3:0]ALU_LUI = 4'b1010;                            // LUI operation
    localparam [3:0]ALU_AUIPC = 4'b1011;                          // AUIPC operation

    ALU dut (.operand_a(operand_a),
             .operand_b(operand_b),
             .pc(pc),
             .alu_control(alu_control),
             .result(result),
             .zero(zero));


    initial begin

        operand_a = 32'h63D1_8A27;
        operand_b = 32'h1E47_B5C9;
        pc = 32'h0000_0000;
        alu_control = ALU_ADD;
        #5;
        operand_a = 32'hA714_6C82;
        operand_b = 32'h2B93_174E;
        alu_control = ALU_SUB;
        #5;
        operand_a = 32'hD6A3_91C7;
        operand_b = 32'h4B27_E5F2;
        alu_control = ALU_AND;
        #5;
        operand_a = 32'h5A18_34D6;
        operand_b = 32'h93C1_27A9;
        alu_control = ALU_OR;
        #5;
        operand_a = 32'h7C52_A1D8;
        operand_b = 32'h2F96_4B73;
        alu_control = ALU_XOR;
        #5;
        operand_a = 32'h0000_001B;
        operand_b = 32'h0000_0005;
        alu_control = ALU_SLL;
        #5;
        operand_a = 32'hD840_0000;
        operand_b = 32'h0000_0007;
        alu_control = ALU_SRL;
        #5;
        operand_a = 32'hD840_0000;
        operand_b = 32'h0000_0007;
        alu_control = ALU_SRA;
        #5;
        operand_a = 32'hFFFF_FFF1;
        operand_b = 32'h0000_002D;
        alu_control = ALU_SLT;
        #5;
        operand_a = 32'hE31A_407C;
        operand_b = 32'h72C9_BA11;
        alu_control = ALU_SLT;
        #5;
        operand_a = 32'hE31A_407C;
        operand_b = 32'h72C9_BA11;
        alu_control = ALU_SLTU;
        #5;
        operand_a = 32'h1357_9BDF;
        operand_b = 32'hECA8_6420;
        alu_control = ALU_XOR;
        #5;
        operand_a = 32'h0000_0000;
        operand_b = 32'h0000_0000;
        alu_control = ALU_ADD;
        #5;
        operand_a = 32'h0000_0000;
        operand_b = 32'h0000_0000;
        alu_control = ALU_SUB;
        #5;
        operand_a = 32'h91C4_2E73;
        operand_b = 32'hF3A1_9000;
        pc = 32'h0000_0000;
        alu_control = ALU_LUI;
        #5;
        operand_a = 32'h6B20_17D4;
        operand_b = 32'h3141_B000;
        pc = 32'h0040_2C18;
        alu_control = ALU_AUIPC;
        #5;        
        operand_a = 32'h7A13_5C29;
        operand_b = 32'h0000_0000;
        pc = 32'h0000_0000;
        alu_control = 4'b1111;
        #5;
        $finish;
    end

endmodule