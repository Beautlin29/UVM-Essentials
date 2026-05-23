class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent a;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    a = agent::type_id::create("a", this);
  endfunction
endclass
