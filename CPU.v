/*-----------------------------------------
                    CPU
-------------------------------------------
1. Input 
    19-bit instruction
2. Output
    a. 8-bit answer
    b. Flag, denoting nature of the answer

------------------------------------------*/

`include "CU.v"
`include "ALU.v"

module CPU (
    input wire [18:0] instruction,
    output wire [7:0] answer,
    output wire flag
);
    wire [7:0] decodedOpcode;
    wire [7:0] operand1, operand2;

    //CU decodes the instruction and separates the operands
    CU C (instruction, decodedOpcode, operand1, operand2);

    //ALU performs the correct operation using decoded opcode and operands
    ALU A (decodedOpcode, operand1, operand2, answer, flag);

endmodule