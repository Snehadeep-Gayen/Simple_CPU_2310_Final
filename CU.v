/*----------------------------------
                CU
------------------------------------
1. Input
    19-bit instruction
2. Output 
    a. Decoded Opcode 
    b. Operand 1
    c. Operand 2
-----------------------------------*/

module CU(
    input wire [18:0] instruction,
    output wire [7:0] decodedOpcode,
    output wire [7:0] data1,
    output wire [7:0] data2
);
    decoder3to8 d (instruction[18:16], decodedOpcode);
    buf b1 [7:0] (data1, instruction[15:8]);
    buf b2 [7:0] (data2, instruction[7:0]);

endmodule


//3to8 decoder
module decoder3to8(
    input wire [2:0] in,
    output wire [7:0] decodedOpcode
);
    wire [2:0] in_bar;
    not n [2:0] (in_bar, in);

    and (decodedOpcode[0], in_bar[2], in_bar[1], in_bar[0]);
    and (decodedOpcode[1], in_bar[2], in_bar[1], in[0]);
    and (decodedOpcode[2], in_bar[2], in[1], in_bar[0]);
    and (decodedOpcode[3], in_bar[2], in[1], in[0]);
    and (decodedOpcode[4], in[2], in_bar[1], in_bar[0]);
    and (decodedOpcode[5], in[2], in_bar[1], in[0]);
    and (decodedOpcode[6], in[2], in[1], in_bar[0]);
    and (decodedOpcode[7], in[2], in[1], in[0]);

endmodule