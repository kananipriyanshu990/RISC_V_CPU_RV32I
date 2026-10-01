module IMMEDIATE_GENERATOR (input  wire [31:0] instruction,
                            output reg  [31:0] immediate);

localparam [6:0] OPCODE_I_ALU = 7'b0010011;                                              // I-type ALU instructions
localparam [6:0] OPCODE_LOAD = 7'b0000011;                                               // Load instructions
localparam [6:0] OPCODE_JALR = 7'b1100111;                                               // JALR instruction
localparam [6:0] OPCODE_STORE = 7'b0100011;                                              // S-type store instructions
localparam [6:0] OPCODE_BRANCH = 7'b1100011;                                             // B-type branch instructions
localparam [6:0] OPCODE_LUI = 7'b0110111;                                                // U-type LUI instruction
localparam [6:0] OPCODE_AUIPC = 7'b0010111;                                              // U-type AUIPC instruction
localparam [6:0] OPCODE_JAL = 7'b1101111;                                                // J-type JAL instruction

always @(*) begin
    case (instruction[6:0])

        OPCODE_I_ALU,
        OPCODE_LOAD,
        OPCODE_JALR:
            immediate = {{20{instruction[31]}}, instruction[31:20]};                      // Generate sign-extended I-type immediate

        OPCODE_STORE:
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};   // Generate sign-extended S-type immediate

        OPCODE_BRANCH:
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};  // Generate sign-extended B-type immediate

        OPCODE_LUI,
        OPCODE_AUIPC:
            immediate = {instruction[31:12], 12'b0};                                       // Generate U-type immediate

        OPCODE_JAL:
            immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};  // Generate sign-extended J-type immediate

        default:
            immediate = 32'd0;                                                             // Return zero for unsupported instruction formats

    endcase
end

endmodule