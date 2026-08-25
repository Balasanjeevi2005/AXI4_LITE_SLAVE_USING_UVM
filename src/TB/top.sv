`include "defines.svh"
`include "uvm_macros.svh"
`include "axi4_if.sv"
`include "axi4_rtl.sv"
`include "test_pkg.sv"
import uvm_pkg::*;
import test_pkg::*;

 module top();
   bit ACLK;
   bit ARESETn;
   axi4_if DUV_IF(ACLK);

  //instatiate DUV
   axi4_lite_slave DUV(.ACLK(ACLK),
                       .ARESETN(DUV_IF.ARESETn),
                       .AWADDR(DUV_IF.AWADDR),
                       .AWPROT(DUV_IF.AWPROT),
                       .AWVALID(DUV_IF.AWVALID),
                       .AWREADY(DUV_IF.AWREADY),
                       .WDATA(DUV_IF.WDATA),
                       .WSTRB(DUV_IF.WSTRB),
                       .WVALID(DUV_IF.WVALID),
                       .WREADY(DUV_IF.WREADY),
                       .BRESP(DUV_IF.BRESP),
                       .BVALID(DUV_IF.BVALID),
                       .BREADY(DUV_IF.BREADY),
                       .ARADDR(DUV_IF.ARADDR),
                       .ARPROT(DUV_IF.ARPROT),
                       .ARVALID(DUV_IF.ARVALID),
                       .ARREADY(DUV_IF.ARREADY),
                       .RDATA(DUV_IF.RDATA),
                       .RRESP(DUV_IF.RRESP),
                       .RVALID(DUV_IF.RVALID),
                       .RREADY(DUV_IF.RREADY));
  
  initial begin

    uvm_config_db#(virtual axi4_if)::set(null,"*","axi4_if",DUV_IF);
    $dumpfile("waves.fsdb");
    $dumpvars;
    run_test();
		
  end

  initial begin
    ACLK=1'b0;
    forever 
    #5 ACLK=~ACLK;
  end

endmodule
