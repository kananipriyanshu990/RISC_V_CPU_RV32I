module ALU (input wire [31:0] operand_a,
            input wire [31:0] operand_b,
            input wire [31:0] pc,
            input wire [3:0] alu_control,
            output reg [31:0] result,
            output wire zero);

    localparam [3:0] ALU_ADD   = 4'b0000;                              // Select addition
    localparam [3:0] ALU_SUB   = 4'b0001;                              // Select subtraction
    localparam [3:0] ALU_AND   = 4'b0010;                              // Select bitwise AND
    localparam [3:0] ALU_OR    = 4'b0011;                              // Select bitwise OR
    localparam [3:0] ALU_XOR   = 4'b0100;                              // Select bitwise XOR
    localparam [3:0] ALU_SLL   = 4'b0101;                              // Select logical left shift
    localparam [3:0] ALU_SRL   = 4'b0110;                              // Select logical right shift
    localparam [3:0] ALU_SRA   = 4'b0111;                              // Select arithmetic right shift
    localparam [3:0] ALU_SLT   = 4'b1000;                              // Select signed set-less-than
    localparam [3:0] ALU_SLTU  = 4'b1001;                              // Select unsigned set-less-than
    localparam [3:0] ALU_LUI   = 4'b1010;                              // Select LUI operation
    localparam [3:0] ALU_AUIPC = 4'b1011;                              // Select AUIPC operation
    
    always @(*) begin
        case (alu_control)
    
            ALU_ADD:
                result = operand_a + operand_b;                        // Perform 32-bit addition
    
            ALU_SUB:
                result = operand_a - operand_b;                        // Perform 32-bit subtraction
    
            ALU_AND:
                result = operand_a & operand_b;                        // Perform bitwise AND
    
            ALU_OR:
                result = operand_a | operand_b;                        // Perform bitwise OR
    
            ALU_XOR:
                result = operand_a ^ operand_b;                        // Perform bitwise XOR
    
            ALU_SLL:
                result = operand_a << operand_b[4:0];                  // Perform logical left shift using the lower five bits as shift amount
    
            ALU_SRL:
                result = operand_a >> operand_b[4:0];                  // Perform logical right shift using the lower five bits as shift amount
    
            ALU_SRA:
                result = $signed(operand_a) >>> operand_b[4:0];        // Perform arithmetic right shift using the signed operand
    
            ALU_SLT:
                result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0; // Perform signed less-than comparison
    
            ALU_SLTU:
                result = (operand_a < operand_b) ? 32'd1 : 32'd0;      // Perform unsigned less-than comparison
    
            ALU_LUI:
                result = operand_b;                                    // Pass the U-type immediate through for LUI
    
            ALU_AUIPC:
                result = pc + operand_b;                               // Add the current PC to the U-type immediate for AUIPC
    
            default:
                result = 32'd0;                                        // Return zero for an unsupported ALU control code
    
        endcase
    end
    
    assign zero = (result == 32'd0);                                   // Assert zero when the ALU result is zero
endmodule