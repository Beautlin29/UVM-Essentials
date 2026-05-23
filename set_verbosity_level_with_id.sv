`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("DRV1", "Executed Driver Code with High Verbosity Level", UVM_HIGH); // won't be displayed
    `uvm_info("DRV2", "Executed Driver Code with High Verbosity Level", UVM_HIGH);
  endtask
endclass

module tb;
  driver d;
  
  initial begin
    d = driver::type_id::create("d", null);
    d.set_report_id_verbosity("DRV2", UVM_HIGH);
    d.run();
  end
endmodule