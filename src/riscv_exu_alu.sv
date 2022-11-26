import riscv_pkg::*;

module riscv_exu_alu (
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

    output logic rvfi_valid,
    output riscv_pkg::rvfi_t rvfi
);

   always_ff @(posedge clock) begin
      done = '0;

      register_write_en = '0;
      register_write[4:0] = register_write[4:0];
      register_write_data[31:0] = register_write_data[31:0];

      rvfi_valid = '0;
      rvfi = '0;

      if (vld) begin
         register_write[4:0] = idu.rd[4:0];
         if (idu.op.ADD) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] + rs2_data[31:0];
         end
         if (idu.op.ADDI) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] + idu.immed[31:0];
         end
         if (idu.op.AND) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] & rs2_data[31:0];
         end
         if (idu.op.ANDI) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] & idu.immed[31:0];
         end
         if (idu.op.AUIPC) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = idu.addr[31:0] + idu.immed[31:0];
         end
         if (idu.op.DIV) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs2_data[31:0] == 32'b0 
                                        ? {32{1'b1}} 
                                        : rs1_data[31:0] == {1'b1, {31{1'b0}}} && rs2_data[31:0] == {32{1'b1}} 
                                          ? {1'b1, {31{1'b0}}} 
                                          : $signed(rs1_data[31:0]) / $signed(rs2_data[31:0]);
         end
         if (idu.op.DIVU) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs2_data[31:0] == 32'b0 
                                        ? {32{1'b1}} 
                                        : rs1_data[31:0] / rs2_data[31:0];
         end
         if (idu.op.LUI) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = idu.immed[31:0];
         end
         if (idu.op.MUL) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] * rs2_data[31:0];
         end
         if (idu.op.MULH) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = ({{32{rs1_data[31]}}, rs1_data[31:0]} *	{{32{rs2_data[32-1]}}, rs2_data[31:0]}) >> 32;
         end
         if (idu.op.MULHSU) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = ({{32{rs1_data[31]}}, rs1_data[31:0]} * {32'b0, rs2_data[31:0]}) >> 32;
         end
         if (idu.op.MULHU) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = ({32'b0, rs1_data[31:0]} * {32'b0, rs2_data[31:0]}) >> 32;
         end
         if (idu.op.OR) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] | rs2_data[31:0];
         end
         if (idu.op.ORI) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] | idu.immed[31:0];
         end
         if (idu.op.REM) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs2_data[31:0] == 32'b0 
                                        ? rs1_data[31:0] 
                                        : rs1_data[31:0] == {1'b1, {31{1'b0}}} && rs2_data[31:0] == {32{1'b1}} 
                                          ? {32{1'b0}} 
                                          : $signed(rs1_data[31:0]) % $signed(rs2_data[31:0]);
         end
         if (idu.op.REMU) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs2_data[31:0] == 32'b0 
                                        ? rs1_data[31:0] 
                                        : rs1_data[31:0] % rs2_data[31:0];
         end
         if (idu.op.SLL) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] << idu.rs2[5:0];
         end
         if (idu.op.SLT) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:1] = '0;
            register_write_data[0] = $signed(rs1_data[31:0]) < $signed(rs2_data[31:0]);
         end
         if (idu.op.SLTI) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:1] = '0;
            register_write_data[0] = $signed(rs1_data[31:0]) < $signed(idu.immed[31:0]);
         end
         if (idu.op.SLTIU) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:1] = '0;
            register_write_data[0] = rs1_data[31:0] < idu.immed[31:0];
         end
         if (idu.op.SLTU) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:1] = '0;
            register_write_data[0] = rs1_data[31:0] < rs2_data[31:0];
         end
         if (idu.op.SRA) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] >>> idu.rs2[5:0];
         end
         if (idu.op.SRL) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] >> idu.rs2[5:0];
         end
         if (idu.op.SUB) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] - rs2_data[31:0];
         end
         if (idu.op.XOR) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] ^ rs2_data[31:0];
         end
         if (idu.op.XORI) begin
            done = '1;
            register_write_en = '1;
            register_write_data[31:0] = rs1_data[31:0] ^ idu.immed[31:0];
         end

         rvfi_valid = '1;
         rvfi.order[63:0] = idu.seq[63:0];
         rvfi.insn[31:0] = idu.data[31:0];
         rvfi.rs1_addr[4:0] = idu.rs1[4:0];
         rvfi.rs2_addr[4:0] = idu.rs2[4:0];
         rvfi.rs1_rdata[31:0] = rs1_data[31:0];
         rvfi.rs2_rdata[31:0] = rs2_data[31:0];
         rvfi.rd_addr[4:0] = idu.rd[4:0];
         rvfi.rd_wdata[31:0] = register_write_data[31:0];
         if (idu.rd[4:0] == 'd0) begin
            rvfi.rd_wdata[31:0] = '0;
         end
         rvfi.pc_rdata[31:0] = idu.addr[31:0];
         rvfi.pc_wdata[31:0] = idu.addr_next[31:0];

      end


      if (reset) begin
         done = '0;
         register_write_en = '0;
      end
   end

endmodule : riscv_exu_alu
