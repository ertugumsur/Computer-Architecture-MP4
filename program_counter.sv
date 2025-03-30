//-----------------------------------------------------------------------------
// pc.sv
//
// The Program Counter (PC) stores the address of the current instruction.
// Each cycle, the top-level module uses this address to fetch the instruction
// from the memory module. After the instruction is decoded and executed,
// the PC is updated — usually to PC + 4, or to a new address if the instruction
// is a branch or jump — so that it points to the next instruction to execute.
//-----------------------------------------------------------------------------
