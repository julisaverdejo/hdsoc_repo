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

module serializer_in (
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        start_i,
    input  logic [31:0] data_i,       
    output logic        data_o,
    //output logic        ena_o,
    output logic        eot_o
);

  // Internal signals
  logic ena;
  
  // Default values if not sending anything
  localparam logic [7:0] COMMA = 8'h3C;
  localparam logic       KCODE = 1'b1;
  
  // FSM States
  typedef enum {ST_IDLE, ST_SYNC} state_type_e;

  //Signal declaration
  state_type_e state_reg, state_next;
  logic [8:0]  data_q, data_d;
  logic [2:0]  cnt_pkt_q, cnt_pkt_d;
  logic eot_q, eot_d;

  tx_serial mod_tx_serial (
    .clk_i(clk_i),
    .rst_i(rst_i), 
    .data_i(data_q),
    .data_o(data_o),
    .ena_o(ena)
  );
 
  
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      state_reg <= ST_IDLE;
      data_q    <= {KCODE, COMMA};
      cnt_pkt_q <= 'b0;
      eot_q     <= 'b0;
    end else begin
      state_reg <= state_next;
      data_q    <= data_d;
      cnt_pkt_q <= cnt_pkt_d;
      eot_q     <= eot_d;
    end
  end

  always_comb begin
    state_next = state_reg;
    cnt_pkt_d  = cnt_pkt_q;
    eot_d      = eot_q;
    case (state_reg)
      ST_IDLE: begin
        eot_d = 'b0;
        if (start_i) begin
          // if (ena) begin
          //   cnt_d = cnt_q + 1;
          // end
          state_next = ST_SYNC;
        end
      end

      ST_SYNC: begin
        if (ena) begin
          if (cnt_pkt_d == 4) begin
            eot_d = 'b1;
            cnt_pkt_d = 0;
            state_next = ST_IDLE;
          end else begin
            cnt_pkt_d = cnt_pkt_q + 1;
          end
        end           
      end

    endcase    
  end

  // Multiplexor
  always_comb begin
    case(cnt_pkt_q)
      3'd0 : data_d = {KCODE, COMMA};
      3'd1 : data_d = {1'b0, data_i[7:0]};
      3'd2 : data_d = {1'b0, data_i[15:8]};
      3'd3 : data_d = {1'b0, data_i[23:16]};
      default : data_d = {KCODE, COMMA};
    endcase
  end

  //assign ena_o = ena;
  assign eot_o = eot_q;
endmodule
