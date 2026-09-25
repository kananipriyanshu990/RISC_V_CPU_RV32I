module PIPELINE_REGISTER #(parameter WIDTH = 32) 
                          (input wire clk,
                           input wire reset,
                           input wire enable,
                           input wire flush,
                           input wire [WIDTH-1:0] data_in,
                           output reg [WIDTH-1:0] data_out);

    always @(posedge clk) begin
        if (reset)
            data_out <= {WIDTH{1'b0}};                           // Reset pipeline register contents
        else if (flush)
            data_out <= {WIDTH{1'b0}};                           // Flush pipeline register contents
        else if (enable)
            data_out <= data_in;                                 // Capture new pipeline data
    end
endmodule