import axi4_pkg::*;

module riscv_top (
   input    axi4_pkg::common AXI_COMMON,

   output   axi4_pkg::aw_m AXI_AW_M
);

   logic clock;
   logic reset;

   //Extract clock and reset
   assign clock =  AXI_COMMON.ACLK;
   assign reset = ~AXI_COMMON.ARESETn;

   riscv_ifu ifu (
      .clock   (clock),
      .reset   (reset),
      .AXI_AW_M(AXI_AW_M)
   );

endmodule: riscv_top