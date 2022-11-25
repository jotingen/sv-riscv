module riscv_rvfimon_assert (
    input logic clock,
    input logic reset,

    input reg [15:0] errcode
);

   //Wait for reset for most asserts
   logic reset_observed;
   logic enable_assert;

   always_ff @(posedge clock) begin

      reset_observed <= reset_observed;

      if (reset_observed === 'x) begin
         reset_observed <= '0;
      end

      if (reset === '1) begin
         reset_observed <= '1;
      end

   end

   always_comb begin

      enable_assert <= '0;

      if (reset_observed === '1 && reset === '0) enable_assert <= '1;

   end

   //Clock and reset should never be X
   always @* begin

      clock_x_assert :
      assert (clock !== 'x)
      else $fatal(1, "%m assertion fail");

      reset_x_assert :
      assert (reset !== 'x)
      else $fatal(1, "%m assertion fail");

   end

   //Should not get errors
   rvfimon_errcode_assert :
   assert property (@(posedge clock) if (enable_assert) errcode == '0)
   else $fatal(1, "%m assertion fail");



endmodule
