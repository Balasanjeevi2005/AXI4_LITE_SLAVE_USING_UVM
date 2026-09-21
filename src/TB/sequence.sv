//WRITE OPERATION
class w_seq extends uvm_sequence#(trans);
  `uvm_object_utils(w_seq)
   
  //trans res;
  function new(string name="w_seq");
    super.new(name);
  endfunction
  
  task body();
    repeat(50)begin
    req=trans::type_id::create("req");
    
    start_item(req);
      assert(req.randomize()with{
        !(AWADDR[7:0] inside{[8'h28:8'h30],[8'h40:8'hff]});
        AWADDR[1:0]==2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        //RVALID ==1'b0;
        RREADY ==1'b0;
      });
    finish_item(req);
    end
  endtask 
endclass


//READ OPERATION
class r_seq extends uvm_sequence#(trans,trans);
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
        r==1;
        w==0;
        ARADDR[1:0]==2'b00;
        ARADDR[`ADDR_WIDTH-1:8]== '0;
        ARVALID==1'b1;
        //RVALID ==1'b1;
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
        w==1;
        r==1;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        ARADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b1;
        //RVALID ==1'b1;
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
        w==1;
        r==1;
        AWADDR[7:0] inside{[8'h00:8'h24],8'h3C};
        AWADDR[1:0]==2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        
        ARADDR==AWADDR;
        ARVALID==1'b1;
        //RVALID ==1'b1;
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
        w==1;
        r==0;
        AWADDR[1:0]!=2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        //RVALID ==1'b0;
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
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w==1;
        r==0;
        a_d==2'b11;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        //RVALID ==1'b0;
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
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w==1;
        r==0;
        a_d==2'b11;
        AWADDR[1:0]==2'b00;
        AWVALID==1'b1;
        WVALID ==1'b1;
        BREADY ==1'b1;
        ARVALID==1'b0;
        //RVALID ==1'b0;
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
        ARADDR[`ADDR_WIDTH-1:8]== '0;
        w==0;
        r==1;
        ARADDR[1:0]==2'b00;
        ARVALID==1'b1;
        //RVALID ==1'b1;
        RREADY ==1'b1;
        AWVALID==1'b0;
        WVALID ==1'b0;
        BREADY ==1'b0;
      });
      finish_item(req);
    end
    //all zero
    req = trans::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {
        WDATA   == {`DATA_WIDTH{1'b0}};
        w==1;
        r==0;
        a_d==2'b11;
        AWVALID == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b1;

        ARVALID == 1'b0;
        RREADY  == 1'b0;

        AWADDR[1:0] == 2'b00;
        AWADDR[7:0] inside {[8'h00:8'h27],
                            [8'h31:8'h3F]};
        AWADDR[`ADDR_WIDTH-1:8]== '0;
      });

    finish_item(req);
    //all ones
    req = trans::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {
        WDATA   == {`DATA_WIDTH{1'b1}};
        w==1;
        r==0;
        a_d==2'b11;
        AWVALID == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b1;

        ARVALID == 1'b0;
        RREADY  == 1'b0;

        AWADDR[1:0] == 2'b00;
        AWADDR[7:0] inside {[8'h00:8'h27],
                            [8'h31:8'h3F]};
        AWADDR[`ADDR_WIDTH-1:8]== '0;
      });

    finish_item(req);
    
    
  endtask
  endclass
  class fsm_seq extends uvm_sequence#(trans);
    `uvm_object_utils(fsm_seq)
    function new(string name="fsm_seq");
      super.new(name);
    endfunction
  
    task body();

      //W_BOTH -> W_IDLE
      // Step 1: Enter W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        w == 0;
        r == 0;
        AWADDR[1:0] == 2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID == 1'b0;
        WVALID  == 1'b0;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);

      // Step 2: Try W_BOTH -> W_IDLE
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==0;
      });

      finish_item(req);   

      // Step 3: Try W_IDLE -> W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
      });

      finish_item(req);
      //W_ADDR -> W_DATA
      // Step 1: Enter W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b10;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WVALID  == 1'b0;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
      // Step 2: Try W_ADDR -> W_IDLE
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==0;
      });

      finish_item(req);   

      // Step 3: Try W_IDLE -> W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
      });

      finish_item(req);

      //fsm not covered
      //W_DATA-> W_IDLE
      // Step 1: Enter W_DATA
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        w == 1;
        r == 0;
        a_d == 2'b01;
        AWVALID == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
      // Step 2: Try W_DATA -> W_IDLE
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==0;
      });

      finish_item(req);   

      // Step 3: Try W_IDLE -> W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
      });

      finish_item(req);
      //fsm not covered
      //W_ADDR -> W_DATA
      // Step 1: Enter W_ADDR
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b10;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WVALID  == 1'b0;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
      // Step 2: Try WADDR_ -> W_DATA
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        w == 1;
        r == 0;
        a_d == 2'b01;
        AWVALID == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
      
   

   // cross coverage of awvalid,wvalid
      repeat(50)begin
      // AWVALID = 1, WVALID = 0
      req = trans::type_id::create("req");

      start_item(req);
      assert(req.randomize() with {
        !(AWADDR[7:0] inside{[8'h28:8'h30],[8'h40:8'hff]});
        AWADDR[1:0]==2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b1;
        WVALID ==1'b0;

        BREADY  == 1'b1;
        ARVALID == 1'b0;
        RREADY  == 1'b0;

      });
      finish_item(req);

      // AWVALID = 0, WVALID = 1
      req = trans::type_id::create("req");

      start_item(req);
      assert(req.randomize() with {
        !(AWADDR[7:0] inside{[8'h28:8'h30],[8'h40:8'hff]});
        AWADDR[1:0]==2'b00;
        AWVALID==1'b0;
        WVALID ==1'b1;

        BREADY  == 1'b1;
        ARVALID == 1'b0;
        RREADY  == 1'b0;

      });
      finish_item(req);

      // AWVALID = 0, WVALID = 0
      req = trans::type_id::create("req");

      start_item(req);
      assert(req.randomize() with {
        !(AWADDR[7:0] inside{[8'h28:8'h30],[8'h40:8'hff]});
        AWADDR[1:0]==2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b0;
        WVALID ==1'b0;

        BREADY  == 1'b1;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });
      finish_item(req);
      
      //non toggle rdata
      req = trans::type_id::create("req");

      start_item(req);
      assert(req.randomize() with {
        !(AWADDR[7:0] inside{[8'h28:8'h30],[8'h40:8'hff]});
        AWADDR[1:0]==2'b00;
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        AWVALID==1'b1;
        WVALID ==1'b1;
        WDATA == 32'h0050_0200;
        BREADY  == 1'b1;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });
      finish_item(req);
    end
    
    //extra for addr to idle
    repeat(10)begin
    // Step 3: Try W_IDLE -> W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
      });

      finish_item(req);
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '1;
        w == 1;
        r == 0;
        a_d == 2'b10;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WVALID  == 1'b0;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
      // Step 2: Try W_ADDR -> W_IDLE
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==0;
      });

      finish_item(req);
    // Step 3: Try W_IDLE -> W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
      });

      finish_item(req);
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b10;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WVALID  == 1'b0;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
      // Step 2: Try W_ADDR -> W_IDLE
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==0;
      });

      finish_item(req);
    end
    //EXTRA RDATA & PROT
    repeat(2)begin
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WDATA[3] == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
    //READ
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 1;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        ARADDR == AWADDR;
        WDATA[3] == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b1;
        ARVALID == 1'b1;
        RREADY  == 1'b1;
      });

      finish_item(req);
    //RDATA =0
    //READ
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 1;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        ARADDR == AWADDR;
        WDATA[3] == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b1;
        ARVALID == 1'b1;
        RREADY  == 1'b1;
      });

      finish_item(req);
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 1;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        ARADDR == AWADDR;
        WDATA[3] == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b1;
        ARVALID == 1'b1;
        RREADY  == 1'b1;
      });

      finish_item(req);
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 1;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        ARADDR == AWADDR;
        WDATA[3] == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b1;
        ARVALID == 1'b1;
        RREADY  == 1'b1;
      });

      finish_item(req);
    //prot =111 to 000
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWPROT == 3'b111;
        AWVALID == 1'b1;
        WDATA[3] == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
    //READ
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WDATA[3] == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);

    //WRITE
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWPROT == 3'b000;
        AWVALID == 1'b1;
        WDATA[3] == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
    //READ
    req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b11;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b1;
        WDATA[3] == 1'b1;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);
    end


//INCRESING COVERAGE
      // Step 1: Try W_IDLE 
      repeat(50)begin
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1'b0;
      });

      finish_item(req);
     
      // Step 2: Try W_IDLE -> W_BOTH
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b01;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });

      finish_item(req);

      // Step 3: Try W_BOTH -> W_ADDR
      req = trans::type_id::create("req");
      start_item(req);

      assert(req.randomize() with {
        ARESETn==1;
        !(AWADDR[7:0] inside {[8'h28:8'h30],
                            [8'h40:8'hff]});
        AWADDR[`ADDR_WIDTH-1:8]== '0;
        w == 1;
        r == 0;
        a_d == 2'b10;
        AWADDR[1:0] == 2'b00;
        AWVALID == 1'b0;
        WVALID  == 1'b1;
        BREADY  == 1'b0;
        ARVALID == 1'b0;
        RREADY  == 1'b0;
      });
   end
   endtask
endclass
