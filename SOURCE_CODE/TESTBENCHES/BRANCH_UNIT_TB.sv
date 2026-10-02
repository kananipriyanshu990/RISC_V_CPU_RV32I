`timescale 1ns/1ps

module BRANCH_UNIT_TB;

    reg branch;
    reg [2:0] funct3;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    wire branch_taken;
    
    integer pass_count;
    integer fail_count;
    
    BRANCH_UNIT BRN_UNIT (.branch(branch),
                          .funct3(funct3),
                          .rs1_data(rs1_data),
                          .rs2_data(rs2_data),
                          .branch_taken(branch_taken));
    
    task automatic TEST_BRANCH;
        input [2:0] TEST_FUNCT3;
        input [31:0] TEST_RS1;
        input [31:0] TEST_RS2;
        input EXPECTED;
    
        begin
            funct3 = TEST_FUNCT3;
            rs1_data = TEST_RS1;
            rs2_data = TEST_RS2;
            #1;
    
            if (branch_taken !== EXPECTED) begin
                fail_count = fail_count + 1;
                $display("FAIL: funct3=%b rs1=%h rs2=%h expected=%b got=%b",
                         TEST_FUNCT3, TEST_RS1, TEST_RS2, EXPECTED, branch_taken);
            end
            else begin
                pass_count = pass_count + 1;
                $display("PASS: funct3=%b rs1=%h rs2=%h result=%b",
                         TEST_FUNCT3, TEST_RS1, TEST_RS2, branch_taken);
            end
        end
    endtask
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        branch = 1'b1;
        funct3 = 3'b000;
        rs1_data = 32'd0;
        rs2_data = 32'd0;
    
        TEST_BRANCH(3'b000, 32'h4C71_9A26, 32'h4C71_9A26, 1'b1);   // BEQ equal operands
        TEST_BRANCH(3'b000, 32'h4C71_9A26, 32'h8B35_61D4, 1'b0);   // BEQ unequal operands
    
        TEST_BRANCH(3'b001, 32'h739E_214B, 32'h739E_214B, 1'b0);   // BNE equal operands
        TEST_BRANCH(3'b001, 32'h739E_214B, 32'h19D4_A860, 1'b1);   // BNE unequal operands
    
        TEST_BRANCH(3'b100, 32'hE31A_407C, 32'h72C9_BA11, 1'b1);   // BLT signed negative versus positive
        TEST_BRANCH(3'b100, 32'h61F4_2A83, 32'h2D87_C190, 1'b0);   // BLT signed positive comparison
    
        TEST_BRANCH(3'b101, 32'hE31A_407C, 32'h72C9_BA11, 1'b0);   // BGE signed negative versus positive
        TEST_BRANCH(3'b101, 32'h61F4_2A83, 32'h2D87_C190, 1'b1);   // BGE signed positive comparison
    
        TEST_BRANCH(3'b110, 32'h1A72_D4C9, 32'hB6E3_1840, 1'b1);   // BLTU unsigned smaller value
        TEST_BRANCH(3'b110, 32'hE31A_407C, 32'h72C9_BA11, 1'b0);   // BLTU unsigned comparison
    
        TEST_BRANCH(3'b111, 32'hE31A_407C, 32'h72C9_BA11, 1'b1);   // BGEU unsigned larger value
        TEST_BRANCH(3'b111, 32'h1A72_D4C9, 32'hB6E3_1840, 1'b0);   // BGEU unsigned smaller value
    
        branch = 1'b0;
    
        TEST_BRANCH(3'b000, 32'h4C71_9A26, 32'h4C71_9A26, 1'b0);   // Disabled branch forces not taken
        TEST_BRANCH(3'b100, 32'hE31A_407C, 32'h72C9_BA11, 1'b0);   // Disabled branch forces not taken
    
        branch = 1'b1;
    
        TEST_BRANCH(3'b010, 32'h517C_3E92, 32'h517C_3E92, 1'b0);   // Unsupported funct3 is not taken
    
        if (fail_count == 0)
            $display("ALL BRANCH UNIT TESTS PASSED");
        else
            $display("BRANCH UNIT TEST FAILED");
    
        $finish;
    end
endmodule