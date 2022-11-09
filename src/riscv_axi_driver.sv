import axi4_pkg::*;

module riscv_axi_driver (
   input    logic             clock,
   input    logic             reset,

   input    logic             req_vld,
   input    logic             req_rnw,
   input    logic [31:0]      req_addr,
   input    logic [31:0]      req_data,

   output   logic             req_ack,

   output   logic             rsp_vld,
   output   logic [31:0]      rsp_data,

   input    axi4_pkg::aw_s    AXI_AW_S,
   input    axi4_pkg::w_s     AXI_W_S,
   input    axi4_pkg::b_s     AXI_B_S,
   input    axi4_pkg::ar_s    AXI_AR_S,
   input    axi4_pkg::r_s     AXI_R_S,

   output   axi4_pkg::aw_m    AXI_AW_M,
   output   axi4_pkg::w_m     AXI_W_M,
   output   axi4_pkg::b_m     AXI_B_M,
   output   axi4_pkg::ar_m    AXI_AR_M,
   output   axi4_pkg::r_m     AXI_R_M

);

typedef struct packed {
   logic        req_vld;
   logic        req_rnw;
   logic        rsp_vld;
   logic [31:0] rsp_data;
} pending_entry;
pending_entry [2**(3+1)-1:0] pending;
logic [3:0] pending_wr_ptr;
logic [3:0] pending_rd_ptr;

//Determine if we can accept new request
always_comb
   begin
   req_ack = '0;
   if( (pending_wr_ptr + 'd1)%16 != pending_rd_ptr )
      begin
      //Read
      if(   req_rnw
        &   AXI_AR_S.ARREADY )
         begin
         req_ack = '1;
         end
      //Write
      if(   req_rnw
        &   AXI_AW_S.AWREADY )
         begin
         req_ack = '1;
         end
      end
   end

always_ff @(posedge clock)
   begin
   pending        = pending;
   pending_wr_ptr = pending_wr_ptr;
   pending_rd_ptr = pending_rd_ptr;


   AXI_AR_M = AXI_AR_M;
   AXI_AW_M = AXI_AW_M;

   AXI_AR_M.ARVALID = '0;
   AXI_AW_M.AWVALID = '0;

   if( req_vld )
      begin
      //Check if pending fifo is not full
      //  and subordinate is ready
      if( (pending_wr_ptr + 'd1)%16 != pending_rd_ptr )
         begin
         //Read
         if(   req_rnw
           &   AXI_AR_S.ARREADY )
            begin
            pending[pending_wr_ptr].req_vld = '1;
            pending[pending_wr_ptr].req_rnw = '1;
            pending_wr_ptr = pending_wr_ptr + 'd1;

            AXI_AR_M = '0;
            AXI_AR_M.ARVALID = '1;
            AXI_AR_M.ARID = pending_wr_ptr + 'd1;
            AXI_AR_M.ARADDR = req_addr;
            end
         //Write
         if(   req_rnw
           &   AXI_AW_S.AWREADY )
            begin
            pending[pending_wr_ptr].req_vld = '1;
            pending[pending_wr_ptr].req_rnw = '0;
            pending_wr_ptr = pending_wr_ptr + 'd1;

            AXI_AW_M = '0;
            AXI_AW_M.AWVALID = '1;
            AXI_AW_M.AWID = pending_wr_ptr + 'd1;
            AXI_AW_M.AWADDR = req_addr;
            end
         end
      end


   if( reset )
      begin
      pending        = '0;
      pending_wr_ptr = '0;
      pending_rd_ptr = '0;
      AXI_AR_M.ARVALID = '0;
      AXI_AW_M.AWVALID = '0;
      end
   
   end

endmodule: riscv_axi_driver