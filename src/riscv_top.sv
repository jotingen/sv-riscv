import axi4_pkg::*;

module riscv_top (
   input    axi4_pkg::common AXI_COMMON,

   output   axi4_pkg::aw_m AXI_AW_M,

   input    logic [31:0] a,
   input    logic [31:0] b,
   output   logic [31:0] sum
);

   logic clock;
   logic reset;

   //Extract clock and reset
   assign clock =  AXI_COMMON.ACLK;
   assign reset = ~AXI_COMMON.ARESETn;

   always_comb begin
      sum = a + b;
   end

   always_ff@(posedge clock) begin
      AXI_AW_M = AXI_AW_M;
      if(reset) begin
         AXI_AW_M.AWVALID = '0;
      end
   end

endmodule: riscv_top