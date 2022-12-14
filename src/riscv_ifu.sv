import axi4_pkg::*;
import riscv_pkg::*;

module riscv_ifu (
    input logic clock,
    input logic reset,

    input axi4_pkg::ar_s AXI_AR_S,
    input axi4_pkg::r_s  AXI_R_S,

    output axi4_pkg::ar_m AXI_AR_M,
    output axi4_pkg::r_m  AXI_R_M,

    input logic flush,
    input logic [31:0] flush_addr,

    output logic            ifu_vld,
    output riscv_pkg::ifu_t ifu

);

   logic [ 2:0]       buffer_vld;
   logic [ 2:0]       buffer_vld_next;
   logic [ 2:0][31:0] buffer_addr;
   logic [ 2:0][31:0] buffer_addr_next;
   logic [ 2:0][15:0] buffer_data;
   logic [ 2:0][15:0] buffer_data_next;

   logic              buffer_is_compressed;

   logic              req_ack;

   logic              rsp_vld;
   logic [31:0]       rsp_addr;
   logic [31:0]       rsp_data;
   logic              rsp_ack;
   logic [31:0]       PC;

   riscv_axi_driver axi_driver (
       .clock(clock),
       .reset(reset),

       .req_vld ('1),
       .req_rnw ('1),
       .req_addr(PC),
       .req_data('x),

       .flush(flush),

       .req_ack(req_ack),

       .rsp_vld (rsp_vld),
       .rsp_addr(rsp_addr),
       .rsp_data(rsp_data),

       .rsp_ack(rsp_ack),

       .AXI_AW_S('0),
       .AXI_W_S ('0),
       .AXI_B_S ('0),
       .AXI_AR_S(AXI_AR_S),
       .AXI_R_S (AXI_R_S),

       .AXI_AW_M(),
       .AXI_W_M (),
       .AXI_B_M (),
       .AXI_AR_M(AXI_AR_M),
       .AXI_R_M (AXI_R_M)
   );

   //Update PC for next fetch
   always_ff @(posedge clock) begin
      PC[31:0] = PC[31:0];

      if (req_ack) begin
         PC[31:0] = PC[31:0] + 'd4;
      end

      if (flush) begin
         PC[31:0] = flush_addr[31:0];
      end

      if (reset) begin
         PC[31:0] = 'h200;
      end
   end

   //Buffer

   // Flag if bottom of buffer is compressed instruction
   always_comb begin

      buffer_is_compressed = buffer_data[0][1:0] != 2'b11;

      unique case ({
         rsp_vld, buffer_is_compressed, buffer_vld[2:0]
      }) inside
         5'b0_?_??0: begin
            ifu_vld = '0;
            ifu.addr = 'x;
            ifu.data = 'x;
            rsp_ack = '0;
            buffer_vld_next = '0;
            buffer_addr_next = 'x;
            buffer_data_next = 'x;
         end
         5'b1_?_??0: begin
            ifu_vld = '0;
            ifu.addr = 'x;
            ifu.data = 'x;
            rsp_ack = '1;
            buffer_vld_next[0] = rsp_vld;
            buffer_addr_next[0] = rsp_addr;
            buffer_data_next[0] = rsp_data[15:0];
            buffer_vld_next[1] = rsp_vld;
            buffer_addr_next[1] = rsp_addr + 'd2;
            buffer_data_next[1] = rsp_data[31:16];
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end

         5'b0_0_?01: begin
            ifu_vld = '0;
            ifu.addr = 'x;
            ifu.data = 'x;
            rsp_ack = '0;
            buffer_vld_next[0] = buffer_vld[0];
            buffer_addr_next[0] = buffer_addr[0];
            buffer_data_next[0] = buffer_data[0][15:0];
            buffer_vld_next[1] = '0;
            buffer_addr_next[1] = 'x;
            buffer_data_next[1] = 'x;
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end
         5'b0_1_?01: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {16'd0, buffer_data[0]};
            rsp_ack = '0;
            buffer_vld_next = '0;
            buffer_addr_next = 'x;
            buffer_data_next = 'x;
         end
         5'b1_0_?01: begin
            ifu_vld = '0;
            ifu.addr = 'x;
            ifu.data = 'x;
            rsp_ack = '1;
            buffer_vld_next[0] = buffer_vld[0];
            buffer_addr_next[0] = buffer_addr[0];
            buffer_data_next[0] = buffer_data[0][15:0];
            buffer_vld_next[1] = rsp_vld;
            buffer_addr_next[1] = rsp_addr;
            buffer_data_next[1] = rsp_data[15:0];
            buffer_vld_next[2] = rsp_vld;
            buffer_addr_next[2] = rsp_addr + 'd2;
            buffer_data_next[2] = rsp_data[31:16];
         end
         5'b1_1_?01: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {16'd0, buffer_data[0]};
            rsp_ack = '1;
            buffer_vld_next[0] = rsp_vld;
            buffer_addr_next[0] = rsp_addr;
            buffer_data_next[0] = rsp_data[15:0];
            buffer_vld_next[1] = rsp_vld;
            buffer_addr_next[1] = rsp_addr + 'd2;
            buffer_data_next[1] = rsp_data[31:16];
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end

         5'b0_0_011: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {buffer_data[1], buffer_data[0]};
            rsp_ack = '0;
            buffer_vld_next = '0;
            buffer_addr_next = 'x;
            buffer_data_next = 'x;
         end
         5'b0_1_011: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {16'd0, buffer_data[0]};
            rsp_ack = '0;
            buffer_vld_next[0] = buffer_vld[1];
            buffer_addr_next[0] = buffer_addr[1];
            buffer_data_next[0] = buffer_data[1][15:0];
            buffer_vld_next[1] = '0;
            buffer_addr_next[1] = 'x;
            buffer_data_next[1] = 'x;
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end
         5'b1_0_011: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {buffer_data[1], buffer_data[0]};
            rsp_ack = '1;
            buffer_vld_next[0] = rsp_vld;
            buffer_addr_next[0] = rsp_addr;
            buffer_data_next[0] = rsp_data[15:0];
            buffer_vld_next[1] = rsp_vld;
            buffer_addr_next[1] = rsp_addr + 'd2;
            buffer_data_next[1] = rsp_data[31:16];
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end
         5'b1_1_011: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {16'd0, buffer_data[0]};
            rsp_ack = '1;
            buffer_vld_next[0] = buffer_vld[1];
            buffer_addr_next[0] = buffer_addr[1];
            buffer_data_next[0] = buffer_data[1][15:0];
            buffer_vld_next[1] = rsp_vld;
            buffer_addr_next[1] = rsp_addr;
            buffer_data_next[1] = rsp_data[15:0];
            buffer_vld_next[2] = rsp_vld;
            buffer_addr_next[2] = rsp_addr + 'd2;
            buffer_data_next[2] = rsp_data[31:16];
         end

         5'b0_0_111: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {buffer_data[1], buffer_data[0]};
            rsp_ack = '0;
            buffer_vld_next[0] = buffer_vld[2];
            buffer_addr_next[0] = buffer_addr[2];
            buffer_data_next[0] = buffer_data[2][15:0];
            buffer_vld_next[1] = '0;
            buffer_addr_next[1] = 'x;
            buffer_data_next[1] = 'x;
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end
         5'b0_1_111: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {16'd0, buffer_data[0]};
            rsp_ack = '0;
            buffer_vld_next[0] = buffer_vld[1];
            buffer_addr_next[0] = buffer_addr[1];
            buffer_data_next[0] = buffer_data[1][15:0];
            buffer_vld_next[1] = buffer_vld[2];
            buffer_addr_next[1] = buffer_addr[2];
            buffer_data_next[1] = buffer_data[2][15:0];
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end
         5'b1_0_111: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {buffer_data[1], buffer_data[0]};
            rsp_ack = '1;
            buffer_vld_next[0] = buffer_vld[2];
            buffer_addr_next[0] = buffer_addr[2];
            buffer_data_next[0] = buffer_data[2][15:0];
            buffer_vld_next[1] = rsp_vld;
            buffer_addr_next[1] = rsp_addr;
            buffer_data_next[1] = rsp_data[15:0];
            buffer_vld_next[2] = rsp_vld;
            buffer_addr_next[2] = rsp_addr + 'd2;
            buffer_data_next[2] = rsp_data[31:16];
         end
         5'b1_1_111: begin
            ifu_vld = '1;
            ifu.addr = buffer_addr[0];
            ifu.data = {16'd0, buffer_data[0]};
            rsp_ack = '0;
            buffer_vld_next[0] = buffer_vld[1];
            buffer_addr_next[0] = buffer_addr[1];
            buffer_data_next[0] = buffer_data[1][15:0];
            buffer_vld_next[1] = buffer_vld[2];
            buffer_addr_next[1] = buffer_addr[2];
            buffer_data_next[1] = buffer_data[2][15:0];
            buffer_vld_next[2] = '0;
            buffer_addr_next[2] = 'x;
            buffer_data_next[2] = 'x;
         end

         default: begin
            ifu_vld = 'x;
            ifu.addr = 'x;
            ifu.data = 'x;
            rsp_ack = 'x;
            buffer_vld_next = 'x;
            buffer_addr_next = 'x;
            buffer_data_next = 'x;
         end
      endcase

      if (flush) begin
         ifu_vld = '0;
         buffer_vld_next = '0;
      end

   end

   always_ff @(posedge clock) begin
      buffer_vld  <= buffer_vld_next;
      buffer_addr <= buffer_addr_next;
      buffer_data <= buffer_data_next;

      if (reset) begin
         buffer_vld <= '0;
      end
   end


endmodule : riscv_ifu
