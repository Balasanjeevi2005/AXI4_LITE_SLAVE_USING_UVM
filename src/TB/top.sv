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
                       .ARESETn(ARESETn),

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

  //assign DUV_IF.w_state = DUV.wr_state;
  //assign DUV_IF.r_state = DUV.rd_state;
   
   initial begin
     uvm_config_db#(virtual axi4_if)::set(null,"*","axi4_if",DUV_IF);
     //$dumpfile("waves.fsdb");
     //$dumpvars;
     run_test();	
   end
   
   initial begin
     //w_addr -> w_idle
     @(posedge ACLK);
     ARESETn=0;
     repeat(1)@(posedge ACLK);
     ARESETn=1;
     repeat(5)@(posedge ACLK);
     ARESETn=0;
     repeat(3)@(posedge ACLK);
     //w_data -> w_idle
     @(posedge ACLK);
     ARESETn=0;
     repeat(1)@(posedge ACLK);
     ARESETn=1;
     repeat(5)@(posedge ACLK);
     ARESETn=0;
     repeat(3)@(posedge ACLK);
     #2 ARESETn=1;
     #10 ARESETn=0;
     repeat(2)@(posedge ACLK);
     ARESETn=1;
     repeat(100)@(posedge ACLK);
     ARESETn=0;
     repeat(10)@(posedge ACLK);
     ARESETn=1;
   end
   
   initial begin
     ACLK=1'b0;
     forever 
       #5 ACLK=~ACLK;
   end

endmodule
