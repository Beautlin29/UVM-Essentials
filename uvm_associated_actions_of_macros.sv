`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("DRV", "UVM Info with High Verbosity Level", UVM_HIGH);
    `uvm_warning("DRV", "UVM Warning");
    `uvm_error("DRV", "UVM Error");
    `uvm_error("DRV", "UVM Error"); 
  endtask
endclass

module tb;
  driver d;
  
  initial begin
    d = driver::type_id::create("d", null);
    d.set_report_severity_action(UVM_INFO, UVM_NO_ACTION); // uvm_info should not print
    d.set_report_severity_action(UVM_WARNING, UVM_DISPLAY | UVM_EXIT); // uvm_warning should print and exit
    d.run();
  end
endmodule