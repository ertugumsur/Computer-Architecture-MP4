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
// File Contributor(s): Ahan Trivedi
//-----------------------------------------------------------------------------

// Given a 32 bit instruction we want... [31:25] funct7 | [24:20] rs2 | [19:15] rs1 | [14:12] funct3 | [11:7] rd | [6:0] opcode

module instruction_decode(
    input logic [31:0] instruction, // Raw 32 bit instruction pulled from memory
    output logic [6:0] opcode, // Operation Code
    output logic [4:0] rd, // Destination Register
    output logic [2:0] funct3, // Function 3 bits
    output logic [4:0] rs1, // Source Register 1
    output logic [4:0] rs2, // Source Register 2
    output logic [6:0] funct7 // Function 7 bits
);

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

endmodule
