`timescale 1ps/1ps
`include "CPU.v"

module CPUtb ();

    reg [18:0] instruction;
    wire [7:0] ans;
    wire flag;

    CPU c (instruction, ans, flag);

    initial begin

        
        $dumpfile("CPU.vcd");
        $dumpvars(0, CPUtb);

        instruction = 19'b0010010001100010100; #20; //Addition 
        instruction = 19'b0100010001100010100; #20; //Subtraction 
        instruction = 19'b0110010001100010100; #20; //Bitwise And 
        instruction = 19'b1000010001100010100; #20; //Bitwise or 
        instruction = 19'b1010010001100010100; #20; //Bitwise Not 
        instruction = 19'b1100010001100010100; #20; //Increment 
        instruction = 19'b1110010001100010100; #20; //Decrement


        $display("instruction = %b, ans = %b, flag = %b", instruction, ans, flag);

        #140
        $finish;
    end

endmodule