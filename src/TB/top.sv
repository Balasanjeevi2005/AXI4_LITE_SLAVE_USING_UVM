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
   axi4_if DUV_IF(ACLK,ARESETn);

  //instatiate DUV
   axi4_lite_slave DUV(.ACLK(ACLK),
                       .ARESETN(ARESETn),
                       .AWADDR(AWADDR),
                       .AWPROT(AWPROT),
                       .AWVALID(AWVALID),
                       .AWREADY(AWREADY),
                       .WDATA(WDATA),
                       .WSTRB(WSTRB),
                       .WVALID(WVALID),
                       .WREADY(WREADY),
                       .BRESP(BRESP),
                       .BVALID(BVALID),
                       .BREADY(BREADY),
                       .ARADDR(ARADDR),
                       .ARPROT(ARPROT),
                       .ARVALID(ARVALID),
                       .ARREADY(ARREADY),
                       .RDATA(RDATA),
                       .RRESP(RRESP),
                       .RVALID(RVALID),
                       .RREADY(RREADY));
  
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
