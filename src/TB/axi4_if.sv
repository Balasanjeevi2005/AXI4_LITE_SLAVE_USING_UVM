interface (input logic ACLK);
  logic ARESETn;
  logic[`ADDR_WIDTH-1:0]AWADDR;
  logic[2:0]AWPROT;
  logic AWVALID;
  logic AWREADY;
  
  logic[`DATA_WIDTH-1:0]WDATA;
  logic[(`DATA_WIDTH/8)-1:0]WSTRB;
  logic WVALID;
  logic WREADY;
  
  logic[1:0] BRESP;
  logic BVALID;
  logic BREADY;
  
  logic[`ADDR_WIDTH-1:0]ARADDR;
  logic[2:0]ARPROT;
  logic ARVALID;
  logic ARREADY;
  
  logic [`DATA_WIDTH-1:0]RDATA;
  logic[1:0]RRESP;
  logic RVALID;
  logic RREADY;
  
  clocking inp_drv_cb@(posedge ACLK);
    default input #1 output #1;
    output ARESETn;

    output [`ADDR_WIDTH-1:0]AWADDR;
    output [2:0]AWPROT;
    output AWVALID;
    
    output[`DATA_WIDTH-1:0]WDATA;
    output[(`DATA_WIDTH/8)-1:0]WSTRB;
    output WVALID;
    
    
    output BREADY;

    output[`ADDR_WIDTH-1:0]ARADDR;
    output[2:0]ARPROT;
    output ARVALID;
    
    output RREADY;
  endclocking
  
  
  clocking inp_mon_cb@(posedge ACLK);
    default input #1 output #1;
    input ARESETn;

    input [`ADDR_WIDTH-1:0]AWADDR;
    input [2:0]AWPROT;
    input AWVALID;
    
    input[`DATA_WIDTH-1:0]WDATA;
    input[(`DATA_WIDTH/8)-1:0]WSTRB;
    input WVALID;
    
    
    input BREADY;

    input[`ADDR_WIDTH-1:0]ARADDR;
    input[2:0]ARPROT;
    input ARVALID;
    
    input RREADY;
  endclocking
  
  clocking out_mon_cb@(posedge clk);
    default input #1 output #1;
    input AWREADY;
    input WREADY;
    input[1:0]BRESP;
    input BVALID;
    input ARREADY;
    input[`DATA_WIDTH-1:0]RDATA;
    input[1:0]RRESP;
    input RVALID;
  endclocking
  
  modport IN_DRV(clocking inp_drv_cb);
  modport IN_MON(clocking inp_mon_cb);
  modport OUT_MON(clocking out_mon_cb);
  
endinterface
