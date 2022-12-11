package riscv_pkg;

   parameter REGISTER_PORTS = 2;

   typedef struct packed {
      logic [31:2] base;
      logic [1:0]  mode;
   } csr_mtvec_t;
   typedef struct packed {csr_mtvec_t mtvec;} csr_t;

   typedef struct packed {
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
      logic SLLI;
      logic SLT;
      logic SLTI;
      logic SLTIU;
      logic SLTU;
      logic SRA;
      logic SRAI;
      logic SRL;
      logic SRLI;
      logic SUB;
      logic SW;
      logic XOR;
      logic XORI;
      logic ILLEGAL;
   } op;

   typedef struct packed {
      logic [31:0] addr;
      logic [31:0] data;
   } ifu_t;

   typedef struct packed {
      logic [63:0]  seq;
      logic [31:0]  addr;
      logic [31:0]  addr_next;
      logic [31:0]  data;
      riscv_pkg::op op;
      logic         rd_used;
      logic [4:0]   rd;
      logic         rs1_used;
      logic [4:0]   rs1;
      logic         rs2_used;
      logic [4:0]   rs2;
      logic [31:0]  immed;
   } idu_t;

   typedef struct packed {
      logic [63:0] order;
      logic [31:0] insn;
      logic trap;
      logic halt;
      logic intr;
      logic [1:0] mode;
      logic [4:0] rs1_addr;
      logic [4:0] rs2_addr;
      logic [31:0] rs1_rdata;
      logic [31:0] rs2_rdata;
      logic [4:0] rd_addr;
      logic [31:0] rd_wdata;
      logic [31:0] pc_rdata;
      logic [31:0] pc_wdata;
      logic [31:0] mem_addr;
      logic [3:0] mem_rmask;
      logic [3:0] mem_wmask;
      logic [31:0] mem_rdata;
      logic [31:0] mem_wdata;
      logic mem_extamo;
   } rvfi_t;

endpackage : riscv_pkg
