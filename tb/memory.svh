//Class for memory block

class memory;
   rand logic compressed_0;
   rand logic compressed_1;
   logic [15:0] memory[int];

   instruction inst = new();

   constraint c_compressed_0 {
      compressed_0 dist {
         0 := 40,
         1 := 60
      };
   }
   constraint c_compressed_1 {
      compressed_1 dist {
         0 := 40,
         1 := 60
      };
   }

   function automatic void reset();
      memory.delete();
   endfunction

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

