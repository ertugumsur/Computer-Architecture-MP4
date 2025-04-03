//-----------------------------------------------------------------------------
// Main Control Unit
//
// Implements a finite state machine (FSM) that sequences the processor through
// the multicycle stages: Fetch, Decode, Execute, Memory, and Writeback. Based
// on the 7-bit opcode from the decoded instruction and the current state,
// this module generates the control signals that guide the datapath — including
// register file writes, ALU source selection, memory access, and PC updates.
//
// Used In: All stages
//
// File Contributor(s): 
//-----------------------------------------------------------------------------

