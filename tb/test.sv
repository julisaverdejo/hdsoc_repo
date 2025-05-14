module test (
  top_if vif
);
  
  int x = 0;

  initial begin
    $display("Begin Of Simulation.");   
    reset();
    fork
      begin
        repeat(100) begin
          x = $urandom_range(100,200);
          #(x*1ns);
          write();
        end
      end

      begin
        capture();
      end
      
    join
//    detect();
    // The write() task is executed aleatory


    // Drain time
    repeat (200) @(vif.cb); 
    $display("End Of Simulation.");
    $finish;
  end
  
  task automatic reset();
    vif.rst_i = 'b1;
    vif.start_i = 'b0;
    vif.data_i = 'b0; 
    repeat (4) @(vif.cb);
    vif.cb.rst_i <= 'b0;    
  endtask : reset 

  task automatic detect();
    for (int i = 0; i < 20; i++) begin
      wait (vif.ena_o != 1);
      @(vif.cb iff (vif.ena_o == 1));
      //repeat (2) @(vif.cb);    
      $display("Time %4t, i = %3d", $realtime, i);
    end
  endtask : detect

  task automatic write();
    // Configure write signal
    @(vif.cb);
    vif.cb.start_i <= 'b1;
    vif.cb.data_i <= 27'b000000011_000000010_000000001;
    @(vif.cb);
    vif.cb.start_i <= 'b0;
    repeat (45) @(vif.cb);   
  endtask : write  

  task automatic capture();
    bit [9:0] dataout;
    int i = 0;
    int cnt = 0;    
    // wait (vif.ena_o != 1);
    // @(vif.cb iff (vif.ena_o == 1));
    wait (vif.ena_o != 0); 
    wait (vif.ena_o == 0);


     $display("Time %4t", $realtime);
    #(10ns);
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
      #(20ns);
    end  
     
  endtask : capture

endmodule : test

