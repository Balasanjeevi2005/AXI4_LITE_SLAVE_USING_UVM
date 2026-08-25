class out_agnt extends uvm_agent;
  
  `uvm_component_utils(out_agnt)
  
  out_mon om_h;
  axi4_cfg c_h;
  
  function new(string name="out_agnt",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void built_phase(uvm_phase phase);
    super.built_phase(phase);
    if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",c_h))
      `uvm_fatal("config fail","-------------->out_agent config fail");
    if(c_h.out_mon_is_passive==UVM_PASSIVE)
      om_h=out_mon::type_id::create("om_h",this);
  endfunction
  
endclass
    
