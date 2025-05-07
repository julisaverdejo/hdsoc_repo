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
    input  logic [26:0] data_i,       
    output logic        data_o
);

  // Internal signals
  logic ena;
  
  // Default values if not sending anything
  localparam logic [7:0] COMMA = 8'h3C;
  localparam logic       KCODE = 1'b1;

  tx_serial mod_tx_serial (
    .clk_i(clk_i),
    .rst_i(rst_i), 
    .data_i(data_q),
    .data_o(data_o),
    .ena_o(ena)
  );
  
  // FSM States
  typedef enum {ST_IDLE, ST_SYNC} state_type_e;

  //Signal declaration
  state_type_e state_reg, state_next;
  logic [8:0]  data_q, data_d;
  logic [1:0]  cnt_q, cnt_d;
  
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      state_reg <= ST_IDLE;
      data_q    <= {KCODE, COMMA};
      cnt_q     <= 'b0;
    end else begin
      state_reg <= state_next;
      data_q    <= data_d;
      cnt_q     <= cnt_d;
    end
  end

  always_comb begin
    state_next = state_reg;
    cnt_d      = cnt_q;
    case (state_reg)
      ST_IDLE: begin
        if (start_i) begin
          if (~ena) begin
            cnt_d = cnt_q + 1;
          end
          state_next = ST_SYNC;
        end
      end

      ST_SYNC: begin
        if (ena) begin
          if (cnt_d == 3) begin
            cnt_d = 0;
            state_next = ST_IDLE;
          end else begin
            cnt_d = cnt_q + 1;
          end
        end           
      end

    endcase    
  end

  // Multiplexor
  always_comb begin
    case(cnt_q)
      2'd0 : data_d = {KCODE, COMMA};
      2'd1 : data_d = data_i[8:0];
      2'd2 : data_d = data_i[17:9];
      2'd3 : data_d = data_i[26:18];
      default : data_d = {KCODE, COMMA};
    endcase
  end

endmodule
