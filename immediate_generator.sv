//-----------------------------------------------------------------------------
// Immediate Extractor
//
// This module takes a 32-bit RV32I instruction and extracts the immediate value
// based on the instruction format (I, S, B, U, or J). It identifies the type of
// instruction using the opcode, slices out the appropriate immediate bits from
// the instruction, and sign-extends the result to 32 bits. The output is used
// in operations such as ALU computation, memory addressing, and PC updates.
//
// Used In: Decode, Execute
//
// File Contributor(s): Ahan Trivedi
//-----------------------------------------------------------------------------

module immediate_generator(
    input  logic [31:0] instruction,    // The full 32-bit instruction
    output logic [31:0] immediate       // The sign-extended immediate output
);
    logic [6:0] opcode;
    assign opcode = instruction[6:0];   // Extract opcode (used to determine format)

    always_comb begin
        case (opcode)
            // --------------------------------------------------
            // I-Type
            // Immediate is in bits [31:20] (12-bit signed)
            // --------------------------------------------------
            7'b0010011, // Arithmetic immediate
            7'b0000011, // Loads
            7'b1100111: // jalr
                immediate = {{20{instruction[31]}}, instruction[31:20]};
            // --------------------------------------------------
            // S-Type
            // Immediate is split: [31:25] and [11:7]
            // --------------------------------------------------
            7'b0100011: // Stores
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            // --------------------------------------------------
            // B-Type
            // Immediate is scattered: [31], [7], [30:25], [11:8], then shifted left by 1
            // --------------------------------------------------
            7'b1100011: // Branches
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7],
                             instruction[30:25], instruction[11:8], 1'b0};
            // --------------------------------------------------
            // U-Type
            // Immediate is upper 20 bits [31:12], lower 12 are zeros
            // --------------------------------------------------
            7'b0110111, // LUI
            7'b0010111: // AUIPC
                immediate = {instruction[31:12], 12'b0};
            // --------------------------------------------------
            // J-Type
            // Immediate is: [31], [19:12], [20], [30:21], then shifted left by 1
            // --------------------------------------------------
            7'b1101111: // JAL
                immediate = {{11{instruction[31]}}, instruction[31],
                             instruction[19:12], instruction[20],
                             instruction[30:21], 1'b0};
            // --------------------------------------------------
            // Default case: no immediate or unrecognized opcode
            // --------------------------------------------------
            default: immediate = 32'b0;
        endcase
    end
endmodule

