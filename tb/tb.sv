module tb;

  // New clock signal - 25 MHz
  localparam time ClkPeriod = 40ns;
  logic clk_i = 0;
  always #(ClkPeriod / 2) clk_i = ~clk_i;


  // Wishbone bus clock signal - 50 MHz
  // localparam time ClkPeriod = 20ns;
  // logic CLK_I = 0;
  // always #(ClkPeriod / 2) CLK_I = ~CLK_I;

  // // New clock signal - 25 MHz
  // localparam time ClkPeriodNew = 40ns;
  // logic clk_i = 0;
  // always #(ClkPeriodNew / 2) clk_i = ~clk_i;

  // // New clock signal - 62.5 MHz
  // localparam time ClkPeriodNew = 16ns;
  // logic CLK_NEWFREQ_I = 0;
  // always #(ClkPeriodNew / 2) CLK_NEWFREQ_I = ~CLK_NEWFREQ_I;


  // interface
  // top_if vif (CLK_I, CLK_NEWFREQ_I);

  top_if vif (clk_i);
  
  // test
  test top_test (vif);
  
  // instantiation
  // wb_serializer dut (
  //   .CLK_NEWFREQ_I(vif.CLK_NEWFREQ_I),
  //   .RST_NEWFREQ_I(vif.RST_NEWFREQ_I),
  //   .data_o(vif.data_o),
  //   //.ena_o(vif.ena_o),
	//   .CLK_I(vif.CLK_I),
	//   .RST_I(vif.RST_I),
	//   .CYC_I(vif.CYC_I),
	//   .ADR_I(vif.ADR_I),
	//   .DAT_I(vif.DAT_I),
	//   .STB_I(vif.STB_I),
  //   .WE_I(vif.WE_I),
	//   .ACK_O(vif.ACK_O),
	//   .ERR_O(vif.ERR_O),
	//   .DAT_O(vif.DAT_O)
  // );

  deserializer dut (
    .clk_i(vif.clk_i),
    .rst_i(vif.rst_i),
    .inputdata_i(vif.inputdata_i),
    .outputdata_o(vif.outputdata_o),
    .code_err_o(vif.code_err_o),
    .disp_err_o(vif.disp_err_o),
    .eob_o(vif.eob_o)
  );

  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule