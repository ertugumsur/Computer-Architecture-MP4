//-----------------------------------------------------------------------------
// Immediate Extractor
//
// This module takes a 32-bit RV32I instruction and extracts the immediate value
// based on the instruction format (I, S, B, U, or J). It identifies the type of
// instruction using the opcode, slices out the appropriate immediate bits from
// the instruction, and sign-extends the result to 32 bits. The output is used
// in operations such as ALU computation, memory addressing, and PC updates.
//
// Used In: Deocde, Execute
//
// File Contributor(s): Ahan Trivedi
//-----------------------------------------------------------------------------
module immediate_generator(
    input logic [31:0] instruction // Takes a 32 bit instruction from memory
    output logic [31:0] imme_out // Outputs a 32 bit sign extended immediate to be used in ALU or PC offset
);
