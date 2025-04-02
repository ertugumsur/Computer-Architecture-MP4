//-----------------------------------------------------------------------------
// Main Control Unit
//
// This module takes the 7-bit opcode field from a decoded RV32I instruction
// and generates the necessary control signals for the datapath. These signals
// determine how the instruction is executed, including whether to write to
// the register file, access memory, select ALU inputs, and update the PC.
// It acts as the decision-making unit that interprets the instruction type
// and directs the processor accordingly.
//
// File Contributor(s):
//-----------------------------------------------------------------------------
