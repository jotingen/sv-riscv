import axi4_pkg::*;

module tb ();
   logic                clock;
   logic                reset;
   axi4_pkg::aw_m [0:0] AXI_AW_M;
   axi4_pkg::aw_s [0:0] AXI_AW_S;
   axi4_pkg::w_m  [0:0] AXI_W_M;
   axi4_pkg::w_s  [0:0] AXI_W_S;
   axi4_pkg::b_m  [0:0] AXI_B_M;
   axi4_pkg::b_s  [0:0] AXI_B_S;
   axi4_pkg::ar_m [1:0] AXI_AR_M;
   axi4_pkg::ar_s [1:0] AXI_AR_S;
   axi4_pkg::r_m  [1:0] AXI_R_M;
   axi4_pkg::r_s  [1:0] AXI_R_S;

   class axi_aw_s_driver;
      rand logic ready;

      constraint c_ready { ready dist {0:=5,1:=95};}
   endclass

   class axi_ar_s_driver;
      rand logic ready;

      constraint c_ready { ready dist {0:=5,1:=95};}
   endclass

   axi_aw_s_driver axi_aw_s_0 = new();
   axi_ar_s_driver axi_ar_s_1 = new();
   axi_ar_s_driver axi_ar_s_0 = new();
   always_ff @(posedge clock)
      begin
      if(!axi_aw_s_0.randomize()) $fatal(1,"axi_aw_s randomization failed");
      AXI_AW_S[0].AWREADY <= axi_aw_s_0.ready;
      if(!axi_ar_s_1.randomize()) $fatal(1,"axi_ar_s randomization failed");
      AXI_AR_S[1].ARREADY <= axi_ar_s_1.ready;
      if(!axi_ar_s_0.randomize()) $fatal(1,"axi_ar_s randomization failed");
      AXI_AR_S[0].ARREADY <= axi_ar_s_0.ready;
      end

   riscv_top DUT(
      .AXI_COMMON(axi4_pkg::common'{ACLK:clock,ARESETn:~reset}),
      .AXI_AW_M(AXI_AW_M), 
      .*); 

   bind DUT axi4_assert axi4_riscv_assert_inst(
      .AXI_COMMON(DUT.AXI_COMMON), 
      .AXI_AW_M('0), 
      .AXI_AW_S('0),
      .AXI_W_M('0),
      .AXI_W_S('0),
      .AXI_B_M('0),
      .AXI_B_S('0),
      .AXI_AR_M({DUT.AXI_AR_M[1],'0}),
      .AXI_AR_S({DUT.AXI_AR_M[1],'0}),
      .AXI_R_M({DUT.AXI_AR_M[1],'0}),
      .AXI_R_S({DUT.AXI_AR_S[1],'0}),
      .*);

   always #10 clock =~ clock;

   initial begin
      reset = 1;
      #50;
      #0
      reset = 0;
   end

   initial begin
      clock = 0;
      reset = 1;
      #1000;
      //assert (sum == 5) else // Unless something went really wrong in the universe, we'd expect that 1+2=3
      //   $fatal(1, "Well if we cant add 1 and 2 to get 3 then we really screwed something up");
      $display("TB passed");
      $finish;
   end

endmodule : tb