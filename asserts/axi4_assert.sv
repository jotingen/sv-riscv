import axi4_pkg::*;
module axi4_assert(
   input    axi4_pkg::common  AXI_COMMON,
   input    axi4_pkg::aw_m    AXI_AW_M
);

   //Wait for reset for most asserts
   logic reset_observed;
   logic enable_assert;

   always_ff @(posedge AXI_COMMON.ACLK) 
      begin

      reset_observed <= reset_observed;

      if( reset_observed === 'x)
         begin
         reset_observed <= '0;
         end

      if( AXI_COMMON.ARESETn === 0)
         begin
         reset_observed <= '1;
         end

      end

   always_comb 
      begin

      enable_assert <= '0;

      if(reset_observed === '1
        && AXI_COMMON.ARESETn === '1)
        enable_assert <= '1;

      end

   //Clock and reset should never be X
   always @* 
      begin

      clock_x_assert:
         assert (AXI_COMMON.ACLK !== 'x)
         else
            $fatal(1,"%m assertion fail");

      reset_x_assert:
         assert (AXI_COMMON.ARESETn !== 'x)
         else
            $fatal(1,"%m assertion fail");

      end


   //AW_M
   always @(posedge AXI_COMMON.ACLK) 
      begin

      aw_m_awvalid_x_assert:
         if(enable_assert)
            assert (AXI_AW_M.AWVALID !== 'x)
            else
               $fatal(1,"%m assertion fail");

      aw_m_x_assert:
         if(enable_assert)
            if(AXI_AW_M.AWVALID)
               assert (^AXI_AW_M !== 'x)
               else
                  $fatal(1,"%m assertion fail");

      end



endmodule