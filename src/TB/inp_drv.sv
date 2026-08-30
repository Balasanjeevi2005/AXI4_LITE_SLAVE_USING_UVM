class inp_drv extends uvm_driver#(trans);
  
  `uvm_component_utils(inp_drv)
  
  axi4_cfg c_h;
  virtual axi4_if.IN_DRV vif;
  trans t;

  function new(string name="inp_drv",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",c_h))
      `uvm_fatal("config fail","-------------->inp_drv config fail");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=c_h.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    
    @(vif.inp_drv_cb);
    
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      // Hold this transaction for one clock
      @(vif.inp_drv_cb);
      `uvm_info("inp_drv",$sformatf("input driver:\n%s",req.sprint()),UVM_HIGH);
      seq_item_port.item_done();
    end
    
  endtask
  
  task drive(trans t);
    
    
     @(vif.inp_drv_cb);
    
    if(t.AWVALID || t.WVALID)begin
      
      if(t.AWVALID)begin //&& (!a_flag)
        vif.inp_drv_cb.AWADDR  <= t.AWADDR;
        vif.inp_drv_cb.AWVALID <= t.AWVALID;
        vif.inp_drv_cb.AWPROT <= t.AWPROT;
        //a_flag=1'b1;
      end
      
      if(t.WVALID) begin //&& (!d_flag)
        vif.inp_drv_cb.WDATA   <= t.WDATA;
        vif.inp_drv_cb.WSTRB   <= t.WSTRB;
        vif.inp_drv_cb.WVALID  <= t.WVALID;
        //d_flag=1'b1;
      end
      
      if(t.BREADY && vif.inp_drv_cb.BVALID)begin
        vif.inp_drv_cb.BREADY  <= t.BREADY;
        //a_flag=1'b0;
        //d_flag=1'b0;
      end
        
    end
    if (t.ARVALID) begin
      vif.inp_drv_cb.ARADDR  <= t.ARADDR;
      vif.inp_drv_cb.ARVALID <= t.ARVALID;
      vif.inp_drv_cb.ARPROT <= t.ARPROT;
      
      while(!(t.RREADY && vif.inp_drv_cb.RVALID))begin
        @(vif.inp_drv_cb);
      end
      
      vif.inp_drv_cb.RREADY  <= t.RREADY;
    end
    
    
  endtask
  
endclass
    
