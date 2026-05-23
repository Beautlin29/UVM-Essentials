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
  
  virtual function string convert2string();
    string s = super.convert2string(); 
    
    s = {s, $sformatf("a : %0d ", a)};
    s = {s, $sformatf("b : %0s ", b)};
    s = {s, $sformatf("c : %0f ", c)};
    
    return s;
  endfunction
  
endclass

module tb;
  dummy d;

  initial begin
    d = dummy::type_id::create("d");
    d.randomize();
    `uvm_info("TB_TOP", $sformatf("%0s", d.convert2string()), UVM_NONE);
  end
  
endmodule