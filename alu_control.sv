//-----------------------------------------------------------------------------
// ALU Operation Selector
//
// This module takes the ALUOp signal from the main control unit along with the
// funct3 and funct7 fields from the instruction, and outputs a 4-bit control
// signal to select the specific operation the ALU should perform (e.g., add,
// subtract, AND, OR, etc.). This enables fine-grained control of ALU behavior
// for both R-type and I-type instructions.
//-----------------------------------------------------------------------------
