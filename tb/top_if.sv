interface top_if (
    input logic clk_i
 ); 
  logic        rst_i;
  logic        start_i;
  logic [26:0] data_i;
  logic        data_o;
  logic        ena_o;
  
  clocking cb @(posedge clk_i); 
    default input #1ns output #10ns; //these times are applied after 1 clk cycle
    output  rst_i;
    output  start_i;
    output  data_i;
    input   data_o;
    input   ena_o;
  endclocking
  
endinterface : top_if
