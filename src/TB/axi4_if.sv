`include "uvm_macros.svh"
interface axi4_if(input logic ACLK,input logic ARESETn);
  import uvm_pkg::*;
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

    input AWREADY;

    input WREADY;
 
    
    input BRESP;
    input BVALID;

    input ARREADY;
    
    input RRESP;
    input RDATA;
    input RVALID;

    output AWADDR;
    output AWPROT;
    output AWVALID;
    
    output WDATA;
    output WSTRB;
    output WVALID;
    
    
    output BREADY;

    output ARADDR;
    output ARPROT;
    output ARVALID;
    
    output RREADY;
  endclocking
  
  
  clocking inp_mon_cb@(posedge ACLK);
    default input #1 output #1;
    
    input ARESETn;

    input AWADDR;
    input AWPROT;
    input AWVALID;
    
    input WDATA;
    input WSTRB;
    input WVALID;
    
    input BREADY;

    input ARADDR;
    input ARPROT;
    input ARVALID;
    
    input RREADY;
  endclocking
  
  clocking out_mon_cb@(posedge ACLK);
    default input #1 output #1;

    input AWREADY;
    input WREADY;

    input BRESP;
    input BVALID;

    input ARREADY;

    input RDATA;
    input RRESP;
    input RVALID;

  endclocking
  
  modport IN_DRV(clocking inp_drv_cb);
  modport IN_MON(clocking inp_mon_cb);
  modport OUT_MON(clocking out_mon_cb);
/*
   // FSM signals coming from DUT
  logic [2:0] wr_state;
  logic       rd_state;
    
  localparam [2:0]
      w_idle = 3'd0,
      w_both = 3'd1,
      w_addr = 3'd2,
      w_data = 3'd3,
      w_resp = 3'd4;

  localparam
      r_idle = 1'd0,
      r_data = 1'd1;
    
  check_rst:assert property(
    @(posedge ACLK)
    !ARESETn|->(!AWREADY && !WREADY && !BVALID && !ARREADY && !RVALID)
    )
    else
      `uvm_error("assertion_fail","reset failed"); 
    
     
  widle_wboth:assert property(
     @(posedge ACLK)
     (w_state==w_idle && ARESETn)|=> (w_state==w_both)
    )
    else
      `uvm_error("assertion_fail","w_idle->w_both");
     
   wboth_wresp:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     ((w_state==w_both) && AWVALID && WVALID)|=> (w_state==w_resp)
    )
    else
      `uvm_error("assertion_fail","w_both->w_resp");
     
   wboth_waddr:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     ((w_state==w_both) && AWVALID && !WVALID)|=> (w_state==w_addr)
    )
    else
      `uvm_error("assertion_fail","w_both->w_addr");
     
   wboth_wdata:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     ((!AWVALID && WVALID) && (w_state==w_both))|=> (w_state==w_data)
    )
    else
      `uvm_error("assertion_fail","w_both->w_data");
     
   waddr_wresp:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     (WVALID  && WREADY && (w_state==w_addr)) |=> (w_state==w_resp)
    )
    else
      `uvm_error("assertion_fail","w_addr->w_resp");
     
   wdata_wresp:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     (AWVALID  && AWREADY && (w_state==w_data) ) |=> (w_state==w_resp)
    )
    else
      `uvm_error("assertion_fail","w_data->w_resp");
    
   wresp_widle:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     ((w_state==w_resp) && BVALID && BREADY) |=> (w_state==w_idle)
    )
    else
      `uvm_error("assertion_fail","w_resp->w_idle");
    
   ridle_rdata:assert property(
     @(posedge ACLK)
     (r_state==r_idle && ARESETn) |=> (r_state==r_data)
    )
    else
      `uvm_error("assertion_fail","r_idle->r_data");
   
   rdata_ridle:assert property(
     @(posedge ACLK)
     disable iff(!ARESETn)
     (r_state==r_data && RVALID && RREADY) |=> (r_state==r_idle)
    )
    else
      `uvm_error("assertion_fail","r_data->r_idle");
      
    */
endinterface
