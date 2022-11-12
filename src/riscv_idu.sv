import axi4_pkg::*;
import riscv_pkg::*;

module riscv_idu (
   input    logic                   clock,
   input    logic                   reset,

   input    logic                   ifu_vld,
   input    logic      [31:0]       ifu_addr,
   input    logic      [31:0]       ifu_data,

   output   logic                   idu_vld,
   output   logic      [31:0]       idu_addr,
   output   riscv_pkg::instr_type   idu_data
);

logic          ifu_is_compressed;
riscv_pkg::cinstr_type  ifu_cdata;
riscv_pkg::instr_type   ifu_cdata_converted;

logic          ifu_is_illegal;

always_comb
   begin
   ifu_is_illegal = '0;

   ifu_cdata = 
         ifu_data[15:0];

   ifu_is_compressed = 
         ifu_data[1:0] != 2'd11;

   unique case (ifu_cdata) inside
      //Illegal instruction
      //000 nzuimm[5:4|9:6|2|3] rd ′ 00 C.ADDI4SPN (RES, nzuimm=0)
      //001 uimm[5:3] rs1 ′ uimm[7:6] rd ′ 00 C.FLD (RV32/64)
      //001 uimm[5:4|8] rs1 ′ uimm[7:6] rd ′ 00 C.LQ (RV128)
      //010 uimm[5:3] rs1 ′ uimm[2|6] rd ′ 00 C.LW
      //011 uimm[5:3] rs1 ′ uimm[2|6] rd ′ 00 C.FLW (RV32)
      //011 uimm[5:3] rs1 ′ uimm[7:6] rd ′ 00 C.LD (RV64/128)
      //100 — 00 Reserved
      //101 uimm[5:3] rs1 ′ uimm[7:6] rs2 ′ 00 C.FSD (RV32/64)
      //101 uimm[5:4|8] rs1 ′ uimm[7:6] rs2 ′ 00 C.SQ (RV128)
      //110 uimm[5:3] rs1 ′ uimm[2|6] rs2 ′ 00 C.SW
      //111 uimm[5:3] rs1 ′ uimm[2|6] rs2 ′ 00 C.FSW (RV32)
      //111 uimm[5:3] rs1 ′ uimm[7:6] rs2 ′ 00 C.SD (RV64/128)
      //Table 16.5: Instruction listing for RVC, Quadrant 0.
      //Volume I: RISC-V Unprivileged ISA V20191213 113
      //15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
      //000 nzimm[5] 0 nzimm[4:0] 01 C.NOP (HINT, nzimm̸=0)
      //000 nzimm[5] rs1/rd̸=0 nzimm[4:0] 01 C.ADDI (HINT, nzimm=0)
      //001 imm[11|4|9:8|10|6|7|3:1|5] 01 C.JAL (RV32)
      //001 imm[5] rs1/rd̸=0 imm[4:0] 01 C.ADDIW (RV64/128; RES, rd=0)
      //010 imm[5] rd̸=0 imm[4:0] 01 C.LI (HINT, rd=0)
      //011 nzimm[9] 2 nzimm[4|6|8:7|5] 01 C.ADDI16SP (RES, nzimm=0)
      //011 nzimm[17] rd̸={0, 2} nzimm[16:12] 01 C.LUI (RES, nzimm=0; HINT, rd=0)
      //100 nzuimm[5] 00 rs1 ′/rd ′ nzuimm[4:0] 01 C.SRLI (RV32 NSE, nzuimm[5]=1)
      //100 0 00 rs1 ′/rd ′ 0 01 C.SRLI64 (RV128; RV32/64 HINT)
      //100 nzuimm[5] 01 rs1 ′/rd ′ nzuimm[4:0] 01 C.SRAI (RV32 NSE, nzuimm[5]=1)
      //100 0 01 rs1 ′/rd ′ 0 01 C.SRAI64 (RV128; RV32/64 HINT)
      //100 imm[5] 10 rs1 ′/rd ′
      //imm[4:0] 01 C.ANDI
      //100 0 11 rs1 ′/rd ′ 00 rs2 ′ 01 C.SUB
      //100 0 11 rs1 ′/rd ′ 01 rs2 ′ 01 C.XOR
      //100 0 11 rs1 ′/rd ′ 10 rs2 ′ 01 C.OR
      //100 0 11 rs1 ′/rd ′ 11 rs2 ′ 01 C.AND
      //100 1 11 rs1 ′/rd ′ 00 rs2 ′ 01 C.SUBW (RV64/128; RV32 RES)
      //100 1 11 rs1 ′/rd ′ 01 rs2 ′ 01 C.ADDW (RV64/128; RV32 RES)
      //100 1 11 — 10 — 01 Reserved
      //100 1 11 — 11 — 01 Reserved
      //101 imm[11|4|9:8|10|6|7|3:1|5] 01 C.J
      //110 imm[8|4:3] rs1 ′
      //imm[7:6|2:1|5] 01 C.BEQZ
      //111 imm[8|4:3] rs1 ′
      //imm[7:6|2:1|5] 01 C.BNEZ
      //Table 16.6: Instruction listing for RVC, Quadrant 1.
      //15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
      //000 nzuimm[5] rs1/rd̸=0 nzuimm[4:0] 10 C.SLLI (HINT, rd=0; RV32 NSE, nzuimm[5]=1)
      //000 0 rs1/rd̸=0 0 10 C.SLLI64 (RV128; RV32/64 HINT; HINT, rd=0)
      //001 uimm[5] rd uimm[4:3|8:6] 10 C.FLDSP (RV32/64)
      //001 uimm[5] rd̸=0 uimm[4|9:6] 10 C.LQSP (RV128; RES, rd=0)
      //010 uimm[5] rd̸=0 uimm[4:2|7:6] 10 C.LWSP (RES, rd=0)
      //011 uimm[5] rd uimm[4:2|7:6] 10 C.FLWSP (RV32)
      //011 uimm[5] rd̸=0 uimm[4:3|8:6] 10 C.LDSP (RV64/128; RES, rd=0)
      //100 0 rs1̸=0 0 10 C.JR (RES, rs1=0)
      //100 0 rd̸=0 rs2̸=0 10 C.MV (HINT, rd=0)
      //100 1 0 0 10 C.EBREAK
      //100 1 rs1̸=0 0 10 C.JALR
      //100 1 rs1/rd̸=0 rs2̸=0 10 C.ADD (HINT, rd=0)
      //101 uimm[5:3|8:6] rs2 10 C.FSDSP (RV32/64)
      //101 uimm[5:4|9:6] rs2 10 C.SQSP (RV128)
      //110 uimm[5:2|7:6] rs2 10 C.SWSP
      //111 uimm[5:2|7:6] rs2 10 C.FSWSP (RV32)
      //111 uimm[5:3|8:6] rs2 10 C.SDSP (RV64/128)

      default:
         begin
         ifu_is_illegal = '1;
         end
   endcase

   //If it was compressed, update data, else reset flags
   if( ifu_is_compressed )
      begin
      end
   else
      begin
      ifu_is_illegal = '0;
      end
   
   end


always_ff @(posedge clock)
   begin
   idu_vld <= ifu_vld;
   idu_addr <= ifu_addr;
   idu_data <= ifu_data;

   if( reset )
      begin
      idu_vld <= '0;
      end
   end

endmodule: riscv_idu