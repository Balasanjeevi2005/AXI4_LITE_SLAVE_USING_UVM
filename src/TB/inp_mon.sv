class inp_mon extends uvm_monitor;
  
  `uvm_component_utils(inp_mon)
  uvm_analysis_port #(trans) inp_mon_port;
  
  axi4_if.IN_MON vif;
  axi4_cfg c_h;
  
  trans t;
  
  function new(string name="inp_mon",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void built_phase(uvm_phase phase);
    super.built_phase(phase);
    if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",c_h))
      `uvm_fatal("config fail","-------------->inp_mon config fail");
    inp_mon_port=new("inp_mon_port",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=c_h.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      collect_inp();
      `uvm_info("INP_MON",$sformatf("INP_MON:\n%S",t.sprint()),UVM_FULL);
    end
  endtask
  
  virtual task collect_inp();
    
    repeat(2)@(vif.inp_mon_cb);
    
    t=trans::type_id::create("t");
    
    t.AWADDR  = vif.inp_mon_cb.AWADDR;
    t.AWVALID = vif.inp_mon_cb.AWVALID;
    t.WDATA   = vif.inp_mon_cb.WDATA;
    t.WSTRB   = vif.inp_mon_cb.WSTRB;
    t.WVALID  = vif.inp_mon_cb.WVALID;
    t.BREADY  = vif.inp_mon_cb.BREADY;
    t.ARADDR  = vif.inp_mon_cb.ARADDR;
    t.ARVALID = vif.inp_mon_cb.ARVALID;
    t.RREADY  = vif.inp_mon_cb.RREADY;
    
   // t.AWPROT  = vif.inp_mon_cb.AWPROT;
   // t.ARPROT  = vif.inp_mon_cb.ARPROT;
    
    inp_mon_port.write(t);
  endtask
  
endclass
