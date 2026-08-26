class axi4_cfg extends uvm_object;
  `uvm_object_utils(axi4_cfg)
  
  virtual axi4_if vif;
  uvm_active_passive_enum inp_agent_is_active;
  uvm_active_passive_enum out_agent_is_passive;
  
  function new(string name="axi4_cfg");
    super.new(name);
  endfunction
  
endclass
