`timescale 1ns/1ps

module BRANCH_UNIT_TB;

    reg branch;
    reg [2:0] funct3;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    wire branch_taken;
    
    BRANCH_UNIT BRN_UNIT (.branch(branch),
                          .funct3(funct3),
                          .rs1_data(rs1_data),
                          .rs2_data(rs2_data),
                          .branch_taken(branch_taken));
    
    task automatic TEST_BRANCH;
        input [2:0] TEST_FUNCT3;
        input [31:0] TEST_RS1;
        input [31:0] TEST_RS2;
    
        begin
            funct3 = TEST_FUNCT3;
            rs1_data = TEST_RS1;
            rs2_data = TEST_RS2;
            #5;
        end
    endtask
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        branch = 1'b1;
        funct3 = 3'b000;
        rs1_data = 32'd0;
        rs2_data = 32'd0;
    
        TEST_BRANCH(3'b000, 32'h4C71_9A26, 32'h4C71_9A26);   // BEQ equal operands
        TEST_BRANCH(3'b000, 32'h4C71_9B56, 32'h8B35_61D4);   // BEQ unequal operands
    
        TEST_BRANCH(3'b001, 32'h739E_214B, 32'h739E_214B);   // BNE equal operands
        TEST_BRANCH(3'b001, 32'h770E_214B, 32'h19D4_A860);   // BNE unequal operands
    
        TEST_BRANCH(3'b100, 32'hE31A_407C, 32'h72C9_BA11);   // BLT signed negative versus positive
        TEST_BRANCH(3'b100, 32'h61F4_2A83, 32'h2D87_C190);   // BLT signed positive comparison
    
        TEST_BRANCH(3'b101, 32'hE31A_407C, 32'h72C9_BA11);   // BGE signed negative versus positive
        TEST_BRANCH(3'b101, 32'h61F4_2A83, 32'h2D87_C190);   // BGE signed positive comparison
    
        TEST_BRANCH(3'b110, 32'h1A72_D4C9, 32'hB6E3_1840);   // BLTU unsigned smaller value
        TEST_BRANCH(3'b110, 32'hE31A_407C, 32'h72C9_BA11);   // BLTU unsigned comparison
    
        TEST_BRANCH(3'b111, 32'hE31A_407C, 32'h72C9_BA11);   // BGEU unsigned larger value
        TEST_BRANCH(3'b111, 32'h1A72_D4C9, 32'hB6E3_1840);   // BGEU unsigned smaller value
    
        branch = 1'b0;
    
        TEST_BRANCH(3'b000, 32'h4C71_9A26, 32'h4C71_9A26);   // Disabled branch forces not taken
        TEST_BRANCH(3'b100, 32'hE31A_407C, 32'h72C9_BA11);   // Disabled branch forces not taken
    
        branch = 1'b1;
    
        TEST_BRANCH(3'b010, 32'h517C_3E92, 32'h517C_3E92);   // Unsupported funct3 is not taken
    
        $finish;
    end
endmodule