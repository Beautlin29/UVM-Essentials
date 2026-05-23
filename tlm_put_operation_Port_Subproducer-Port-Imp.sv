`include "uvm_macros.svh"
import uvm_pkg::*;

class subproducer extends uvm_component;
  `uvm_component_utils(subproducer) 
  
  int data = 20;
  
  uvm_blocking_put_port #(int) subport; // initiator has port
   
  function new(string path = "producer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    subport = new("subport", this);
  endfunction
  
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    subport.put(data); // blocking put operation
    `uvm_info("SUBPROD", $sformatf("Data sent by Subproducer: %0d", data), UVM_NONE);
    #10;
    phase.drop_objection(this);
  endtask
  
endclass
  
class producer extends uvm_component;
  `uvm_component_utils(producer) 
  
  subproducer s;
  
  uvm_blocking_put_port #(int) port; // initiator has port
   
  function new(string path = "producer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
    s = subproducer::type_id::create("s", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    s.subport.connect(this.port);
  endfunction
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer) 
  
  int data;
  
  uvm_blocking_put_imp #(int, consumer) imp; // responder has implementation
   
  function new(string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	imp = new("imp", this);
  endfunction
  
  virtual task put(int datar); // put operation definition
    #10;
    data = datar;
    `uvm_info("CONS", $sformatf("Data received by Consumer: %0d", data), UVM_NONE);
  endtask
  
endclass
 
class env extends uvm_env;
  `uvm_component_utils(env) 
  
  producer p;
  consumer c;
  
  function new(string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p = producer::type_id::create("p", this);
    c = consumer::type_id::create("c", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    p.port.connect(c.imp);
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