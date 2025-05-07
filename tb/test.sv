module test (
  top_if vif
);
  
  int x = 0;

  initial begin
    $display("Begin Of Simulation.");   
    reset();
    // The write() task is executed aleatory
    repeat(100) begin
      x = $urandom_range(100,200);
      #(x*1ns);
      write();
    end

    // Drain time
    repeat (200) @(vif.cb); 
    $display("End Of Simulation.");
    $finish;
  end
  
  task automatic reset();
    vif.rst_i = 'b1;
    vif.start_i = 'b0;
    vif.data_i = 'b0; 
    repeat (5) @(vif.cb);
    vif.cb.rst_i <= 'b0; 
    repeat (10) @(vif.cb);       
  endtask : reset 


  task automatic write();
    // Configure write signal
    @(vif.cb);
    vif.cb.start_i <= 'b1;
    vif.cb.data_i <= 27'b000000011_000000010_000000001;
    @(vif.cb);
    vif.cb.start_i <= 'b0;
    repeat (45) @(vif.cb);
   
  endtask : write  

endmodule : test

