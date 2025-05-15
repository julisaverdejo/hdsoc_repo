interface top_if (
    input logic clk_i
 ); 
	logic       rst_i;
	logic [8:0] data_i;
	logic [2:0] dvsr_i;
	logic       data_o;
	logic       ena_o;
  
  clocking cb @(posedge clk_i); 
    default input #1ns output #5ns; //these times are applied after 1 clk cycle
    output  rst_i;
    output  data_i;
    output  dvsr_i;
    input   data_o;
    input   ena_o;
  endclocking
  
endinterface : top_if