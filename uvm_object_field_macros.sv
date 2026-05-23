`include "uvm_macros.svh"
import uvm_pkg::*;

class object extends uvm_object;
//   `uvm_object_utils(object)
  
  function new(string path = "object");
    super.new(path);
  endfunction
  
  rand bit [3:0] a;
  typedef enum bit [1:0] {s0 , s1, s2, s3} state_type;
  rand state_type state;
  
  real temp = 12.34;
  string str = "UVM";
  
  `uvm_object_utils_begin(object)
  `uvm_field_int(a, UVM_BIN);
  `uvm_field_enum(state_type, state, UVM_DEFAULT);
  `uvm_field_string(str,UVM_DEFAULT);
  `uvm_field_real(temp, UVM_DEFAULT);
  `uvm_object_utils_end
  
  
endclass

class child extends uvm_object;
	
  object o;
  
  function new(string path = "object");
    super.new(path);
    o = object::type_id::create("o");
  endfunction
   
  `uvm_object_utils_begin(child)
  `uvm_field_object(o, UVM_DEFAULT);
  `uvm_object_utils_end
   
endclass

module tb;
  child c;
  
  initial begin
    c = child::type_id::create("c");
    c.o.randomize();
    c.print(); 
  end
endmodule