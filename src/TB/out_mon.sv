class out_mon extends uvm_monitor;
  
  `uvm_component_utils(out_mon)
  
  virtual axi4_if.OUT_MON vif;
  axi4_cfg c_h;
  
  function new(string name="out_mon",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void built_phase(uvm_phase phase);
    super.built_phase(phase);
    if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",c_h))
      `uvm_fatal("config fail","-------------->out_mon config fail");
    out_mon_port=new("out_mon_port",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=c_h.vif;
  endfunction
  
  task run_phase(uvm_phase  phase);
    t=trans::type_id::create("t");
    forever begin
      collect_out();
      `uvm_info("out_mon",$sformatf("output monitor:\n%s",t.sprint()),UVM_LOW);
    end
  endtask
  
  virtual task collect_out();
    
    repeat(3)@(vif.out_mon_cb);
    
    t.AWREADY = vif.out_mon_cb.AWREADY;
    t.WREADY  = vif.out_mon_cb.WREADY;
    t.BRESP   = vif.out_mon_cb.BRESP;
    t.BVALID  = vif.out_mon_cb.BVALID;
    
    t.ARREADY = vif.out_mon_cb.ARREADY;
    t.RDATA   = vif.out_mon_cb.RDATA;
    t.RRESP   = vif.out_mon_cb.RRESP;
    t.RVALID  = vif.out_mon_cb.RVALID;
    
    out_mon_port.write(t);
  
endclass
