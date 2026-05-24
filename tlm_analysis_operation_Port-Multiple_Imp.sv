`include "uvm_macros.svh"
import uvm_pkg::*;
  
class producer extends uvm_component;
  `uvm_component_utils(producer) 
  
  int data = 20;
  
  uvm_analysis_port #(int) port; // initiator has port
   
  function new(string path = "producer", uvm_component parent = null);
    super.new(path, parent);
    port = new("port", this);
  endfunction
  
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    port.write(data); // analysis write operation
    `uvm_info("PROD", $sformatf("Data sent by Producer: %0d", data), UVM_NONE);
    #10;
    phase.drop_objection(this);
  endtask
  
endclass

class consumer1 extends uvm_component;
  `uvm_component_utils(consumer1) 
  
  int data;
  
  uvm_analysis_imp #(int, consumer1) imp1; // responder has implementation
   
  function new(string path = "consumer1", uvm_component parent = null);
    super.new(path, parent);
    imp1 = new("imp1", this);
  endfunction
  
  virtual function void write(int datar); // write operation definition - must be a function and no time statements
    data = datar;
    `uvm_info("CONS1", $sformatf("Data received by Consumer1: %0d", data), UVM_NONE);
  endfunction
  
endclass

class consumer2 extends uvm_component;
  `uvm_component_utils(consumer2) 
  
  int data;
  
  uvm_analysis_imp #(int, consumer2) imp2; // responder has implementation
   
  function new(string path = "consumer2", uvm_component parent = null);
    super.new(path, parent);
    imp2 = new("imp2", this);
  endfunction
  
  virtual function void write(int datar); // write operation definition - must be a function and no time statements
    data = datar;
    `uvm_info("CONS2", $sformatf("Data received by Consumer2: %0d", data), UVM_NONE);
  endfunction
  
endclass
 
class env extends uvm_env;
  `uvm_component_utils(env) 
  
  producer p;
  consumer1 c1;
  consumer2 c2;
  
  function new(string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p = producer::type_id::create("p", this);
    c1 = consumer1::type_id::create("c1", this);
    c2 = consumer2::type_id::create("c2", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    p.port.connect(c1.imp1);
    p.port.connect(c2.imp2);
  endfunction
  
endclass
 
class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
  endfunction
  
endclass
 
module tb;
  
  initial begin
    run_test("test");
  end
 
endmodule