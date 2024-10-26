`timescale 1ps/1ps

`define A 3'b000
`define B 3'b001
`define C 3'b010
`define D 3'b011
`define E 3'b100

module top_module_tb;
reg clk, reset, err;
reg [1:0] in;
wire [1:0] out;

top_module dut(clk,reset,in,out);

task my_checker1;
input [2:0] expected_state;

begin
    if(top_module_tb.dut.present_state !== expected_state ) begin
       $display("ERROR ** state is %b, expected %b", top_module_tb.dut.present_state , expected_state);
        err = 1'b1;
       end
    end
endtask


task my_checker2;
input [1:0] expected_output;

begin
 if (top_module_tb.dut.out !== expected_output) begin
        $display("ERROR: output is %b, expected output is %b", top_module_tb.dut.out, expected_output);
        err = 1'b1;
    end
end
endtask

initial begin
clk = 0; #5;
forever begin
    clk = 1; #5;
    clk = 0; #5;
end
end

 // Test procedure
  initial begin
     // BCDEDCA
    reset = 1'b1; in = 2'b00; err = 1'b0; #10; 
    // Check the initial state
    my_checker1(3'b001); // Replace `STATE_INIT` with the initial state of your FSM
    reset = 1'b0; // De-assert reset

    // Example of a state transition check
    $display("Checking transition from B to C");
    in = 2'b00; #10;
    my_checker1(3'b010); 

    $display("Checking transition from C to D");
    in = 2'b11; #10;
    my_checker1(3'b011);

    $display("Checking transition from D to E");
    in = 2'b10; #10;
    my_checker1(3'b100); 

    $display("Checking transition from E to D");
    #10;
    my_checker1(3'b011); 

    $display("Checking transition from D to C");
    in = 2'b01; #10;
    my_checker1(3'b010); // Replace `STATE_NEXT` with the expected state

    $display("Checking transition from C to A");
    in = 2'b01; #10;
    my_checker1(3'b000); 


    reset = 1'b1; #10; // Reset FSM
    reset = 1'b0;

    //BABCDE
     reset = 1'b1; in = 2'b00; err = 1'b0; #10; 
    // Check the initial state
    my_checker2(2'b00); // Replace `STATE_INIT` with the initial state of your FSM
    reset = 1'b0; // De-assert reset

    // Example of a state transition check
    $display("Checking output at A");
    in = 2'b01; #10;
    my_checker2(3'b11); 

    $display("Checking output at B");
    in = 2'b11; #10;
    my_checker2(2'b00); 

    $display("Checking output at C");
    in = 2'b00; #10;
    my_checker2(2'b01);

    $display("Checking output at D");
    in = 2'b11; #10;
    my_checker2(2'b10); 

    $display("Checking output at E");
    in = 2'b10; #10;
    my_checker2(2'b11); 

    reset = 1'b1; #10; // Reset FSM
    reset = 1'b0;


    // Final results
    if (~err)
      $display("All tests passed!");
    else
      $display("Some tests failed.");
    $stop;
  end
endmodule