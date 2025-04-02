//-----------------------------------------------------------------------------
// Instruction Decoder
//
// This module takes a 32-bit RV32I instruction fetched from memory and extracts
// its individual fields: opcode, rd, rs1, rs2, funct3, and funct7. These fields
// are used by the control unit, register file, ALU, and other components to
// properly interpret and execute the instruction.
//
// File Contributor(s):
//-----------------------------------------------------------------------------
