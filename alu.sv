//-----------------------------------------------------------------------------
// Arithmetic Logic Unit
//
// This module performs arithmetic and logical operations for the RV32I instruction set,
// based on a 4-bit alu_control signal provided by the ALU control unit. It takes in two
// 32-bit operands and computes the selected operation (e.g., add, sub, and, or, slt, etc.).
// The result is used for register write-back, memory addressing, or branch decision-making.
// The ALU also outputs a zero flag, which is used by the branch logic.
//-----------------------------------------------------------------------------
