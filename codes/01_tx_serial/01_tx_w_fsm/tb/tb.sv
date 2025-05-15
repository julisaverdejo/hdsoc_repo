module tb;

  // clock signal
  localparam time ClkPeriod = 10ns;
  logic clk_i = 0;
  always #(ClkPeriod / 2) clk_i = ~clk_i;
  
  // interface
  top_if vif (clk_i);
  
  // test
  test top_test (vif);
  
  // instantiation
  tx_serial dut (
    .clk_i(vif.clk_i),
	.rst_i(vif.rst_i),
	.data_i(vif.data_i),
	.dvsr_i(vif.dvsr_i),
	.data_o(vif.data_o),
	.ena_o(vif.ena_o)
  );
  
  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule