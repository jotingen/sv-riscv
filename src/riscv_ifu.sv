import axi4_pkg::*;

module riscv_ifu (
   input    logic             clock,
   input    logic             reset,

   input    axi4_pkg::ar_s    AXI_AR_S,
   input    axi4_pkg::r_s     AXI_R_S,

   output   axi4_pkg::ar_m    AXI_AR_M,
   output   axi4_pkg::r_m     AXI_R_M

);

   logic          req_ack;
   logic [31:0]   PC;

   riscv_axi_driver axi_driver (
      .clock      (clock),
      .reset      (reset),

      .req_vld  ('1),
      .req_rnw  ('1),
      .req_addr (PC),
      .req_data ('x),

      .req_ack  (req_ack),

      .rsp_vld  (),
      .rsp_data (),

      .AXI_AW_S ('0),
      .AXI_W_S  ('0),
      .AXI_B_S  ('0),
      .AXI_AR_S (AXI_AR_S),
      .AXI_R_S  (AXI_R_S),

      .AXI_AW_M (),
      .AXI_W_M  (),
      .AXI_B_M  (),
      .AXI_AR_M (AXI_AR_M),
      .AXI_R_M  (AXI_R_M)
   );

   //Update PC for next fetch
   always_ff @(posedge clock)
      begin
      PC[31:0] = PC[31:0]; 

      if(req_ack)
         begin
         PC[31:0] = PC[31:0] + 'd4;
         end

      if(reset)
         begin
         PC[31:0] = 'h200;
         end
      end

   //Recieve Response
   //assign AXI_R_M.RREADY = '1;
    

endmodule: riscv_ifu