`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("DRV", "Executed Driver Code with High Verbosity Level", UVM_HIGH);
  endtask
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  task run();
    `uvm_info("MON", "Executed Monitor Code with High Verbosity Level", UVM_HIGH);
  endtask
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver d;
  monitor m;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
    d = driver::type_id::create("d", this);
    m = monitor::type_id::create("m", this);
  endfunction
  
  task run();
    d.run();
    m.run();
    `uvm_info("ENV", "Executed Environment Code with High Verbosity Level", UVM_HIGH);
  endtask
endclass

module tb;
  env e;
  
  initial begin
    e = env::type_id::create("e", null);
    e.set_report_verbosity_level_hier(UVM_HIGH);
    e.run();
  end
endmodule