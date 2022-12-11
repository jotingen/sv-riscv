import axi4_pkg::*;

module tb ();
   logic                                                                             clock;
   logic                                                                             reset;
   axi4_pkg::aw_m    [                                                          0:0] AXI_AW_M;
   axi4_pkg::aw_s    [                                                          0:0] AXI_AW_S;
   axi4_pkg::w_m     [                                                          0:0] AXI_W_M;
   axi4_pkg::w_s     [                                                          0:0] AXI_W_S;
   axi4_pkg::b_m     [                                                          0:0] AXI_B_M;
   axi4_pkg::b_s     [                                                          0:0] AXI_B_S;
   axi4_pkg::ar_m    [                                                          1:0] AXI_AR_M;
   axi4_pkg::ar_s    [                                                          1:0] AXI_AR_S;
   axi4_pkg::r_m     [                                                          1:0] AXI_R_M;
   axi4_pkg::r_s     [                                                          1:0] AXI_R_S;

   logic               [riscv_pkg::REGISTER_PORTS-1:0]                               rvfi_valid;
   riscv_pkg::rvfi_t [                                riscv_pkg::REGISTER_PORTS-1:0] rvfi;
   logic               [                         15:0]                               rvfi_errcode;

   `include "instruction.svh"
   `include "memory.svh"
   `include "axi.svh"

   memory mem = new();
   axi_aw_s_driver axi_aw_s_0 = new();
   axi_ar_s_driver axi_ar_s_1 = new();
   axi_ar_s_driver axi_ar_s_0 = new();
   axi_r_s_driver axi_r_s_1 = new();
   axi_r_s_driver axi_r_s_0 = new();
   axi_ar_m_monitor axi_ar_m_1 = new();
   axi_ar_m_monitor axi_ar_m_0 = new();
   always_ff @(posedge clock) begin
      if (!mem.randomize()) $fatal(1, "mem randomization failed");

      if (!axi_aw_s_0.randomize()) $fatal(1, "axi_aw_s randomization failed");
      AXI_AW_S[0].AWREADY <= axi_aw_s_0.ready;
      if (!axi_ar_s_1.randomize()) $fatal(1, "axi_ar_s randomization failed");
      AXI_AR_S[1].ARREADY <= axi_ar_s_1.ready;
      if (!axi_ar_s_0.randomize()) $fatal(1, "axi_ar_s randomization failed");
      AXI_AR_S[0].ARREADY <= axi_ar_s_0.ready;

      axi_ar_m_1.run("1", AXI_AR_S[1], AXI_AR_M[1]);
      axi_ar_m_0.run("0", AXI_AR_S[0], AXI_AR_M[0]);
      axi_r_s_1.run("1", AXI_R_M[1]);
      axi_r_s_0.run("0", AXI_R_M[0]);
      AXI_R_S[1] <= axi_r_s_1.AXI_R_S;
      AXI_R_S[0] <= axi_r_s_0.AXI_R_S;

   end

   riscv_top DUT (
       .AXI_COMMON(axi4_pkg::common'{ACLK: clock, ARESETn: ~reset}),
       .AXI_AW_M  (AXI_AW_M),
       .*
   );

   bind DUT axi4_assert axi4_riscv_assert_inst (
       .AXI_COMMON(DUT.AXI_COMMON),
       .AXI_AW_M('0),
       .AXI_AW_S('0),
       .AXI_W_M('0),
       .AXI_W_S('0),
       .AXI_B_M('0),
       .AXI_B_S('0),
       .AXI_AR_M({DUT.AXI_AR_M[1], {$bits(axi4_pkg::ar_m) {'0}}}),
       .AXI_AR_S({DUT.AXI_AR_S[1], {$bits(axi4_pkg::ar_m) {'0}}}),
       .AXI_R_M({DUT.AXI_R_M[1], {$bits(axi4_pkg::r_s) {'0}}}),
       .AXI_R_S({DUT.AXI_R_S[1], {$bits(axi4_pkg::r_s) {'0}}}),
       .*
   );

   bind DUT.riscv_idu riscv_idu_assert riscv_idu_assert_inst (.*);

   riscv_rvfimon rvfimon (
       .clock,
       .reset,
       .rvfi_valid     ({rvfi_valid[1:0]}),
       .rvfi_order     ({rvfi[1].order, rvfi[0].order}),
       .rvfi_insn      ({rvfi[1].insn, rvfi[0].insn}),
       .rvfi_trap      ({rvfi[1].trap, rvfi[0].trap}),
       .rvfi_halt      ({rvfi[1].halt, rvfi[0].halt}),
       .rvfi_intr      ({rvfi[1].intr, rvfi[0].intr}),
       .rvfi_mode      ({rvfi[1].mode, rvfi[0].mode}),
       .rvfi_rs1_addr  ({rvfi[1].rs1_addr, rvfi[0].rs1_addr}),
       .rvfi_rs2_addr  ({rvfi[1].rs2_addr, rvfi[0].rs2_addr}),
       .rvfi_rs1_rdata ({rvfi[1].rs1_rdata, rvfi[0].rs1_rdata}),
       .rvfi_rs2_rdata ({rvfi[1].rs2_rdata, rvfi[0].rs2_rdata}),
       .rvfi_rd_addr   ({rvfi[1].rd_addr, rvfi[0].rd_addr}),
       .rvfi_rd_wdata  ({rvfi[1].rd_wdata, rvfi[0].rd_wdata}),
       .rvfi_pc_rdata  ({rvfi[1].pc_rdata, rvfi[0].pc_rdata}),
       .rvfi_pc_wdata  ({rvfi[1].pc_wdata, rvfi[0].pc_wdata}),
       .rvfi_mem_addr  ({rvfi[1].mem_addr, rvfi[0].mem_addr}),
       .rvfi_mem_rmask ({rvfi[1].mem_rmask, rvfi[0].mem_rmask}),
       .rvfi_mem_wmask ({rvfi[1].mem_wmask, rvfi[0].mem_wmask}),
       .rvfi_mem_rdata ({rvfi[1].mem_rdata, rvfi[0].mem_rdata}),
       .rvfi_mem_wdata ({rvfi[1].mem_wdata, rvfi[0].mem_wdata}),
       .rvfi_mem_extamo({rvfi[1].mem_extamo, rvfi[0].mem_extamo}),
       .errcode        (rvfi_errcode)
   );

   bind rvfimon riscv_rvfimon_assert riscv_rvfimon_assert_inst (.*);

   always #10 clock = ~clock;

   //initial begin
   //   reset = 1;
   //   #50;
   //   #0 reset = 0;
   //end

   //After each pass, reset memory and restart
   int passes = 100;
   initial begin
      clock = 0;
      for (int pass = 0; pass < passes; pass++) begin
         reset = 1;
         for (int cycle = 0; cycle < 50; cycle++) begin
            mem.reset();
            axi_ar_m_1.reset("1");
            axi_ar_m_0.reset("1");
            #10;
         end
         #10;
         #0 reset = 0;
         #10000;
      end
      $display("TB passed");
      $finish;
   end

endmodule : tb
