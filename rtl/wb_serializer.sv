//==============================================================================
// [Filename]     -
// [Project]      -
// [Author]       Julisa Verdejo Palacios - julisa.verdejopalacios@ba.infn.it
// [Language]     -
// [Created]      2025-04-28
// [Modified]     -
// [Description]  -
// [Notes]        'data_i' is a register compose of three 9-bit registers
//                 [k + 8-bits][k + 8-bits][k + 8-bits]
//                 [k = 0] -> data,  [k = 1] -> kcode 
// [Status]       -
// [Revisions]    -
//==============================================================================
`include "wb_serializer.pkg"

module wb_serializer_in (
    //input  logic        start_i,      
    output logic        data_o,

    // WISHBONE BUS INTERFACE
		input  logic        CLK_I,	// clock
		input  logic        RST_I,  // synchronous reset
		input  logic        CYC_I,  // cycle
		input  logic [31:0] ADR_I,  // address
		input  logic [31:0] DAT_I,  // data input  
		input  logic        STB_I,  // strobe      
        input  logic        WE_I,   // write enable
		output logic        ACK_O,  // acknowledge
		output logic        ERR_O,  // error
		output logic [31:0] DAT_O  // data output
);

  import WBSerializer::*;
  localparam ADDR_SIZE = $bits(NUM_REGS);

  // Internal signals
  logic start;

  serializer_in mod_serialin (
    .clk_i(CLK_I),
    .rst_i(RST_I),
    .start_i(start),
    .data_i(data),       
    .data_o(data_o),
    .cnt_pkt_o(cnt_pkt)
);

  // WISHBONE BUS INTERNAL SIGNALS
  logic [1:0] cnt_pkt, pkt;

  //Signal declaration
  logic [31:0] data;

  always_ff @(posedge CLK_I) begin
	if (RST_I) begin
	  pkt <= 'b0; 
	end else if (!CYC_I) begin
	  pkt <= 'b0;
	end else begin
	  pkt <= cnt_pkt;
	end
  end

// WISHBONE BUS

	// READ: SLAVE ---> MASTER

always_comb begin
	case (ADR_I[ADDR_SIZE-1:0])				
		ADR_WRITE: begin	
		  DAT_O = 'b0;
		  ERR_O = 'b0;			
		  ACK_O = WE_I ? pkt : STB_I;
		end
/*
		ADR_READ: begin	
			DAT_O = {31'b0, ena};
			ERR_O = 'b0;		
			ACK_O = WE_I ? pkt : STB_I;
		end
*/
		default:	begin
			DAT_O = 'b0;	
			ERR_O = 'b0;		
			ACK_O = 'b0;
		end
	endcase
end

// WRITE: MASTER ---> SLAVE

always_ff @(posedge CLK_I) begin
  if (RST_I) begin
    start <= 'b0;
	data  <= 'b0;
  end else begin
    start <= 'b0;
	if (WE_I && STB_I) begin
	  case (ADR_I[ADDR_SIZE-1:0])	

	    ADR_WRITE: begin
	      start <= 'b1;
	      data  <= DAT_I;
	    end				

	    default: begin
	    end
	  endcase
    end
  end
end

endmodule
