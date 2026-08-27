class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  rand bit[`ADDR_WIDTH-1:0]AWADDR;
  rand bit AWVALID;
  logic AWREADY;
  
  rand bit[`DATA_WIDTH-1:0]WDATA;
  rand bit[(`DATA_WIDTH/8)-1:0]WSTRB;
  rand bit WVALID;
  logic WREADY;
  
  logic[1:0]BRESP;
  logic BVALID;
  rand bit BREADY;
  
  rand bit[`ADDR_WIDTH-1:0]ARADDR;
  rand bit ARVALID;
  logic ARREADY;
  
  logic[`DATA_WIDTH-1:0]RDATA;
  logic[1:0]RRESP;
  logic RVALID;
  rand bit RREADY;
  
  rand bit[2:0]AWPROT;
  rand bit[2:0]ARPROT;
  localparam bit [`DATA_WIDTH-1:0]DW_MAX={`DATA_WIDTH{1'b1}};
  constraint c0{AWADDR[1:0]dist{2'b00:=10,[2'b01:2'b11]:=1}};
  constraint c1{AWADDR[7:0]dist{[8'h00:8'h3F]:=10,[8'h40:8'hFF]:=1}};
  
  constraint c2{ARADDR[1:0]dist{2'b00:=10,[2'b01:2'b11]:=1}};
  constraint c3{ARADDR[7:0]dist{[8'h00:8'h3F]:=10,[8'h4F:8'hFF]:=1}};
  
  constraint c4{AWVALID dist{1:=15,0:=1}};
  constraint c5{ARVALID dist{1:=15,0:=1}};
  constraint c6{WVALID dist{1:=15,0:=1}};
  
  constraint c7{WDATA inside{[0:DW_MAX]}};
  constraint c8{WSTRB dist{4'b1111:=10,[4'b0000:4'b1110]:=1}};
  
  constraint c9{BREADY dist{1:=15,0:=1}};//dout if 0 what happen
  constraint c10{RREADY dist{1:=15,0:=1}};//dout if 0 what happen
  
  

  `uvm_object_utils_begin(trans)
  
  `uvm_field_int(AWADDR,UVM_ALL_ON)
  `uvm_field_int(AWVALID,UVM_ALL_ON)
  `uvm_field_int(AWREADY,UVM_ALL_ON)
  
  `uvm_field_int(WDATA,UVM_ALL_ON)
  `uvm_field_int(WSTRB,UVM_ALL_ON)
  `uvm_field_int(WVALID,UVM_ALL_ON)
  `uvm_field_int(WREADY,UVM_ALL_ON)
  
  `uvm_field_int(BRESP,UVM_ALL_ON)
  `uvm_field_int(BVALID,UVM_ALL_ON)
  `uvm_field_int(BREADY,UVM_ALL_ON)
  
  `uvm_field_int(ARADDR,UVM_ALL_ON)
  `uvm_field_int(ARVALID,UVM_ALL_ON)
  `uvm_field_int(ARREADY,UVM_ALL_ON)
  
  `uvm_field_int(RDATA,UVM_ALL_ON)
  `uvm_field_int(RRESP,UVM_ALL_ON)
  `uvm_field_int(RVALID,UVM_ALL_ON)
  `uvm_field_int(RREADY,UVM_ALL_ON)
  
  `uvm_field_int(AWPROT,UVM_ALL_ON)
  `uvm_field_int(ARPROT,UVM_ALL_ON)
  
  `uvm_object_utils_end
  
    
  function new(string name="trans");
    super.new(name);
  endfunction
  
endclass
