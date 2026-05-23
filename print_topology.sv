`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRV", "Executed Driver Build Phase", UVM_NONE);
  endfunction
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MON", "Executed Monitor Build Phase", UVM_NONE);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver d;
  monitor m;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    d = driver::type_id::create("d", this);
    m = monitor::type_id::create("m", this);
    
    `uvm_info("ENV", "Executed Environment Build Phase", UVM_NONE);
  endfunction
  
   virtual function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

module tb;
  initial begin
    run_test("env");
  end
endmodule