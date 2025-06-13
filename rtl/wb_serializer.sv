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
`include "wb_serializer_pkg.sv"

module wb_serializer (
  input  logic  CLK_NEWFREQ_I, 
	input  logic  RST_NEWFREQ_I,
	input  logic  INPUTDATA_I,
  output logic  data_o,
	//output logic  ena_o,

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

  //========================= Internal signals ========================= 
  // Signals for start with WB_FREQ
  logic start_write, aux_start_write_d, aux_start_write_q;
  //logic ena;
  logic [8:0] wrd8b_data_q, wrd8b_data_in;
  logic [8:0] outputdata;
  logic eob, err;

  // Signals for start_new_write with CLK_NEWFREQ
  logic reg_aux1_start, reg_aux2_start, reg_aux3_start, start_new_write;

  // Signals for end of transaction with CLK_NEWFREQ
  logic eot_stretch, eot_aux1, eot_aux2, eot_aux3;
  logic eot_new;


  deserializer #(.WIDTH(10))
  (
    .clk_i(CLK_NEWFREQ_I),
    .rst_i(RST_NEWFREQ_I),
    .inputdata_i(INPUTDATA_I),
    .outputdata_o(outputdata),
    .eob_o(eob),
    .err_o(err)
  );


  //========================= WISHBONE BUS INTERNAL SIGNALS ========================= 
    
  //Signal declaration
  logic [31:0] data;
  logic eob_aux1, eob_aux2, eob_aux3, EOB_I;
  logic aux_start_read_d, aux1_start_read_q, aux2_start_read_q;
  logic start_read, start_new_read;  

// WISHBONE BUS
  always_ff @(posedge CLK_I, posedge RST_I) begin
	  if(RST_I) begin
	    eob_aux1 <= 1'b0;
	    eob_aux2 <= 1'b0;
      EOB      <= 1'b0;
	  end else begin
      eob_aux1 <= eob;
      eob_aux2 <= eob_aux1;
      EOB      <= ~eob_aux2;
	  end
  end

// start read to know when the conversion is finished and pass the 8-bit DAT_I (WB signal)
  assign aux_start_read_d = (CYC_I & STB_I & ~WE_I & (ADR_I = ADR_READ) & EOB);

  always_ff @(posedge CLK_I, posedge RST_I) begin
    if (RST_I) begin
      aux1_start_read_q <= 1'b0;
    end else begin
      aux2_start_read_q <= aux_start_read_d;
    end
  end

  assign start_read = ~aux2_start_read_q & aux_start_read_d;

  always_ff @(posedge CLK_I, posedge RST_I) begin
    if (RST_I) begin
      start_new_read <= 1'b0;
    end else begin
      start_new_read <= start_read;
    end
  end  

// Add a flip-flop to pass from one clk frequency to another (WB Frequency)
  always_ff @(posedge CLK_I, posedge RST_I) begin
	if (RST_I) begin
	  wrd8b_data_in <= 9'b0; 
	end else begin
	  if (start_new_read) begin
	    wrd8b_data_q <= outputdata;
      rd8b_data_in <= wrd8b_data_q;
	  end else begin
	    wrd8b_data_in <= wrd8b_data_in;
	  end
  end


	// READ: SLAVE ---> MASTER

  always_comb begin
  	 case (ADR_I[ADDR_SIZE-1:0])				
  	   ADR_WRITE: begin	
  	     DAT_O = 'b0;
  	     ERR_O = 'b0;			
  	     ACK_O = WE_I ? eot_new : STB_I;
  	   end
  /*
  		ADR_READ: begin	
  			DAT_O = {24'b0, wrd8b_data_in};
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
      //start <= 'b0;
	  data  <= 'b0;
	  aux_start_write_q <= 1'b0;
    end else begin
      //start <= 'b0;
      aux_start_write_q <= aux_start_write_d;
	  if (WE_I && STB_I) begin
	    case (ADR_I[ADDR_SIZE-1:0])	

	      ADR_WRITE: begin
	        //start <= 'b1;
	        data  <= DAT_I;
	      end				

	      default: begin
	      end
	    endcase
      end
    end
  end

  //assign ena_o = ena;
  assign aux_start_write_d = CYC_I & STB_I & WE_I & (ADR_I == ADR_WRITE);
  assign start_write = aux_start_write_q;

  //========================= CROSSING CLOCK DOMAIN ========================= 

  always_ff @(posedge CLK_NEWFREQ_I, posedge RST_NEWFREQ_I) begin
    if (RST_NEWFREQ_I) begin
      reg_aux1_start  <= 'b0;
      reg_aux2_start  <= 'b0;	
	    start_new_write <= 'b0;
    end else begin
      reg_aux1_start <= start_write;
      reg_aux2_start <= reg_aux1_start;
	    if (reg_aux2_start == 0 && reg_aux1_start == 1) begin
        start_new_write <= 1'b1;
	    end else begin
	      start_new_write <= 1'b0;
	    end
    end
  end

  serializer_in mod_serialin (
    .clk_i(CLK_NEWFREQ_I),
    .rst_i(RST_NEWFREQ_I),
    .start_i(start_new_write),
    .data_i(data),       
    .data_o(data_o),
	//.ena_o(ena),
	  .eot_o(eot)
  );

  always_ff @(posedge CLK_NEWFREQ_I, posedge RST_NEWFREQ_I) begin
	  if(RST_NEWFREQ_I) begin
	    eot_stretch <= 1'b0;
	  end else if (eot) begin
      eot_stretch <= ~eot_stretch;
	  end else begin
	    eot_stretch <= eot_stretch;
	  end
  end

  always_ff @(posedge CLK_I, posedge RST_I) begin
	  if(RST_I) begin
	    eot_aux1 <= 1'b0;
	    eot_aux2 <= 1'b0;
	    eot_aux3 <= 1'b0;
	  end else begin
	    eot_aux1 <= eot_stretch;
	    eot_aux2 <= eot_aux1;
	    eot_aux3 <= eot_aux2;
	  end
  end
  assign eot_new = eot_aux3 ^ eot_aux2;
endmodule
