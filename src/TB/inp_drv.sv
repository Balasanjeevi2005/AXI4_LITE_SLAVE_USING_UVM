class inp_drv extends uvm_driver#(trans);
  
  `uvm_component_utils(inp_drv)
  
  axi4_cfg c_h;
  virtual axi4_if.IN_DRV vif;
  trans t;
  
  function new(string name="inp_drv",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void built_phase(uvm_phase phase);
    super.built_phase(phase);
    if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",c_h))
      `uvm_fatal("config fail","-------------->inp_drv config fail");
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=c_h.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      `uvm_info("inp_drv",$sformatf("input driver:\n%s",req.sprint()),UVM_MEDIUM);
      seq_item_port.item_done();
    end
    
  endtask
  
  task drive(trans t);
 
    @(vif.inp_drv_cb);
    vif.inp_drv_cb.AWADDR  <= t.AWADDR;
    vif.inp_drv_cb.AWVALID <= t.AWVALID;
    vif.inp_drv_cb.WDATA   <= t.WDATA;
    vif.inp_drv_cb.WSTRB   <= t.WSTRB;
    vif.inp_drv_cb.WVALID  <= t.WVALID;
    vif.inp_drv_cb.BREADY  <= t.BREADY;
    vif.inp_drv_cb.ARADDR  <= t.ARADDR;
    vif.inp_drv_cb.ARVALID <= t.ARVALID;
    vif.inp_drv_cb.RREADY  <= t.RREADY;

  endtask
  
endclass
    
