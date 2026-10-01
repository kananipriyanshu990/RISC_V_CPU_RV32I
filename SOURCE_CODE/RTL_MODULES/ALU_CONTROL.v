module ALU_CONTROL (input wire [2:0]alu_op,
                    input wire [2:0]funct3,
                    input wire [6:0]funct7,
                    output reg [3:0]alu_control);

    localparam [2:0] ALU_OP_ADD = 3'b000;                              // Addition operation class
    localparam [2:0] ALU_OP_BRANCH = 3'b001;                           // Branch operation class
    localparam [2:0] ALU_OP_R_TYPE = 3'b010;                           // R-type operation class
    localparam [2:0] ALU_OP_I_ALU = 3'b011;                            // I-type ALU operation class
    localparam [2:0] ALU_OP_LUI = 3'b100;                              // LUI operation class
    localparam [2:0] ALU_OP_AUIPC = 3'b101;                            // AUIPC operation class
    
    localparam [3:0] ALU_ADD = 4'b0000;                                // Select addition
    localparam [3:0] ALU_SUB = 4'b0001;                                // Select subtraction
    localparam [3:0] ALU_AND = 4'b0010;                                // Select bitwise AND
    localparam [3:0] ALU_OR = 4'b0011;                                 // Select bitwise OR
    localparam [3:0] ALU_XOR = 4'b0100;                                // Select bitwise XOR
    localparam [3:0] ALU_SLL = 4'b0101;                                // Select logical left shift
    localparam [3:0] ALU_SRL = 4'b0110;                                // Select logical right shift
    localparam [3:0] ALU_SRA = 4'b0111;                                // Select arithmetic right shift
    localparam [3:0] ALU_SLT = 4'b1000;                                // Select signed set-less-than
    localparam [3:0] ALU_SLTU = 4'b1001;                               // Select unsigned set-less-than
    localparam [3:0] ALU_LUI = 4'b1010;                                // Select LUI operation
    localparam [3:0] ALU_AUIPC = 4'b1011;                              // Select AUIPC operation

    always @(*) begin
        alu_control = ALU_ADD;                                         // Use addition as the safe default ALU operation

        case (alu_op)

            ALU_OP_ADD: begin
                alu_control = ALU_ADD;                                 // Select addition for address and default calculations
            end

            ALU_OP_BRANCH: begin
                alu_control = ALU_ADD;                                 // Use addition as the harmless ALU operation during branch instructions
            end

            ALU_OP_R_TYPE: begin
                            case (funct3)
                                3'b000: alu_control = (funct7[5] ? ALU_SUB : ALU_ADD);     // Select ADD or SUB from funct3 and funct7
                                3'b001: alu_control = ALU_SLL;                             // Select SLL
                                3'b010: alu_control = ALU_SLT;                             // Select signed SLT
                                3'b011: alu_control = ALU_SLTU;                            // Select unsigned SLTU
                                3'b100: alu_control = ALU_XOR;                             // Select XOR
                                3'b101: alu_control = (funct7[5] ? ALU_SRA : ALU_SRL);     // Select SRL or SRA from funct3 and funct7
                                3'b110: alu_control = ALU_OR;                              // Select OR
                                3'b111: alu_control = ALU_AND;                             // Select AND
                                default: alu_control = ALU_ADD;                            // Use addition for an unsupported funct3 value
                            endcase
                           end

            ALU_OP_I_ALU: begin
                        case (funct3)
                            3'b000: alu_control = ALU_ADD;                                 // Select ADDI
                            3'b001: alu_control = ALU_SLL;                                 // Select SLLI
                            3'b010: alu_control = ALU_SLT;                                 // Select SLTI
                            3'b011: alu_control = ALU_SLTU;                                // Select SLTIU
                            3'b100: alu_control = ALU_XOR;                                 // Select XORI
                            3'b101: alu_control = (funct7[5] ? ALU_SRA : ALU_SRL);         // Select SRLI or SRAI
                            3'b110: alu_control = ALU_OR;                                  // Select ORI
                            3'b111: alu_control = ALU_AND;                                 // Select ANDI
                            default: alu_control = ALU_ADD;                                // Use addition for an unsupported funct3 value
                        endcase
                       end

            ALU_OP_LUI: begin
                alu_control = ALU_LUI;                                  // Select LUI operation
            end

            ALU_OP_AUIPC: begin
                alu_control = ALU_AUIPC;                                // Select AUIPC operation
            end

            default: begin
                alu_control = ALU_ADD;                                  // Use addition for an unsupported ALU operation class
            end
        endcase
    end
endmodule