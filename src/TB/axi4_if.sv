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

  syn_rst:assert property (@(posedge ACLK) !ARESETn |-> ({AWREADY, WREADY, BVALID, BRESP, ARREADY, RVALID, RDATA, RRESP} == 0));
  asyn_rst:assert property (@(negedge ACLK) !ARESETn |-> ({AWREADY, WREADY, BVALID, BRESP, ARREADY, RVALID, RDATA, RRESP} == 0));
  checkbvalid:assert property (@(posedge ACLK) disable iff (!ARESETn) (BVALID && !BREADY) |=> BVALID);
  checkbresp:assert property (@(posedge ACLK) disable iff (!ARESETn) (BVALID && !BREADY) |=> ($stable(BRESP)));
  checkrvalid:assert property (@(posedge ACLK) disable iff (!ARESETn) (RVALID && !RREADY) |=> RVALID);
  checkrdata:assert property (@(posedge ACLK) disable iff (!ARESETn) (RVALID && !RREADY) |=> ($stable(RDATA)));
  checkrresp:assert property (@(posedge ACLK) disable iff (!ARESETn) (RVALID && !RREADY) |=> ($stable(RRESP)));

endinterface
