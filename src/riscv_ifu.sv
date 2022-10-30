import axi4_pkg::*;

module riscv_ifu (
   input    logic             clock,
   input    logic             reset,

   input    axi4_pkg::ar_s    AXI_AR_S,
   input    axi4_pkg::r_s     AXI_R_S,

   output   axi4_pkg::ar_m    AXI_AR_M,
   output   axi4_pkg::r_m     AXI_R_M

);

   logic [31:0] PC;

   logic fetch;

   //Determine if we should fetch
   always_comb
      begin
      fetch = '1;
      end

   //Generate Request
   always_ff@(posedge clock) begin
      AXI_AR_M = AXI_AR_M;
      if(fetch)
         begin
         AXI_AR_M = '0;
         AXI_AR_M.ARVALID = '1;
         AXI_AR_M.ARADDR = PC;
         end
         
      if(reset) 
         begin
         AXI_AR_M.ARVALID = '0;
         end
   end

   //Update PC for next fetch
   always_ff @(posedge clock)
      begin
      PC[31:0] = PC[31:0]; 

      if(fetch)
         begin
         PC[31:0] = PC[31:0] + 'd4;
         end

      if(reset)
         begin
         PC[31:0] = 'h200;
         end
      end

   //Recieve Response
   assign AXI_R_M.RREADY = '1;
    

endmodule: riscv_ifu