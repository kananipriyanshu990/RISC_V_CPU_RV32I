`timescale 1ns/1ps

module IMMEDIATE_GENERATOR_TB;

    logic [31:0]instruction;
    logic [31:0]immediate;

    IMMEDIATE_GENERATOR IG (.instruction(instruction),
                            .immediate(immediate));

    task automatic check_immediate;
        input [31:0]test_instruction;
        begin
            instruction = test_instruction;
            #1;
        end
    endtask

    initial begin

        instruction = 32'd0;

        check_immediate(32'h0A73_9213);

        check_immediate(32'hF6C5_17A1);

        check_immediate(32'h0000_0013);

        check_immediate(32'h7FF4_9613);

        check_immediate(32'h8005_1693);

        check_immediate(32'h1C82_A223);

        check_immediate(32'hE9B7_0D23);

        check_immediate(32'h0031_2023);

        check_immediate(32'h0385_9863);

        check_immediate(32'hF64D_1CE3);

        check_immediate(32'h0020_0063);

        check_immediate(32'h3141_20B7);

        check_immediate(32'h8E37_4517);

        check_immediate(32'h0000_00EF);

        check_immediate(32'h1A2B_30EF);

        check_immediate(32'hE5D6_F0EF);

        check_immediate(32'hFFFFFFFF);
        $finish;
    end
endmodule