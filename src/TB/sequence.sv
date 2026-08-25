//WRITE OPERATION
class w_seq extends uvm_sequence#(trans);
  `uvm_object_utils(wr_seq)
  
  function new(string name="w_seq");
    super.new(name);
  endfunction
  
  task body();
    repeat(50)begin
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        !(AWADDR[7:0] inside{[8'h28:8'h30],[8'h40:8'hff]});
        AWADDR[1:0]==2'b00;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        RVALID ==1'b0;
        RREADY ==1'b0;
      });
      finish_item(req);
    end
    end
  endtask 
endclass

//READ OPERATION
class r_seq extends uvm_sequence#(trans);
  `uvm_object_utils(r_seq)
  
  function new(string name="r_seq");
    super.new(name);
  endfunction
  
  task body();
    repeat(50)begin
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        !(ARADDR[7:0] inside{[8'h34:8'h38],[8'h40:8'hff]});
        ARADDR[1:0]==2'b00;
        ARVALID==1'b1;
        RVALID ==1'b1;
        RREADY ==1'b1;
        AWVALID==1'b0;
        WVALID ==1'b0;
        BREADY ==1'b0;
      });
      finish_item(req);
    end
    end
  endtask 
endclass

// WRITE-READ OPERATION
class wr_seq extends uvm_sequence#(trans);
  `uvm_object_utils(wr_seq)
  
  function new(string name="wr_seq");
    super.new(name);
  endfunction
  
  task body();
    repeat(100)begin
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{ 
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b1;
        RVALID ==1'b1;
        RREADY ==1'b1;
      });
      finish_item(req);
    end
    end
  endtask 
endclass

//DIRECT TEST CASES
class direct_seq extends uvm_sequence#(trans);
  `uvm_object_utils(direct_seq)
  
  function new(string name="direct_seq");
    super.new(name);
  endfunction
  
  task body();
    //write-read on same address
    repeat(5)begin
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        AWADDR[7:0] inside{[8'h00:8'h24],8'h3C};
        AWADDR[1:0]==2'b00;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        
        ARADDR[7:0]==AWADDR[7:0];
        ARVALID==1'b1;
        RVALID ==1'b1;
        RREADY ==1'b1;
      });
      finish_item(req);
    end
    end
  endtask 
endclass

//ERROR TEST CASES
class err_seq extends uvm_sequence#(trans);
  `uvm_object_utils(err_seq)
  
  function new(string name="err_seq");
    super.new(name);
  endfunction
  
  task body();
    //unaligned addr(SLVERR)
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        AWADDR[1:0]!=2'b00;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        RVALID ==1'b0;
        RREADY ==1'b0;
      });
      finish_item(req);
    end
    //address out of range(DECERR)
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        !(AWADDR[7:0] inside{[8'h00:8'h3f]});
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        RVALID ==1'b0;
        RREADY ==1'b0;
      });
      finish_item(req);
    end
    //write to RO region(SLVERR)
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        AWADDR[7:0] inside{[8'h28:8'h30]};
        AWADDR[1:0]==2'b00;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        RVALID ==1'b0;
        RREADY ==1'b0;
      });
      finish_item(req);
    end
    //Read to WO region(SLVERR)
    req=trans::type_id::create("req");
    begin
      start_item(req);
      assert(req.randomize()with{
        ARADDR[7:0] inside{[8'h34:8'h38]};
        ARADDR[1:0]==2'b00;
        ARVALID==1'b1;
        RVALID ==1'b1;
        RREADY ==1'b1;
        AWVALID==1'b0;
        WVALID ==1'b0;
        BREADY ==1'b0;
      });
      finish_item(req);
    end
  
  endtask 
endclass
