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

   logic        idu_ADD_next;
   logic        idu_ADDI_next;
   logic        idu_AND_next;
   logic        idu_ANDI_next;
   logic        idu_AUIPC_next;
   logic        idu_BEQ_next;
   logic        idu_BGE_next;
   logic        idu_BGEU_next;
   logic        idu_BLT_next;
   logic        idu_BLTU_next;
   logic        idu_BNE_next;
   logic        idu_DIV_next;
   logic        idu_DIVU_next;
   logic        idu_EBREAK_next;
   logic        idu_ECALL_next;
   logic        idu_FENCE_next;
   logic        idu_JAL_next;
   logic        idu_JALR_next;
   logic        idu_LB_next;
   logic        idu_LBU_next;
   logic        idu_LH_next;
   logic        idu_LHU_next;
   logic        idu_LUI_next;
   logic        idu_LW_next;
   logic        idu_MUL_next;
   logic        idu_MULH_next;
   logic        idu_MULHSU_next;
   logic        idu_MULHU_next;
   logic        idu_OR_next;
   logic        idu_ORI_next;
   logic        idu_REM_next;
   logic        idu_REMU_next;
   logic        idu_SB_next;
   logic        idu_SH_next;
   logic        idu_SLL_next;
   logic        idu_SLT_next;
   logic        idu_SLTI_next;
   logic        idu_SLTIU_next;
   logic        idu_SLTU_next;
   logic        idu_SRA_next;
   logic        idu_SRL_next;
   logic        idu_SUB_next;
   logic        idu_SW_next;
   logic        idu_XOR_next;
   logic        idu_XORI_next;
   logic        idu_defined_next;
   logic        idu_compressed_next;
   logic        idu_bimm12hi_next;
   logic        idu_bimm12lo_next;
   logic        idu_c_bimm9hi_next;
   logic        idu_c_bimm9lo_next;
   logic        idu_c_imm12_next;
   logic        idu_c_imm6hi_next;
   logic        idu_c_imm6lo_next;
   logic        idu_c_nzimm10hi_next;
   logic        idu_c_nzimm10lo_next;
   logic        idu_c_nzimm18hi_next;
   logic        idu_c_nzimm18lo_next;
   logic        idu_c_nzimm6hi_next;
   logic        idu_c_nzimm6lo_next;
   logic        idu_c_nzuimm10_next;
   logic        idu_c_rs2_next;
   logic        idu_c_uimm7hi_next;
   logic        idu_c_uimm7lo_next;
   logic        idu_c_uimm8sp_s_next;
   logic        idu_c_uimm8sphi_next;
   logic        idu_c_uimm8splo_next;
   logic        idu_fm_next;
   logic        idu_imm12_next;
   logic        idu_imm12hi_next;
   logic        idu_imm12lo_next;
   logic        idu_imm20_next;
   logic        idu_jimm20_next;
   logic        idu_pred_next;
   logic        idu_rd_next;
   logic        idu_rd_p_next;
   logic        idu_rd_rs1_next;
   logic        idu_rd_rs1_p_next;
   logic        idu_rs1_next;
   logic        idu_rs1_p_next;
   logic        idu_rs2_next;
   logic        idu_rs2_p_next;
   logic        idu_succ_next;

   logic [63:0] idu_seq_next;
   logic [31:0] idu_addr_next;
   logic [31:0] idu_data_next;

   logic        dcd_ADD;
   logic        dcd_ADDI;
   logic        dcd_AND;
   logic        dcd_ANDI;
   logic        dcd_AUIPC;
   logic        dcd_BEQ;
   logic        dcd_BGE;
   logic        dcd_BGEU;
   logic        dcd_BLT;
   logic        dcd_BLTU;
   logic        dcd_BNE;
   logic        dcd_C_ADD;
   logic        dcd_C_ADDI;
   logic        dcd_C_ADDI16SP;
   logic        dcd_C_ADDI4SPN;
   logic        dcd_C_AND;
   logic        dcd_C_ANDI;
   logic        dcd_C_BEQZ;
   logic        dcd_C_BNEZ;
   logic        dcd_C_EBREAK;
   logic        dcd_C_J;
   logic        dcd_C_JAL;
   logic        dcd_C_JALR;
   logic        dcd_C_JR;
   logic        dcd_C_LI;
   logic        dcd_C_LUI;
   logic        dcd_C_LW;
   logic        dcd_C_LWSP;
   logic        dcd_C_MV;
   logic        dcd_C_NOP;
   logic        dcd_C_OR;
   logic        dcd_C_SUB;
   logic        dcd_C_SW;
   logic        dcd_C_SWSP;
   logic        dcd_C_XOR;
   logic        dcd_DIV;
   logic        dcd_DIVU;
   logic        dcd_EBREAK;
   logic        dcd_ECALL;
   logic        dcd_FENCE;
   logic        dcd_JAL;
   logic        dcd_JALR;
   logic        dcd_LB;
   logic        dcd_LBU;
   logic        dcd_LH;
   logic        dcd_LHU;
   logic        dcd_LUI;
   logic        dcd_LW;
   logic        dcd_MUL;
   logic        dcd_MULH;
   logic        dcd_MULHSU;
   logic        dcd_MULHU;
   logic        dcd_OR;
   logic        dcd_ORI;
   logic        dcd_REM;
   logic        dcd_REMU;
   logic        dcd_SB;
   logic        dcd_SH;
   logic        dcd_SLL;
   logic        dcd_SLT;
   logic        dcd_SLTI;
   logic        dcd_SLTIU;
   logic        dcd_SLTU;
   logic        dcd_SRA;
   logic        dcd_SRL;
   logic        dcd_SUB;
   logic        dcd_SW;
   logic        dcd_XOR;
   logic        dcd_XORI;
   logic        dcd_defined;
   logic        dcd_compressed;
   logic        dcd_bimm12hi;
   logic        dcd_bimm12lo;
   logic        dcd_c_bimm9hi;
   logic        dcd_c_bimm9lo;
   logic        dcd_c_imm12;
   logic        dcd_c_imm6hi;
   logic        dcd_c_imm6lo;
   logic        dcd_c_nzimm10hi;
   logic        dcd_c_nzimm10lo;
   logic        dcd_c_nzimm18hi;
   logic        dcd_c_nzimm18lo;
   logic        dcd_c_nzimm6hi;
   logic        dcd_c_nzimm6lo;
   logic        dcd_c_nzuimm10;
   logic        dcd_c_rs2;
   logic        dcd_c_uimm7hi;
   logic        dcd_c_uimm7lo;
   logic        dcd_c_uimm8sp_s;
   logic        dcd_c_uimm8sphi;
   logic        dcd_c_uimm8splo;
   logic        dcd_fm;
   logic        dcd_imm12;
   logic        dcd_imm12hi;
   logic        dcd_imm12lo;
   logic        dcd_imm20;
   logic        dcd_jimm20;
   logic        dcd_pred;
   logic        dcd_rd;
   logic        dcd_rd_p;
   logic        dcd_rd_rs1;
   logic        dcd_rd_rs1_p;
   logic        dcd_rs1;
   logic        dcd_rs1_p;
   logic        dcd_rs2;
   logic        dcd_rs2_p;
   logic        dcd_succ;

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
      idu_ADD_next = dcd_ADD | dcd_C_ADD | dcd_C_MV;
      idu_ADDI_next      = dcd_ADDI | dcd_C_ADDI | dcd_C_ADDI16SP | dcd_C_ADDI4SPN | dcd_C_LI | dcd_C_NOP;
      idu_AND_next = dcd_AND | dcd_C_AND;
      idu_ANDI_next = dcd_ANDI | dcd_C_ANDI;
      idu_AUIPC_next = dcd_AUIPC;
      idu_BEQ_next = dcd_BEQ | dcd_C_BEQZ;
      idu_BGE_next = dcd_BGE;
      idu_BGEU_next = dcd_BGEU;
      idu_BLT_next = dcd_BLT;
      idu_BLTU_next = dcd_BLTU;
      idu_BNE_next = dcd_BNE | dcd_C_BNEZ;
      idu_DIV_next = dcd_DIV;
      idu_DIVU_next = dcd_DIVU;
      idu_EBREAK_next = dcd_EBREAK | dcd_C_EBREAK;
      idu_ECALL_next = dcd_ECALL;
      idu_FENCE_next = dcd_FENCE;
      idu_JAL_next = dcd_JAL | dcd_C_J | dcd_C_JAL;
      idu_JALR_next = dcd_JALR | dcd_C_JALR | dcd_C_JR;
      idu_LB_next = dcd_LB;
      idu_LBU_next = dcd_LBU;
      idu_LH_next = dcd_LH;
      idu_LHU_next = dcd_LHU;
      idu_LUI_next = dcd_LUI | dcd_C_LUI;
      idu_LW_next = dcd_LW | dcd_C_LW | dcd_C_LWSP;
      idu_MUL_next = dcd_MUL;
      idu_MULH_next = dcd_MULH;
      idu_MULHSU_next = dcd_MULHSU;
      idu_MULHU_next = dcd_MULHU;
      idu_OR_next = dcd_OR | dcd_C_OR;
      idu_ORI_next = dcd_ORI;
      idu_REM_next = dcd_REM;
      idu_REMU_next = dcd_REMU;
      idu_SB_next = dcd_SB;
      idu_SH_next = dcd_SH;
      idu_SLL_next = dcd_SLL;
      idu_SLT_next = dcd_SLT;
      idu_SLTI_next = dcd_SLTI;
      idu_SLTIU_next = dcd_SLTIU;
      idu_SLTU_next = dcd_SLTU;
      idu_SRA_next = dcd_SRA;
      idu_SRL_next = dcd_SRL;
      idu_SUB_next = dcd_SUB | dcd_C_SUB;
      idu_SW_next = dcd_SW | dcd_C_SW | dcd_C_SWSP;
      idu_XOR_next = dcd_XOR | dcd_C_XOR;
      idu_XORI_next = dcd_XORI;

      idu_defined_next = dcd_defined;
      idu_compressed_next = dcd_compressed;

      idu_addr_next = ifu_addr;

      idu_data_next = ifu_data;
      if (dcd_compressed) begin
         idu_data_next[31:16] = '0;
      end

      idu_seq_next = idu_seq + 'd1;

   end

   always_ff @(posedge clock) begin
      idu_vld <= '0;
      idu_seq <= idu_seq;
      idu_addr <= idu_addr;
      idu_data <= idu_data;
      idu_defined <= idu_defined;
      if (ifu_vld) begin
         idu_vld <= '1;
         idu_seq <= idu_seq_next;
         idu_addr <= idu_addr_next;
         idu_data <= idu_data_next;
         idu_defined <= idu_defined_next;
      end

      if (reset) begin
         idu_vld <= '0;
         idu_seq <= '0;
      end
   end

endmodule : riscv_idu
