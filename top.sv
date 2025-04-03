//-----------------------------------------------------------------------------
// Top-Level Module
//
// Coordinates the multicycle processor datapath. Each instruction is executed
// over multiple clock cycles: Fetch, Decode, Execute, Memory Access, and
// Writeback. This module instantiates and wires together all major components,
// including the control unit, ALU, register file, memory, and PC.
//
// Used In: All stages
//
// File Contributor(s): Ishan Porwal
//-----------------------------------------------------------------------------
