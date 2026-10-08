module BRANCH_UNIT (input wire branch,
                    input wire [2:0]funct3,
                    input wire [31:0]rs1_data,
                    input wire [31:0]rs2_data,
                    output reg branch_taken);

    always @(*) begin
        branch_taken = 1'b0;                                                      // Default to branch not taken
    
        if (branch) begin
            case (funct3)
                3'b000: branch_taken = (rs1_data == rs2_data);                    // BEQ: branch when operands are equal
                3'b001: branch_taken = (rs1_data != rs2_data);                    // BNE: branch when operands are not equal
                3'b100: branch_taken = ($signed(rs1_data) < $signed(rs2_data));   // BLT: signed less-than comparison
                3'b101: branch_taken = ($signed(rs1_data) >= $signed(rs2_data));  // BGE: signed greater-than-or-equal comparison
                3'b110: branch_taken = (rs1_data < rs2_data);                     // BLTU: unsigned less-than comparison
                3'b111: branch_taken = (rs1_data >= rs2_data);                    // BGEU: unsigned greater-than-or-equal comparison
                default: branch_taken = 1'b0;                                     // Unsupported branch funct3 is not taken
            endcase
        end
        else begin
            branch_taken = 1'b0;
        end
    end
endmodule