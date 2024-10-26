`define A 3'b000
`define B 3'b001
`define C 3'b010
`define D 3'b011
`define E 3'b100

module top_module(clk,reset,in,out);
 // Initializing inputs and outputs
 input clk, reset;
 input [1:0] in;
 output reg [1:0] out;

    reg [2:0] present_state;

    always_ff @(posedge clk) begin

        if(reset) begin
            present_state <= `B; //If reset is pressed, goes to state B
        end

        else begin

            case(present_state)

            //Transitions from state A
            `A: begin
                if (in[1:0] == 2'b11)
                present_state <= `B;
                else
                present_state <= `A;
            end

            //Transitions from state B
            `B: begin
                if (in[1:0] == 2'b01)
                present_state <= `A;
                else if (in[1:0] == 2'b00)
                present_state <= `C;
                else
                present_state <= `B;
            end

            //Transitions from state C
            `C: begin
                if (in[1:0] == 2'b01)
                present_state <= `A;
                else if (in[1:0] == 2'b11)
                present_state <= `D;
                else
                present_state <= `C;
            end

            //Transitions from state D
            `D: begin
                if (in[1:0] == 2'b01)
                present_state <= `C;
                else if (in[1:0] == 2'b10)
                present_state <= `E;
                else
                present_state <= `D;
            end

            //Transitions from state E
            `E: present_state <= `D;

            endcase

        end

    end

    always_comb begin
        if (present_state == `B)
        out[1:0] <= 2'b00; //Displays output for state B
        else if (present_state == `A | present_state == `E)
        out[1:0] <= 2'b11; //Displays output for states A and E
        else if (present_state == `C)
        out[1:0] <= 2'b01; //Displays output for state C
        else
        out[1:0] <= 2'b10; //Displays output for state D
    end

endmodule