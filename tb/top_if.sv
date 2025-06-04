interface top_if (
    input logic CLK_I,
    input logic clk_i
 ); 
    
    // New clock signal
    logic  rst_i;     
    logic  data_o;
    //logic        ena_o;

    // WISHBONE BUS INTERFACE
		logic        RST_I;  // synchronous reset
		logic        CYC_I;  // cycle
		logic [31:0] ADR_I;  // address
		logic [31:0] DAT_I;  // data input  
		logic        STB_I;  // strobe      
    logic        WE_I;   // write enable
		logic        ACK_O;  // acknowledge
		logic        ERR_O;  // error
		logic [31:0] DAT_O;  // data output
  
  clocking cb @(posedge CLK_I); 
    default output #10ns; //these times are applied after 1 clk cycle
    output  RST_I;
    output  CYC_I;
    output  ADR_I;
    output  DAT_I;
    output  STB_I;
    output  WE_I; 
    input   ACK_O;
    input   ERR_O;
    input   DAT_O;
    //input   data_o;
    //input   ena_o;
  endclocking

  clocking cb_slow @(posedge clk_i); 
    default output #20ns; //these times are applied after 1 clk cycle
    output  rst_i;
    input   data_o;
  endclocking


endinterface : top_if
