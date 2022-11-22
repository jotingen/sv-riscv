import axi4_pkg::*;
import riscv_pkg::*;

module riscv_idu (
    input logic clock,
    input logic reset,

    input logic        ifu_vld,
    input logic [31:0] ifu_addr,
    input logic [31:0] ifu_data,

    output logic        idu_vld,
    output logic [63:0] idu_seq,
    output logic [31:0] idu_addr,
    output logic [31:0] idu_data,
    output logic        idu_defined
);

   logic ADD;
   logic ADDI;
   logic AND;
   logic ANDI;
   logic AUIPC;
   logic BEQ;
   logic BGE;
   logic BGEU;
   logic BLT;
   logic BLTU;
   logic BNE;
   logic DIV;
   logic DIVU;
   logic EBREAK;
   logic ECALL;
   logic FENCE;
   logic JAL;
   logic JALR;
   logic LB;
   logic LBU;
   logic LH;
   logic LHU;
   logic LUI;
   logic LW;
   logic MUL;
   logic MULH;
   logic MULHSU;
   logic MULHU;
   logic OR;
   logic ORI;
   logic REM;
   logic REMU;
   logic SB;
   logic SH;
   logic SLL;
   logic SLT;
   logic SLTI;
   logic SLTIU;
   logic SLTU;
   logic SRA;
   logic SRL;
   logic SUB;
   logic SW;
   logic XOR;
   logic XORI;
   logic defined;
   logic compressed;
   logic bimm12hi;
   logic bimm12lo;
   logic c_bimm9hi;
   logic c_bimm9lo;
   logic c_imm12;
   logic c_imm6hi;
   logic c_imm6lo;
   logic c_nzimm10hi;
   logic c_nzimm10lo;
   logic c_nzimm18hi;
   logic c_nzimm18lo;
   logic c_nzimm6hi;
   logic c_nzimm6lo;
   logic c_nzuimm10;
   logic c_rs2;
   logic c_uimm7hi;
   logic c_uimm7lo;
   logic c_uimm8sp_s;
   logic c_uimm8sphi;
   logic c_uimm8splo;
   logic fm;
   logic imm12;
   logic imm12hi;
   logic imm12lo;
   logic imm20;
   logic jimm20;
   logic pred;
   logic rd;
   logic rd_p;
   logic rd_rs1;
   logic rd_rs1_p;
   logic rs1;
   logic rs1_p;
   logic rs2;
   logic rs2_p;
   logic succ;

   logic dcd_ADD;
   logic dcd_ADDI;
   logic dcd_AND;
   logic dcd_ANDI;
   logic dcd_AUIPC;
   logic dcd_BEQ;
   logic dcd_BGE;
   logic dcd_BGEU;
   logic dcd_BLT;
   logic dcd_BLTU;
   logic dcd_BNE;
   logic dcd_C_ADD;
   logic dcd_C_ADDI;
   logic dcd_C_ADDI16SP;
   logic dcd_C_ADDI4SPN;
   logic dcd_C_AND;
   logic dcd_C_ANDI;
   logic dcd_C_BEQZ;
   logic dcd_C_BNEZ;
   logic dcd_C_EBREAK;
   logic dcd_C_J;
   logic dcd_C_JAL;
   logic dcd_C_JALR;
   logic dcd_C_JR;
   logic dcd_C_LI;
   logic dcd_C_LUI;
   logic dcd_C_LW;
   logic dcd_C_LWSP;
   logic dcd_C_MV;
   logic dcd_C_NOP;
   logic dcd_C_OR;
   logic dcd_C_SUB;
   logic dcd_C_SW;
   logic dcd_C_SWSP;
   logic dcd_C_XOR;
   logic dcd_DIV;
   logic dcd_DIVU;
   logic dcd_EBREAK;
   logic dcd_ECALL;
   logic dcd_FENCE;
   logic dcd_JAL;
   logic dcd_JALR;
   logic dcd_LB;
   logic dcd_LBU;
   logic dcd_LH;
   logic dcd_LHU;
   logic dcd_LUI;
   logic dcd_LW;
   logic dcd_MUL;
   logic dcd_MULH;
   logic dcd_MULHSU;
   logic dcd_MULHU;
   logic dcd_OR;
   logic dcd_ORI;
   logic dcd_REM;
   logic dcd_REMU;
   logic dcd_SB;
   logic dcd_SH;
   logic dcd_SLL;
   logic dcd_SLT;
   logic dcd_SLTI;
   logic dcd_SLTIU;
   logic dcd_SLTU;
   logic dcd_SRA;
   logic dcd_SRL;
   logic dcd_SUB;
   logic dcd_SW;
   logic dcd_XOR;
   logic dcd_XORI;
   logic dcd_defined;
   logic dcd_compressed;
   logic dcd_bimm12hi;
   logic dcd_bimm12lo;
   logic dcd_c_bimm9hi;
   logic dcd_c_bimm9lo;
   logic dcd_c_imm12;
   logic dcd_c_imm6hi;
   logic dcd_c_imm6lo;
   logic dcd_c_nzimm10hi;
   logic dcd_c_nzimm10lo;
   logic dcd_c_nzimm18hi;
   logic dcd_c_nzimm18lo;
   logic dcd_c_nzimm6hi;
   logic dcd_c_nzimm6lo;
   logic dcd_c_nzuimm10;
   logic dcd_c_rs2;
   logic dcd_c_uimm7hi;
   logic dcd_c_uimm7lo;
   logic dcd_c_uimm8sp_s;
   logic dcd_c_uimm8sphi;
   logic dcd_c_uimm8splo;
   logic dcd_fm;
   logic dcd_imm12;
   logic dcd_imm12hi;
   logic dcd_imm12lo;
   logic dcd_imm20;
   logic dcd_jimm20;
   logic dcd_pred;
   logic dcd_rd;
   logic dcd_rd_p;
   logic dcd_rd_rs1;
   logic dcd_rd_rs1_p;
   logic dcd_rs1;
   logic dcd_rs1_p;
   logic dcd_rs2;
   logic dcd_rs2_p;
   logic dcd_succ;

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
      ADD        = dcd_ADD | dcd_C_ADD | dcd_C_MV;
      ADDI       = dcd_ADDI | dcd_C_ADDI | dcd_C_ADDI16SP | dcd_C_ADDI4SPN | dcd_C_LI | dcd_C_NOP;
      AND        = dcd_AND | dcd_C_AND;
      ANDI       = dcd_ANDI | dcd_C_ANDI;
      AUIPC      = dcd_AUIPC;
      BEQ        = dcd_BEQ | dcd_C_BEQZ;
      BGE        = dcd_BGE;
      BGEU       = dcd_BGEU;
      BLT        = dcd_BLT;
      BLTU       = dcd_BLTU;
      BNE        = dcd_BNE | dcd_C_BNEZ;
      DIV        = dcd_DIV;
      DIVU       = dcd_DIVU;
      EBREAK     = dcd_EBREAK | dcd_C_EBREAK;
      ECALL      = dcd_ECALL;
      FENCE      = dcd_FENCE;
      JAL        = dcd_JAL | dcd_C_J | dcd_C_JAL;
      JALR       = dcd_JALR | dcd_C_JALR | dcd_C_JR;
      LB         = dcd_LB;
      LBU        = dcd_LBU;
      LH         = dcd_LH;
      LHU        = dcd_LHU;
      LUI        = dcd_LUI | dcd_C_LUI;
      LW         = dcd_LW | dcd_C_LW | dcd_C_LWSP;
      MUL        = dcd_MUL;
      MULH       = dcd_MULH;
      MULHSU     = dcd_MULHSU;
      MULHU      = dcd_MULHU;
      OR         = dcd_OR | dcd_C_OR;
      ORI        = dcd_ORI;
      REM        = dcd_REM;
      REMU       = dcd_REMU;
      SB         = dcd_SB;
      SH         = dcd_SH;
      SLL        = dcd_SLL;
      SLT        = dcd_SLT;
      SLTI       = dcd_SLTI;
      SLTIU      = dcd_SLTIU;
      SLTU       = dcd_SLTU;
      SRA        = dcd_SRA;
      SRL        = dcd_SRL;
      SUB        = dcd_SUB | dcd_C_SUB;
      SW         = dcd_SW | dcd_C_SW | dcd_C_SWSP;
      XOR        = dcd_XOR | dcd_C_XOR;
      XORI       = dcd_XORI;

      defined    = dcd_defined;
      compressed = dcd_compressed;
   end

   always_ff @(posedge clock) begin
      idu_vld <= '0;
      idu_seq <= idu_seq;
      idu_addr <= idu_addr;
      idu_data <= idu_data;
      idu_defined <= idu_defined;
      if (ifu_vld) begin
         idu_vld <= '1;
         idu_seq <= idu_seq + '1;
         idu_addr <= ifu_addr;
         idu_data <= ifu_data;
         idu_defined <= dcd_defined;
      end

      if (reset) begin
         idu_vld <= '0;
         idu_seq <= '0;
      end
   end

endmodule : riscv_idu
