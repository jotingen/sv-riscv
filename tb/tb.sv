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

   logic [15:0] memory[int];
   function logic[31:0] memory_read(logic [31:0] addr);
      if(~memory.exists(addr[31:0]))
         begin
         memory[addr[31:0]][15:0] = $urandom();
         end
      if(~memory.exists(addr[31:0]+'d4))
         begin
         memory[addr[31:0]+'d4][15:0] = $urandom();
         end

      return   {  memory[addr[31:0]+'d4][15:0],
                  memory[addr[31:0]][15:0]   };
   endfunction


   class axi_aw_s_driver;
      rand logic ready;

      constraint c_ready { ready dist {0:=5,1:=95};}
   endclass

   class axi_ar_s_driver;
      rand logic ready;

      constraint c_ready { ready dist {0:=5,1:=95};}
   endclass

   axi4_pkg::ar_m AXI_AR_M_queue[1:0][$];
   class axi_ar_m_monitor;
      function run(  string tag,
                     axi4_pkg::ar_s AXI_AR_S,
                     axi4_pkg::ar_m AXI_AR_M);
         if(AXI_AR_M.ARVALID & AXI_AR_S.ARREADY)
            begin
            $display("%0t [AXI AR %s] %p", $time, tag, AXI_AR_M);
            AXI_AR_M_queue[tag.atoi()].push_back(AXI_AR_M);
            end
      endfunction
   endclass

   class axi_r_s_driver;
      axi4_pkg::r_s  AXI_R_S;
      function run(  string tag,
                     axi4_pkg::r_m AXI_R_M);
         AXI_R_S = {$bits(axi4_pkg::r_s){'x}};
         AXI_R_S.RVALID = '0;
         //Randomly check to send data
         if($urandom_range(0,1))
            begin
            //If M is ready
            if(AXI_R_M.RREADY)
               begin
               //If there is an AR entry
               if(AXI_AR_M_queue[tag.atoi()].size() > 0)
                  begin
                  int random_ndx = $urandom_range(0,AXI_AR_M_queue[tag.atoi()].size()-1);
                  axi4_pkg::ar_m ar_item = AXI_AR_M_queue[tag.atoi()][random_ndx];
                  AXI_AR_M_queue[tag.atoi()].delete(random_ndx);
                  AXI_R_S.RVALID = '1;
                  AXI_R_S.RID = ar_item.ARID;
                  AXI_R_S.RDATA[31:0] = memory_read(ar_item.ARADDR[31:0]);
                  $display("%0t [AXI R %s] %p", $time, tag, AXI_R_S);
                  end
               end
            end
      endfunction
   endclass

   axi_aw_s_driver axi_aw_s_0 = new();
   axi_ar_s_driver axi_ar_s_1 = new();
   axi_ar_s_driver axi_ar_s_0 = new();
   axi_r_s_driver axi_r_s_1 = new();
   axi_r_s_driver axi_r_s_0 = new();
   axi_ar_m_monitor axi_ar_m_1 = new();
   axi_ar_m_monitor axi_ar_m_0 = new();
   always_ff @(posedge clock)
      begin
      if(!axi_aw_s_0.randomize()) $fatal(1,"axi_aw_s randomization failed");
      AXI_AW_S[0].AWREADY <= axi_aw_s_0.ready;
      if(!axi_ar_s_1.randomize()) $fatal(1,"axi_ar_s randomization failed");
      AXI_AR_S[1].ARREADY <= axi_ar_s_1.ready;
      if(!axi_ar_s_0.randomize()) $fatal(1,"axi_ar_s randomization failed");
      AXI_AR_S[0].ARREADY <= axi_ar_s_0.ready;

      axi_ar_m_1.run("1",
                     AXI_AR_S[1],
                     AXI_AR_M[1]);
      axi_ar_m_0.run("0",
                     AXI_AR_S[0],
                     AXI_AR_M[0]);
      axi_r_s_1.run("1",
                    AXI_R_M[1]);
      axi_r_s_0.run("0",
                    AXI_R_M[0]);
      AXI_R_S[1] <= axi_r_s_1.AXI_R_S;
      AXI_R_S[0] <= axi_r_s_0.AXI_R_S;

      end

   riscv_top DUT(
      .AXI_COMMON(axi4_pkg::common'{ACLK:clock,ARESETn:~reset}),
      .AXI_AW_M(AXI_AW_M), 
      .*); 

   bind DUT axi4_assert axi4_riscv_assert_inst(
      .AXI_COMMON(DUT.AXI_COMMON), 
      .AXI_AW_M('0), 
      .AXI_AW_S('0),
      .AXI_W_M('0),
      .AXI_W_S('0),
      .AXI_B_M('0),
      .AXI_B_S('0),
      .AXI_AR_M({DUT.AXI_AR_M[1],{$bits(axi4_pkg::ar_m){'0}}}),
      .AXI_AR_S({DUT.AXI_AR_S[1],{$bits(axi4_pkg::ar_m){'0}}}),
      .AXI_R_M({DUT.AXI_R_M[1],{$bits(axi4_pkg::r_s){'0}}}),
      .AXI_R_S({DUT.AXI_R_S[1],{$bits(axi4_pkg::r_s){'0}}}),
      .*);

   always #10 clock =~ clock;

   initial begin
      reset = 1;
      #50;
      #0
      reset = 0;
   end

   initial begin
      clock = 0;
      reset = 1;
      #1000;
      //assert (sum == 5) else // Unless something went really wrong in the universe, we'd expect that 1+2=3
      //   $fatal(1, "Well if we cant add 1 and 2 to get 3 then we really screwed something up");
      $display("TB passed");
      $finish;
   end

endmodule : tb