import axi4_pkg::*;
import riscv_pkg::*;

module riscv_idu (
    input logic clock,
    input logic reset,

    input logic        ifu_vld,
    input logic [31:0] ifu_addr,
    input logic [31:0] ifu_data,

    output logic                idu_vld,
    output logic         [63:0] idu_seq,
    output logic         [31:0] idu_addr,
    output logic         [31:0] idu_data,
    output riscv_pkg::op        idu_op,
    output logic         [ 5:0] idu_rd,
    output logic         [ 5:0] idu_rs1,
    output logic         [ 5:0] idu_rs2,
    output logic         [31:0] idu_immed
);

   riscv_pkg::op        idu_op_next;

   logic         [63:0] idu_seq_next;
   logic         [31:0] idu_addr_next;
   logic         [31:0] idu_data_next;
   logic         [ 5:0] idu_rd_next;
   logic         [ 5:0] idu_rs1_next;
   logic         [ 5:0] idu_rs2_next;
   logic         [31:0] idu_immed_next;

   logic                dcd_ADD;
   logic                dcd_ADDI;
   logic                dcd_AND;
   logic                dcd_ANDI;
   logic                dcd_AUIPC;
   logic                dcd_BEQ;
   logic                dcd_BGE;
   logic                dcd_BGEU;
   logic                dcd_BLT;
   logic                dcd_BLTU;
   logic                dcd_BNE;
   logic                dcd_C_ADD;
   logic                dcd_C_ADDI;
   logic                dcd_C_ADDI16SP;
   logic                dcd_C_ADDI4SPN;
   logic                dcd_C_AND;
   logic                dcd_C_ANDI;
   logic                dcd_C_BEQZ;
   logic                dcd_C_BNEZ;
   logic                dcd_C_EBREAK;
   logic                dcd_C_J;
   logic                dcd_C_JAL;
   logic                dcd_C_JALR;
   logic                dcd_C_JR;
   logic                dcd_C_LI;
   logic                dcd_C_LUI;
   logic                dcd_C_LW;
   logic                dcd_C_LWSP;
   logic                dcd_C_MV;
   logic                dcd_C_NOP;
   logic                dcd_C_OR;
   logic                dcd_C_SUB;
   logic                dcd_C_SW;
   logic                dcd_C_SWSP;
   logic                dcd_C_XOR;
   logic                dcd_DIV;
   logic                dcd_DIVU;
   logic                dcd_EBREAK;
   logic                dcd_ECALL;
   logic                dcd_FENCE;
   logic                dcd_JAL;
   logic                dcd_JALR;
   logic                dcd_LB;
   logic                dcd_LBU;
   logic                dcd_LH;
   logic                dcd_LHU;
   logic                dcd_LUI;
   logic                dcd_LW;
   logic                dcd_MUL;
   logic                dcd_MULH;
   logic                dcd_MULHSU;
   logic                dcd_MULHU;
   logic                dcd_OR;
   logic                dcd_ORI;
   logic                dcd_REM;
   logic                dcd_REMU;
   logic                dcd_SB;
   logic                dcd_SH;
   logic                dcd_SLL;
   logic                dcd_SLT;
   logic                dcd_SLTI;
   logic                dcd_SLTIU;
   logic                dcd_SLTU;
   logic                dcd_SRA;
   logic                dcd_SRL;
   logic                dcd_SUB;
   logic                dcd_SW;
   logic                dcd_XOR;
   logic                dcd_XORI;
   logic                dcd_defined;
   logic                dcd_compressed;
   logic                dcd_bimm12hi;
   logic                dcd_bimm12lo;
   logic                dcd_c_bimm9hi;
   logic                dcd_c_bimm9lo;
   logic                dcd_c_imm12;
   logic                dcd_c_imm6hi;
   logic                dcd_c_imm6lo;
   logic                dcd_c_nzimm10hi;
   logic                dcd_c_nzimm10lo;
   logic                dcd_c_nzimm18hi;
   logic                dcd_c_nzimm18lo;
   logic                dcd_c_nzimm6hi;
   logic                dcd_c_nzimm6lo;
   logic                dcd_c_nzuimm10;
   logic                dcd_c_rs2;
   logic                dcd_c_uimm7hi;
   logic                dcd_c_uimm7lo;
   logic                dcd_c_uimm8sp_s;
   logic                dcd_c_uimm8sphi;
   logic                dcd_c_uimm8splo;
   logic                dcd_fm;
   logic                dcd_imm12;
   logic                dcd_imm12hi;
   logic                dcd_imm12lo;
   logic                dcd_imm20;
   logic                dcd_jimm20;
   logic                dcd_pred;
   logic                dcd_rd;
   logic                dcd_rd_p;
   logic                dcd_rd_rs1;
   logic                dcd_rd_rs1_p;
   logic                dcd_rs1;
   logic                dcd_rs1_p;
   logic                dcd_rs2;
   logic                dcd_rs2_p;
   logic                dcd_succ;

   logic         [31:0] immed_i;
   logic         [31:0] immed_s;
   logic         [31:0] immed_b;
   logic         [31:0] immed_u;
   logic         [31:0] immed_j;

   riscv_decode decode (
       .data       (ifu_data),
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

      idu_seq_next = idu_seq + 'd1;

      idu_addr_next = ifu_addr;

      idu_data_next = ifu_data;

      idu_op_next.ADD = dcd_ADD | dcd_C_ADD | dcd_C_MV;
      idu_op_next.ADDI = dcd_ADDI | dcd_C_ADDI | dcd_C_ADDI16SP | dcd_C_ADDI4SPN | dcd_C_LI | dcd_C_NOP;
      idu_op_next.AND = dcd_AND | dcd_C_AND;
      idu_op_next.ANDI = dcd_ANDI | dcd_C_ANDI;
      idu_op_next.AUIPC = dcd_AUIPC;
      idu_op_next.BEQ = dcd_BEQ | dcd_C_BEQZ;
      idu_op_next.BGE = dcd_BGE;
      idu_op_next.BGEU = dcd_BGEU;
      idu_op_next.BLT = dcd_BLT;
      idu_op_next.BLTU = dcd_BLTU;
      idu_op_next.BNE = dcd_BNE | dcd_C_BNEZ;
      idu_op_next.DIV = dcd_DIV;
      idu_op_next.DIVU = dcd_DIVU;
      idu_op_next.EBREAK = dcd_EBREAK | dcd_C_EBREAK;
      idu_op_next.ECALL = dcd_ECALL;
      idu_op_next.FENCE = dcd_FENCE;
      idu_op_next.JAL = dcd_JAL | dcd_C_J | dcd_C_JAL;
      idu_op_next.JALR = dcd_JALR | dcd_C_JALR | dcd_C_JR;
      idu_op_next.LB = dcd_LB;
      idu_op_next.LBU = dcd_LBU;
      idu_op_next.LH = dcd_LH;
      idu_op_next.LHU = dcd_LHU;
      idu_op_next.LUI = dcd_LUI | dcd_C_LUI;
      idu_op_next.LW = dcd_LW | dcd_C_LW | dcd_C_LWSP;
      idu_op_next.MUL = dcd_MUL;
      idu_op_next.MULH = dcd_MULH;
      idu_op_next.MULHSU = dcd_MULHSU;
      idu_op_next.MULHU = dcd_MULHU;
      idu_op_next.OR = dcd_OR | dcd_C_OR;
      idu_op_next.ORI = dcd_ORI;
      idu_op_next.REM = dcd_REM;
      idu_op_next.REMU = dcd_REMU;
      idu_op_next.SB = dcd_SB;
      idu_op_next.SH = dcd_SH;
      idu_op_next.SLL = dcd_SLL;
      idu_op_next.SLT = dcd_SLT;
      idu_op_next.SLTI = dcd_SLTI;
      idu_op_next.SLTIU = dcd_SLTIU;
      idu_op_next.SLTU = dcd_SLTU;
      idu_op_next.SRA = dcd_SRA;
      idu_op_next.SRL = dcd_SRL;
      idu_op_next.SUB = dcd_SUB | dcd_C_SUB;
      idu_op_next.SW = dcd_SW | dcd_C_SW | dcd_C_SWSP;
      idu_op_next.XOR = dcd_XOR | dcd_C_XOR;
      idu_op_next.XORI = dcd_XORI;

      idu_op_next.ILLEGAL = ~dcd_defined;

      //Registers
      idu_rd_next[5:0] = idu_data_next[11:7];
      idu_rs1_next[5:0] = idu_data_next[19:15];
      idu_rs2_next[5:0] = idu_data_next[24:20];

      //Immediates
      immed_i[31:0] = {20'd0, idu_data_next[31:20]};
      immed_s[31:0] = {20'd0, idu_data_next[31:15], idu_data_next[11:7]};
      immed_b[31:0] = {
         idu_data_next[31], idu_data_next[7], idu_data_next[30:25], idu_data_next[11:8], 1'd0
      };
      immed_u[31:0] = {12'd0, idu_data_next[31:12]};
      immed_j[31:0] = {
         11'd0,
         idu_data_next[31],
         idu_data_next[19:12],
         idu_data_next[20],
         idu_data_next[30:21],
         1'd0
      };

      idu_immed_next[31:0] = '0;
      if (dcd_imm12) begin
         idu_immed_next[31:0] = immed_i[31:0];
      end else if (dcd_imm12hi) begin
         idu_immed_next[31:0] = immed_s[31:0];
      end else if (dcd_bimm12hi) begin
         idu_immed_next[31:0] = immed_b[31:0];
      end else if (dcd_imm20) begin
         idu_immed_next[31:0] = immed_u[31:0];
      end else if (dcd_jimm20) begin
         idu_immed_next[31:0] = immed_j[31:0];
      end

      if (dcd_compressed) begin
         idu_data_next[31:16] = '0;
         if (dcd_C_ADD) begin
            idu_rd_next  = idu_data_next[11:7];
            idu_rs1_next = idu_data_next[11:7];
            idu_rs2_next = idu_data_next[6:2];
         end
         if (dcd_C_ADDI) begin
            idu_rd_next = idu_data_next[11:7];
            idu_rs1_next = idu_data_next[11:7];
            idu_rs2_next = idu_data_next[6:2];
            idu_immed_next[31:0] = {{27{idu_data_next[12]}}, idu_data_next[6:2]};
         end
         if (dcd_C_ADDI16SP) begin
            idu_rd_next = idu_data_next[11:7];
            idu_rs1_next = idu_data_next[11:7];
            idu_immed_next[31:0] = {
               {23{idu_data_next[12]}},
               idu_data_next[4:3],
               idu_data_next[5],
               idu_data_next[2],
               idu_data_next[6],
               4'd0
            };
         end
         if (dcd_C_ADDI4SPN) begin
            idu_rd_next = {2'd0, idu_data_next[4:2]};
            idu_immed_next[31:0] = {
               22'd0,
               idu_data_next[10:7],
               idu_data_next[12:11],
               idu_data_next[5],
               idu_data_next[6],
               2'd0
            };
         end
         if (dcd_C_AND) begin
            idu_rd_next  = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs2_next = {2'd0, idu_data_next[4:2]};
         end
         if (dcd_C_ANDI) begin
            idu_rd_next = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_immed_next[31:0] = {{26{idu_data_next[12]}}, idu_data_next[6:2]};
         end
         if (dcd_C_BEQZ) begin
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = 'd0;
            idu_immed_next[31:0] = {
               {23{idu_data_next[12]}},
               idu_data_next[6:5],
               idu_data_next[2],
               idu_data_next[11:10],
               idu_data_next[4:3],
               1'd0
            };
         end
         if (dcd_C_BNEZ) begin
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = 'd0;
            idu_immed_next[31:0] = {
               {23{idu_data_next[12]}},
               idu_data_next[6:5],
               idu_data_next[2],
               idu_data_next[11:10],
               idu_data_next[4:3],
               1'd0
            };
         end
         if (dcd_C_EBREAK) begin
         end
         if (dcd_C_J) begin
            idu_rd_next = 'd0;
            idu_immed_next[31:0] = {
               {9{idu_data_next[12]}},
               idu_data_next[8],
               idu_data_next[10:9],
               idu_data_next[6],
               idu_data_next[7],
               idu_data_next[2],
               idu_data_next[11],
               idu_data_next[5:3],
               1'd0
            };
         end
         if (dcd_C_JAL) begin
            idu_rd_next = 'd1;
            idu_immed_next[31:0] = {
               {9{idu_data_next[12]}},
               idu_data_next[8],
               idu_data_next[10:9],
               idu_data_next[6],
               idu_data_next[7],
               idu_data_next[2],
               idu_data_next[11],
               idu_data_next[5:3],
               1'd0
            };
         end
         if (dcd_C_JALR) begin
            idu_rd_next = 'd0;
            idu_rs1_next = idu_data_next[11:7];
            idu_rs2_next = idu_data_next[6:2];
            idu_immed_next[31:0] = 'd0;
         end
         if (dcd_C_JR) begin
            idu_rd_next = 'd1;
            idu_rs1_next = idu_data_next[11:7];
            idu_rs2_next = idu_data_next[6:2];
            idu_immed_next[31:0] = 'd0;
         end
         if (dcd_C_LI) begin
            idu_rd_next = idu_data_next[11:7];
            idu_rs1_next = 'd0;
            idu_immed_next[31:0] = {{27{idu_data_next[12]}}, idu_data_next[6:2]};
         end
         if (dcd_C_LUI) begin
            idu_rd_next = idu_data_next[11:7];
            idu_immed_next[31:0] = {{14{idu_data_next[12]}}, idu_data_next[6:2], 12'd0};
         end
         if (dcd_C_LW) begin
            idu_rd_next = {2'd0, idu_data_next[4:2]};
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_immed_next[31:0] = {
               25'd0, idu_data_next[5], idu_data_next[12:10], idu_data_next[6], 2'd0
            };
         end
         if (dcd_C_LWSP) begin
            idu_rd_next = idu_data_next[11:7];
            idu_immed_next[31:0] = {
               24'd0, idu_data_next[3:2], idu_data_next[12], idu_data_next[6:4], 2'd0
            };
         end
         if (dcd_C_MV) begin
            idu_rd_next  = idu_data_next[11:7];
            idu_rs1_next = idu_data_next[11:7];
            idu_rs2_next = idu_data_next[6:2];
         end
         if (dcd_C_NOP) begin
            idu_rd_next = '0;
            idu_rs1_next = '0;
            idu_immed_next[31:0] = '0;
         end
         if (dcd_C_OR) begin
            idu_rd_next  = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs2_next = {2'd0, idu_data_next[4:2]};
         end
         if (dcd_C_SUB) begin
            idu_rd_next  = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs2_next = {2'd0, idu_data_next[4:2]};
         end
         if (dcd_C_SW) begin
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs2_next = {2'd0, idu_data_next[4:2]};
            idu_immed_next[31:0] = {
               25'd0, idu_data_next[5], idu_data_next[12:10], idu_data_next[6], 2'd0
            };
         end
         if (dcd_C_SWSP) begin
            idu_rs2_next = idu_data_next[6:2];
            idu_immed_next[31:0] = {24'd0, idu_data_next[7:6], idu_data_next[12:9], 2'd0};
         end
         if (dcd_C_XOR) begin
            idu_rd_next  = {2'd0, idu_data_next[9:7]};
            idu_rs1_next = {2'd0, idu_data_next[9:7]};
            idu_rs2_next = {2'd0, idu_data_next[4:2]};
         end
      end

   end

   always_ff @(posedge clock) begin
      idu_vld <= '0;
      idu_seq <= idu_seq;
      idu_addr <= idu_addr;
      idu_data <= idu_data;
      idu_op <= idu_op;
      idu_rd <= idu_rd_next;
      idu_rs1 <= idu_rs1_next;
      idu_rs2 <= idu_rs2_next;
      idu_immed[31:0] <= idu_immed_next[31:0];
      if (ifu_vld) begin
         idu_vld <= '1;
         idu_seq <= idu_seq_next;
         idu_addr <= idu_addr_next;
         idu_data <= idu_data_next;
         idu_op <= idu_op_next;
         idu_rd <= idu_rd_next;
         idu_rs1 <= idu_rs1_next;
         idu_rs2 <= idu_rs2_next;
         idu_immed[31:0] <= idu_immed_next[31:0];
      end

      if (reset) begin
         idu_vld <= '0;
         idu_seq <= '0;
      end
   end

endmodule : riscv_idu
