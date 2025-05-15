module tx_serial (
    input logic       clk_i,
	input logic       rst_i,
	input logic [8:0] data_i,
	input logic [2:0] dvsr_i,
	output logic      data_o,
	output logic      ena_o
);

  logic [9:0] data_shift_q, data_shift_d;
  logic rdisp_q, rdisp_d;
  
  encode_8b10b encoder_int (
    .datain (data_i),
    .dispin (rdisp_q),
    .dataout(data_shift_d),
    .dispout(rdisp_d)
  );

  // FSM States
  typedef enum {S0, S1} state_type_e;

  //Signal declaration
  state_type_e state_reg, state_next;
  logic [3:0] bit_cnt_q, bit_cnt_d;
  logic [2:0] cnt_pulse_q, cnt_pulse_d;
  //logic [9:0] data_shift_q, data_shift_d;
  logic ena;
  //logic rdisp_q, rdisp_d;
  logic dreg;

  always_ff @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg    <= S0;
      bit_cnt_q    <= 'd0;
      cnt_pulse_q  <= 'd0;
      data_shift_q <= 'd0;
      rdisp_q      <= 'd0;
	  end else begin
      state_reg    <= state_next;
      bit_cnt_q    <= bit_cnt_d;
      cnt_pulse_q  <= cnt_pulse_d;
      if (ena) begin
        data_shift_q <= data_shift_d;
        rdisp_q      <= rdisp_d;
      end
	  end
  end

  always_comb begin
    state_next   = state_reg;
    bit_cnt_d    = bit_cnt_q;
    cnt_pulse_d  = cnt_pulse_q;
    ena          = 'd0;
    case (state_reg)

      S0: begin
        ena = 'd1;
        state_next = S1;
        bit_cnt_d = 'd0;
        cnt_pulse_d = 'd0;
      end

      S1: begin
        if (cnt_pulse_q == dvsr_i) begin
          if (bit_cnt_q == 'd9) begin
            state_next = S0;
            //cnt_pulse_d = 'd0;
            //bit_cnt_d = 'd0;
          end else begin
            bit_cnt_d = bit_cnt_q + 1;
            cnt_pulse_d = 'd0;
          end
        end else begin
          cnt_pulse_d = cnt_pulse_q + 1;
        end
      end

    endcase
  end

  assign dreg = data_shift_q[bit_cnt_q];
  assign data_o = dreg;
  assign ena_o = ena;
 
endmodule