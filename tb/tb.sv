import axi4_pkg::*;

module tb ();
   logic             clock;
   logic             reset;
   axi4_pkg::aw_m    AXI_AW_M;
   axi4_pkg::aw_s    AXI_AW_S;
   axi4_pkg::w_m     AXI_W_M;
   axi4_pkg::w_s     AXI_W_S;
   axi4_pkg::b_m     AXI_B_M;
   axi4_pkg::b_s     AXI_B_S;
   axi4_pkg::ar_m    AXI_AR_M;
   axi4_pkg::ar_s    AXI_AR_S;
   axi4_pkg::r_m     AXI_R_M;
   axi4_pkg::r_s     AXI_R_S;

   riscv_top DUT(
      .AXI_COMMON(axi4_pkg::common'{ACLK:clock,ARESETn:~reset}),
      .AXI_AW_M(AXI_AW_M), 
      .*); 

   bind DUT axi4_assert axi4_riscv_assert_inst(
      .AXI_COMMON(DUT.AXI_COMMON), 
      .AXI_AW_M(DUT.AXI_AW_M), 
      .AXI_AW_S('0),
      .AXI_W_M('0),
      .AXI_W_S('0),
      .AXI_B_M('0),
      .AXI_B_S('0),
      .AXI_AR_M('0),
      .AXI_AR_S('0),
      .AXI_R_M('0),
      .AXI_R_S('0),
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