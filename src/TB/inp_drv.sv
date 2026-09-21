class inp_drv extends uvm_driver#(trans);
  
  `uvm_component_utils(inp_drv)
  
  axi4_cfg c_h;
  virtual axi4_if.IN_DRV vif;
  trans req;

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
      seq_item_port.item_done(req);
    end
    
  endtask
  
  task drive(trans req);
    @(vif.inp_drv_cb);
    fork 
      write_addr(req);
      write_data(req);
      read_addr(req);
      write_resp(req);
      read_resp(req);
      slave_resp(req);
    join
  endtask
   
  task write_addr(trans t);
    vif.inp_drv_cb.AWADDR  <= t.AWADDR;
    vif.inp_drv_cb.AWVALID <= t.AWVALID;
    vif.inp_drv_cb.AWPROT <= t.AWPROT;
  endtask
  
  task write_data(trans t);
    vif.inp_drv_cb.WDATA   <= t.WDATA;
    vif.inp_drv_cb.WSTRB   <= t.WSTRB;
    vif.inp_drv_cb.WVALID  <= t.WVALID;
  endtask
  
  task read_addr(trans t);
    vif.inp_drv_cb.ARADDR  <= t.ARADDR;
    vif.inp_drv_cb.ARVALID <= t.ARVALID;
    vif.inp_drv_cb.ARPROT <= t.ARPROT; 
  endtask

  task write_resp(trans t);
    vif.inp_drv_cb.BREADY  <= t.BREADY;
  endtask

  task read_resp(trans t);
    vif.inp_drv_cb.RREADY  <= t.RREADY;
  endtask

  task slave_resp(trans t);
   // $cast(res,t.clone());
    
    t.AWREADY = vif.inp_drv_cb.AWREADY;
    
    t.WREADY  = vif.inp_drv_cb.WREADY;
  
    t.BVALID  = vif.inp_drv_cb.BVALID;
    t.BRESP   = vif.inp_drv_cb.BRESP;

    t.ARREADY = vif.inp_drv_cb.ARREADY;

    t.RRESP  = vif.inp_drv_cb.RRESP;
    t.RDATA  = vif.inp_drv_cb.RDATA;
    t.RVALID = vif.inp_drv_cb.RVALID;

  endtask

endclass
    
