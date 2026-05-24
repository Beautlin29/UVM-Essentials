`include "uvm_macros.svh"
import uvm_pkg::*;
  
class producer extends uvm_component;
  `uvm_component_utils(producer) 
  
  int data;
  
  uvm_blocking_get_port #(int) recv; // initiator has port
   
  function new(string path = "producer", uvm_component parent = null);
    super.new(path, parent);
    recv = new("recv", this);
  endfunction
  
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    recv.get(data); // blocking get operation
    `uvm_info("PROD", $sformatf("Data Received by Producer: %0d", data), UVM_NONE);
    #10;
    phase.drop_objection(this);
  endtask
  
endclass

class consumer extends uvm_component;
  `uvm_component_utils(consumer) 
  
  int data = 200;
  
  uvm_blocking_get_imp #(int, consumer) send; // responder has implementation
   
  function new(string path = "consumer", uvm_component parent = null);
    super.new(path, parent);
    send = new("send", this);
  endfunction
  
  virtual task get(output int datas); // put operation definition
    #10;
    datas = data;
    `uvm_info("CONS", $sformatf("Data set by Consumer: %0d", datas), UVM_NONE);
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
    p.recv.connect(c.send);
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