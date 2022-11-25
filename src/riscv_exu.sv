import axi4_pkg::*;
import riscv_pkg::*;

module riscv_exu (
    input logic clock,
    input logic reset,

    input axi4_pkg::aw_s AXI_AW_S,
    input axi4_pkg::w_s  AXI_W_S,
    input axi4_pkg::b_s  AXI_B_S,
    input axi4_pkg::ar_s AXI_AR_S,
    input axi4_pkg::r_s  AXI_R_S,

    output axi4_pkg::aw_m AXI_AW_M,
    output axi4_pkg::w_m  AXI_W_M,
    output axi4_pkg::b_m  AXI_B_M,
    output axi4_pkg::ar_m AXI_AR_M,
    output axi4_pkg::r_m  AXI_R_M,

    input logic            idu_vld,
    input riscv_pkg::idu_t idu,

    input logic [31:0][31:0] register,
    input logic [31:0] register_locked,

    output logic [riscv_pkg::REGISTER_PORTS-1:0]      register_lock_en,
    output logic [riscv_pkg::REGISTER_PORTS-1:0][4:0] register_lock,

    output logic [riscv_pkg::REGISTER_PORTS-1:0]       register_write_en,
    output logic [riscv_pkg::REGISTER_PORTS-1:0][ 4:0] register_write,
    output logic [riscv_pkg::REGISTER_PORTS-1:0][31:0] register_write_data,

    output logic hold,

    output logic [riscv_pkg::REGISTER_PORTS-1:0] rvfi_valid,
    output riscv_pkg::rvfi_t [riscv_pkg::REGISTER_PORTS-1:0] rvfi
);

   logic alu_vld;
   logic alu_done;

   //Based on idu op, determine what block should process and if it can
   always_comb begin
      hold = '0;
      alu_vld = '0;
      register_lock_en = '0;

      if (idu_vld) begin
         if(  idu.op.ADD
            | idu.op.ADDI
            | idu.op.AND
            | idu.op.ANDI
            | idu.op.AUIPC
            | idu.op.DIV
            | idu.op.DIVU
            | idu.op.MUL
            | idu.op.MULH
            | idu.op.MULHSU
            | idu.op.MULHU
            | idu.op.OR
            | idu.op.ORI
            | idu.op.REM
            | idu.op.REMU
            | idu.op.SLL
            | idu.op.SLT
            | idu.op.SLTI
            | idu.op.SLTIU
            | idu.op.SLTU
            | idu.op.SRA
            | idu.op.SRL
            | idu.op.SUB
            | idu.op.XOR
            | idu.op.XORI )
            if (alu_vld & ~alu_done) begin
               hold = '1;
            end else begin
               alu_vld = '1;
               if (idu.rd_used) begin
                  register_lock_en[0]   = '1;
                  register_lock[0][4:0] = idu.rd[4:0];
               end
            end
      end
   end

   riscv_exu_alu riscv_exu_alu (
       .clock(clock),
       .reset(reset),

       .vld(alu_vld),
       .idu(idu),

       .rs1_data(register[idu.rs1][31:0]),
       .rs2_data(register[idu.rs2][31:0]),

       .register_write_en  (register_write_en[0]),
       .register_write     (register_write[0][4:0]),
       .register_write_data(register_write_data[0][31:0]),

       .done(alu_done),

       .rvfi_valid(rvfi_valid[0]),
       .rvfi      (rvfi[0])
   );


endmodule : riscv_exu
