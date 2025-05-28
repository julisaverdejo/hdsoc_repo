module tb;

  // clock signal
  localparam time ClkPeriod = 20ns;
  logic CLK_I = 0;
  always #(ClkPeriod / 2) CLK_I = ~CLK_I;
  
  // interface
  top_if vif (CLK_I);
  
  // test
  test top_test (vif);
  
  // instantiation
  wb_serializer dut (
    .data_o(vif.data_o),
    .ena_o(vif.ena_o),
    //.eobyte_o(vif.eobyte_o),
	  .CLK_I(vif.CLK_I),
	  .RST_I(vif.RST_I),
	  .CYC_I(vif.CYC_I),
	  .ADR_I(vif.ADR_I),
	  .DAT_I(vif.DAT_I),
	  .STB_I(vif.STB_I),
    .WE_I(vif.WE_I),
	  .ACK_O(vif.ACK_O),
	  .ERR_O(vif.ERR_O),
	  .DAT_O(vif.DAT_O)
  );
  
  initial begin
    $timeformat(-9, 1, "ns", 10);
  end

endmodule