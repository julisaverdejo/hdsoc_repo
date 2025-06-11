module deserializer #(
  parameter WIDTH = 10
) (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        inputdata_i,
    output logic [8:0]  outputdata_o,
    output logic        code_err_o,
    output logic        disp_err_o,
    output logic        eob_o
);

  //Internal signals
  logic coderr_d, disperr_d;
 
  //Signal declaration
  logic [WIDTH-1:0] shift_reg_q, shift_reg_d, shift_reg, data;
  logic [3:0] cnt_bits;  
  logic eob;
  logic rdisp_q, rdisp_d;
  logic coderr_q;
  logic disperr_q;

  decode_8b10b encoder_int (
    .datain(10'hae), 
    .dispin(rdisp_q), 
    .dataout(outputdata_o), 
    .dispout(rdisp_d), 
    .code_err(coderr_d), 
    .disp_err(disperr_d)
  );
  

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin 
      rdisp_q     <= 1'b0;
      shift_reg_q <= 10'd0;
      shift_reg   <= 10'h27c;
      cnt_bits    <= 'd0;
      coderr_q    <= 1'b0;
      disperr_q   <= 1'b0;
    end else begin 
      if (eob) begin 
        rdisp_q   <= rdisp_d;
        shift_reg_q <= shift_reg_q;
        shift_reg   <= shift_reg_q;
        cnt_bits  <= 'b0;
        coderr_q  <= coderr_d;
        disperr_q <= disperr_d;
      end else begin 
        shift_reg   <= shift_reg;
        shift_reg_q <= {shift_reg_q[WIDTH-2:0], inputdata_i};
        cnt_bits  <= cnt_bits + 1;
      end
    end
  end

  assign eob = (cnt_bits == 'd11);
  assign eob_o = eob;
  assign data = eob ? shift_reg_q: shift_reg;
  assign code_err_o = coderr_q;
  assign disp_err_o = disperr_q;

endmodule
