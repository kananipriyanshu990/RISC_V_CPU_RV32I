module CONTROL_UNIT (input  wire [6:0]opcode,
                     output reg reg_write,
                     output reg mem_read,
                     output reg mem_write,
                     output reg mem_to_reg,
                     output reg alu_src,
                     output reg branch,
                     output reg jump,
                     output reg [2:0]alu_op);

localparam [6:0] OPCODE_R_TYPE = 7'b0110011;                       // R-type ALU instructions
localparam [6:0] OPCODE_I_ALU = 7'b0010011;                        // I-type ALU instructions
localparam [6:0] OPCODE_LOAD = 7'b0000011;                         // Load instructions
localparam [6:0] OPCODE_STORE = 7'b0100011;                        // Store instructions
localparam [6:0] OPCODE_BRANCH = 7'b1100011;                       // Conditional branch instructions
localparam [6:0] OPCODE_JALR = 7'b1100111;                         // JALR instruction
localparam [6:0] OPCODE_JAL = 7'b1101111;                          // JAL instruction
localparam [6:0] OPCODE_LUI = 7'b0110111;                          // LUI instruction
localparam [6:0] OPCODE_AUIPC = 7'b0010111;                        // AUIPC instruction

localparam [2:0] ALU_OP_ADD = 3'b000;                              // Select addition operation class
localparam [2:0] ALU_OP_BRANCH = 3'b001;                           // Select branch operation class
localparam [2:0] ALU_OP_R_TYPE = 3'b010;                           // Select R-type ALU operation class
localparam [2:0] ALU_OP_I_ALU = 3'b011;                            // Select I-type ALU operation class
localparam [2:0] ALU_OP_LUI = 3'b100;                              // Select LUI operation class
localparam [2:0] ALU_OP_AUIPC = 3'b101;                            // Select AUIPC operation class

always @(*) begin
    reg_write = 1'b0;                                               // Disable register-file write by default
    mem_read = 1'b0;                                                // Disable data-memory read by default
    mem_write = 1'b0;                                               // Disable data-memory write by default
    mem_to_reg = 1'b0;                                              // Select ALU result by default for write-back
    alu_src = 1'b0;                                                 // Select register operand by default
    branch = 1'b0;                                                  // Disable conditional branch by default
    jump = 1'b0;                                                    // Disable jump by default
    alu_op = ALU_OP_ADD;                                            // Use addition as the safe default ALU class

    case (opcode)

        OPCODE_R_TYPE: begin
            reg_write = 1'b1;                                       // R-type instructions write the ALU result to rd
            alu_op = ALU_OP_R_TYPE;                                 // Select R-type ALU operation decoding
        end

        OPCODE_I_ALU: begin
            reg_write = 1'b1;                                       // I-type ALU instructions write the ALU result to rd
            alu_src = 1'b1;                                         // Select the immediate as the second ALU operand
            alu_op = ALU_OP_I_ALU;                                  // Select I-type ALU operation decoding
        end

        OPCODE_LOAD: begin
            reg_write = 1'b1;                                       // Load instructions write memory data to rd
            mem_read = 1'b1;                                        // Enable data-memory read
            mem_to_reg = 1'b1;                                      // Select memory data for write-back
            alu_src = 1'b1;                                         // Select the load offset as the second ALU operand
            alu_op = ALU_OP_ADD;                                    // Address calculation requires addition
        end

        OPCODE_STORE: begin
            mem_write = 1'b1;                                       // Store instructions write data to memory
            alu_src = 1'b1;                                         // Select the store offset as the second ALU operand
            alu_op = ALU_OP_ADD;                                    // Address calculation requires addition
        end

        OPCODE_BRANCH: begin
            branch = 1'b1;                                          // Enable conditional branch processing
            alu_op = ALU_OP_BRANCH;                                 // Select branch operation class
        end

        OPCODE_JAL: begin
            reg_write = 1'b1;                                       // JAL writes the return address to rd
            jump = 1'b1;                                            // Enable unconditional jump processing
        end

        OPCODE_JALR: begin
            reg_write = 1'b1;                                       // JALR writes the return address to rd
            jump = 1'b1;                                            // Enable unconditional jump processing
            alu_src = 1'b1;                                         // Select the JALR immediate for target calculation
        end

        OPCODE_LUI: begin
            reg_write = 1'b1;                                       // LUI writes the immediate value to rd
            alu_src = 1'b1;                                         // Select the U-type immediate as the ALU B input
            alu_op = ALU_OP_LUI;                                    // Select LUI operation class
        end

        OPCODE_AUIPC: begin
            reg_write = 1'b1;                                       // AUIPC writes the PC-relative result to rd
            alu_src = 1'b1;                                         // Select the U-type immediate as the second ALU operand
            alu_op = ALU_OP_AUIPC;                                  // Select AUIPC operation class
        end

        default: begin
            reg_write = 1'b0;                                       // Keep register-file write disabled for unsupported opcodes
            mem_read = 1'b0;                                        // Keep data-memory read disabled for unsupported opcodes
            mem_write = 1'b0;                                       // Keep data-memory write disabled for unsupported opcodes
            mem_to_reg = 1'b0;                                      // Keep ALU result selected for unsupported opcodes
            alu_src = 1'b0;                                         // Keep register operand selected for unsupported opcodes
            branch = 1'b0;                                          // Keep branch disabled for unsupported opcodes
            jump = 1'b0;                                            // Keep jump disabled for unsupported opcodes
            alu_op = ALU_OP_ADD;                                    // Return to the safe addition control class
        end
    endcase
end

endmodule