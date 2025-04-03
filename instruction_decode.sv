//-----------------------------------------------------------------------------
// Instruction Decoder
//
// This module takes the 32-bit instruction fetched from memory and extracts
// the fields required for execution: opcode, funct3, funct7, rs1, rs2, and rd.
// These fields are used during the Decode stage to help the control unit
// generate signals and guide the datapath through the remaining stages.
//
// Used In: Decode
//
// File Contributor(s):
//-----------------------------------------------------------------------------

