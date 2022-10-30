import axi4_pkg::*;

module riscv_ifu (
   input    logic clock,
   input    logic reset,

   output   axi4_pkg::aw_m AXI_AW_M

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
      AXI_AW_M = AXI_AW_M;
      if(fetch)
         begin
         AXI_AW_M = '0;
         AXI_AW_M.AWVALID = '1;
         AXI_AW_M.AWADDR = PC;
         end
         
      if(reset) 
         begin
         AXI_AW_M.AWVALID = '0;
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
    

endmodule: riscv_ifu