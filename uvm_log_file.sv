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
  int file;
  
  initial begin
    d = driver::type_id::create("d", null);
    file = $fopen("log.txt", "w");
    d.set_report_verbosity_level(UVM_HIGH);
    
    // these lines are necessary for log
    d.set_report_severity_action(UVM_INFO, UVM_DISPLAY|UVM_LOG);
    d.set_report_severity_action(UVM_WARNING, UVM_DISPLAY|UVM_LOG);
    d.set_report_severity_action(UVM_ERROR, UVM_DISPLAY|UVM_LOG);
    
//     d.set_report_severity_file(UVM_ERROR, file);
    d.set_report_default_file(file);
    d.run();
    $fclose(file);
  end
endmodule