`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "driver.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

module tb;
  
  adder_if aif();
  
  adder dut(.a(aif.a), .b(aif.b), .y(aif.y));
  
  initial begin
    uvm_config_db #(virtual adder_if)::set(null, "uvm_test_top.e.a.d", "aif", aif);
    run_test("test");
  end
endmodule