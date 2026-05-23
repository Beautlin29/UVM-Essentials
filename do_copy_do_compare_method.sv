`include "uvm_macros.svh"
import uvm_pkg::*;

class dummy extends uvm_object;
  `uvm_object_utils(dummy)
  
  function new(string path = "dummy");
    super.new(path);
  endfunction
  
  rand bit [3:0] a;
  
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
    
    printer.print_field_int("a", a, $bits(a), UVM_DEC);
  endfunction
  
  virtual function void do_copy(uvm_object rhs);
    dummy temp;
    $cast(temp, rhs);
    super.do_copy(rhs);
    
    this.a = temp.a; 
  endfunction
  
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    dummy temp;
    int status;
    $cast(temp, rhs);
    status = super.do_compare(rhs, comparer) && (a == temp.a);
    return status;
   endfunction
  
endclass

module tb;
  dummy d, e;
  int status;

  initial begin
    d = dummy::type_id::create("d");
    d.randomize();
    d.print();
    
    e = dummy::type_id::create("e");
    e.copy(d);
    e.print();
    
    status = d.compare(e);
    $display("Value of status: %0d", status);
  end
  
endmodule