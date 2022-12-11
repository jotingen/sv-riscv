import riscv_pkg::*;

module riscv_csr (
    input logic clock,
    input logic reset,

    output riscv_pkg::csr_t csr
);

   always_ff @(posedge clock) begin

      csr <= csr;

      if (reset) begin
         csr <= '0;
         csr.mtvec.base[31:2] <= '0;
         csr.mtvec.mode[1:0] <= '0;
      end

   end


endmodule : riscv_csr
