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
    `uvm_fatal("DRV", "UVM Fatal");
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