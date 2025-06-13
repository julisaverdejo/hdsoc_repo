interface top_if (
    // input logic CLK_I,
    // input logic CLK_NEWFREQ_I
    input clk_i
);

  logic        rst_i;
  logic        inputdata_i;
  logic [8:0]  outputdata_o;
  logic        err_o;
  logic        eob_o; 
    
  //   // New clock signal
  //   logic  RST_NEWFREQ_I;     
  //   logic  data_o;
  //   //logic        ena_o;

  //   // WISHBONE BUS INTERFACE
	// 	logic        RST_I;  // synchronous reset
	// 	logic        CYC_I;  // cycle
	// 	logic [31:0] ADR_I;  // address
	// 	logic [31:0] DAT_I;  // data input  
	// 	logic        STB_I;  // strobe      
  //   logic        WE_I;   // write enable
	// 	logic        ACK_O;  // acknowledge
	// 	logic        ERR_O;  // error
	// 	logic [31:0] DAT_O;  // data output
  
  // clocking cb @(posedge CLK_I); 
  //   default output #10ns; //these times are applied after 1 clk cycle
  //   output  RST_I;
  //   output  CYC_I;
  //   output  ADR_I;
  //   output  DAT_I;
  //   output  STB_I;
  //   output  WE_I; 
  //   input   ACK_O;
  //   input   ERR_O;
  //   input   DAT_O;
  //   //input   data_o;
  //   //input   ena_o;
  // endclocking

  // clocking cb_slow @(posedge CLK_NEWFREQ_I); 
  //   default output #20ns; //these times are applied after 1 clk cycle
  //   output  RST_NEWFREQ_I;
  //   input   data_o;
  // endclocking


  clocking cb @(posedge clk_i); 
    default output #20ns; //these times are applied after 1 clk cycle
    output   rst_i;
    output   inputdata_i;
    input    outputdata_o;
    input    err_o;
    input    eob_o;
  endclocking

    clocking cb_neg @(negedge clk_i); 
    default output #20ns; //these times are applied after 1 clk cycle
    output   rst_i;
    output   inputdata_i;
    input    outputdata_o;
    input    err_o;
    input    eob_o;
  endclocking

endinterface : top_if
