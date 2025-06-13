module xclk_reg #(
  parameter WIDTH = 10
) (
    input  logic               clk_i,
    input  logic               rst_i,
    input  logic [WIDTH - 1:0] input_i,
    output logic [WIDTH - 1:0] output_o,
);

  logic [WIDTH-1:0] out1_reg, out2_reg, out3_reg;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      out1_reg <= 'b0;
      out2_reg <= 'b0;
      out3_reg <= 'b0;
    end else begin
      out1_reg <= input_i;
      out2_reg <= out1_reg;
      out3_reg <= out3_reg;
    end
  end

assign output_o = out3_reg;
endmodule
