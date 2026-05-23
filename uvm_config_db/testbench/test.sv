class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    e = env::type_id::create("e", this);
  endfunction
  
   virtual function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass
