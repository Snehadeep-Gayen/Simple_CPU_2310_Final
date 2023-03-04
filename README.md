# SIMPLE CPU DESIGN : VERILOG LAB 4
### Author : Snehadeep Gayen
### Roll No : CS21B078

##  How to run the code

* Edit the input instructions in file `CPU_tb.v`
* Compile the code using `iverilog CPU_tb.v`
* Do `vvp a.out` and open the vcd file using `gtkwave CPU.vcd`

## Files included, and their heirarchy

* CPU_tb.v  : Testbench for CPU
  * CPU.v   : CPU module
    * CU.v  : Control Unit
    * ALU.v : Arithmetic and Logic Unit