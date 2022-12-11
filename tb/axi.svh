//Classes for AXI interfaces

import axi4_pkg::*;

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

   function automatic void reset(string tag);
      AXI_AR_M_queue[tag.atoi()].delete();
   endfunction

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

