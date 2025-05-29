module test (
  top_if vif
);
  
  int x = 0;

  initial begin
    $display("Begin Of Simulation.");   
    reset();
    // repeat (1000) begin
    //   x = $urandom_range(2000,3000);
    //   #(x*1ns);
    //   write();
    //   //$display("Time %4t, IM OUT", $realtime);
    // end
    fork     
      begin
        repeat(10) begin
          x = $urandom_range(1000,2000);
          #(x*1ns);
          write();
        end
      end

      begin
        capture();
      end

    join_any

    //    detect();
    // The write() task is executed aleatory

    // Drain time
    repeat (10) @(vif.cb); 
    $display("End Of Simulation.");
    $finish;
  end
  
  task automatic reset();
    vif.RST_I = 1'b1;
    vif.CYC_I = 1'b0;
    vif.ADR_I = 32'b0;
    vif.DAT_I = 32'h0;
    vif.STB_I = 1'b0;
    vif.WE_I  = 1'b0; 
    @(vif.cb);
    vif.cb.RST_I <= 'b0;
    repeat (10) @(vif.cb);    
  endtask : reset 
/*
  task automatic detect();
    for (int i = 0; i < 20; i++) begin
      wait (vif.ena_o != 1);
      @(vif.cb iff (vif.ena_o == 1));
      //repeat (2) @(vif.cb);    
      $display("Time %4t, i = %3d", $realtime, i);
    end
  endtask : detect
*/
  task automatic write();
    // Configure write signal
    @(vif.cb);
    $display("Time %4t, CB here", $realtime);
    vif.cb.CYC_I <= 1'b1;
    vif.cb.ADR_I <= 32'b0;
    vif.cb.DAT_I <= 32'h30201;
    vif.cb.STB_I <= 1'b1;
    vif.cb.WE_I  <= 1'b1;
    #(50ns);
    $display("Time %4t, WATING ACK", $realtime);
    wait (vif.ACK_O != 1);
    @(vif.cb iff (vif.ACK_O == 1));
    $display("Time %4t, Detected", $realtime);
    @(vif.cb);
    vif.CYC_I = 1'b0;
    vif.ADR_I = 32'b0;
    vif.DAT_I = 32'h0;
    vif.STB_I = 1'b0;
    vif.WE_I  = 1'b0; 
    repeat (5) @(vif.cb);
  endtask : write  

  task automatic capture();
    bit [31:0] dataout;
    int i = 0;
    int cnt = 0;    
    // wait (vif.ena_o != 1);
    // @(vif.cb iff (vif.ena_o == 1));
    wait (vif.ena_o != 0); 
    wait (vif.ena_o == 0);
    $display("Time %4t", $realtime);
    #(20ns);
    //for (int i = 0; i < 10; i++) begin
    while (1) begin
      dataout[i] = vif.data_o;
      if (i == 9) begin
        $display("Time %4t, value : %10b %3d", $realtime, dataout, dataout);
        cnt = cnt + 1;
        i = 0;
        if (cnt == 100) begin
          break;
        end
      end  else begin
        i++;
      end
      #(40ns);
    end      
  endtask : capture

endmodule : test

