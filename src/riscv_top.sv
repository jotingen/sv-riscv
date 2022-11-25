import axi4_pkg::*;
import riscv_pkg::*;

module riscv_top (
    input axi4_pkg::common       AXI_COMMON,
    input axi4_pkg::aw_s         AXI_AW_S,
    input axi4_pkg::w_s          AXI_W_S,
    input axi4_pkg::b_s          AXI_B_S,
    input axi4_pkg::ar_s   [1:0] AXI_AR_S,
    input axi4_pkg::r_s    [1:0] AXI_R_S,

    output axi4_pkg::aw_m       AXI_AW_M,
    output axi4_pkg::w_m        AXI_W_M,
    output axi4_pkg::b_m        AXI_B_M,
    output axi4_pkg::ar_m [1:0] AXI_AR_M,
    output axi4_pkg::r_m  [1:0] AXI_R_M,

    output logic [riscv_pkg::REGISTER_PORTS-1:0] rvfi_valid,
    output riscv_pkg::rvfi_t [riscv_pkg::REGISTER_PORTS-1:0] rvfi
);

   logic                                                  clock;
   logic                                                  reset;

   logic            [riscv_pkg::REGISTER_PORTS-1:0]       register_lock_en;
   logic            [riscv_pkg::REGISTER_PORTS-1:0][ 4:0] register_lock;

   logic            [riscv_pkg::REGISTER_PORTS-1:0]       register_write_en;
   logic            [riscv_pkg::REGISTER_PORTS-1:0][ 4:0] register_write;
   logic            [riscv_pkg::REGISTER_PORTS-1:0][31:0] register_write_data;

   logic            [                         31:0][31:0] register;
   logic            [                         31:0]       register_locked;

   logic                                                  ifu_vld;
   riscv_pkg::ifu_t                                       ifu;

   logic                                                  idu_vld;
   riscv_pkg::idu_t                                       idu;

   logic                                                  hold;

   //Extract clock and reset
   assign clock = AXI_COMMON.ACLK;
   assign reset = ~AXI_COMMON.ARESETn;

   riscv_reg riscv_reg (
       .clock              (clock),
       .reset              (reset),
       .register_lock_en   (register_lock_en[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_lock      (register_lock[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_write_en  (register_write_en[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_write     (register_write[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_write_data(register_write_data[riscv_pkg::REGISTER_PORTS-1:0]),
       .register           (register[31:0]),
       .register_locked    (register_locked[31:0])
   );

   riscv_ifu riscv_ifu (
       .clock   (clock),
       .reset   (reset),
       .AXI_AR_S(AXI_AR_S[1]),
       .AXI_R_S (AXI_R_S[1]),
       .AXI_AR_M(AXI_AR_M[1]),
       .AXI_R_M (AXI_R_M[1]),
       .ifu_vld (ifu_vld),
       .ifu(ifu)
   );

   riscv_idu riscv_idu (
       .clock   (clock),
       .reset   (reset),
       .ifu_vld (ifu_vld),
       .ifu(ifu),
       .idu_vld (idu_vld),
       .idu(idu)
   );

   riscv_exu riscv_exu (
       .clock(clock),
       .reset(reset),

       .AXI_AW_S(AXI_AW_S),
       .AXI_W_S (AXI_W_S),
       .AXI_B_S (AXI_B_S),
       .AXI_AR_S(AXI_AR_S[0]),
       .AXI_R_S (AXI_R_S[0]),

       .AXI_AW_M(AXI_AW_M),
       .AXI_W_M (AXI_W_M),
       .AXI_B_M (AXI_B_M),
       .AXI_AR_M(AXI_AR_M[0]),
       .AXI_R_M (AXI_R_M[0]),

       .idu_vld(idu_vld),
       .idu(idu),

       .register_lock_en(register_lock_en[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_lock   (register_lock[riscv_pkg::REGISTER_PORTS-1:0]),

       .register(register[31:0]),
       .register_locked(register_locked),

       .register_write_en  (register_write_en[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_write     (register_write[riscv_pkg::REGISTER_PORTS-1:0]),
       .register_write_data(register_write_data[riscv_pkg::REGISTER_PORTS-1:0]),

       .hold(hold),

       .rvfi_valid(rvfi_valid[riscv_pkg::REGISTER_PORTS-1:0]),
       .rvfi      (rvfi[riscv_pkg::REGISTER_PORTS-1:0])
   );

endmodule : riscv_top
