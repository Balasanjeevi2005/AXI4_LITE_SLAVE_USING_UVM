`include "defines.sv"
class subscriber extends uvm_subscriber#(trans);
  
  `uvm_component_utils(subscriber)
  
  trans t;
  
  covergroup cg;
    
    AWADDR:coverpoint t.AWADDR{
      bins w_addr={[0:$]};
    }
    
    AWVALID:coverpoint t.AWVALID{
      bins low ={0};
      bins high={1};
    }
    
    WDATA:coverpoint t.WDATA{
      bins all_zero={ {`DATA_WIDTH{1'b0}} };
      bins all_ones={ {`DATA_WIDTH{1'b1}} };
      bins others  = default;
    }
    
    WVALID:coverpoint t.WVALID{
      bins low ={0};
      bins high={1};
    }
    
    WSTRB:coverpoint t.WSTRB{
      bins strb[]={[0:$]};
    }
    
    ARADDR:coverpoint t.ARADDR{
      bins r_addr={[0:$]};
    }
    
    ARVALID:coverpoint t.ARVALID{
      bins low ={0};
      bins high={1};
    }
    
    RREADY:coverpoint t.RREADY{
      bins low ={0};
      bins high={1};
    }
    
    BREADY:coverpoint t.BREADY{
      bins low ={0};
      bins high={1};
    }

    //RESP
    BRESP:coverpoint t.BREADY{
      bins OKAY  ={2'b00};
      bins SLVERR={2'b10};
      bins DECERR={2'b11};
      bins other =default;
    }
    
    RRESP:coverpoint t.RREADY{
      bins OKAY  ={2'b00};
      bins SLVERR={2'b10};
      bins DECERR={2'b11};
      bins other =default;
    }
    
    W_addr_data:cross AWVALID,WVALID;
    
  endgroup
  
  function new(string name="subscriber",uvm_component parent);
    super.new(name,parent);
    cg=new();
  endfunction
  
  function void write(trans t1);
    t=t1;
    cg.sample();
  endfunction
  
endclass
