class inp_agnt extends uvm_agent;
  
  `uvm_component_utils(inp_agnt)
  
  inp_mon im_h;
  inp_drv id_h;
  sequencer sr_h;
  axi4_cfg c_h;
  
  function new(string name="inp_agnt",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void built_phase(uvm_phase phase);
    super.built_phase(phase);
    if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",c_h))
      `uvm_fatal("config fail","-------------->inp_agent config fail");
    im_h=inp_mon::type_id::create("im_h",this);
    if(c_h.input_agent_is_active==UVM_ACTIVE)
      begin
        id_h=inp_drv::type_id::create("id_h",this);
        sr_h=sequencer::type_id::create("sr_h",this);
      end
  endfunction
  
  function void connnect_phase(uvm_phase phase);
    super.connect_phase(phase);
    id_h.seq_item_port.connect(sr_h.seq_item_export);
  endfunction
  
endclass
    
