module tx_serial (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [8:0]  data_i,
    output logic        data_o,
    output logic        ena_o
);
  localparam dvsr = 1;
  logic ena;
  logic rdisp_q, rdisp_d;
  logic [3:0] cnt_bits;  // bit counter
  logic cnt_ticks;      // clk cycle counter
  logic [9:0] shift_reg_q, shift_reg_d;
  
  encode_8b10b encoder_int (
    .datain (data_i),
    .dispin (rdisp_q),
    .dataout(shift_reg_d),
    .dispout(rdisp_d)
  );

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin 
      rdisp_q <= 'd0;
      shift_reg_q <= 'd0;
      cnt_bits <= 'd9;
      cnt_ticks <= dvsr;
    end else begin 
      if (ena) begin 
        rdisp_q <= rdisp_d;
        shift_reg_q <= shift_reg_d;
        cnt_bits <= 'b0;
        cnt_ticks <= 'b0;
      end else begin 
        if (cnt_ticks == dvsr) begin
          shift_reg_q <= shift_reg_q >> 1;
          cnt_bits <= cnt_bits + 1;
          cnt_ticks <= 'b0;
        end else begin
          cnt_ticks <= cnt_ticks + 1;
        end
      end
    end
  end

  assign ena = (cnt_bits == 'd9 && cnt_ticks == dvsr);
  assign data_o = shift_reg_q[0];
  assign ena_o = ena;
  
endmodule
