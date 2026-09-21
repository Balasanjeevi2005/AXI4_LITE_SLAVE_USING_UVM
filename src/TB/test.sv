class test extends uvm_test;
  
  `uvm_component_utils(test)
  
  env e_h;
  axi4_cfg c_h;
  
  function new(string name="test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    c_h=axi4_cfg::type_id::create("c_h");
    
    if(!uvm_config_db#(virtual axi4_if)::get(this,"","axi4_if",c_h.vif))
      `uvm_fatal("config fail","-------------->test virtual_interface config fail");
    
    c_h.inp_agnt_is_active=UVM_ACTIVE;
    c_h.out_agnt_is_passive=UVM_PASSIVE;
    
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
  
  w_seq w1;
  r_seq r1;
  wr_seq wr1;

  err_seq e1;
  direct_seq d1;
  fsm_seq f1;
  //cov_seq c1;
  function new(string name="test1",uvm_component parent);
    super.new(name,parent); 
  endfunction
  
  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    fork 
      begin
        w1=w_seq::type_id::create("w1");
        w1.start(e_h.inp_agnt_h.sr_h);
      end
      begin
        r1=r_seq::type_id::create("r1");
        r1.start(e_h.inp_agnt_h.sr_h);
      end
      begin
        wr1=wr_seq::type_id::create("wr1");
        wr1.start(e_h.inp_agnt_h.sr_h);
      end
      begin
        e1=err_seq::type_id::create("e1");
        e1.start(e_h.inp_agnt_h.sr_h);
      end
      begin
        d1=direct_seq::type_id::create("d1");
        d1.start(e_h.inp_agnt_h.sr_h);
      end
      begin
       f1=fsm_seq::type_id::create("f1");
       f1.start(e_h.inp_agnt_h.sr_h);
      end
      /*begin
       c1=cov_seq::type_id::create("c1");
       c1.start(e_h.inp_agnt_h.sr_h);
      end*/
    join
    phase.phase_done.set_drain_time(this,20);
    phase.drop_objection(this);
    
  endtask
  
endclass
