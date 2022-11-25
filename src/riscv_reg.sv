import riscv_pkg::*;

module riscv_reg (
    input logic clock,
    input logic reset,

    input logic [riscv_pkg::REGISTER_PORTS-1:0]       register_lock_en,
    input logic [riscv_pkg::REGISTER_PORTS-1:0][4:0] register_lock,

    input logic [riscv_pkg::REGISTER_PORTS-1:0]       register_write_en,
    input logic [riscv_pkg::REGISTER_PORTS-1:0][ 4:0] register_write,
    input logic [riscv_pkg::REGISTER_PORTS-1:0][31:0] register_write_data,

    output logic [31:0][31:0] register,
    output logic [31:0] register_locked
);


   always_ff @(posedge clock) begin
      register_locked[31:0] <= register_locked[31:0];
      register[31:0] <= register[31:0];

      for (int n = 0; n < riscv_pkg::REGISTER_PORTS; n++) begin
         if (register_write_en[n]) begin
            register_locked[register_write[n][4:0]] <= '0;
            register[register_write[n][4:0]][31:0]  <= register_write_data[n][31:0];
         end
      end

      for (int n = 0; n < riscv_pkg::REGISTER_PORTS; n++) begin
         if (register_lock_en[n]) begin
            register_locked[register_lock[n][4:0]] <= '1;
         end
      end

      //x0 is always 0, don't lock, don't write
      register_locked[0] <= '0;
      register[0][31:0] <= '0;

      if (reset) begin
         register[31:0] <= '0;
         register_locked[31:0] <= '0;
      end
   end

endmodule : riscv_reg
