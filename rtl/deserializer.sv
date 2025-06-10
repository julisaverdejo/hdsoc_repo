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
  logic coderr, disperr;
 
  //Signal declaration
  logic [WIDTH-1:0] shift_reg_q, shift_reg_d;
  logic [3:0] cnt_bits;  
  logic eob;
  logic rdisp_q, rdisp_d;
  logic coderr_q;
  logic disperr_q;

  decode_8b10b encoder_int (
    .datain(shift_reg_q), 
    .dispin(rdisp_q), 
    .dataout(outputdata_o), 
    .dispout(rdisp_d), 
    .code_err(coderr), 
    .disp_err(disperr)
  );
  

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin 
      rdisp_q     <= 'd0;
      shift_reg_q <= 'd0;
      shift_reg_d <= 'd0;
      cnt_bits    <= 'd9;
      coderr_q    <= 'b0;
      disperr_q   <= 'b0;
    end else begin 
      if (eob) begin 
        rdisp_q   <= rdisp_d;
        shift_reg_q <= shift_reg_d;
        cnt_bits  <= 'b0;
        coderr_q  <= coderr;
        disperr_q <= disperr;
      end else begin 
        shift_reg_d <= {shift_reg_d[WIDTH-2:0], inputdata_i};
        cnt_bits  <= cnt_bits + 1;
      end
    end
  end

  assign eob = (cnt_bits == 'd9);
  assign eob_o = eob;
  assign code_err_o = coderr_q;
  assign disp_err_o = disperr_q;

endmodule
