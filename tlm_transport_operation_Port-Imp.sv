`include "uvm_macros.svh"
import uvm_pkg::*;
  
class producer extends uvm_component;
  `uvm_component_utils(producer) 
  
  int datas = 1000, datar = 0;
  
  uvm_blocking_transport_port #(int, int) port; // initiator has port
   
  function new(string path = "producer", uvm_component parent = null);
    super.new(path, parent);
    port = new("port", this);
  endfunction
  
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    port.transport(datas, datar); // blocking transport operation
    `uvm_info("PROD", $sformatf("Data Sent: %0d\t Data Received: %0d", datas, datar), UVM_NONE);
    #10;
    phase.drop_objection(this);
  endtask
  
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer) 
  
  int datas = 2000, datar = 0;
  
  uvm_blocking_transport_imp #(int, int, consumer) imp; // responder has implementation
   
  function new(string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
    imp = new("imp", this);
  endfunction
  
  virtual task transport(input int datar, output int datas); // transport operation definition
    #10;
    datas = this.datas; // or use different name 
    datar = datar;
    `uvm_info("CONS", $sformatf("Data Sent: %0d\t Data Received: %0d", datas, datar), UVM_NONE);
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