`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
  
  int data = 10;
  
  initial begin
    `uvm_info("UVM_TB_TOP", "Hello World", UVM_NONE);
    `uvm_info("UVM_TB_TOP", $sformatf("Value of Data: %0d", data), UVM_NONE);
    `uvm_info("UVM_TB_TOP", "This message will not be printed because of higher verbosity level!", UVM_HIGH);
    // id, msg, verbosity level
    
    // changing verbosity level of reporting macros
    uvm_top.set_report_verbosity_level(UVM_HIGH);
    `uvm_info("UVM_TB_TOP", "This message will be printed now because of higher verbosity level!", UVM_HIGH);
    `uvm_info("UVM_TB_TOP", $sformatf("Value of Verbosity Level: %0d", uvm_top.get_report_verbosity_level), UVM_HIGH);
  end
  
endmodule