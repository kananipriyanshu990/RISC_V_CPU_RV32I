module HAZARD_DETECTION_UNIT (input  wire [4:0] id_ex_rs1,
                              input  wire [4:0] id_ex_rs2,
                              input  wire [4:0] id_ex_rd,
                              input  wire id_ex_mem_read,
                              input  wire [4:0] if_id_rs1,
                              input  wire [4:0] if_id_rs2,
                              output reg pc_write,
                              output reg if_id_write,
                              output reg id_ex_control_stall);

    always @(*) begin
        pc_write = 1'b1;                                                   // Allow the PC to advance normally
        if_id_write = 1'b1;                                                // Allow the IF/ID register to advance normally
        id_ex_control_stall = 1'b0;                                        // Allow normal ID/EX control signals
    
        if (id_ex_mem_read &&(id_ex_rd != 5'd0) && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2))) begin
            pc_write = 1'b0;                                               // Hold the PC during a load-use hazard
            if_id_write = 1'b0;                                            // Hold the dependent instruction in IF/ID
            id_ex_control_stall = 1'b1;                                    // Convert the instruction entering EX into a bubble
        end
    end
endmodule