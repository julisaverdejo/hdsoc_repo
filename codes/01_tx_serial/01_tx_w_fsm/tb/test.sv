module test (
  top_if vif
);

  initial begin
    $display("Begin Of Simulation.");
    fork
      reset();
      send_data();
    join

    // Drain time
    repeat (20) @(vif.cb);

    $display("End Of Simulation.");
    $finish;
  end
  
  task automatic reset();
    vif.rst_i = 'b1;
    vif.dvsr_i = 6;
    repeat (5) @(vif.cb);
    vif.cb.rst_i <= 'b0; 
    repeat (5) @(vif.cb);       
  endtask : reset 

  task automatic send_data();
    vif.data_i = 'd0;
    for (int i = 0; i<10; i++) begin
      wait (vif.ena_o != 1); 
      @(vif.cb iff (vif.ena_o == 1));
      repeat (35) @(vif.cb);
      vif.data_i = i;
     end
  endtask : send_data

endmodule : test

