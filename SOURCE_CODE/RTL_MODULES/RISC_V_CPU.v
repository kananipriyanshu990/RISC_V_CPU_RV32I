module RISC_V_CPU (input wire clk,
                   input wire reset,
                   input wire [31:0]imem_rdata,                                // Instruction supplied for imem_addr during the fetch cycle
                   input wire [31:0]dmem_rdata,                                // Load data supplied for dmem_addr during the MEM cycle
                   output wire [31:0]dmem_addr,                                // Data-memory byte address driven by the MEM-stage instruction
                   output wire [31:0]dmem_wdata,                               // Store data driven by the MEM-stage instruction
                   output wire [31:0]imem_addr,                                // Instruction-memory byte address driven by the CPU
                   output wire dmem_we,                                        // Active-high word-store request
                   output wire [3:0]dmem_be);                                  // Byte enables for the data-memory request


    localparam [6:0] OPCODE_R_TYPE = 7'b0110011;
    localparam [6:0] OPCODE_I_ALU = 7'b0010011;
    localparam [6:0] OPCODE_LOAD = 7'b0000011;
    localparam [6:0] OPCODE_BRANCH = 7'b1100011;
    localparam [6:0] OPCODE_JALR = 7'b1100111;
    localparam [2:0] ALUOP_AUIPC = 3'b101;

    wire [31:0]pc;
    wire [31:0]pc_plus_4;
    reg  [31:0]next_pc;

    wire pc_write;
    wire if_id_write;
    wire id_ex_control_stall;

    wire branch_taken;
    wire control_flush;
    wire [31:0]jump_target;

    wire [63:0]if_id_data_in;
    wire [63:0]if_id_data_out;
    wire [31:0]if_id_pc;
    wire [31:0]if_id_instruction;

    wire [6:0]id_opcode;
    wire [4:0]id_rd;
    wire [4:0]id_rs1;
    wire [4:0]id_rs2;
    wire [2:0]id_funct3;
    wire [6:0]id_funct7;
    wire [31:0]id_immediate;

    wire id_reg_write;
    wire id_mem_read;
    wire id_mem_write;
    wire id_mem_to_reg;
    wire id_alu_src;
    wire id_branch;
    wire id_jump;
    wire [2:0]id_alu_op;
    wire [3:0]id_alu_control;

    wire [31:0]regfile_rs1_data;
    wire [31:0]regfile_rs2_data;
    wire [31:0]id_rs1_data;
    wire [31:0]id_rs2_data;
    wire [31:0]wb_data;

    wire [4:0]mem_wb_rd;
    wire mem_wb_reg_write;

    wire [160:0]id_ex_data_in;
    wire [160:0]id_ex_data_out;

    wire [31:0]id_ex_pc;
    wire [31:0]id_ex_rs1_data;
    wire [31:0]id_ex_rs2_data;
    wire [31:0]id_ex_immediate;
    wire [4:0]id_ex_rs1;
    wire [4:0]id_ex_rs2;
    wire [4:0]id_ex_rd;
    wire [2:0]id_ex_funct3;

    wire id_ex_reg_write;
    wire id_ex_mem_read;
    wire id_ex_mem_write;
    wire id_ex_mem_to_reg;
    wire id_ex_alu_src;
    wire id_ex_branch;
    wire id_ex_jump;
    wire id_ex_is_jalr;
    wire [2:0] id_ex_alu_op;
    wire [3:0] id_ex_alu_control;

    wire [1:0]forward_a;
    wire [1:0]forward_b;
    wire [31:0]forwarded_operand_a;
    wire [31:0]forwarded_operand_b;
    wire [31:0]ex_operand_a;
    wire [31:0]ex_operand_b;
    wire [31:0]alu_result;
    wire [31:0]ex_store_data;

    wire [105:0]ex_mem_data_in;
    wire [105:0]ex_mem_data_out;
    wire [31:0]ex_mem_pc;
    wire [31:0]ex_mem_alu_result;
    wire [31:0]ex_mem_store_data;
    wire [4:0]ex_mem_rd;
    wire ex_mem_reg_write;
    wire ex_mem_mem_read;
    wire ex_mem_mem_write;
    wire ex_mem_mem_to_reg;
    wire ex_mem_jump;

    wire [103:0]mem_wb_data_in;
    wire [103:0]mem_wb_data_out;
    wire [31:0]mem_wb_pc;
    wire [31:0]mem_wb_mem_data;
    wire [31:0]mem_wb_alu_result;
    wire mem_wb_mem_to_reg;
    wire mem_wb_jump;

    wire hazard_rs1_used;
    wire hazard_rs2_used;
    wire [4:0]hazard_rs1;
    wire [4:0]hazard_rs2;

    assign pc_plus_4 = pc + 32'd4;                                      // Calculate the sequential PC value

    always @(*) begin
        next_pc = pc_plus_4;                                            // Select sequential execution by default

        if (control_flush)
            next_pc = jump_target;                                      // Select the taken branch or jump target
        else if (!pc_write)
            next_pc = pc;                                               // Hold the PC during a load-use stall
    end

    assign imem_addr = pc;                                              // Present the current fetch address to the external instruction memory

    PROGRAM_COUNTER PC_UNIT (.clk(clk),
                             .reset(reset),
                             .next_pc(next_pc),
                             .pc(pc));

    assign if_id_data_in = {pc, imem_rdata};                            // Pair the current fetch PC with the instruction supplied for that address

    PIPELINE_REGISTER #(.WIDTH(64)) IF_ID_REGISTER (.clk(clk),
                                                    .reset(reset),
                                                    .enable(if_id_write),
                                                    .flush(control_flush),
                                                    .data_in(if_id_data_in),
                                                    .data_out(if_id_data_out));

    assign if_id_pc          = if_id_data_out[63:32];                    // Extract the instruction PC from IF/ID
    assign if_id_instruction  = if_id_data_out[31:0];                   // Extract the instruction word from IF/ID

    INSTRUCTION_DECODER DECODER (.instruction(if_id_instruction),
                                 .opcode(id_opcode),
                                 .rd(id_rd),
                                 .rs1(id_rs1),
                                 .rs2(id_rs2),
                                 .funct3(id_funct3),
                                 .funct7(id_funct7));

    IMMEDIATE_GENERATOR IMMEDIATE_UNIT (.instruction(if_id_instruction),
                                        .immediate(id_immediate));

    CONTROL_UNIT CONTROL (.opcode(id_opcode),
                          .reg_write(id_reg_write),
                          .mem_read(id_mem_read),
                          .mem_write(id_mem_write),
                          .mem_to_reg(id_mem_to_reg),
                          .alu_src(id_alu_src),
                          .branch(id_branch),
                          .jump(id_jump),
                          .alu_op(id_alu_op));

    ALU_CONTROL ALU_CONTROL_UNIT (.alu_op(id_alu_op),
                                  .funct3(id_funct3),
                                  .funct7(id_funct7),
                                  .alu_control(id_alu_control));

    REGISTER_FILE REGISTERS (.clk(clk),
                             .reset(reset),
                             .rs1_addr(id_rs1),
                             .rs2_addr(id_rs2),
                             .rd_addr(mem_wb_rd),
                             .rd_data(wb_data),
                             .rd_write_enable(mem_wb_reg_write),
                             .rs1_data(regfile_rs1_data),
                             .rs2_data(regfile_rs2_data));

    assign id_rs1_data = (mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_rs1)) ?
                         wb_data : regfile_rs1_data;                    // Bypass the current WB value to source register 1

    assign id_rs2_data = (mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_rs2)) ?
                         wb_data : regfile_rs2_data;                    // Bypass the current WB value to source register 2

    assign hazard_rs1_used =(id_opcode == OPCODE_R_TYPE) ||
                            (id_opcode == OPCODE_I_ALU)  ||
                            (id_opcode == OPCODE_LOAD)   ||
                            (id_opcode == OPCODE_BRANCH) ||
                            (id_opcode == OPCODE_JALR);                                  // Identify instructions that read rs1

    assign hazard_rs2_used = (id_opcode == OPCODE_R_TYPE) || (id_opcode == OPCODE_BRANCH);                                // Identify instructions that read rs2

    assign hazard_rs1 = hazard_rs1_used ? id_rs1 : 5'd0;                // Ignore unused rs1 fields during load-use detection
    assign hazard_rs2 = hazard_rs2_used ? id_rs2 : 5'd0;                // Ignore unused rs2 fields during load-use detection

    HAZARD_DETECTION_UNIT HAZARD_UNIT (.id_ex_rs1(id_ex_rs1),
                                       .id_ex_rs2(id_ex_rs2),
                                       .id_ex_rd(id_ex_rd),
                                       .id_ex_mem_read(id_ex_mem_read),
                                       .if_id_rs1(hazard_rs1),
                                       .if_id_rs2(hazard_rs2),
                                       .pc_write(pc_write),
                                       .if_id_write(if_id_write),
                                       .id_ex_control_stall(id_ex_control_stall));

    assign id_ex_data_in = {if_id_pc,
                            id_rs1_data,
                            id_rs2_data,
                            id_immediate,
                            id_rs1,
                            id_rs2,
                            id_rd,
                            id_funct3,
                            id_ex_control_stall ? 1'b0 : id_reg_write,
                            id_ex_control_stall ? 1'b0 : id_mem_read,
                            id_ex_control_stall ? 1'b0 : id_mem_write,
                            id_ex_control_stall ? 1'b0 : id_mem_to_reg,
                            id_ex_control_stall ? 1'b0 : id_alu_src,
                            id_ex_control_stall ? 1'b0 : id_branch,
                            id_ex_control_stall ? 1'b0 : id_jump,
                            id_ex_control_stall ? 1'b0 : (id_opcode == OPCODE_JALR),
                            id_ex_control_stall ? 3'b000 : id_alu_op,
                            id_ex_control_stall ? 4'b0000 : id_alu_control};                                                                  // Assemble the ID/EX pipeline data

    PIPELINE_REGISTER #(.WIDTH(161)) ID_EX_REGISTER (.clk(clk),
                                                     .reset(reset),
                                                     .enable(1'b1),
                                                     .flush(control_flush),
                                                     .data_in(id_ex_data_in),
                                                     .data_out(id_ex_data_out));

    assign {id_ex_pc,
            id_ex_rs1_data,
            id_ex_rs2_data,
            id_ex_immediate,
            id_ex_rs1,
            id_ex_rs2,
            id_ex_rd,
            id_ex_funct3,
            id_ex_reg_write,
            id_ex_mem_read,
            id_ex_mem_write,
            id_ex_mem_to_reg,
            id_ex_alu_src,
            id_ex_branch,
            id_ex_jump,
            id_ex_is_jalr,
            id_ex_alu_op,
            id_ex_alu_control} = id_ex_data_out;                                                  // Unpack the ID/EX pipeline data

    FORWARDING_UNIT FORWARD_UNIT (.id_ex_rs1(id_ex_rs1),
                                  .id_ex_rs2(id_ex_rs2),
                                  .ex_mem_rd(ex_mem_rd),
                                  .ex_mem_reg_write(ex_mem_reg_write),
                                  .ex_mem_mem_to_reg(ex_mem_mem_to_reg),
                                  .mem_wb_rd(mem_wb_rd),
                                  .mem_wb_reg_write(mem_wb_reg_write),
                                  .forward_a(forward_a),
                                  .forward_b(forward_b));

    assign forwarded_operand_a = (forward_a == 2'b10) ?
                                 ex_mem_alu_result :
                                 (forward_a == 2'b01) ?
                                 wb_data : id_ex_rs1_data;              // Select the forwarded EX operand A

    assign forwarded_operand_b = (forward_b == 2'b10) ?
                                 ex_mem_alu_result :
                                 (forward_b == 2'b01) ?
                                 wb_data : id_ex_rs2_data;              // Select the forwarded EX operand B

    assign ex_operand_a = (id_ex_alu_op == ALUOP_AUIPC) ?
                          id_ex_pc : forwarded_operand_a;               // Select the PC as operand A for AUIPC

    assign ex_operand_b = id_ex_alu_src ?
                          id_ex_immediate : forwarded_operand_b;        // Select the immediate or forwarded register operand B

    ALU EXECUTION_ALU (.operand_a(ex_operand_a),
                       .operand_b(ex_operand_b),
                       .pc(id_ex_pc),
                       .alu_control(id_ex_alu_control),
                       .result(alu_result),
                       .zero());

    BRANCH_UNIT BRANCH (.branch(id_ex_branch),
                        .funct3(id_ex_funct3),
                        .rs1_data(forwarded_operand_a),
                        .rs2_data(forwarded_operand_b),
                        .branch_taken(branch_taken));

    assign jump_target = id_ex_is_jalr ?
                         ((forwarded_operand_a + id_ex_immediate) & 32'hFFFF_FFFE) :
                         (id_ex_pc + id_ex_immediate);                   // Calculate the JALR or JAL target

    assign control_flush = branch_taken || id_ex_jump;                 // Flush younger instructions after a taken control transfer
    assign ex_store_data = forwarded_operand_b;                        // Preserve the forwarded rs2 value for a store

    assign ex_mem_data_in = {id_ex_pc,
                             alu_result,
                             ex_store_data,
                             id_ex_rd,
                             id_ex_reg_write,
                             id_ex_mem_read,
                             id_ex_mem_write,
                             id_ex_mem_to_reg,
                             id_ex_jump};                                                                  // Assemble the EX/MEM pipeline data

    PIPELINE_REGISTER #(.WIDTH(106)) EX_MEM_REGISTER (.clk(clk),
                                                      .reset(reset),
                                                      .enable(1'b1),
                                                      .flush(1'b0),
                                                      .data_in(ex_mem_data_in),
                                                      .data_out(ex_mem_data_out));

    assign {ex_mem_pc,
            ex_mem_alu_result,
            ex_mem_store_data,
            ex_mem_rd,
            ex_mem_reg_write,
            ex_mem_mem_read,
            ex_mem_mem_write,
            ex_mem_mem_to_reg,
            ex_mem_jump} = ex_mem_data_out;                                          

    assign dmem_addr = ex_mem_alu_result;                               // Present the address belonging to the instruction in the MEM stage
    assign dmem_wdata = ex_mem_store_data;                              // Present the store data belonging to the instruction in the MEM stage
    assign dmem_we = ex_mem_mem_write;                                  // Request a data-memory write for the instruction in the MEM stage
    assign dmem_be = ex_mem_mem_write ? 4'b1111 : 4'b0000;            // Enable all bytes for the supported RV32I word store

    assign mem_wb_data_in = {ex_mem_pc,
                             dmem_rdata,
                             ex_mem_alu_result,
                             ex_mem_rd,
                             ex_mem_reg_write,
                             ex_mem_mem_to_reg,
                             ex_mem_jump};                                                                  // Assemble the MEM/WB pipeline data

    PIPELINE_REGISTER #(.WIDTH(104)) MEM_WB_REGISTER (.clk(clk),
                        .reset(reset),
                        .enable(1'b1),
                        .flush(1'b0),
                        .data_in(mem_wb_data_in),
                        .data_out(mem_wb_data_out));

    assign {mem_wb_pc,
            mem_wb_mem_data,
            mem_wb_alu_result,
            mem_wb_rd,
            mem_wb_reg_write,
            mem_wb_mem_to_reg,
            mem_wb_jump} = mem_wb_data_out;                                                 // Unpack the MEM/WB pipeline data

    assign wb_data = mem_wb_mem_to_reg ?
                     mem_wb_mem_data :
                     (mem_wb_jump ? (mem_wb_pc + 32'd4) : mem_wb_alu_result);               // Select the final register write-back value

endmodule