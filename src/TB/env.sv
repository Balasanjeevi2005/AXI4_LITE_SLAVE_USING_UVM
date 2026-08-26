class env extends uvm_env;
 `uvm_component_utils(env)
 
 inp_agnt inp_agt_h;
 out_agnt out_agt_h;
 scoreboard sb_h;
 subscriber sub_h;
  
 axi4_cfg m_cfg;

 function new(string name="env",uvm_component parent);
   super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);

   if(!uvm_config_db#(axi4_cfg)::get(this,"","axi4_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"Output_agt Getting Failed")

  inp_agt_h=inp_agnt::type_id::create("inp_agt_h",this);
  out_agt_h=out_agnt::type_id::create("out_agt_h",this);
  sb_h=scoreboard::type_id::create("sb_h",this);
  sub_h = subscriber::type_id::create("sub_h", this);

 endfunction

 function void connect_phase(uvm_phase phase);
   
   super.connect_phase(phase);
   
   inp_agt_h.im_h.inp_mon_port.connect(sb_h.inp_mon_fifo.analysis_export);
   out_agt_h.om_h.out_mon_port.connect(sb_h.out_mon_fifo.analysis_export);
   
   inp_agt_h.im_h.inp_mon_port.connect(sub_h.analysis_export);
   
 endfunction

endclass
  

	
  

