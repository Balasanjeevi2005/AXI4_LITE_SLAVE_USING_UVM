`include "defines.sv"
class subscriber extends uvm_subscriber#(trans);
  
  `uvm_component_utils(subscriber)
  
  trans t1;
  
  covergroup cg;
    
    AWADDR:coverpoint t1.AWADDR{
      bins w_addr={[0:$]};
    }
    
    AWVALID:coverpoint t1.AWVALID{
      bins low ={0};
      bins high={1};
    }
    
    WDATA:coverpoint t1.WDATA{
      bins all_zero={ {`DATA_WIDTH{1'b0}} };
      bins all_ones={ {`DATA_WIDTH{1'b1}} };
      bins others  = default;
    }
    
    WVALID:coverpoint t1.WVALID{
      bins low ={0};
      bins high={1};
    }
    
    WSTRB:coverpoint t1.WSTRB{
      bins strb[]={[0:$]};
    }
    
    ARADDR:coverpoint t1.ARADDR{
      bins r_addr={[0:$]};
    }
    
    ARVALID:coverpoint t1.ARVALID{
      bins low ={0};
      bins high={1};
    }
    
    RREADY:coverpoint t1.RREADY{
      bins low ={0};
      bins high={1};
    }
    
    BREADY:coverpoint t1.BREADY{
      bins low ={0};
      bins high={1};
    }

    //RESP
    BRESP:coverpoint t1.BREADY{
      bins OKAY  ={2'b00};
      bins SLVERR={2'b10};
      bins DECERR={2'b11};
      bins other =default;
    }
    
    RRESP:coverpoint t1.RREADY{
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
  
  function void write(trans t);
    t1=t;
    cg.sample();
  endfunction
  
endclass
