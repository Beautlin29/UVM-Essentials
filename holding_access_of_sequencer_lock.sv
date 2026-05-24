/*
SEQ_ARB_FIFO (DEFAULT) strictly fifo --priority do not effect
SEQ_ARB_WEIGHTED  : weight is used for priority
SEQ_ARB_RANDOM  strictly random -- priority do not effect
SEQ_ARB_STRICT_FIFO    support priority for strict; if same priority, works as fifo
SEQ_ARB_STRICT_RANDOM  support priority for strict; if same priority, works as random
SEQ_ARB_USER
*/

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

class seq1 extends uvm_sequence#(transaction);
  `uvm_object_utils(seq1)
  function new(string path = "seq1");
    super.new(path);
  endfunction
  
  transaction t;
  
  virtual task body();
    lock(m_sequencer); // seq1 locks all the transactions!
    repeat(5) begin
      t = transaction::type_id::create("t");
      start_item(t);
      assert(t.randomize);
      finish_item(t);
      `uvm_info("SEQ1", $sformatf("Data: %0d", t.a), UVM_NONE);
    end
    unlock(m_sequencer);
  endtask
endclass

class seq2 extends uvm_sequence#(transaction);
  `uvm_object_utils(seq2)
  function new(string path = "seq2");
    super.new(path);
  endfunction
  
  transaction t;
  
  virtual task body();
    repeat(5) begin
      t = transaction::type_id::create("t");
      start_item(t);
      assert(t.randomize);
      finish_item(t);
      `uvm_info("SEQ2", $sformatf("Data: %0d", t.a), UVM_NONE);
    end
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
  
  virtual task run_phase(uvm_phase phase); 
    forever begin
      seq_item_port.get_next_item(t);
      `uvm_info("DRV", $sformatf("Data: %0d", t.a), UVM_NONE);
      seq_item_port.item_done();
    end
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
  
  seq1 s1;
  seq2 s2;
  env e;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    s1 = seq1::type_id::create("s1");
    s2 = seq2::type_id::create("s2");
  endfunction
	
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork  
      s1.start(e.a.seqr, null, 100);
      s2.start(e.a.seqr, null, 200); 
    join  
    phase.drop_objection(this);
  endtask
endclass

module tb;
 
  initial begin
    run_test("test");
  end

endmodule