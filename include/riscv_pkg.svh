package riscv_pkg;

   //typedef enum {

   //}

   typedef struct packed {
      logic [31:25]  funct7;
      logic [24:20]  rs2;
      logic [19:15]  rs1;
      logic [14:12]  funct3;
      logic [11:7]   rd;
      logic [6:0]    opcode;
   } r_type;
   typedef struct packed {
      logic [31:20]  imm_11_0;
      logic [19:15]  rs1;
      logic [14:12]  funct3;
      logic [11:7]   rd;
      logic [6:0]    opcode;
   } i_type;
   typedef struct packed {
      logic [31:25]  imm_11_5;
      logic [24:20]  rs2;
      logic [19:15]  rs1;
      logic [14:12]  funct3;
      logic [11:7]   imm_4_0;
      logic [6:0]    opcode;
   } s_type;
   typedef struct packed {
      logic [31:31]  imm_12;
      logic [30:25]  imm_10_5;
      logic [24:20]  rs2;
      logic [19:15]  rs1;
      logic [14:12]  funct3;
      logic [11:8]   imm_4_1;
      logic [7:7]    imm_11;
      logic [6:0]    opcode;
   } b_type;
   typedef struct packed {
      logic [31:12]  imm_31_12;
      logic [11:7]   rd;
      logic [6:0]    opcode;
   } u_type;
   typedef struct packed {
      logic [31:31]  imm_20;
      logic [30:21]  imm_10_1;
      logic [20:20]  imm_11;
      logic [19:12]  imm_19_12;
      logic [11:7]   rd;
      logic [6:0]    opcode;
   } j_type;

   typedef union packed {
      r_type   r;
      i_type   i;
      s_type   s;
      b_type   b;
      u_type   u;
      j_type   j;
   } instr_type;

   typedef struct packed {
      logic [15:12]  funct4;
      logic [11:7]   rd_rs1;
      logic [6:2]    rs2;
      logic [1:0]    opcode;
   } cr_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:12]  imm_hi;
      logic [11:7]   rd_rs1;
      logic [6:2]    imm_lo;
      logic [1:0]    opcode;
   } ci_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:7]   imm;
      logic [6:2]    rs2;
      logic [1:0]    opcode;
   } css_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:5]   imm;
      logic [4:2]    rd_p;
      logic [1:0]    opcode;
   } ciw_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:10]  imm_hi;
      logic [9:7]    rs1_p;
      logic [6:5]    imm_lo;
      logic [4:2]    rd_p;
      logic [1:0]    opcode;
   } cl_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:10]  imm_hi;
      logic [9:7]    rs1_p;
      logic [6:5]    imm_lo;
      logic [4:2]    rs2_p;
      logic [1:0]    opcode;
   } cs_type;
   typedef struct packed {
      logic [15:10]  funct6;
      logic [9:7]    rd_rs1_p;
      logic [6:5]    funct2;
      logic [4:2]    rs2_p;
      logic [1:0]    opcode;
   } ca_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:10]  offset_hi;
      logic [9:7]    rs1_p;
      logic [6:2]    offset_lo;
      logic [1:0]    opcode;
   } cb_type;
   typedef struct packed {
      logic [15:13]  funct3;
      logic [12:2]   jumpt_target;
      logic [1:0]    opcode;
   } cj_type;

   typedef union packed {
      cr_type   cr;
      ci_type   ci;
      css_type  css;
      ciw_type  ciw;
      cl_type   cl;
      cs_type   cs;
      ca_type   ca;
      cb_type   cb;
      cj_type   cj;
   } cinstr_type;


endpackage: riscv_pkg