import axi4_pkg::*;

module tb ();
   logic                clock;
   logic                reset;
   axi4_pkg::aw_m [0:0] AXI_AW_M;
   axi4_pkg::aw_s [0:0] AXI_AW_S;
   axi4_pkg::w_m  [0:0] AXI_W_M;
   axi4_pkg::w_s  [0:0] AXI_W_S;
   axi4_pkg::b_m  [0:0] AXI_B_M;
   axi4_pkg::b_s  [0:0] AXI_B_S;
   axi4_pkg::ar_m [1:0] AXI_AR_M;
   axi4_pkg::ar_s [1:0] AXI_AR_S;
   axi4_pkg::r_m  [1:0] AXI_R_M;
   axi4_pkg::r_s  [1:0] AXI_R_S;

   `include "riscv_decode_fn.svh"

   class instruction;
      rand logic [15:0] instr_cdata;

      logic [45:0] instr_op_ndx;

      function void pre_randomize();
         std::randomize(
             instr_op_ndx
         ) with {
            instr_op_ndx dist {
               45 := 100,  //ADD := 100,
               44 := 100,  //ADDI := 100,
               43 := 100,  //AND := 100,
               42 := 100,  //ANDI := 100,
               41 := 100,  //AUIPC := 100,
               40 := 100,  //BEQ := 100,
               39 := 100,  //BGE := 100,
               38 := 100,  //BGEU := 100,
               37 := 100,  //BLT := 100,
               36 := 100,  //BLTU := 100,
               35 := 100,  //BNE := 100,
               34 := 100,  //DIV := 100,
               33 := 100,  //DIVU := 100,
               32 := 100,  //EBREAK := 100,
               31 := 100,  //ECALL := 100,
               30 := 100,  //FENCE := 100,
               29 := 100,  //JAL := 100,
               28 := 100,  //JALR := 100,
               27 := 100,  //LB := 100,
               26 := 100,  //LBU := 100,
               25 := 100,  //LH := 100,
               24 := 100,  //LHU := 100,
               23 := 100,  //LUI := 100,
               22 := 100,  //LW := 100,
               21 := 100,  //MUL := 100,
               20 := 100,  //MULH := 100,
               19 := 100,  //MULHSU := 100,
               18 := 100,  //MULHU := 100,
               17 := 100,  //OR := 100,
               16 := 100,  //ORI := 100,
               15 := 100,  //REM := 100,
               14 := 100,  //REMU := 100,
               13 := 100,  //SB := 100,
               12 := 100,  //SH := 100,
               11 := 100,  //SLL := 100,
               10 := 100,  //SLT := 100,
               9  := 100,  //SLTI := 100,
               8  := 100,  //SLTIU := 100,
               7  := 100,  //SLTU := 100,
               6  := 100,  //SRA := 100,
               5  := 100,  //SRL := 100,
               4  := 100,  //SUB := 100,
               3  := 100,  //SW := 100,
               2  := 100,  //XOR := 100,
               1  := 100,  //XORI := 100,
               0  := 0  //ILLEGAL := 0
            };
         };
         $display("TEST: %d", instr_op_ndx);
      endfunction


      constraint cdata_c {
         riscv_decode_defined({16'd0, instr_cdata});
         riscv_decode_compressed({16'd0, instr_cdata});
      }

      function logic [31:0] data;
         do begin
            data = $urandom();
            if (instr_op_ndx == 45) begin
               data &= ~riscv_decode_addi_mask();
               data |= riscv_decode_add_match();
            end
            if (instr_op_ndx == 44) begin
               data &= ~riscv_decode_addi_mask();
               data |= riscv_decode_addi_match();
            end
            if (instr_op_ndx == 43) begin
               data &= ~riscv_decode_and_mask();
               data |= riscv_decode_and_match();
            end
            if (instr_op_ndx == 42) begin
               data &= ~riscv_decode_andi_mask();
               data |= riscv_decode_andi_match();
            end
            if (instr_op_ndx == 41) begin
               data &= ~riscv_decode_auipc_mask();
               data |= riscv_decode_auipc_match();
            end
            if (instr_op_ndx == 40) begin
               data &= ~riscv_decode_beq_mask();
               data |= riscv_decode_beq_match();
            end
            if (instr_op_ndx == 39) begin
               data &= ~riscv_decode_bge_mask();
               data |= riscv_decode_bge_match();
            end
            if (instr_op_ndx == 38) begin
               data &= ~riscv_decode_bgeu_mask();
               data |= riscv_decode_bgeu_match();
            end
            if (instr_op_ndx == 37) begin
               data &= ~riscv_decode_blt_mask();
               data |= riscv_decode_blt_match();
            end
            if (instr_op_ndx == 36) begin
               data &= ~riscv_decode_bltu_mask();
               data |= riscv_decode_bltu_match();
            end
            if (instr_op_ndx == 35) begin
               data &= ~riscv_decode_bne_mask();
               data |= riscv_decode_bne_match();
            end
            if (instr_op_ndx == 34) begin
               data &= ~riscv_decode_div_mask();
               data |= riscv_decode_div_match();
            end
            if (instr_op_ndx == 33) begin
               data &= ~riscv_decode_divu_mask();
               data |= riscv_decode_divu_match();
            end
            if (instr_op_ndx == 32) begin
               data &= ~riscv_decode_ebreak_mask();
               data |= riscv_decode_ebreak_match();
            end
            if (instr_op_ndx == 31) begin
               data &= ~riscv_decode_ecall_mask();
               data |= riscv_decode_ecall_match();
            end
            if (instr_op_ndx == 30) begin
               data &= ~riscv_decode_fence_mask();
               data |= riscv_decode_fence_match();
            end
            if (instr_op_ndx == 29) begin
               data &= ~riscv_decode_jal_mask();
               data |= riscv_decode_jal_match();
            end
            if (instr_op_ndx == 28) begin
               data &= ~riscv_decode_jalr_mask();
               data |= riscv_decode_jalr_match();
            end
            if (instr_op_ndx == 27) begin
               data &= ~riscv_decode_lb_mask();
               data |= riscv_decode_lb_match();
            end
            if (instr_op_ndx == 26) begin
               data &= ~riscv_decode_lbu_mask();
               data |= riscv_decode_lbu_match();
            end
            if (instr_op_ndx == 25) begin
               data &= ~riscv_decode_lh_mask();
               data |= riscv_decode_lh_match();
            end
            if (instr_op_ndx == 24) begin
               data &= ~riscv_decode_lhu_mask();
               data |= riscv_decode_lhu_match();
            end
            if (instr_op_ndx == 23) begin
               data &= ~riscv_decode_lui_mask();
               data |= riscv_decode_lui_match();
            end
            if (instr_op_ndx == 22) begin
               data &= ~riscv_decode_lw_mask();
               data |= riscv_decode_lw_match();
            end
            if (instr_op_ndx == 21) begin
               data &= ~riscv_decode_mul_mask();
               data |= riscv_decode_mul_match();
            end
            if (instr_op_ndx == 20) begin
               data &= ~riscv_decode_mulh_mask();
               data |= riscv_decode_mulh_match();
            end
            if (instr_op_ndx == 19) begin
               data &= ~riscv_decode_mulhsu_mask();
               data |= riscv_decode_mulhsu_match();
            end
            if (instr_op_ndx == 18) begin
               data &= ~riscv_decode_mulhu_mask();
               data |= riscv_decode_mulhu_match();
            end
            if (instr_op_ndx == 17) begin
               data &= ~riscv_decode_or_mask();
               data |= riscv_decode_or_match();
            end
            if (instr_op_ndx == 16) begin
               data &= ~riscv_decode_ori_mask();
               data |= riscv_decode_ori_match();
            end
            if (instr_op_ndx == 15) begin
               data &= ~riscv_decode_rem_mask();
               data |= riscv_decode_rem_match();
            end
            if (instr_op_ndx == 14) begin
               data &= ~riscv_decode_remu_mask();
               data |= riscv_decode_remu_match();
            end
            if (instr_op_ndx == 13) begin
               data &= ~riscv_decode_sb_mask();
               data |= riscv_decode_sb_match();
            end
            if (instr_op_ndx == 12) begin
               data &= ~riscv_decode_sh_mask();
               data |= riscv_decode_sh_match();
            end
            if (instr_op_ndx == 11) begin
               data &= ~riscv_decode_sll_mask();
               data |= riscv_decode_sll_match();
            end
            if (instr_op_ndx == 10) begin
               data &= ~riscv_decode_slt_mask();
               data |= riscv_decode_slt_match();
            end
            if (instr_op_ndx == 9) begin
               data &= ~riscv_decode_slti_mask();
               data |= riscv_decode_slti_match();
            end
            if (instr_op_ndx == 8) begin
               data &= ~riscv_decode_sltiu_mask();
               data |= riscv_decode_sltiu_match();
            end
            if (instr_op_ndx == 7) begin
               data &= ~riscv_decode_sltu_mask();
               data |= riscv_decode_sltu_match();
            end
            if (instr_op_ndx == 6) begin
               data &= ~riscv_decode_sra_mask();
               data |= riscv_decode_sra_match();
            end
            if (instr_op_ndx == 5) begin
               data &= ~riscv_decode_srl_mask();
               data |= riscv_decode_srl_match();
            end
            if (instr_op_ndx == 4) begin
               data &= ~riscv_decode_sub_mask();
               data |= riscv_decode_sub_match();
            end
            if (instr_op_ndx == 3) begin
               data &= ~riscv_decode_sw_mask();
               data |= riscv_decode_sw_match();
            end
            if (instr_op_ndx == 2) begin
               data &= ~riscv_decode_xor_mask();
               data |= riscv_decode_xor_match();
            end
            if (instr_op_ndx == 1) begin
               data &= ~riscv_decode_xori_mask();
               data |= riscv_decode_xori_match();
            end

         end while (!(((instr_op_ndx == 45) & riscv_decode_add(
             data
         )) | ((instr_op_ndx == 44) & riscv_decode_addi(
             data
         )) | ((instr_op_ndx == 43) & riscv_decode_and(
             data
         )) | ((instr_op_ndx == 42) & riscv_decode_andi(
             data
         )) | ((instr_op_ndx == 41) & riscv_decode_auipc(
             data
         )) | ((instr_op_ndx == 40) & riscv_decode_beq(
             data
         )) | ((instr_op_ndx == 39) & riscv_decode_bge(
             data
         )) | ((instr_op_ndx == 38) & riscv_decode_bgeu(
             data
         )) | ((instr_op_ndx == 37) & riscv_decode_blt(
             data
         )) | ((instr_op_ndx == 36) & riscv_decode_bltu(
             data
         )) | ((instr_op_ndx == 35) & riscv_decode_bne(
             data
         )) | ((instr_op_ndx == 34) & riscv_decode_div(
             data
         )) | ((instr_op_ndx == 33) & riscv_decode_divu(
             data
         )) | ((instr_op_ndx == 32) & riscv_decode_ebreak(
             data
         )) | ((instr_op_ndx == 31) & riscv_decode_ecall(
             data
         )) | ((instr_op_ndx == 30) & riscv_decode_fence(
             data
         )) | ((instr_op_ndx == 29) & riscv_decode_jal(
             data
         )) | ((instr_op_ndx == 28) & riscv_decode_jalr(
             data
         )) | ((instr_op_ndx == 27) & riscv_decode_lb(
             data
         )) | ((instr_op_ndx == 26) & riscv_decode_lbu(
             data
         )) | ((instr_op_ndx == 25) & riscv_decode_lh(
             data
         )) | ((instr_op_ndx == 24) & riscv_decode_lhu(
             data
         )) | ((instr_op_ndx == 23) & riscv_decode_lui(
             data
         )) | ((instr_op_ndx == 22) & riscv_decode_lw(
             data
         )) | ((instr_op_ndx == 21) & riscv_decode_mul(
             data
         )) | ((instr_op_ndx == 20) & riscv_decode_mulh(
             data
         )) | ((instr_op_ndx == 19) & riscv_decode_mulhsu(
             data
         )) | ((instr_op_ndx == 18) & riscv_decode_mulhu(
             data
         )) | ((instr_op_ndx == 17) & riscv_decode_or(
             data
         )) | ((instr_op_ndx == 16) & riscv_decode_ori(
             data
         )) | ((instr_op_ndx == 15) & riscv_decode_rem(
             data
         )) | ((instr_op_ndx == 14) & riscv_decode_remu(
             data
         )) | ((instr_op_ndx == 13) & riscv_decode_sb(
             data
         )) | ((instr_op_ndx == 12) & riscv_decode_sh(
             data
         )) | ((instr_op_ndx == 11) & riscv_decode_sll(
             data
         )) | ((instr_op_ndx == 10) & riscv_decode_slt(
             data
         )) | ((instr_op_ndx == 9) & riscv_decode_slti(
             data
         )) | ((instr_op_ndx == 8) & riscv_decode_sltiu(
             data
         )) | ((instr_op_ndx == 7) & riscv_decode_sltu(
             data
         )) | ((instr_op_ndx == 6) & riscv_decode_sra(
             data
         )) | ((instr_op_ndx == 5) & riscv_decode_srl(
             data
         )) | ((instr_op_ndx == 4) & riscv_decode_sub(
             data
         )) | ((instr_op_ndx == 3) & riscv_decode_sw(
             data
         )) | ((instr_op_ndx == 2) & riscv_decode_xor(
             data
         )) | ((instr_op_ndx == 1) & riscv_decode_xori(
             data
         )) | ((instr_op_ndx == 0) & !riscv_decode_defined(
             data
         ))));
         return data;
      endfunction

      function logic [15:0] cdata;
         return instr_cdata;
      endfunction

      function string disasm(input [31:0] data);

         if (riscv_decode_add(data)) begin
            return "ADD";
         end else if (riscv_decode_addi(data)) begin
            return "ADDI";
         end else if (riscv_decode_and(data)) begin
            return "AND";
         end else if (riscv_decode_andi(data)) begin
            return "ANDI";
         end else if (riscv_decode_auipc(data)) begin
            return "AUIPC";
         end else if (riscv_decode_beq(data)) begin
            return "BEQ";
         end else if (riscv_decode_bge(data)) begin
            return "BGE";
         end else if (riscv_decode_bgeu(data)) begin
            return "BGEU";
         end else if (riscv_decode_blt(data)) begin
            return "BLT";
         end else if (riscv_decode_bltu(data)) begin
            return "BLTU";
         end else if (riscv_decode_bne(data)) begin
            return "BNE";
         end else if (riscv_decode_c_add(data)) begin
            return "C.ADD";
         end else if (riscv_decode_c_addi(data)) begin
            return "C.ADDI";
         end else if (riscv_decode_c_addi16sp(data)) begin
            return "C.ADDI16SP";
         end else if (riscv_decode_c_addi4spn(data)) begin
            return "C.ADDI4SPN";
         end else if (riscv_decode_c_and(data)) begin
            return "C.AND";
         end else if (riscv_decode_c_andi(data)) begin
            return "C.ANDI";
         end else if (riscv_decode_c_beqz(data)) begin
            return "C.BEQZ";
         end else if (riscv_decode_c_bnez(data)) begin
            return "C.BNEZ";
         end else if (riscv_decode_c_ebreak(data)) begin
            return "C.EBREAK";
         end else if (riscv_decode_c_j(data)) begin
            return "C.J";
         end else if (riscv_decode_c_jal(data)) begin
            return "C.JAL";
         end else if (riscv_decode_c_jalr(data)) begin
            return "C.JALR";
         end else if (riscv_decode_c_jr(data)) begin
            return "C.JR";
         end else if (riscv_decode_c_li(data)) begin
            return "C.LI";
         end else if (riscv_decode_c_lui(data)) begin
            return "C.LUI";
         end else if (riscv_decode_c_lw(data)) begin
            return "C.LW";
         end else if (riscv_decode_c_lwsp(data)) begin
            return "C.LWSP";
         end else if (riscv_decode_c_mv(data)) begin
            return "C.MV";
         end else if (riscv_decode_c_nop(data)) begin
            return "C.NOP";
         end else if (riscv_decode_c_or(data)) begin
            return "C.OR";
         end else if (riscv_decode_c_sub(data)) begin
            return "C.SUB";
         end else if (riscv_decode_c_sw(data)) begin
            return "C.SW";
         end else if (riscv_decode_c_swsp(data)) begin
            return "C.SWSP";
         end else if (riscv_decode_c_xor(data)) begin
            return "C.XOR";
         end else if (riscv_decode_div(data)) begin
            return "DIV";
         end else if (riscv_decode_divu(data)) begin
            return "DIVU";
         end else if (riscv_decode_ebreak(data)) begin
            return "EBREAK";
         end else if (riscv_decode_ecall(data)) begin
            return "ECALL";
         end else if (riscv_decode_fence(data)) begin
            return "FENCE";
         end else if (riscv_decode_jal(data)) begin
            return "JAL";
         end else if (riscv_decode_jalr(data)) begin
            return "JALR";
         end else if (riscv_decode_lb(data)) begin
            return "LB";
         end else if (riscv_decode_lbu(data)) begin
            return "LBU";
         end else if (riscv_decode_lh(data)) begin
            return "LH";
         end else if (riscv_decode_lhu(data)) begin
            return "LHU";
         end else if (riscv_decode_lui(data)) begin
            return "LUI";
         end else if (riscv_decode_lw(data)) begin
            return "LW";
         end else if (riscv_decode_mul(data)) begin
            return "MUL";
         end else if (riscv_decode_mulh(data)) begin
            return "MULH";
         end else if (riscv_decode_mulhsu(data)) begin
            return "MULHSU";
         end else if (riscv_decode_mulhu(data)) begin
            return "MULHU";
         end else if (riscv_decode_or(data)) begin
            return "OR";
         end else if (riscv_decode_ori(data)) begin
            return "ORI";
         end else if (riscv_decode_rem(data)) begin
            return "REM";
         end else if (riscv_decode_remu(data)) begin
            return "REMU";
         end else if (riscv_decode_sb(data)) begin
            return "SB";
         end else if (riscv_decode_sh(data)) begin
            return "SH";
         end else if (riscv_decode_sll(data)) begin
            return "SLL";
         end else if (riscv_decode_slt(data)) begin
            return "SLT";
         end else if (riscv_decode_slti(data)) begin
            return "SLTI";
         end else if (riscv_decode_sltiu(data)) begin
            return "SLTIU";
         end else if (riscv_decode_sltu(data)) begin
            return "SLTU";
         end else if (riscv_decode_sra(data)) begin
            return "SRA";
         end else if (riscv_decode_srl(data)) begin
            return "SRL";
         end else if (riscv_decode_sub(data)) begin
            return "SUB";
         end else if (riscv_decode_sw(data)) begin
            return "SW";
         end else if (riscv_decode_xor(data)) begin
            return "XOR";
         end else if (riscv_decode_xori(data)) begin
            return "XORI";
         end else begin
            return "ILLEGAL";
         end


         return;

      endfunction

   endclass


   class memory;
      rand logic compressed_0;
      rand logic compressed_1;
      logic [15:0] memory[int];

      instruction inst = new();

      constraint c_compressed_0 {
         compressed_0 dist {
            0 := 95,
            1 := 5
         };
      }
      constraint c_compressed_1 {
         compressed_1 dist {
            0 := 95,
            1 := 5
         };
      }

      function automatic logic [31:0] memory_read(logic [31:0] addr);
         //For now only generate valid instructions
         if (!memory.exists(
                 addr[31:1] + 'd2
             ) && !memory.exists(
                 addr[31:1] + 'd1
             ) && !memory.exists(
                 addr[31:1]
             )) begin
            if (compressed_0) begin
               while (!inst.randomize());
               memory[addr[31:1]][15:0] = inst.cdata();
               $display("%0t [MEM] Created - Addr:%08x Data:%04x %s", $time, addr,
                        memory[addr[31:1]][15:0], inst.disasm(memory[addr[31:1]][15:0]));
               if (compressed_1) begin
                  while (!inst.randomize());
                  memory[addr[31:1]+'d1][15:0] = inst.cdata();
                  $display("%0t [MEM] Created - Addr:%08x Data:%04x %s", $time, addr + 'd2,
                           memory[addr[31:1]+'d1][15:0], inst.disasm(memory[addr[31:1]+'d1][15:0]));
               end else begin
                  while (!inst.randomize());
                  {memory[addr[31:1]+'d2][15:0], memory[addr[31:1]+'d1][15:0]} = inst.data();
                  $display("%0t [MEM] Created - Addr:%08x Data:%08x %s", $time, addr + 'd2, {
                           memory[addr[31:1]+'d2][15:0], memory[addr[31:1]+'d1][15:0]}, inst.disasm(
                           {memory[addr[31:1]+'d2][15:0], memory[addr[31:1]+'d1][15:0]}));
               end
            end else begin
               while (!inst.randomize());
               {memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]} = inst.data();
               $display("%0t [MEM] Created - Addr:%08x Data:%08x %s", $time, addr, {
                        memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]}, inst.disasm(
                        {memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]}));
            end
         end else if (!memory.exists(addr[31:1] + 'd1) && !memory.exists(addr[31:1])) begin
            if (compressed_0) begin
               while (!inst.randomize());
               memory[addr[31:1]][15:0] = inst.cdata();
               $display("%0t [MEM] Created - Addr:%08x Data:%04x %s", $time, addr,
                        memory[addr[31:1]][15:0], inst.disasm(memory[addr[31:1]][15:0]));
               while (!inst.randomize());
               memory[addr[31:1]+'d1][15:0] = inst.cdata();
               $display("%0t [MEM] Created - Addr:%08x Data:%04x %s", $time, addr + 'd2,
                        memory[addr[31:1]+'d1][15:0], inst.disasm(memory[addr[31:1]+'d1][15:0]));
            end else begin
               while (!inst.randomize());
               {memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]} = inst.data();
               $display("%0t [MEM] Created - Addr:%08x Data:%08x %s", $time, addr, {
                        memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]}, inst.disasm(
                        {memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]}));
            end
         end else begin
            if (!memory.exists(addr[31:1])) begin
               while (!inst.randomize());
               memory[addr[31:1]][15:0] = inst.cdata();
               $display("%0t [MEM] Created - Addr:%08x Data:%04x %s", $time, addr,
                        memory[addr[31:1]][15:0], inst.disasm(memory[addr[31:1]][15:0]));
            end
            if (!memory.exists(addr[31:1] + 'd1)) begin
               while (!inst.randomize());
               memory[addr[31:1]+'d1][15:0] = inst.cdata();
               $display("%0t [MEM] Created - Addr:%08x Data:%04x %s", $time, addr + 'd2,
                        memory[addr[31:1]+'d1][15:0], inst.disasm(memory[addr[31:1]+'d1][15:0]));
            end
         end
         return {memory[addr[31:1]+'d1][15:0], memory[addr[31:1]][15:0]};
      endfunction
   endclass


   class axi_aw_s_driver;
      rand logic ready;

      constraint c_ready {
         ready dist {
            0 := 5,
            1 := 95
         };
      }
   endclass

   class axi_ar_s_driver;
      rand logic ready;

      constraint c_ready {
         ready dist {
            0 := 5,
            1 := 95
         };
      }
   endclass

   axi4_pkg::ar_m AXI_AR_M_queue[1:0][$];
   class axi_ar_m_monitor;
      function run(string tag, axi4_pkg::ar_s AXI_AR_S, axi4_pkg::ar_m AXI_AR_M);
         if (AXI_AR_M.ARVALID & AXI_AR_S.ARREADY) begin
            $display("%0t [AXI AR %s] %p", $time, tag, AXI_AR_M);
            AXI_AR_M_queue[tag.atoi()].push_back(AXI_AR_M);
            $display("%0t [AXI AR %s] Done", $time, tag);
         end
      endfunction
   endclass

   class axi_r_s_driver;
      axi4_pkg::r_s AXI_R_S;
      function run(string tag, axi4_pkg::r_m AXI_R_M);
         AXI_R_S = {$bits(axi4_pkg::r_s) {'x}};
         AXI_R_S.RVALID = '0;
         //Randomly check to send data
         if ($urandom_range(0, 1)) begin
            //If M is ready
            if (AXI_R_M.RREADY) begin
               //If there is an AR entry
               if (AXI_AR_M_queue[tag.atoi()].size() > 0) begin
                  int random_ndx = $urandom_range(0, AXI_AR_M_queue[tag.atoi()].size() - 1);
                  axi4_pkg::ar_m ar_item = AXI_AR_M_queue[tag.atoi()][random_ndx];
                  AXI_AR_M_queue[tag.atoi()].delete(random_ndx);
                  AXI_R_S.RVALID = '1;
                  AXI_R_S.RID = ar_item.ARID;
                  AXI_R_S.RDATA[31:0] = mem.memory_read(ar_item.ARADDR[31:0]);
                  $display("%0t [AXI R %s] %p", $time, tag, AXI_R_S);
               end
            end
         end
      endfunction
   endclass

   memory mem = new();
   axi_aw_s_driver axi_aw_s_0 = new();
   axi_ar_s_driver axi_ar_s_1 = new();
   axi_ar_s_driver axi_ar_s_0 = new();
   axi_r_s_driver axi_r_s_1 = new();
   axi_r_s_driver axi_r_s_0 = new();
   axi_ar_m_monitor axi_ar_m_1 = new();
   axi_ar_m_monitor axi_ar_m_0 = new();
   always_ff @(posedge clock) begin
      if (!mem.randomize()) $fatal(1, "mem randomization failed");

      if (!axi_aw_s_0.randomize()) $fatal(1, "axi_aw_s randomization failed");
      AXI_AW_S[0].AWREADY <= axi_aw_s_0.ready;
      if (!axi_ar_s_1.randomize()) $fatal(1, "axi_ar_s randomization failed");
      AXI_AR_S[1].ARREADY <= axi_ar_s_1.ready;
      if (!axi_ar_s_0.randomize()) $fatal(1, "axi_ar_s randomization failed");
      AXI_AR_S[0].ARREADY <= axi_ar_s_0.ready;

      axi_ar_m_1.run("1", AXI_AR_S[1], AXI_AR_M[1]);
      axi_ar_m_0.run("0", AXI_AR_S[0], AXI_AR_M[0]);
      axi_r_s_1.run("1", AXI_R_M[1]);
      axi_r_s_0.run("0", AXI_R_M[0]);
      AXI_R_S[1] <= axi_r_s_1.AXI_R_S;
      AXI_R_S[0] <= axi_r_s_0.AXI_R_S;

   end

   riscv_top DUT (
       .AXI_COMMON(axi4_pkg::common'{ACLK: clock, ARESETn: ~reset}),
       .AXI_AW_M  (AXI_AW_M),
       .*
   );

   bind DUT axi4_assert axi4_riscv_assert_inst (
       .AXI_COMMON(DUT.AXI_COMMON),
       .AXI_AW_M('0),
       .AXI_AW_S('0),
       .AXI_W_M('0),
       .AXI_W_S('0),
       .AXI_B_M('0),
       .AXI_B_S('0),
       .AXI_AR_M({DUT.AXI_AR_M[1], {$bits(axi4_pkg::ar_m) {'0}}}),
       .AXI_AR_S({DUT.AXI_AR_S[1], {$bits(axi4_pkg::ar_m) {'0}}}),
       .AXI_R_M({DUT.AXI_R_M[1], {$bits(axi4_pkg::r_s) {'0}}}),
       .AXI_R_S({DUT.AXI_R_S[1], {$bits(axi4_pkg::r_s) {'0}}}),
       .*
   );

   bind DUT.idu riscv_idu_assert riscv_idu_assert_inst (.*);

   always #10 clock = ~clock;

   initial begin
      reset = 1;
      #50;
      #0 reset = 0;
   end

   initial begin
      clock = 0;
      reset = 1;
      #100000;
      $display("TB passed");
      $finish;
   end

endmodule : tb
