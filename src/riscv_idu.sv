import axi4_pkg::*;
import riscv_pkg::*;

module riscv_idu (
    input logic clock,
    input logic reset,

    input logic            ifu_vld,
    input riscv_pkg::ifu_t ifu,

    output logic            idu_vld,
    output riscv_pkg::idu_t idu
);

   logic            [63:0] seq;
   riscv_pkg::idu_t        idu_next;

   logic                   dcd_ADD;
   logic                   dcd_ADDI;
   logic                   dcd_AND;
   logic                   dcd_ANDI;
   logic                   dcd_AUIPC;
   logic                   dcd_BEQ;
   logic                   dcd_BGE;
   logic                   dcd_BGEU;
   logic                   dcd_BLT;
   logic                   dcd_BLTU;
   logic                   dcd_BNE;
   logic                   dcd_C_ADD;
   logic                   dcd_C_ADDI;
   logic                   dcd_C_ADDI16SP;
   logic                   dcd_C_ADDI4SPN;
   logic                   dcd_C_AND;
   logic                   dcd_C_ANDI;
   logic                   dcd_C_BEQZ;
   logic                   dcd_C_BNEZ;
   logic                   dcd_C_EBREAK;
   logic                   dcd_C_J;
   logic                   dcd_C_JAL;
   logic                   dcd_C_JALR;
   logic                   dcd_C_JR;
   logic                   dcd_C_LI;
   logic                   dcd_C_LUI;
   logic                   dcd_C_LW;
   logic                   dcd_C_LWSP;
   logic                   dcd_C_MV;
   logic                   dcd_C_NOP;
   logic                   dcd_C_OR;
   logic                   dcd_C_SUB;
   logic                   dcd_C_SW;
   logic                   dcd_C_SWSP;
   logic                   dcd_C_XOR;
   logic                   dcd_DIV;
   logic                   dcd_DIVU;
   logic                   dcd_EBREAK;
   logic                   dcd_ECALL;
   logic                   dcd_FENCE;
   logic                   dcd_JAL;
   logic                   dcd_JALR;
   logic                   dcd_LB;
   logic                   dcd_LBU;
   logic                   dcd_LH;
   logic                   dcd_LHU;
   logic                   dcd_LUI;
   logic                   dcd_LW;
   logic                   dcd_MUL;
   logic                   dcd_MULH;
   logic                   dcd_MULHSU;
   logic                   dcd_MULHU;
   logic                   dcd_OR;
   logic                   dcd_ORI;
   logic                   dcd_REM;
   logic                   dcd_REMU;
   logic                   dcd_SB;
   logic                   dcd_SH;
   logic                   dcd_SLL;
   logic                   dcd_SLT;
   logic                   dcd_SLTI;
   logic                   dcd_SLTIU;
   logic                   dcd_SLTU;
   logic                   dcd_SRA;
   logic                   dcd_SRL;
   logic                   dcd_SUB;
   logic                   dcd_SW;
   logic                   dcd_XOR;
   logic                   dcd_XORI;
   logic                   dcd_defined;
   logic                   dcd_compressed;
   logic                   dcd_bimm12hi;
   logic                   dcd_bimm12lo;
   logic                   dcd_c_bimm9hi;
   logic                   dcd_c_bimm9lo;
   logic                   dcd_c_imm12;
   logic                   dcd_c_imm6hi;
   logic                   dcd_c_imm6lo;
   logic                   dcd_c_nzimm10hi;
   logic                   dcd_c_nzimm10lo;
   logic                   dcd_c_nzimm18hi;
   logic                   dcd_c_nzimm18lo;
   logic                   dcd_c_nzimm6hi;
   logic                   dcd_c_nzimm6lo;
   logic                   dcd_c_nzuimm10;
   logic                   dcd_c_rs2;
   logic                   dcd_c_uimm7hi;
   logic                   dcd_c_uimm7lo;
   logic                   dcd_c_uimm8sp_s;
   logic                   dcd_c_uimm8sphi;
   logic                   dcd_c_uimm8splo;
   logic                   dcd_fm;
   logic                   dcd_imm12;
   logic                   dcd_imm12hi;
   logic                   dcd_imm12lo;
   logic                   dcd_imm20;
   logic                   dcd_jimm20;
   logic                   dcd_pred;
   logic                   dcd_rd;
   logic                   dcd_rd_p;
   logic                   dcd_rd_rs1;
   logic                   dcd_rd_rs1_p;
   logic                   dcd_rs1;
   logic                   dcd_rs1_p;
   logic                   dcd_rs2;
   logic                   dcd_rs2_p;
   logic                   dcd_succ;

   logic            [31:0] immed_i;
   logic            [31:0] immed_s;
   logic            [31:0] immed_b;
   logic            [31:0] immed_u;
   logic            [31:0] immed_j;

   riscv_decode decode (
       .data       (ifu.data),
       .ADD        (dcd_ADD),
       .ADDI       (dcd_ADDI),
       .AND        (dcd_AND),
       .ANDI       (dcd_ANDI),
       .AUIPC      (dcd_AUIPC),
       .BEQ        (dcd_BEQ),
       .BGE        (dcd_BGE),
       .BGEU       (dcd_BGEU),
       .BLT        (dcd_BLT),
       .BLTU       (dcd_BLTU),
       .BNE        (dcd_BNE),
       .C_ADD      (dcd_C_ADD),
       .C_ADDI     (dcd_C_ADDI),
       .C_ADDI16SP (dcd_C_ADDI16SP),
       .C_ADDI4SPN (dcd_C_ADDI4SPN),
       .C_AND      (dcd_C_AND),
       .C_ANDI     (dcd_C_ANDI),
       .C_BEQZ     (dcd_C_BEQZ),
       .C_BNEZ     (dcd_C_BNEZ),
       .C_EBREAK   (dcd_C_EBREAK),
       .C_J        (dcd_C_J),
       .C_JAL      (dcd_C_JAL),
       .C_JALR     (dcd_C_JALR),
       .C_JR       (dcd_C_JR),
       .C_LI       (dcd_C_LI),
       .C_LUI      (dcd_C_LUI),
       .C_LW       (dcd_C_LW),
       .C_LWSP     (dcd_C_LWSP),
       .C_MV       (dcd_C_MV),
       .C_NOP      (dcd_C_NOP),
       .C_OR       (dcd_C_OR),
       .C_SUB      (dcd_C_SUB),
       .C_SW       (dcd_C_SW),
       .C_SWSP     (dcd_C_SWSP),
       .C_XOR      (dcd_C_XOR),
       .DIV        (dcd_DIV),
       .DIVU       (dcd_DIVU),
       .EBREAK     (dcd_EBREAK),
       .ECALL      (dcd_ECALL),
       .FENCE      (dcd_FENCE),
       .JAL        (dcd_JAL),
       .JALR       (dcd_JALR),
       .LB         (dcd_LB),
       .LBU        (dcd_LBU),
       .LH         (dcd_LH),
       .LHU        (dcd_LHU),
       .LUI        (dcd_LUI),
       .LW         (dcd_LW),
       .MUL        (dcd_MUL),
       .MULH       (dcd_MULH),
       .MULHSU     (dcd_MULHSU),
       .MULHU      (dcd_MULHU),
       .OR         (dcd_OR),
       .ORI        (dcd_ORI),
       .REM        (dcd_REM),
       .REMU       (dcd_REMU),
       .SB         (dcd_SB),
       .SH         (dcd_SH),
       .SLL        (dcd_SLL),
       .SLT        (dcd_SLT),
       .SLTI       (dcd_SLTI),
       .SLTIU      (dcd_SLTIU),
       .SLTU       (dcd_SLTU),
       .SRA        (dcd_SRA),
       .SRL        (dcd_SRL),
       .SUB        (dcd_SUB),
       .SW         (dcd_SW),
       .XOR        (dcd_XOR),
       .XORI       (dcd_XORI),
       .defined    (dcd_defined),
       .compressed (dcd_compressed),
       .bimm12hi   (dcd_bimm12hi),
       .bimm12lo   (dcd_bimm12lo),
       .c_bimm9hi  (dcd_c_bimm9hi),
       .c_bimm9lo  (dcd_c_bimm9lo),
       .c_imm12    (dcd_c_imm12),
       .c_imm6hi   (dcd_c_imm6hi),
       .c_imm6lo   (dcd_c_imm6lo),
       .c_nzimm10hi(dcd_c_nzimm10hi),
       .c_nzimm10lo(dcd_c_nzimm10lo),
       .c_nzimm18hi(dcd_c_nzimm18hi),
       .c_nzimm18lo(dcd_c_nzimm18lo),
       .c_nzimm6hi (dcd_c_nzimm6hi),
       .c_nzimm6lo (dcd_c_nzimm6lo),
       .c_nzuimm10 (dcd_c_nzuimm10),
       .c_rs2      (dcd_c_rs2),
       .c_uimm7hi  (dcd_c_uimm7hi),
       .c_uimm7lo  (dcd_c_uimm7lo),
       .c_uimm8sp_s(dcd_c_uimm8sp_s),
       .c_uimm8sphi(dcd_c_uimm8sphi),
       .c_uimm8splo(dcd_c_uimm8splo),
       .fm         (dcd_fm),
       .imm12      (dcd_imm12),
       .imm12hi    (dcd_imm12hi),
       .imm12lo    (dcd_imm12lo),
       .imm20      (dcd_imm20),
       .jimm20     (dcd_jimm20),
       .pred       (dcd_pred),
       .rd         (dcd_rd),
       .rd_p       (dcd_rd_p),
       .rd_rs1     (dcd_rd_rs1),
       .rd_rs1_p   (dcd_rd_rs1_p),
       .rs1        (dcd_rs1),
       .rs1_p      (dcd_rs1_p),
       .rs2        (dcd_rs2),
       .rs2_p      (dcd_rs2_p),
       .succ       (dcd_succ)
   );

   always_comb begin

      idu_next.seq = seq;

      idu_next.addr = ifu.addr;

      idu_next.addr_next = ifu.addr + 'd4;
      if (dcd_compressed) begin
         idu_next.addr_next = ifu.addr + 'd2;
      end

      idu_next.data = ifu.data;

      idu_next.op.ADD = dcd_ADD | dcd_C_ADD | dcd_C_MV;
      idu_next.op.ADDI = dcd_ADDI | dcd_C_ADDI | dcd_C_ADDI16SP | dcd_C_ADDI4SPN | dcd_C_LI | dcd_C_NOP;
      idu_next.op.AND = dcd_AND | dcd_C_AND;
      idu_next.op.ANDI = dcd_ANDI | dcd_C_ANDI;
      idu_next.op.AUIPC = dcd_AUIPC;
      idu_next.op.BEQ = dcd_BEQ | dcd_C_BEQZ;
      idu_next.op.BGE = dcd_BGE;
      idu_next.op.BGEU = dcd_BGEU;
      idu_next.op.BLT = dcd_BLT;
      idu_next.op.BLTU = dcd_BLTU;
      idu_next.op.BNE = dcd_BNE | dcd_C_BNEZ;
      idu_next.op.DIV = dcd_DIV;
      idu_next.op.DIVU = dcd_DIVU;
      idu_next.op.EBREAK = dcd_EBREAK | dcd_C_EBREAK;
      idu_next.op.ECALL = dcd_ECALL;
      idu_next.op.FENCE = dcd_FENCE;
      idu_next.op.JAL = dcd_JAL | dcd_C_J | dcd_C_JAL;
      idu_next.op.JALR = dcd_JALR | dcd_C_JALR | dcd_C_JR;
      idu_next.op.LB = dcd_LB;
      idu_next.op.LBU = dcd_LBU;
      idu_next.op.LH = dcd_LH;
      idu_next.op.LHU = dcd_LHU;
      idu_next.op.LUI = dcd_LUI | dcd_C_LUI;
      idu_next.op.LW = dcd_LW | dcd_C_LW | dcd_C_LWSP;
      idu_next.op.MUL = dcd_MUL;
      idu_next.op.MULH = dcd_MULH;
      idu_next.op.MULHSU = dcd_MULHSU;
      idu_next.op.MULHU = dcd_MULHU;
      idu_next.op.OR = dcd_OR | dcd_C_OR;
      idu_next.op.ORI = dcd_ORI;
      idu_next.op.REM = dcd_REM;
      idu_next.op.REMU = dcd_REMU;
      idu_next.op.SB = dcd_SB;
      idu_next.op.SH = dcd_SH;
      idu_next.op.SLL = dcd_SLL;
      idu_next.op.SLT = dcd_SLT;
      idu_next.op.SLTI = dcd_SLTI;
      idu_next.op.SLTIU = dcd_SLTIU;
      idu_next.op.SLTU = dcd_SLTU;
      idu_next.op.SRA = dcd_SRA;
      idu_next.op.SRL = dcd_SRL;
      idu_next.op.SUB = dcd_SUB | dcd_C_SUB;
      idu_next.op.SW = dcd_SW | dcd_C_SW | dcd_C_SWSP;
      idu_next.op.XOR = dcd_XOR | dcd_C_XOR;
      idu_next.op.XORI = dcd_XORI;

      idu_next.op.ILLEGAL = ~dcd_defined;

      //Registers
      idu_next.rd_used = dcd_rd | dcd_rd_p | dcd_rd_rs1 | dcd_rd_rs1_p;
      idu_next.rd[4:0] = idu_next.data[11:7];
      idu_next.rs1_used = dcd_rs1 | dcd_rs1_p;
      idu_next.rs1[4:0] = idu_next.data[19:15];
      idu_next.rs2_used = dcd_rs2 | dcd_rs2_p;
      idu_next.rs2[4:0] = idu_next.data[24:20];

      //Immediates
      immed_i[31:0] = {{20{idu_next.data[31]}}, idu_next.data[31:20]};
      immed_s[31:0] = {{20{idu_next.data[31]}}, idu_next.data[31:15], idu_next.data[11:7]};
      immed_b[31:0] = {
         idu_next.data[31], idu_next.data[7], idu_next.data[30:25], idu_next.data[11:8], 1'd0
      };
      immed_u[31:0] = {idu_next.data[31:12],12'd0};
      immed_j[31:0] = {
         {11{idu_next.data[31]}},
         idu_next.data[31],
         idu_next.data[19:12],
         idu_next.data[20],
         idu_next.data[30:21],
         1'd0
      };

      idu_next.immed[31:0] = '0;
      if (dcd_imm12) begin
         idu_next.immed[31:0] = immed_i[31:0];
      end else if (dcd_imm12hi) begin
         idu_next.immed[31:0] = immed_s[31:0];
      end else if (dcd_bimm12hi) begin
         idu_next.immed[31:0] = immed_b[31:0];
      end else if (dcd_imm20) begin
         idu_next.immed[31:0] = immed_u[31:0];
      end else if (dcd_jimm20) begin
         idu_next.immed[31:0] = immed_j[31:0];
      end

      if (dcd_compressed) begin
         idu_next.data[31:16] = '0;
         if (dcd_C_ADD) begin
            idu_next.rd  = idu_next.data[11:7];
            idu_next.rs1 = idu_next.data[11:7];
            idu_next.rs2 = idu_next.data[6:2];
         end
         if (dcd_C_ADDI) begin
            idu_next.rd = idu_next.data[11:7];
            idu_next.rs1 = idu_next.data[11:7];
            idu_next.rs2 = idu_next.data[6:2];
            idu_next.immed[31:0] = {{27{idu_next.data[12]}}, idu_next.data[6:2]};
         end
         if (dcd_C_ADDI16SP) begin
            idu_next.rd = idu_next.data[11:7];
            idu_next.rs1 = idu_next.data[11:7];
            idu_next.immed[31:0] = {
               {23{idu_next.data[12]}},
               idu_next.data[4:3],
               idu_next.data[5],
               idu_next.data[2],
               idu_next.data[6],
               4'd0
            };
         end
         if (dcd_C_ADDI4SPN) begin
            idu_next.rd = {2'b01, idu_next.data[4:2]};
            idu_next.rs1 = 'd2;
            idu_next.immed[31:0] = {
               22'd0,
               idu_next.data[10:7],
               idu_next.data[12:11],
               idu_next.data[5],
               idu_next.data[6],
               2'd0
            };
         end
         if (dcd_C_AND) begin
            idu_next.rd  = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs2 = {2'b01, idu_next.data[4:2]};
         end
         if (dcd_C_ANDI) begin
            idu_next.rd = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.immed[31:0] = {{27{idu_next.data[12]}}, idu_next.data[6:2]};
         end
         if (dcd_C_BEQZ) begin
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = 'd0;
            idu_next.immed[31:0] = {
               {23{idu_next.data[12]}},
               idu_next.data[6:5],
               idu_next.data[2],
               idu_next.data[11:10],
               idu_next.data[4:3],
               1'd0
            };
         end
         if (dcd_C_BNEZ) begin
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = 'd0;
            idu_next.immed[31:0] = {
               {23{idu_next.data[12]}},
               idu_next.data[6:5],
               idu_next.data[2],
               idu_next.data[11:10],
               idu_next.data[4:3],
               1'd0
            };
         end
         if (dcd_C_EBREAK) begin
         end
         if (dcd_C_J) begin
            idu_next.rd = 'd0;
            idu_next.immed[31:0] = {
               {9{idu_next.data[12]}},
               idu_next.data[8],
               idu_next.data[10:9],
               idu_next.data[6],
               idu_next.data[7],
               idu_next.data[2],
               idu_next.data[11],
               idu_next.data[5:3],
               1'd0
            };
         end
         if (dcd_C_JAL) begin
            idu_next.rd = 'd1;
            idu_next.immed[31:0] = {
               {9{idu_next.data[12]}},
               idu_next.data[8],
               idu_next.data[10:9],
               idu_next.data[6],
               idu_next.data[7],
               idu_next.data[2],
               idu_next.data[11],
               idu_next.data[5:3],
               1'd0
            };
         end
         if (dcd_C_JALR) begin
            idu_next.rd = 'd0;
            idu_next.rs1 = idu_next.data[11:7];
            idu_next.rs2 = idu_next.data[6:2];
            idu_next.immed[31:0] = 'd0;
         end
         if (dcd_C_JR) begin
            idu_next.rd = 'd1;
            idu_next.rs1 = idu_next.data[11:7];
            idu_next.rs2 = idu_next.data[6:2];
            idu_next.immed[31:0] = 'd0;
         end
         if (dcd_C_LI) begin
            idu_next.rd = idu_next.data[11:7];
            idu_next.rs1 = 'd0;
            idu_next.immed[31:0] = {{27{idu_next.data[12]}}, idu_next.data[6:2]};
         end
         if (dcd_C_LUI) begin
            idu_next.rd = idu_next.data[11:7];
            idu_next.immed[31:0] = {{15{idu_next.data[12]}}, idu_next.data[6:2], 12'd0};
         end
         if (dcd_C_LW) begin
            idu_next.rd = {2'b01, idu_next.data[4:2]};
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.immed[31:0] = {
               25'd0, idu_next.data[5], idu_next.data[12:10], idu_next.data[6], 2'd0
            };
         end
         if (dcd_C_LWSP) begin
            idu_next.rd = idu_next.data[11:7];
            idu_next.immed[31:0] = {
               24'd0, idu_next.data[3:2], idu_next.data[12], idu_next.data[6:4], 2'd0
            };
         end
         if (dcd_C_MV) begin
            idu_next.rd  = idu_next.data[11:7];
            idu_next.rs1 = '0;
            idu_next.rs2 = idu_next.data[6:2];
         end
         if (dcd_C_NOP) begin
            idu_next.rd = '0;
            idu_next.rs1 = '0;
            idu_next.immed[31:0] = '0;
         end
         if (dcd_C_OR) begin
            idu_next.rd  = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs2 = {2'b01, idu_next.data[4:2]};
         end
         if (dcd_C_SUB) begin
            idu_next.rd  = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs2 = {2'b01, idu_next.data[4:2]};
         end
         if (dcd_C_SW) begin
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs2 = {2'b01, idu_next.data[4:2]};
            idu_next.immed[31:0] = {
               25'd0, idu_next.data[5], idu_next.data[12:10], idu_next.data[6], 2'd0
            };
         end
         if (dcd_C_SWSP) begin
            idu_next.rs2 = idu_next.data[6:2];
            idu_next.immed[31:0] = {24'd0, idu_next.data[7:6], idu_next.data[12:9], 2'd0};
         end
         if (dcd_C_XOR) begin
            idu_next.rd  = {2'b01, idu_next.data[9:7]};
            idu_next.rs1 = {2'b01, idu_next.data[9:7]};
            idu_next.rs2 = {2'b01, idu_next.data[4:2]};
         end
      end

   end

   always_ff @(posedge clock) begin
      idu_vld <= '0;
      idu <= idu;
      seq <= seq;
      if (ifu_vld) begin
         idu_vld <= '1;
         idu <= idu_next;
         seq <= seq + 1'd1;
      end

      if (reset) begin
         idu_vld <= '0;
         seq <= '0;
      end
   end

endmodule : riscv_idu
