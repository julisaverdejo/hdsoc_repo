module sync_reg #(
  parameter WIDTH = 10
) (
    input  logic               clk_i,
    input  logic               rst_i,
    input  logic [WIDTH - 1:0] input_i,
    output logic [WIDTH - 1:0] output_o,
);

  logic [WIDTH-1:0] out_reg;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      out_reg <= 'b0;
    end else begin
      out_reg <= input_i;
    end
  end

assign output_o = out_reg;
endmodule
