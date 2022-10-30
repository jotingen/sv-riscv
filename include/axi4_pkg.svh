package axi4_pkg;

   typedef struct packed {
      logic       ACLK;
      logic       ARESETn;
   } common;

   typedef struct packed {
      logic       AWID;
      logic       AWADDR;
      logic       AWLEN;
      logic       AWSIZE;
      logic       AWBURST;
      logic       AWLOCK;
      logic       AWCACHE;
      logic       AWPROT;
      logic       AWQOS;
      logic       AWREGION;
      logic       AWUSER;
      logic       AWVALID;
   } aw_m;

   typedef struct packed {
      logic       AWREADY;
   } aw_s;

   typedef struct packed {
      logic       WID;
      logic       WDATA;
      logic       WSTRB;
      logic       WLAST;
      logic       WUSER;
      logic       WVALID;
   } w_m;

   typedef struct packed {
      logic       WREADY;
   } w_s;
   
   typedef struct packed {
      logic       BREADY;
   } b_m;

   typedef struct packed {
      logic       BID;
      logic       BRESP;
      logic       BUSER;
      logic       BVALID;
   } b_s;


endpackage: axi4_pkg