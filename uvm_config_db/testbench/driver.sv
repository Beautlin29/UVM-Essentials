class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  virtual adder_if aif;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual adder_if)::get(this, "", "aif", aif)) // context + instance name + key + value
      `uvm_error("drv", "Unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    for(int i=0; i<10; i++) begin
      aif.a <= $urandom;
      aif.b <= $urandom;
      #10;
    end
    phase.drop_objection(this);
  endtask
endclass