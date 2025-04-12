//-----------------------------------------------------------------------------
// Instruction Register
//
// This module holds the fetched instruction from memory so that it remains
// available throughout the multicycle execution of an instruction.
// The register updates on the rising edge of the clock when 'enable' is high.
//
// Used In: Fetch, Decode, Execute
//
// File Contributor(s): Ahan Trivedi
//-----------------------------------------------------------------------------

module instruction_register (
    input  logic clk, // Clock signal
    input  logic reset, // Reset to clear instruction
    input  logic enable, // Load new instruction when high
    input  logic [31:0] instr_in, // Instruction from memory
    output logic [31:0] instr_out // Latched instruction output
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            instr_out <= 32'b0;
        else if (enable)
            instr_out <= instr_in;
    end

endmodule
