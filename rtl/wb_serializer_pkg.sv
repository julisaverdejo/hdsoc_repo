`ifndef WB_Serializer_PKG
`define WB_Serializer_PKG

package WBSerializer;

typedef enum logic [15:0] {
	ADR_WRITE = 0,	
	ADR_READ  = 1,
	NUM_REGS  = 2
} serRegMap_t;

endpackage

`endif
