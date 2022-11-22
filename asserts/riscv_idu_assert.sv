import riscv_pkg::*;
module riscv_idu_assert (
    input logic clock,
    input logic reset,

    input logic        ifu_vld,
    input logic [31:0] ifu_addr,
    input logic [31:0] ifu_data,

    input logic        idu_vld,
    input logic [63:0] idu_seq,
    input logic [31:0] idu_addr,
    input logic [31:0] idu_data,
    input logic        idu_defined
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


   //Output
   idu_x_assert :
   assert property (
         @(posedge clock) 
            if(enable_assert) 
               if(idu_vld)
                  ^{idu_seq,
                    idu_addr,
                    idu_data,
                    idu_defined} !== 'x
      )
   else $fatal(1, "%m assertion fail");

   //Temporary, always defined
   idu_defined_assert :
   assert property (@(posedge clock) if (enable_assert) if (idu_vld) idu_defined == '1)
   else $fatal(1, "%m assertion fail");



endmodule
