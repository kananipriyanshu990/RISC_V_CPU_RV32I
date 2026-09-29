module INSTRUCTION_DECODER (input  wire [31:0]instruction,
                            output wire [6:0]opcode,
                            output wire [4:0]rd,
                            output wire [4:0]rs1,
                            output wire [4:0]rs2,
                            output wire [2:0]funct3,
                            output wire [6:0]funct7);

    assign opcode = instruction[6:0];                                // Extract instruction opcode
    assign rd = instruction[11:7];                                   // Extract destination register address
    assign funct3 = instruction[14:12];                              // Extract funct3 field
    assign rs1 = instruction[19:15];                                 // Extract first source register address
    assign rs2 = instruction[24:20];                                 // Extract second source register address
    assign funct7 = instruction[31:25];                              // Extract funct7 field
endmodule