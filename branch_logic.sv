//-----------------------------------------------------------------------------
// Branch Logic
//
// The Branch Logic module determines whether a conditional branch instruction
// (such as beq, bne, blt, bge, etc.) should be taken. It receives the values
// of the two source registers and the funct3 field from the instruction,
// and compares the values according to the branch condition. If the condition
// is met, it asserts the branch_taken signal, which is used by the top-level
// module to update the PC to the branch target address.
//
// Used In: Execute
//
// File Contributor(s):
//-----------------------------------------------------------------------------
