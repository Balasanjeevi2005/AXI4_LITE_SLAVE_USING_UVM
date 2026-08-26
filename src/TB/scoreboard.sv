class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  uvm_tlm_analysis_fifo#(trans)inp_mon_fifo;
  uvm_tlm_analysis_fifo#(trans)out_mon_fifo;
  
  trans inp_mon_tx;
  trans out_mon_tx;
  
  logic[`DATA_WIDTH-1:0]mem[`MEM_DEPTH];
  bit wa_flag=1'b0;
  bit wd_flag=1'b0;
  bit[`ADDR_WIDTH-1:0]temp_addr;
  bit[`DATA_WIDTH-1:0]temp_data;
  bit[(`DATA_WIDTH/8)-1:0]temp_strb;
  
  function new(string name="scoreboard",uvm_component parent);
    
    super.new(name,parent);
    inp_mon_fifo=new("inp_mon_fifo",this);
    out_mon_fifo=new("out_mon_fifo",this);
    
  endfunction
 
  task run_phase(uvm_phase phase);
    
    forever begin
      
      inp_mon_fifo.get(inp_mon_tx);
      out_mon_fifo.get(out_mon_tx);
      
      ref_model(inp_mon_tx);
      `uvm_info("reference_model",$sformatf("reference_model:\n%s",inp_mon_tx.sprint()),UVM_NONE);
      
      validate_output();
      
    end
    
  endtask
  
  virtual task validate_output();
    
    if(inp_mon_tx.compare(out_mon_tx))begin
      `uvm_info(get_type_name(),$sformatf("DATA MATCH SUCCESSFUL"),UVM_NONE)
	end
    
	else begin
      `uvm_info(get_type_name(),$sformatf("DATA DISMATCH SUCCESSFUL"),UVM_NONE)
      `uvm_info(get_type_name(),$sformatf("Expected Packet\n%s",inp_mon_tx.sprint()),UVM_NONE)
      `uvm_info(get_type_name(),$sformatf("DUT Packet\n%s",out_mon_tx.sprint()),UVM_NONE)
	end
    
  endtask

  virtual task ref_model(trans t);
    
    if(!t.PRESETn)begin
      foreach (mem[i])
        mem[i] ={`DATA_WIDTH{1'b0}};

      t.AWREADY=1'b0;
      t.WREADY =1'b0;
      t.BVALID =1'b0;
      
      t.ARREADY=1'b0;
      t.RVALID =1'b0;
      
      wa_flag=1'b0;
      wd_flag=1'b0;
      temp_addr={`ADDR_WIDTH{1'b0}};
      temp_data={`DATA_WIDTH{1'b0}};
      temp_strb={(`DATA_WIDTH/8){1'b0}};
      
    end
    else begin
      
      //write
      if(t.AWVALID || t.WVALID)begin
        
        if(t.AWVALID && (!wa_flag))begin
          temp_addr=t.AWADDR;
          t.AWREADY=1'b1;
          wa_flag=1'b1;
        end
        
        if(t.WVALID  && (!wd_flag))begin
          temp_data=t.WDATA;
          temp_strb=t.WSTRB;
          t.WREADY=1'b1;
          wd_flag=1'b1;
        end
        
        if(wa_flag && wd_flag)begin
          if(temp_addr[7:0] inside{[8'h28:8'h30]})
            t.BRESP=2'b11; //decerr
        
          else if( (temp_addr[1:0]!=2'b00) || (!(temp_addr[7:0] inside{[8'h00:8'h3f]})) )
            t.BRESP=2'b10; //slverr
        
          else begin
            t.BRESP=2'b00;
            if(temp_strb[0])
              mem[temp_addr[5:2]][7:0]=temp_data[7:0];
            if(temp_strb[1])
              mem[temp_addr[5:2]][15:8]=temp_data[15:8];
            if(temp_strb[2])
              mem[temp_addr[5:2]][23:16]=temp_data[23:16];
            if(temp_strb[3])
              mem[temp_addr[5:2]][31:24]=temp_data[31:24];
          end
          t.BVALID=1'b1;
          wa_flag=1'b0;
          wd_flag=1'b0;
          temp_addr={`ADDR_WIDTH{1'b0}};
          temp_data={`DATA_WIDTH{1'b0}};
          temp_strb={(`DATA_WIDTH/8){1'b0}};
        end
        
      end
      
      //read
      if(t.ARVALID)begin
        
        t.ARREADY=1'b1;
        
        if(t.ARADDR[7:0] inside{[8'h34:8'h38]})
          t.RRESP=2'b11; //decerr
        
        else if( (t.ARADDR[1:0]!=2'b00) || (!(t.ARADDR[7:0] inside{[8'h00:8'h3f]})) )
          t.RRESP=2'b10; //slverr
        
        else begin
          t.RRESP=2'b00;
          t.RDATA=mem[t.ARADDR[5:2]];
        end
        
        t.RVALID=1'b1;
        
      end
    
      //no operation
      else begin
        t.AWREADY=1'b0;
        t.WREADY =1'b0;
        t.BVALID =1'b0;
      
        t.ARREADY=1'b0;
        t.RVALID =1'b0;

      end
    
    end
 
  endtask
  
 
endclass
    
