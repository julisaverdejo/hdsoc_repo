module test (
  top_if vif
);

int x = 0;

//  initial begin
//    $display("Begin Of Simulation.");
//    fork
//      reset();
//      send_data();
//    join

//    // Drain time
//    repeat (20) @(vif.cb);

//    $display("End Of Simulation.");
//    $finish;
//  end
  
  initial begin
    $display("Begin Of Simulation.");   
    reset();
//    repeat(100) begin
//      x = $urandom_range(100,200);
//      #(x*1ns);
//      write();
//    end

    // Drain time
    repeat (200) @(vif.cb); 
    $display("End Of Simulation.");
    $finish;
  end  
  
  task automatic reset();
    vif.rst_i = 'b1;
    vif.data_i = 'b0;
    repeat (5) @(vif.cb);
    vif.cb.rst_i <= 'b0;    
    repeat (10) @(vif.cb);
    vif.data_i <= 9'b100111100;            
  endtask : reset 

//  task automatic write();
//    vif.data_i = 9'b100111100;
//    repeat (5) @(vif.cb);       
//  endtask : write


//  task automatic send_data();
//    vif.data_i = 'd0;
//    for (int i = 0; i<10; i++) begin
//      wait (vif.ena_o != 1); 
//      @(vif.cb iff (vif.ena_o == 1));
//      repeat (5) @(vif.cb);
//      vif.data_i = i;
//     end
//  endtask : send_data

endmodule : test

