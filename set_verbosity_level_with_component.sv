`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("DRV", "Executed Driver Code with Default Verbosity Level", UVM_MEDIUM);
    `uvm_info("DRV", "Executed Driver Code with High Verbosity Level", UVM_HIGH);
  endtask
endclass

module tb;
  driver d;
  
  initial begin
    d = driver::type_id::create("d", null);
    d.set_report_verbosity_level(UVM_HIGH);
    d.run();
  end
endmodule