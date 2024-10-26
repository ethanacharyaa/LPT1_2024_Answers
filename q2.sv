`timescale 1ps/1ps

module q2_tb;
reg clk,reset;
reg [3:0] in;

initial begin
clk = 1; #5;
forever begin
    clk = 0; #5;
    clk = 1; #5;
end
end

initial begin
    reset = 1'b0;
    in = 4'b0000;
    #5;
    reset = 1'b1;
    #5;
    #5;
    reset = 1'b0;
    in = 4'b0110;
    #10;
    in = 4'b1101;
    #10;
    in = 4'b1001;
    #10;
    in = 4'b1011;
    #10;
 $stop;
end
endmodule