/*----------------------------------
                ALU
------------------------------------
1. Binary Operations
    a. AND
    b. OR
    c. NOT
2. Arithmetic Operations
    a. ADD
    b. SUBTRACT
    c. INCREMENT
    d. DECREMENT
-----------------------------------*/

/*
-------------------------
    MAIN ALU MODULE
-------------------------
1. Input 
    a. Decoded Opcode
    b. Byte1 and Byte2
2. Output 
    a. Required answer
    b. Flag
*/

module ALU(
    input wire [7:0] decodedOpcode,
    input wire [7:0] data1,
    input wire [7:0] data2,
    output wire [7:0] out,
    output wire flag
);

    supply0 low;

    //wires declared for output of each circuit
    wire [7:0] inst1, add, subtract, incr, decr, AND_temp, NOT_temp, OR_temp;

    //initialising each module with data and enable as decoder output 

    instruction1 ins000 (data1, data2, inst1, flag1);
    adder8bit ins001 (data1, data2, low, add, carry_add);
    subtractor8bit ins010 (data1, data2, subtract, borrow_subtract);
    incrementer ins011 (data1, incr, incr_carry);
    decrementer ins100 (data1, decr, decr_borrow);
    ANDer ins101 (data1, data2, AND_temp);
    ORer ins110 (data1, data2, OR_temp);
    NOTer ins111 (data1, NOT_temp);

    //ANDing output of each to respective enables
    wire [7:0] MUL, ADD, SUB, INC, DEC, AND, OR, NOT;
    and a0 [7:0]  (MUL, inst1, decodedOpcode[0]);
    and a1 [7:0] (ADD, add, decodedOpcode[1]);
    and a2 [7:0]  (SUB, subtract, decodedOpcode[2]);
    and a3 [7:0] (INC, incr, decodedOpcode[3]);
    and a4 [7:0]  (DEC, decr, decodedOpcode[4]);
    and a5 [7:0] (AND, AND_temp, decodedOpcode[5]);
    and a6 [7:0]  (OR, OR_temp, decodedOpcode[6]);
    and a7 [7:0] (NOT, NOT_temp, decodedOpcode[7]);

    //ANDing flags to respective enables
    and (flag1_enable, flag1, decodedOpcode[0]);
    and (carry_add_enable, carry_add, decodedOpcode[1]);
    and (borrow_subtract_enable, borrow_subtract, decodedOpcode[2]);
    and (incr_carry_enable, incr_carry, decodedOpcode[3]);
    and (decr_borrow_enable, decr_borrow, decodedOpcode[4]);

    //ORing everything together to output
    or o1 [7:0] (out, MUL, ADD, SUB, INC, DEC, AND, OR, NOT);
    or (flag, flag1_enable, carry_add_enable, borrow_subtract_enable, incr_carry_enable, decr_borrow_enable);

endmodule

/* 
--------------------------
    BINARY OPERATIONS
--------------------------
*/

module ANDer (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] c
);
    and a1 [7:0] (c, b, a);
endmodule

module ORer (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] c
);
    or o1 [7:0] (c, b, a);
endmodule

module NOTer (
    input wire [7:0] a,
    output wire [7:0] c
);
    not n1 [7:0] (c, a);
endmodule

/*
----------------------------
    ARITHMETIC OPERATIONS
----------------------------
*/

//half adder
module halfadder (
    input wire a, b,
    output wire sum, carry
);
    xor (sum, a, b);
    and (carry, a, b);
endmodule

//full adder
module fulladder (
    input wire a, b, cin,
    output wire sum, cout
);
    halfadder h1 (a, b, s1, c1);
    halfadder h2 (s1, cin, sum, c2);
    or (cout, c1, c2);  
endmodule

//adding two 8-bit numbers (using ripple carry adders)
module adder8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire cout
);
    fulladder f1 (a[0], b[0], cin, sum[0], c1);
    fulladder f2 (a[1], b[1], c1, sum[1], c2);
    fulladder f3 (a[2], b[2], c2, sum[2], c3);
    fulladder f4 (a[3], b[3], c3, sum[3], c4);
    fulladder f5 (a[4], b[4], c4, sum[4], c5);
    fulladder f6 (a[5], b[5], c5, sum[5], c6);
    fulladder f7 (a[6], b[6], c6, sum[6], c7);
    fulladder f8 (a[7], b[7], c7, sum[7], cout);

endmodule

//subtracting two 8-bit numbers
module subtractor8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] ans,
    output wire overflow
);
    wire [7:0] b_bar;
    not n [7:0] (b_bar, b);

    supply1 s;
    adder8bit theadder(a, b_bar, s, ans, o_temp);

    not (overflow, o_temp);
    
endmodule

//incrementing 'a'
module incrementer (
    input wire [7:0] a,
    output wire [7:0] ans,
    output wire overflow
);
    supply1 s;
    halfadder h0 (a[0], s, ans[0], c0);
    halfadder h1 (a[1], c0, ans[1], c1);
    halfadder h2 (a[2], c1, ans[2], c2);
    halfadder h3 (a[3], c2, ans[3], c3);
    halfadder h4 (a[4], c3, ans[4], c4);
    halfadder h5 (a[5], c4, ans[5], c5);
    halfadder h6 (a[6], c5, ans[6], c6);
    halfadder h7 (a[7], c6, ans[7], overflow);
    
endmodule

//half subtractor module
module halfsubtractor (
    input wire a, b,
    output wire diff, borrow
);
    xor xor1 (diff, a, b);
    not not1 (a_bar, a);
    and and1 (borrow, a_bar, b);

endmodule


//decrementer (8-bit)
module decrementer (
    input wire [7:0] a,
    output wire [7:0] ans,
    output wire neg
);
    supply1 s;
    halfsubtractor h0 (a[0], s, ans[0], c0);
    halfsubtractor h1 (a[1], c0, ans[1], c1);
    halfsubtractor h2 (a[2], c1, ans[2], c2);
    halfsubtractor h3 (a[3], c2, ans[3], c3);
    halfsubtractor h4 (a[4], c3, ans[4], c4);
    halfsubtractor h5 (a[5], c4, ans[5], c5);
    halfsubtractor h6 (a[6], c5, ans[6], c6);
    halfsubtractor h7 (a[7], c6, ans[7], neg);

endmodule

/*
--------------------------
    EXTRA INSTRUCTION
--------------------------
*/

module instruction1(
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] c,
    output wire status
);
    // buf b1 [7:0] (c, a);
    supply0 s;
    buf (status, s);
    xor x1 [7:0] (c, a, b);
endmodule