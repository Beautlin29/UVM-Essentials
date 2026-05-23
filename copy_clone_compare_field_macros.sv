`include "uvm_macros.svh"
import uvm_pkg::*;

class object extends uvm_object;
  
  function new(string path = "object");
    super.new(path);
  endfunction
  
  rand bit [3:0] a;
  
  `uvm_object_utils_begin(object)
  `uvm_field_int(a, UVM_HEX);
  `uvm_object_utils_end
  
endclass


module tb;
  object first, second;
  
  int status;
  
  // both does deep copy
  
  // copy core method
  /*
  initial begin
    first = new("first");
    second = new("second");
    first.randomize();
    second.copy(first);
    first.print();
    second.print();
  end
  */
  
  // clone core method
  initial begin
    first = new("first"); // need not construct second for clone method!
    first.randomize();
    $cast(second, first.clone());
    first.print();
    second.print();
    
    status = first.compare(second);
    $display("Value of status : %0d", status);
  end
endmodule