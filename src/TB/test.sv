class test extends uvm_test;
  
  `uvm_component_utils(test)
  
  env e_h;
  axi4_cfg c_h;
  
  function new(string="test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    c_h=axi4_cfg::type_id::create("c_h");
    
    if(!uvm_config_db#(virtual axi4_if)::get(this,"","axi4_if",c_h.vif))
      `uvm_fata("config fail","-------------->test virtual_interface config fail");
    
    c_h.inp_agent_is_active==UVM_ACTIVE;
    c_h.out_agent_is_passive==UVM_PASSIVE;
    
    uvm_config_db#(axi4_cfg)::set(this,"*","axi4_cfg",c_h);
    
    e_h=env::type_id::create("e_h",this);
    
  endfunction
 
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass


class test1 extends test;
  
  `uvm_component_utils(test1)
  
  wr_seq w1;
  r_seq r1;
  err_seq e1;
  direct_seq d1;
  
  function new(string="test1",uvm_component parent);
    super.new(name,parent);
  endfunction
  
 // function void build_phase(uvm_phase phase);
	//super.build_phase(phase);
  //endfunction
  
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    
    w1=wr_seq::type_id::create("w1");
    r1=wr_seq::type_id::create("r1");
    e1=wr_seq::type_id::create("e1");
    d1=wr_seq::type_id::create("d1");
    
    w1.start(e_h.inp_agnt_h.sr_h);
    r1.start(e_h.inp_agnt_h.sr_h);
    e1.start(e_h.inp_agnt_h.sr_h);
    c1.start(e_h.inp_agnt_h.sr_h);

	#50;  
    phase.drop_objection(this);
    
  endtask
  
endclass
