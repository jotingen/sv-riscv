import riscv_pkg::*;

module riscv_exu_alu (
    input logic clock,
    input logic reset,

    input logic            vld,
    input riscv_pkg::idu_t idu,

    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,

    output logic        register_write_en,
    output logic [ 5:0] register_write,
    output logic [31:0] register_write_data,

    output logic done
);

    always_ff @(posedge clock) begin
        done <= '0;

        register_write_en <= '0;
        register_write[5:0] <= register_write[5:0];
        register_write_data[31:0] <= register_write_data[31:0];

        if(vld) begin
            register_write[5:0] <= idu.rd[5:0];
         if(  idu.op.ADD ) begin
            done <= '1;
            register_write_en <= '1;
            register_write_data[31:0] <= rs1_data[31:0] + rs2_data[31:0];
         end
         if( idu.op.ADDI ) begin
            done <= '1;
            register_write_en <= '1;
            register_write_data[31:0] <= rs1_data[31:0] + idu.immed[31:0];
         end
         if( idu.op.AND ) begin
            //TODO
         end
         if( idu.op.ANDI ) begin
            //TODO
         end
         if( idu.op.AUIPC ) begin
            //TODO
         end
         if( idu.op.DIV ) begin
            //TODO
         end
         if( idu.op.DIVU ) begin
            //TODO
         end
         if( idu.op.MUL ) begin
            //TODO
         end
         if( idu.op.MULH ) begin
            //TODO
         end
         if( idu.op.MULHSU ) begin
            //TODO
         end
         if( idu.op.MULHU ) begin
            //TODO
         end
         if( idu.op.OR ) begin
            //TODO
         end
         if( idu.op.ORI ) begin
            //TODO
         end
         if( idu.op.REM ) begin
            //TODO
         end
         if( idu.op.REMU ) begin
            //TODO
         end
         if( idu.op.SLL ) begin
            //TODO
         end
         if( idu.op.SLT ) begin
            //TODO
         end
         if( idu.op.SLTI ) begin
            //TODO
         end
         if( idu.op.SLTIU ) begin
            //TODO
         end
         if( idu.op.SLTU ) begin
            //TODO
         end
         if( idu.op.SRA ) begin
            //TODO
         end
         if( idu.op.SRL ) begin
            //TODO
         end
         if( idu.op.SUB ) begin
            //TODO
         end
         if( idu.op.XOR ) begin
            //TODO
         end
         if( idu.op.XORI ) begin
            //TODO
         end 
        end


        if(reset) begin
            done <= '0;
            register_write_en <= '0;
        end
    end

endmodule : riscv_exu_alu
