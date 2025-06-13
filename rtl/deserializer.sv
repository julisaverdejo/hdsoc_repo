module deserializer #(
  parameter WIDTH = 10
) (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        inputdata_i,
    output logic [8:0]  outputdata_o,
    // output logic        code_err_o,
    // output logic        disp_err_o,
    output logic        eob_o,
    output logic        err_o
);

  //Internal signals
  logic coderr_d, disperr_d;
 
  //Signal declaration
  logic [WIDTH-1:0] shift_reg_q;
  logic [3:0] cnt_bits;  
  logic eob;
  logic rdisp_q, rdisp_d;
  logic coderr_q;
  logic disperr_q;
  logic [9:0] data_q;
  logic delay;

  decode_8b10b encoder_int (
    .datain(data_q), 
    .dispin(rdisp_q), 
    .dataout(outputdata_o), 
    .dispout(rdisp_d), 
    .code_err(coderr_d), 
    .disp_err(disperr_d)
  );
  
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin 
      shift_reg_q <= 10'd0;
      cnt_bits    <= 4'd0;
    end else begin 
      shift_reg_q <= {shift_reg_q[WIDTH-2:0], inputdata_i};
      if (eob) begin 
        cnt_bits  <= 'b0;
      end else begin 
        cnt_bits  <= cnt_bits + 1;
      end
    end
  end

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      delay <= 1'b0;
    end else begin 
      delay <= eob;
    end
  end

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      data_q    <= 10'b1001_111100; // K28.1 RD-
      rdisp_q   <= 1'b0;
      coderr_q  <= 1'b0;
      disperr_q <= 1'b0;
    end else begin 
      if (delay) begin
        data_q    <= shift_reg_q;
        rdisp_q   <= rdisp_d;
        coderr_q  <= coderr_d;
        disperr_q <= disperr_d;      
      end

    end
  end

  assign eob = (cnt_bits == 'd9);
  assign eob_o = delay;
  // assign code_err_o = coderr_q;
  // assign disp_err_o = disperr_q;
  assign 

endmodule
