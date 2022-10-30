package axi4_pkg;

   typedef struct packed {
      logic          ACLK;
      logic          ARESETn;
   } common;

   typedef struct packed {
      logic          AWID;
      logic [31:0]   AWADDR;
      logic [7:0]    AWLEN;
      logic [2:0]    AWSIZE;
      logic [1:0]    AWBURST;
      logic          AWLOCK;
      logic [3:0]    AWCACHE;
      logic [2:0]    AWPROT;
      logic [3:0]    AWQOS;
      logic [3:0]    AWREGION;
      logic [7:0]    AWUSER;
      logic          AWVALID;
   } aw_m;

   typedef struct packed {
      logic          AWREADY;
   } aw_s;

   typedef struct packed {
      logic          WID;
      logic [31:0]   WDATA;
      logic [3:0]    WSTRB;
      logic          WLAST;
      logic [7:0]    WUSER;
      logic          WVALID;
   } w_m;

   typedef struct packed {
      logic          WREADY;
   } w_s;
   
   typedef struct packed {
      logic         BREADY;
   } b_m;

   typedef struct packed {
      logic         BID;
      logic [1:0]   BRESP;
      logic [7:0]   BUSER;
      logic         BVALID;
   } b_s;

   typedef struct packed {
      logic          ARID;
      logic [31:0]   ARADDR;
      logic [7:0]    ARLEN;
      logic [2:0]    ARSIZE;
      logic [1:0]    ARBURST;
      logic          ARLOCK;
      logic [3:0]    ARCACHE;
      logic [2:0]    ARPROT;
      logic [3:0]    ARQOS;
      logic [3:0]    ARREGION;
      logic [7:0]    ARUSER;
      logic          ARVALID;
   } ar_m;

   typedef struct packed {
      logic          ARREADY;
   } ar_s;

   typedef struct packed {
      logic          RREADY;
   } r_m;
   
   typedef struct packed {
      logic          RID;
      logic [31:0]   RDATA;
      logic [1:0]    RRESP;
      logic          RLAST;
      logic [7:0]    RUSER;
      logic          RVALID;
   } r_s;


endpackage: axi4_pkg