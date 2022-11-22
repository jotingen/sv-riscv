import axi4_pkg::*;
module axi4_assert (
    input axi4_pkg::common AXI_COMMON,
    input axi4_pkg::aw_m   AXI_AW_M,
    input axi4_pkg::aw_s   AXI_AW_S,
    input axi4_pkg::w_m    AXI_W_M,
    input axi4_pkg::w_s    AXI_W_S,
    input axi4_pkg::b_m    AXI_B_M,
    input axi4_pkg::b_s    AXI_B_S,
    input axi4_pkg::ar_m   AXI_AR_M,
    input axi4_pkg::ar_s   AXI_AR_S,
    input axi4_pkg::r_m    AXI_R_M,
    input axi4_pkg::r_s    AXI_R_S
);

   //Wait for reset for most asserts
   logic reset_observed;
   logic enable_assert;

   always_ff @(posedge AXI_COMMON.ACLK) begin

      reset_observed <= reset_observed;

      if (reset_observed === 'x) begin
         reset_observed <= '0;
      end

      if (AXI_COMMON.ARESETn === 0) begin
         reset_observed <= '1;
      end

   end

   always_comb begin

      enable_assert <= '0;

      if (reset_observed === '1 && AXI_COMMON.ARESETn === '1) enable_assert <= '1;

   end

   //Clock and reset should never be X
   always @* begin

      clock_x_assert :
      assert (AXI_COMMON.ACLK !== 'x)
      else $fatal(1, "%m assertion fail");

      reset_x_assert :
      assert (AXI_COMMON.ARESETn !== 'x)
      else $fatal(1, "%m assertion fail");

   end


   //AW
   aw_m_awvalid_reset_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if ($past(
       AXI_COMMON.ARESETn, 1
   ) === 0) AXI_AW_M.AWVALID !== '1)
   else $fatal(1, "%m assertion fail");

   aw_m_awvalid_x_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) AXI_AW_M.AWVALID !== 'x)
   else $fatal(1, "%m assertion fail");

   aw_m_awvalid_stays_on_if_no_ready_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) if ($past(
       AXI_AW_M.AWVALID, 1
   ) & ~$past(
       AXI_AW_S.AWREADY, 1
   )) AXI_AW_M.AWVALID)
   else $fatal(1, "%m assertion fail");

   aw_m_x_assert :
   assert property (
         @(posedge AXI_COMMON.ACLK) 
            if(enable_assert) 
               if(AXI_AW_M.AWVALID)
                  ^AXI_AW_M !== 'x
      )
   else $fatal(1, "%m assertion fail");


   //W
   w_m_wvalid_reset_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if ($past(
       AXI_COMMON.ARESETn, 1
   ) === 0) AXI_W_M.WVALID !== '1)
   else $fatal(1, "%m assertion fail");

   w_m_wvalid_x_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) AXI_W_M.WVALID !== 'x)
   else $fatal(1, "%m assertion fail");

   w_m_wvalid_stays_on_if_no_ready_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) if ($past(
       AXI_W_M.WVALID, 1
   ) & ~$past(
       AXI_W_S.WREADY, 1
   )) AXI_W_M.WVALID)
   else $fatal(1, "%m assertion fail");

   w_m_x_assert :
   assert property (
         @(posedge AXI_COMMON.ACLK) 
            if(enable_assert) 
               if(AXI_W_M.WVALID)
                  ^AXI_W_M !== 'x
      )
   else $fatal(1, "%m assertion fail");


   //B
   b_s_bvalid_reset_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if ($past(
       AXI_COMMON.ARESETn, 1
   ) === 0) AXI_B_S.BVALID !== '1)
   else $fatal(1, "%m assertion fail");

   b_s_bvalid_x_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) AXI_B_S.BVALID !== 'x)
   else $fatal(1, "%m assertion fail");

   b_s_bvalid_stays_on_if_no_ready_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) if ($past(
       AXI_B_S.BVALID, 1
   ) & ~$past(
       AXI_B_M.BREADY, 1
   )) AXI_B_S.BVALID)
   else $fatal(1, "%m assertion fail");

   b_s_x_assert :
   assert property (
         @(posedge AXI_COMMON.ACLK) 
            if(enable_assert) 
               if(AXI_B_S.BVALID)
                  ^AXI_B_S !== 'x
      )
   else $fatal(1, "%m assertion fail");


   //AR
   ar_m_arvalid_reset_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if ($past(
       AXI_COMMON.ARESETn, 1
   ) === 0) AXI_AR_M.ARVALID !== '1)
   else $fatal(1, "%m assertion fail");

   ar_m_arvalid_x_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) AXI_AR_M.ARVALID !== 'x)
   else $fatal(1, "%m assertion fail");

   ar_m_arvalid_stays_on_if_no_ready_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) if ($past(
       AXI_AR_M.ARVALID, 1
   ) & ~$past(
       AXI_AR_S.ARREADY, 1
   )) AXI_AR_M.ARVALID)
   else $fatal(1, "%m assertion fail");

   ar_m_x_assert :
   assert property (
         @(posedge AXI_COMMON.ACLK) 
            if(enable_assert) 
               if(AXI_AR_M.ARVALID)
                  ^AXI_AR_M !== 'x
      )
   else $fatal(1, "%m assertion fail");


   //R
   r_s_rvalid_reset_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if ($past(
       AXI_COMMON.ARESETn, 1
   ) === 0) AXI_R_S.RVALID !== '1)
   else $fatal(1, "%m assertion fail");

   r_s_rvalid_x_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) AXI_R_S.RVALID !== 'x)
   else $fatal(1, "%m assertion fail");

   r_s_rvalid_stays_on_if_no_ready_assert :
   assert property (@(posedge AXI_COMMON.ACLK) if (enable_assert) if ($past(
       AXI_R_S.RVALID, 1
   ) & ~$past(
       AXI_R_M.RREADY, 1
   )) AXI_R_S.RVALID)
   else $fatal(1, "%m assertion fail");

   r_s_x_assert :
   assert property (
         @(posedge AXI_COMMON.ACLK) 
            if(enable_assert) 
               if(AXI_R_S.RVALID)
                  ^AXI_R_S !== 'x
      )
   else $fatal(1, "%m assertion fail");



endmodule
