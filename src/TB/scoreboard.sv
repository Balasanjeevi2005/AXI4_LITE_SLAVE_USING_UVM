class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_tlm_analysis_fifo#(trans)inp_mon_fifo;
  uvm_tlm_analysis_fifo#(trans)out_mon_fifo;
  
  trans inp_mon_xn;
  trans out_mon_xn;

  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
    inp_mon_fifo=new("inp_mon_fifo",this);
    out_mon_fifo=new("out_mon_fifo",this);
  endfunction
 
  task run_phase(uvm_phase phase);
    forever begin
      inp_mon_fifo.get(inp_mon_xn);
      out_mon_fifo.get(out_mon_xn);
      
      ref_model(inp_mon_xn);
      `uvm_info("reference_model",$sformatf("reference_model:\n%s",inp_mon_xn.sprint()),UVM_NONE);
      validate_output():
      check_data(out_mon_tx);
      `uvm_info("CHECKING OUTPUT ",$sformatf("CHECKING OUTPUT\n%s",out_mon_xn.sprint()),UVM_NONE)
    end
  endtask
  
  virtual task validate_output();
    
    if(inp_mon_xn.compare(out_mon_xn))begin
      `uvm_info(get_type_name(),$sformatf("DATA MATCH SUCCESSFUL"),UVM_NONE)
	end
    
	else begin
      `uvm_info(get_type_name(),$sformatf("DATA DISMATCH SUCCESSFUL"),UVM_NONE)
	   
      `uvm_info(get_type_name(),$sformatf("Expected Packet\n%s",inp_mon_xn.sprint()),UVM_NONE)
      `uvm_info(get_type_name(),$sformatf("DUT Packet\n%s",out_mon_xn.sprint()),UVM_NONE)
	end
    
  endtask
  
  task check_Data(trans t);
	begin
	   if(inp_mon_xn.== ch.res)
		$display("\n RES IS  MATCHING");
	   else
		$display("\n RES IS NOT MATCHING");
    end
 endtask
  
  virtual task write_fsm(trans t);
    localparam w_idle = 3'b000;
    localparam w_both = 3'b001;
    localparam w_data = 3'b010;
    localparam w_addr = 3'b011;
    localparam w_resp = 3'b100;
   
    logic [2:0]w_ct_st,w_nt_st;
    logic [1:0]temp_bresp;
    if(!t.ARESETn)begin
      
      awready  = 1'b0;
      wready   = 1'b0;
      bvalid   = 1'b0;
      w_ct_st  = w_idle;
      
    end
 
    else begin
      w_ct_st=w_nt_st;
      case(w_ct_st)begin
        
        //idle state
        w_idle:begin
          w_nt_st=w_both;
        end
        
        //w_both state
        w_both:begin
          if(AWVALID && WVALID)begin
            awaddr=t.AWADDR;
            wdata =t.WDATA;
            awready=1'b1;
            wready =1'b1;
            w_nt_st=w_resp;
          end
          else if(AWVALID)begin
            awaddr=t.AWADDR;
            awready=1'b1;
            w_nt_st=w_addr;
          end
          else if(WVALID)begin
            wdata=t.WDATA;
            wready=1'b1;
            w_nt_st=w_data;
          end
          else 
            w_nt_st=w_both;
          end
        end
        
        // data state
        w_data:begin
          if(awvalid)begin
            awaddr =t.AWADDR;
            awready=1'b1;
            w_nt_st=w_resp;
          end
          else begin
            w_nt_st=w_data;
          end
        end
        
        // addr valid
        w_addr:begin
          if(wvalid)begin
            wdata =t.WDATA;
            wready=1'b1;
            w_nt_st=w_resp;
          end
          else begin
            w_nt_st=w_addr;
          end
        end
        
        // response state
        w_resp:begin
          if(!(awaddr[7:0] inside {[8'h00:8'h3f]}))
            bresp=2'b11;
          else if((awaddr[1:0]!=00) || 
                  (awaddr[7:0] inside {[8'h28:8'h30]})
                 )
            bresp=2'b10;
          else 
          bresp =temp_bresp;
          bvalid=1'b1;
          if(bready)begin
            w_nt_st=w_idle;
          end
          else begin
            w_nt_st=w_resp;
          end
        end
        default:w_nt_st=w_idle;
    end
 
  endtask
  virtual task read_fsm(trans t);
    
    localparam r_idle = 2'b00;
    localparam r_data = 2'b01;
    
    logic [2:0]r_ct_st,r_nt_st;
    logic [1:0]temp_rresp;
    if(!t.ARESETn)begin
      
      arready  = 1'b0;
      rvalid  = 1'b0;
      r_ct_st  = r_idle;
      
    end
 
    else begin
      r_ct_st=r_nt_st;
      case(w_ct_st)begin
        
        //idle state
        r_idle:begin
          if(arvalid)begin
            arready=1'b0;
            r_nt_st=r_data;
          end
          else begin
            r_nt_st=r_idle;
          end 
        end
        
        // data state
        r_data:begin
          rdata =mem[ARADDR];
          rresp =temp_rresp;
          if(rready)begin
            r_nt_st=r_idle;
          end
          else begin
            r_nt_st=r_data;
          end
        end
        
        
  endtask
endclass
    
