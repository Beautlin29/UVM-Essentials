class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  driver d;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    d = driver::type_id::create("d", this);
  endfunction
endclass