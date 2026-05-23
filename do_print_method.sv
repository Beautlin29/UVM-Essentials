`include "uvm_macros.svh"
import uvm_pkg::*;

class dummy extends uvm_object;
  `uvm_object_utils(dummy)
  
  function new(string path = "dummy");
    super.new(path);
  endfunction
  
  rand bit [3:0] a;
  string b = "UVM";
  real c   = 12.34;
  
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    
    printer.print_field_int("a", a, $bits(a), UVM_DEC);
    printer.print_string("b", b);
    printer.print_real("c", c);
  endfunction
  
endclass

module tb;
  dummy d;

  initial begin
    d = dummy::type_id::create("d");
    d.randomize();
    d.print();
  end
  
endmodule