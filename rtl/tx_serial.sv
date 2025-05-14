module tx_serial (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic [8:0]  data_i,
    output logic        data_o,
    output logic        ena_o
);
  
  logic ena;
  logic rdisp_q, rdisp_d;
  logic [3:0] cnt_q;  
  logic tick;
  logic dreg;
  logic [9:0] shift_reg_q, shift_reg_d;
  
  encode_8b10b encoder_int (
    .datain (data_i),
    .dispin (rdisp_q),
    .dataout(shift_reg_d),
    .dispout(rdisp_d)
  );

/*  
  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      tick <= 'b0;
    end else begin
      tick <= tick + 1;
    end
  end
*/

  always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin 
      rdisp_q <= 'd0;
      shift_reg_q <= 'd0;
      cnt_q <= 'd9;
      ena <= 1'b1;
      tick <= 'b0;
    end else begin 
      if (ena) begin 
        rdisp_q <= rdisp_d;
        shift_reg_q <= shift_reg_d;
        cnt_q <= 'b0;
        ena <= 'b0;
      end else begin
        tick <= tick + 1;
        if (tick) begin
          if (cnt_q == 9) begin
            ena <= 1'b1;
          end else begin
            shift_reg_q <= shift_reg_q >> 1;
            cnt_q <= cnt_q + 1;
          end
        end 
      end
    end
  end
  
  //assign ena = (cnt_q == 'd9);
  assign data_o = shift_reg_q[0];
  assign ena_o = ena;
  
endmodule
