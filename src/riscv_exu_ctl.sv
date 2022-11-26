import riscv_pkg::*;

module riscv_exu_ctl (
    input logic clock,
    input logic reset,

    input logic            vld,
    input riscv_pkg::idu_t idu,

    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,

    output logic        register_write_en,
    output logic [ 4:0] register_write,
    output logic [31:0] register_write_data,

    output logic done,

    output logic flush,
    output logic [31:0] flush_addr,
    output logic [63:0] flush_seq,

    output logic rvfi_valid,
    output riscv_pkg::rvfi_t rvfi
);

   always_ff @(posedge clock) begin
      done = '0;

      register_write_en = '0;
      register_write[4:0] = register_write[4:0];
      register_write_data[31:0] = register_write_data[31:0];

      flush = '0;

      rvfi_valid = '0;
      rvfi = '0;

      if (vld) begin
         register_write[4:0] = idu.rd[4:0];

         rvfi.order[63:0] = idu.seq[63:0];
         rvfi.insn[31:0] = idu.data[31:0];
         rvfi.rs1_addr[4:0] = idu.rs1[4:0];
         rvfi.rs2_addr[4:0] = idu.rs2[4:0];
         rvfi.rs1_rdata[31:0] = rs1_data[31:0];
         rvfi.rs2_rdata[31:0] = rs2_data[31:0];
         rvfi.rd_addr[4:0] = idu.rd[4:0];
         rvfi.pc_rdata[31:0] = idu.addr[31:0];

         if (idu.op.BEQ) begin
            done = '1;
            if (rs1_data[31:0] == rs2_data[31:0]) begin
               if (idu.addr[31:0] + idu.immed[31:0] != idu.addr_next[31:0]) begin
                  flush = '1;
                  flush_addr[31:0] = idu.addr[31:0] + idu.immed[31:0];
                  flush_seq[63:0] = idu.seq[63:0] + 'd1;
               end
            end
         end
         if (idu.op.BGE) begin
            done = '1;
            if ($signed(rs1_data[31:0]) >= $signed(rs2_data[31:0])) begin
               if (idu.addr[31:0] + idu.immed[31:0] != idu.addr_next[31:0]) begin
                  flush = '1;
                  flush_addr[31:0] = idu.addr[31:0] + idu.immed[31:0];
                  flush_seq[63:0] = idu.seq[63:0] + 'd1;
               end
            end
         end
         if (idu.op.BGEU) begin
            done = '1;
            if (rs1_data[31:0] >= rs2_data[31:0]) begin
               if (idu.addr[31:0] + idu.immed[31:0] != idu.addr_next[31:0]) begin
                  flush = '1;
                  flush_addr[31:0] = idu.addr[31:0] + idu.immed[31:0];
                  flush_seq[63:0] = idu.seq[63:0] + 'd1;
               end
            end
         end
         if (idu.op.BLT) begin
            done = '1;
            if ($signed(rs1_data[31:0]) < $signed(rs2_data[31:0])) begin
               if (idu.addr[31:0] + idu.immed[31:0] != idu.addr_next[31:0]) begin
                  flush = '1;
                  flush_addr[31:0] = idu.addr[31:0] + idu.immed[31:0];
                  flush_seq[63:0] = idu.seq[63:0] + 'd1;
               end
            end
         end
         if (idu.op.BLTU) begin
            done = '1;
            if (rs1_data[31:0] < rs2_data[31:0]) begin
               if (idu.addr[31:0] + idu.immed[31:0] != idu.addr_next[31:0]) begin
                  flush = '1;
                  flush_addr[31:0] = idu.addr[31:0] + idu.immed[31:0];
                  flush_seq[63:0] = idu.seq[63:0] + 'd1;
               end
            end
         end
         if (idu.op.BNE) begin
            done = '1;
            if (rs1_data[31:0] != rs2_data[31:0]) begin
               if (idu.addr[31:0] + idu.immed[31:0] != idu.addr_next[31:0]) begin
                  flush = '1;
                  flush_addr[31:0] = idu.addr[31:0] + idu.immed[31:0];
                  flush_seq[63:0] = idu.seq[63:0] + 'd1;
               end
            end
         end
         if (idu.op.EBREAK) begin
            //TODO
         end
         if (idu.op.ECALL) begin
            //TODO 
         end
         if (idu.op.FENCE) begin
         end
         if (idu.op.JAL) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] + rs2_data[31:0];
         end
         if (idu.op.JALR) begin
         end
         if (idu.op.ILLEGAL) begin
            //TODO 
         end

         rvfi_valid = '1;
         rvfi.rd_wdata[31:0] = register_write_data[31:0];
         if (idu.rd[4:0] == 'd0) begin
            rvfi.rd_wdata[31:0] = '0;
         end
         rvfi.pc_wdata[31:0] = idu.addr_next[31:0];
         if (flush) begin
            rvfi.pc_wdata[31:0] = flush_addr[31:0];
         end

      end


      if (reset) begin
         done = '0;
         register_write_en = '0;
      end
   end

endmodule : riscv_exu_ctl
