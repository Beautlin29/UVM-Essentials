`include "uvm_macros.svh"
import uvm_pkg::*;

class first extends uvm_object;
  
  function new(string path = "first");
    super.new(path);
  endfunction
  
  rand bit [3:0] data;
  
  `uvm_object_utils_begin(first)
  `uvm_field_int(data, UVM_HEX);
  `uvm_object_utils_end
  
endclass

class first_mod extends first;
  
  function new(string path = "first_mod");
    super.new(path);
  endfunction
  
  rand bit ack;
  
  `uvm_object_utils_begin(first_mod)
  `uvm_field_int(ack, UVM_BIN);
  `uvm_object_utils_end
  
endclass

class component extends uvm_component;
  
  first f;
  
  function new(string path, uvm_component parent = null);
    super.new(path, parent);
    
    f = first::type_id::create("f");
  endfunction
  
  `uvm_component_utils_begin(component)
  `uvm_field_object(f, UVM_DEFAULT);
  `uvm_component_utils_end
  
endclass


module tb;
  component c;
  
  // Typical program to access first class
  /*
  initial begin
    c = component::type_id::create("c", null);
    c.f.randomize();
    c.print();
  end
  */
  
  // Program to override first class defined inside component class by first_mod class
  initial begin
    c.set_type_override_by_type(first::get_type, first_mod::get_type); 
    c = component::type_id::create("c", null);
    c.f.randomize();
    c.print();
  end
  
endmodule