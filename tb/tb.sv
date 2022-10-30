import axi4_pkg::*;

module tb ();
   logic clock;
   logic reset;
   axi4_pkg::aw_m AXI_AW_M;
   logic [31:0] a, b, sum;

   riscv_top DUT(.AXI_COMMON(axi4_pkg::common'{ACLK:clock,ARESETn:~reset}),
                 .*); 

   bind DUT axi4_assert axi4_riscv_assert_inst(.AXI_COMMON(DUT.AXI_COMMON), .AXI_AW_M(DUT.AXI_AW_M), .*);

   always #10 clock =~ clock;

   initial begin
      reset = 1;
      #50
      reset = 0;
   end

   initial begin
      clock = 0;
      reset = 1;
      a = 2;
      b = 3;
      #100;
      assert (sum == 5) else // Unless something went really wrong in the universe, we'd expect that 1+2=3
         $fatal(1, "Well if we cant add 1 and 2 to get 3 then we really screwed something up");
      $display("TB passed, adder ready to use in production");
      $finish;
   end

endmodule : tb