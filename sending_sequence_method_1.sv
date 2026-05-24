`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
  rand bit [3:0] a;
  
  function new(string path = "transaction");
    super.new(path);
  endfunction
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(a, UVM_DEFAULT)
  `uvm_object_utils_end
endclass

class seq extends uvm_sequence#(transaction);
  `uvm_object_utils(seq)
  function new(string path = "seq");
    super.new(path);
  endfunction
  
  transaction t;
  
  virtual task body();
    t = transaction::type_id::create("t");
    wait_for_grant(); // wait for driver to give grant
    assert(t.randomize()); // perform operation
    send_request(t); // send the request to driver
    wait_for_item_done(); // wait for data to be received by driver
  endtask
endclass

class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  function new(string path = "driver", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  transaction t;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
  endfunction
  
  virtual task run_phase(uvm_phase phase); // use run phase instead of main phase
    // phase.raise_objection(this); // dont use objection in driver or monitor!
    forever begin
      seq_item_port.get_next_item(t);
      // Apply stimulus to DUT
      seq_item_port.item_done();
    end
    // phase.drop_objection(this);
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  function new(string path = "agent", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  driver d;
  uvm_sequencer #(transaction) seqr;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = driver::type_id::create("d", this);
    seqr = uvm_sequencer #(transaction)::type_id::create("seqr", this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  function new(string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  agent a;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a = agent::type_id::create("a", this);
  endfunction

endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  seq s;
  env e;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    s = seq::type_id::create("s");
  endfunction
	
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this); // objection should be only used in test or sequence
    s.start(e.a.seqr);
    phase.drop_objection(this);
  endtask
endclass

module tb;
 
  initial begin
    run_test("test");
  end

endmodule