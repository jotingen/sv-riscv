import axi4_pkg::*;

module riscv_top (
   input    axi4_pkg::common        AXI_COMMON,
   input    axi4_pkg::aw_s    [0:0] AXI_AW_S,
   input    axi4_pkg::w_s     [0:0] AXI_W_S,
   input    axi4_pkg::b_s     [0:0] AXI_B_S,
   input    axi4_pkg::ar_s    [1:0] AXI_AR_S,
   input    axi4_pkg::r_s     [1:0] AXI_R_S,

   output   axi4_pkg::aw_m    [0:0] AXI_AW_M,
   output   axi4_pkg::w_m     [0:0] AXI_W_M,
   output   axi4_pkg::b_m     [0:0] AXI_B_M,
   output   axi4_pkg::ar_m    [1:0] AXI_AR_M,
   output   axi4_pkg::r_m     [1:0] AXI_R_M
);

   logic clock;
   logic reset;

   //Extract clock and reset
   assign clock =  AXI_COMMON.ACLK;
   assign reset = ~AXI_COMMON.ARESETn;

   riscv_ifu ifu (
      .clock      (clock),
      .reset      (reset),
      .AXI_AR_S   (AXI_AR_S[1]),
      .AXI_R_S    (AXI_R_S[1]),
      .AXI_AR_M   (AXI_AR_M[1]),
      .AXI_R_M    (AXI_R_M[1])
   );

endmodule: riscv_top